"""
Phase 2 AI 模块单元测试

使用 MockLLMClient，无需真实 API Key，全部离线运行。

测试覆盖：
  - LLMClient：MockLLMClient 基本调用、call_history、response_map
  - PromptBuilder：system_prompt 内容、user_prompt 结构、修正 prompt
  - XSLTRefiner：首轮成功、首轮失败后修正成功、达到 max_rounds 失败
  - MigrationEngine.migrate_with_ai：集成端到端（Mock）

运行：
  cd migration/lens-migration-core
  PYTHONPATH=src/main/python venv/bin/python3 -m pytest tests/ai/ -v
"""

import sys
import os
import pytest
from pathlib import Path
from unittest.mock import patch

# 将源码目录加入 sys.path
SRC = Path(__file__).parent.parent.parent / "src" / "main" / "python"
sys.path.insert(0, str(SRC))

from lens_migration.ai.llm_client import (
    MockLLMClient,
    QwenClient,
    DeepseekClient,
    create_llm_client,
    ChatMessage,
    LLMResponse,
)
from lens_migration.ai.prompt_builder import PromptBuilder, SYSTEM_PROMPT
from lens_migration.ai.xslt_refiner import XSLTRefiner
from lens_migration.parser.intent_parser import IntentParser
from lens_migration import MigrationEngine

# ── 测试数据路径 ──────────────────────────────────────────────────────────────
CLASSIFIER_TEST = (
    Path(__file__).parent.parent
    / "simple-classifier-test"
)
INTENT_FILE   = CLASSIFIER_TEST / "input" / "request" / "migration-intent-v1-to-v2.md"
INPUT_FILE    = CLASSIFIER_TEST / "input" / "old-version" / "classifier-sample-01-v1.xml"
EXPECTED_FILE = CLASSIFIER_TEST / "input" / "new-version" / "classifier-sample-01-v2.xml"

# ── 合法的最小 XSLT（Mock 返回用）────────────────────────────────────────────
VALID_XSLT = """\
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ns="urn:bbf:yang:bbf-qos-classifiers"
    xmlns="urn:bbf:yang:bbf-qos-classifiers"
    exclude-result-prefixes="ns">

  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

  <!-- Identity Template -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>"""

# ── 无效 XSLT（触发修正流程用）───────────────────────────────────────────────
INVALID_XSLT = "this is not valid xml at all <broken>"


# =============================================================================
# 1. MockLLMClient 测试
# =============================================================================

class TestMockLLMClient:
    """测试 MockLLMClient 的基本功能。"""

    def test_fixed_response(self):
        """固定响应模式：每次调用返回相同内容。"""
        client = MockLLMClient(fixed_response="hello xslt")
        resp = client.chat("任何 prompt")
        assert resp.content == "hello xslt"
        assert resp.provider == "mock"
        assert resp.model == "mock"

    def test_response_map(self):
        """关键字映射模式：根据 prompt 内容返回不同响应。"""
        client = MockLLMClient(
            response_map={"rename": "rename-response", "delete": "delete-response"},
            fallback="fallback-response",
        )
        assert client.chat("请处理 rename 规则").content == "rename-response"
        assert client.chat("请处理 delete 规则").content == "delete-response"
        assert client.chat("其他请求").content == "fallback-response"

    def test_call_history_recorded(self):
        """调用历史应被记录，便于测试断言。"""
        client = MockLLMClient(fixed_response="ok")
        client.chat("第一次")
        client.chat("第二次")
        assert len(client.call_history) == 2
        assert "第一次" in client.call_history[0]["messages"][-1]["content"]

    def test_reset_clears_history(self):
        """reset() 应清空调用历史。"""
        client = MockLLMClient(fixed_response="ok")
        client.chat("test")
        client.reset()
        assert len(client.call_history) == 0

    def test_total_tokens_estimated(self):
        """token 数基于内容长度估算，应大于 0。"""
        client = MockLLMClient(fixed_response="x" * 400)
        resp = client.chat("y" * 400)
        assert resp.total_tokens > 0

    def test_system_prompt_included_in_history(self):
        """system_prompt 应出现在 call_history 的消息中。"""
        client = MockLLMClient(fixed_response="ok")
        client.chat("user msg", system_prompt="you are an expert")
        msgs = client.call_history[0]["messages"]
        roles = [m["role"] for m in msgs]
        assert "system" in roles
        assert "user" in roles


# =============================================================================
# 2. create_llm_client 工厂函数测试
# =============================================================================

class TestCreateLLMClient:
    """测试工厂函数对各 provider 的路由。"""

    def test_mock_provider(self):
        client = create_llm_client("mock", fixed_response="test")
        assert isinstance(client, MockLLMClient)
        assert client.provider_name == "mock"

    def test_qwen_provider_routing(self):
        """qwen/dashscope/tongyi 三个别名都应路由到 QwenClient。"""
        for alias in ("qwen", "dashscope", "tongyi"):
            client = create_llm_client(alias, api_key="fake-key")
            assert isinstance(client, QwenClient), f"alias={alias} 未路由到 QwenClient"
            assert client.provider_name == "qwen"

    def test_deepseek_provider_routing(self):
        """deepseek 应路由到 DeepseekClient。"""
        client = create_llm_client("deepseek", api_key="fake-key")
        assert isinstance(client, DeepseekClient)
        assert client.provider_name == "deepseek"

    def test_qwen_default_model(self):
        """Qwen 默认模型应为 qwen-plus。"""
        client = create_llm_client("qwen", api_key="fake-key")
        assert client.model == "qwen-plus"

    def test_deepseek_default_model(self):
        """Deepseek 默认模型应为 deepseek-chat。"""
        client = create_llm_client("deepseek", api_key="fake-key")
        assert client.model == "deepseek-chat"

    def test_qwen_custom_model(self):
        """指定模型名称应被正确传入。"""
        client = create_llm_client("qwen", model="qwen-max", api_key="fake-key")
        assert client.model == "qwen-max"

    def test_unknown_provider_raises(self):
        with pytest.raises(ValueError, match="不支持的 LLM provider"):
            create_llm_client("unknown-provider-xyz")

    def test_provider_case_insensitive(self):
        """provider 名称大小写不敏感。"""
        client = create_llm_client("MOCK", fixed_response="ok")
        assert client.provider_name == "mock"


# =============================================================================
# 3. Qwen 真实集成测试（需要 DASHSCOPE_API_KEY，否则自动跳过）
# =============================================================================

# 检测是否存在 API Key
_DASHSCOPE_KEY = os.environ.get("DASHSCOPE_API_KEY") or os.environ.get("QWEN_API_KEY")

@pytest.mark.skipif(not _DASHSCOPE_KEY, reason="未设置 DASHSCOPE_API_KEY，跳过 Qwen 真实调用测试")
class TestQwenLiveIntegration:
    """
    Qwen 真实 API 集成测试。

    运行前提：
        export DASHSCOPE_API_KEY=sk-xxxxxxxxxxxx

    运行命令（仅跑此分组）：
        DASHSCOPE_API_KEY=sk-xxx PYTHONPATH=src/main/python \\
          venv/bin/python3 -m pytest tests/ai/test_phase2_ai.py::TestQwenLiveIntegration -v -s
    """

    @pytest.fixture
    def intent(self):
        return IntentParser().parse(INTENT_FILE)

    def test_qwen_simple_chat(self):
        """Qwen 基础对话：验证 API 可达、响应非空。"""
        client = QwenClient(model="qwen-turbo")   # turbo 最快最省钱
        resp = client.chat("请用一句话回答：XSLT 是什么？")
        assert resp.content, "Qwen 返回了空响应"
        assert resp.provider == "qwen"
        assert resp.total_tokens > 0
        print(f"\n[Qwen simple chat] 响应: {resp.content[:200]}")
        print(f"[Qwen simple chat] tokens={resp.total_tokens}，耗时={resp.latency_ms:.0f}ms")

    def test_qwen_xslt_generation(self, intent, tmp_path):
        """Qwen 完整 XSLT 生成：从意图文档生成可用的 XSLT 并通过验证。"""
        from lens_migration.ai.xslt_refiner import XSLTRefiner

        input_xml = INPUT_FILE.read_text(encoding="utf-8")
        expected_xml = EXPECTED_FILE.read_text(encoding="utf-8")

        client  = QwenClient(model="qwen-plus")
        refiner = XSLTRefiner(client, max_rounds=3)

        result = refiner.refine(
            intent=intent,
            input_xml=input_xml,
            input_xml_path=INPUT_FILE,
            expected_output=expected_xml,
            expected_output_path=EXPECTED_FILE,
            output_xslt=tmp_path / "qwen-generated.xslt",
        )

        print(f"\n[Qwen XSLT gen] 结果: success={result['success']}，"
              f"rounds={result['rounds_used']}，tokens={result['total_tokens']}")
        for i, rec in enumerate(result["round_history"], 1):
            print(f"  Round {i}: syntax={rec['syntax_valid']}，"
                  f"transform={rec['transformation_ok']}，"
                  f"tests={rec['tests_passed']}，"
                  f"tokens={rec['tokens']}，耗时={rec['latency_ms']:.0f}ms")
        if result.get("errors"):
            print(f"  错误: {result['errors']}")

        # 至少语法合法（即使语义比对未完全通过，也应生成有效 XSLT）
        assert result["rounds_used"] >= 1, "应至少完成一轮生成"
        assert result["round_history"][0]["syntax_valid"], \
            f"第 1 轮 XSLT 语法应有效，错误: {result['round_history'][0]['errors']}"

    def test_qwen_refinement_on_bad_xslt(self, intent, tmp_path):
        """验证 Qwen 在第 1 轮失败时，第 2 轮能修正并生成有效 XSLT。"""
        from lens_migration.ai.xslt_refiner import XSLTRefiner
        from lens_migration.ai.prompt_builder import PromptBuilder

        input_xml = INPUT_FILE.read_text(encoding="utf-8")
        call_count = {"n": 0}

        client = QwenClient(model="qwen-plus")
        original_do_chat = client._do_chat.__func__

        def patched_do_chat(self_inner, messages, **kwargs):
            call_count["n"] += 1
            if call_count["n"] == 1:
                # 强制第 1 轮返回无效内容
                return LLMResponse(
                    content="this is not valid xslt",
                    model="qwen-plus", provider="qwen"
                )
            # 第 2 轮以后走真实 Qwen API
            return original_do_chat(self_inner, messages, **kwargs)

        with patch.object(type(client), "_do_chat", patched_do_chat):
            refiner = XSLTRefiner(client, max_rounds=3)
            result = refiner.refine(
                intent=intent,
                input_xml=input_xml,
                input_xml_path=INPUT_FILE,
                output_xslt=tmp_path / "qwen-refined.xslt",
            )

        print(f"\n[Qwen refinement] rounds={result['rounds_used']}，"
              f"success={result['success']}，tokens={result['total_tokens']}")

        assert result["rounds_used"] >= 2, "应至少经历 2 轮（第 1 轮强制失败）"
        # 第 2 轮开始是真实 Qwen 调用，应能生成语法合法的 XSLT
        if len(result["round_history"]) >= 2:
            assert result["round_history"][1]["syntax_valid"], \
                f"第 2 轮 XSLT 应语法合法，错误: {result['round_history'][1]['errors']}"


# =============================================================================
# 4. PromptBuilder 测试
# =============================================================================

class TestPromptBuilder:
    """测试 PromptBuilder 构建的 Prompt 内容。"""

    @pytest.fixture
    def intent(self):
        return IntentParser().parse(INTENT_FILE)

    @pytest.fixture
    def input_xml(self):
        return INPUT_FILE.read_text(encoding="utf-8")

    @pytest.fixture
    def expected_xml(self):
        return EXPECTED_FILE.read_text(encoding="utf-8")

    def test_system_prompt_contains_xslt_rules(self, intent, input_xml):
        """system_prompt 应包含 XSLT 输出规范关键词。"""
        builder = PromptBuilder()
        system, user = builder.build_generate_prompt(intent, input_xml)
        assert "Identity Template" in system
        assert "xmlns:xsl" in system
        assert "exclude-result-prefixes" in system

    def test_user_prompt_contains_intent_title(self, intent, input_xml):
        """user_prompt 应包含意图文档标题。"""
        builder = PromptBuilder()
        _, user = builder.build_generate_prompt(intent, input_xml)
        assert intent.title in user

    def test_user_prompt_contains_rules(self, intent, input_xml):
        """user_prompt 应包含所有规则描述。"""
        builder = PromptBuilder()
        _, user = builder.build_generate_prompt(intent, input_xml)
        for rule in intent.rules:
            assert rule.description in user

    def test_user_prompt_contains_input_xml(self, intent, input_xml):
        """user_prompt 应包含输入 XML 片段。"""
        builder = PromptBuilder()
        _, user = builder.build_generate_prompt(intent, input_xml)
        assert "classifiers" in user     # XML 根元素名

    def test_user_prompt_contains_expected_output(self, intent, input_xml, expected_xml):
        """有期望输出时，user_prompt 应包含期望输出片段。"""
        builder = PromptBuilder()
        _, user = builder.build_generate_prompt(intent, input_xml, expected_xml)
        assert "期望输出" in user

    def test_refinement_prompt_contains_errors(self, intent, input_xml):
        """修正 Prompt 应包含上一轮错误信息。"""
        builder = PromptBuilder()
        _, original = builder.build_generate_prompt(intent, input_xml)
        refinement = builder.build_refinement_prompt(
            previous_xslt=INVALID_XSLT,
            errors=["XSLT 语法错误: 无效标签", "转换失败"],
            warnings=[],
            original_user_prompt=original,
        )
        assert "XSLT 语法错误" in refinement
        assert "上一轮生成结果有误" in refinement
        assert INVALID_XSLT in refinement


# =============================================================================
# 5. XSLTRefiner 测试
# =============================================================================

class TestXSLTRefiner:
    """测试 XSLTRefiner 的迭代逻辑（全部使用 Mock）。"""

    @pytest.fixture
    def intent(self):
        return IntentParser().parse(INTENT_FILE)

    @pytest.fixture
    def input_xml(self):
        return INPUT_FILE.read_text(encoding="utf-8")

    def test_success_on_first_round(self, intent, input_xml, tmp_path):
        """Mock 返回合法 XSLT → 第 1 轮应通过，rounds_used=1。"""
        client = MockLLMClient(fixed_response=VALID_XSLT)
        refiner = XSLTRefiner(client, max_rounds=3)
        result = refiner.refine(
            intent=intent,
            input_xml=input_xml,
            input_xml_path=INPUT_FILE,
            output_xslt=tmp_path / "out.xslt",
        )
        assert result["success"] is True
        assert result["rounds_used"] == 1
        assert len(result["round_history"]) == 1

    def test_failure_then_success_on_second_round(self, intent, input_xml, tmp_path):
        """第 1 轮返回无效 XSLT，第 2 轮返回合法 XSLT → rounds_used=2。"""
        call_count = {"n": 0}
        original_do_chat = MockLLMClient._do_chat

        def patched_do_chat(self_inner, messages, **kwargs):
            call_count["n"] += 1
            if call_count["n"] == 1:
                from lens_migration.ai.llm_client import LLMResponse
                return LLMResponse(content=INVALID_XSLT, model="mock", provider="mock")
            return original_do_chat(self_inner, messages, **kwargs)

        client = MockLLMClient(fixed_response=VALID_XSLT)
        with patch.object(MockLLMClient, "_do_chat", patched_do_chat):
            refiner = XSLTRefiner(client, max_rounds=3)
            result = refiner.refine(
                intent=intent,
                input_xml=input_xml,
                input_xml_path=INPUT_FILE,
                output_xslt=tmp_path / "out.xslt",
            )
        assert result["rounds_used"] == 2
        assert result["success"] is True

    def test_all_rounds_fail(self, intent, input_xml, tmp_path):
        """每轮都返回无效 XSLT → success=False，rounds_used=max_rounds。"""
        client = MockLLMClient(fixed_response=INVALID_XSLT)
        refiner = XSLTRefiner(client, max_rounds=2)
        result = refiner.refine(
            intent=intent,
            input_xml=input_xml,
            input_xml_path=INPUT_FILE,
            output_xslt=tmp_path / "out.xslt",
        )
        assert result["success"] is False
        assert result["rounds_used"] == 2

    def test_round_history_recorded(self, intent, input_xml, tmp_path):
        """每轮结果都应记录在 round_history 中。"""
        client = MockLLMClient(fixed_response=VALID_XSLT)
        refiner = XSLTRefiner(client, max_rounds=3)
        result = refiner.refine(
            intent=intent,
            input_xml=input_xml,
            input_xml_path=INPUT_FILE,
            output_xslt=tmp_path / "out.xslt",
        )
        assert len(result["round_history"]) >= 1
        record = result["round_history"][0]
        assert "round" in record
        assert "success" in record
        assert "tokens" in record

    def test_xslt_extract_from_code_block(self):
        """_extract_xslt 应能从 ```xml 代码块中提取 XSLT。"""
        wrapped = f"Here is the result:\n```xml\n{VALID_XSLT}\n```\nDone."
        extracted = XSLTRefiner._extract_xslt(wrapped)
        assert extracted.startswith("<?xml")

    def test_xslt_extract_direct_xml(self):
        """_extract_xslt 应能从无代码块的纯 XML 中提取 XSLT。"""
        extracted = XSLTRefiner._extract_xslt(VALID_XSLT)
        assert extracted.startswith("<?xml")

    def test_xslt_extract_returns_empty_for_garbage(self):
        """无法识别的内容应返回空字符串。"""
        extracted = XSLTRefiner._extract_xslt("blah blah blah no xml here")
        assert extracted == ""


# =============================================================================
# 6. MigrationEngine.migrate_with_ai 集成测试
# =============================================================================

class TestMigrationEngineAI:
    """端到端集成测试：MigrationEngine AI 路径（使用 Mock）。"""

    def test_migrate_with_ai_mock_success(self, tmp_path):
        """Mock 返回合法 XSLT → migrate_with_ai 应返回 success=True。"""
        engine = MigrationEngine(work_dir=tmp_path / "work")
        result = engine.migrate_with_ai(
            intent_file=INTENT_FILE,
            input_xml=INPUT_FILE,
            expected_output_xml=EXPECTED_FILE,
            output_xslt=tmp_path / "ai-out.xslt",
            llm_provider="mock",
            fixed_response=VALID_XSLT,
            max_rounds=3,
        )
        assert result["success"] is True
        assert result["rounds_used"] == 1
        assert Path(result["xslt_file"]).exists()
        assert result["total_tokens"] > 0

    def test_migrate_with_ai_result_fields(self, tmp_path):
        """结果字典应包含所有预期字段。"""
        engine = MigrationEngine(work_dir=tmp_path / "work")
        result = engine.migrate_with_ai(
            intent_file=INTENT_FILE,
            input_xml=INPUT_FILE,
            llm_provider="mock",
            fixed_response=VALID_XSLT,
        )
        expected_keys = {
            "success", "intent_file", "input_xml", "xslt_file",
            "rounds_used", "total_tokens", "validation", "round_history", "errors",
        }
        assert expected_keys.issubset(result.keys())

    def test_migrate_with_ai_invalid_provider_raises(self, tmp_path):
        """不支持的 provider 应以错误返回（不抛异常，errors 非空）。"""
        engine = MigrationEngine(work_dir=tmp_path / "work")
        result = engine.migrate_with_ai(
            intent_file=INTENT_FILE,
            input_xml=INPUT_FILE,
            llm_provider="unknown-provider-xyz",
        )
        assert result["success"] is False
        assert len(result["errors"]) > 0

