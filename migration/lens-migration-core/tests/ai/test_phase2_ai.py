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
    GitHubModelsClient,
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

# ── 模块级：各 Provider 可用性检测（在所有类定义之前执行）──────────────────────

# GitHub Token
_GITHUB_TOKEN = os.environ.get("GITHUB_TOKEN") or os.environ.get("GH_TOKEN")

# Qwen / DashScope Key
_DASHSCOPE_KEY = os.environ.get("DASHSCOPE_API_KEY") or os.environ.get("QWEN_API_KEY")

# Ollama：优先使用 conftest.py 根据 OLLAMA_TARGET 设置的 OLLAMA_MODEL / OLLAMA_BASE_URL
# OLLAMA_TARGET=remote → localhost:11435 (SSH 隧道到 10.99.79.20，qwen2.5-coder:14b)
# OLLAMA_TARGET=local  → localhost:11434 (qwen2.5-coder:3b)
_OLLAMA_MODEL_TEST   = os.environ.get("OLLAMA_MODEL",    "qwen2.5-coder:14b")
_OLLAMA_BASE_URL_TEST = os.environ.get("OLLAMA_BASE_URL", "http://localhost:11434/v1")


def _check_ollama_for_test() -> tuple:
    """检测 OLLAMA_BASE_URL 指向的 Ollama 服务是否可达，且目标模型已安装。"""
    import urllib.request, json
    api_base = _OLLAMA_BASE_URL_TEST.replace("/v1", "").rstrip("/")
    try:
        with urllib.request.urlopen(f"{api_base}/api/tags", timeout=5) as r:
            data = json.loads(r.read())
        models = [m.get("name", "") for m in data.get("models", [])]
        base = _OLLAMA_MODEL_TEST.split(":")[0]
        found = any(m == _OLLAMA_MODEL_TEST or m.startswith(base + ":") for m in models)
        if not found:
            return False, (f"Ollama 在线但未找到模型 '{_OLLAMA_MODEL_TEST}'，"
                           f"已有: {models}。请运行: ollama pull {_OLLAMA_MODEL_TEST}")
        return True, f"Ollama 可用，model={_OLLAMA_MODEL_TEST}，url={_OLLAMA_BASE_URL_TEST}"
    except Exception as e:
        return False, f"Ollama 不可达 ({_OLLAMA_BASE_URL_TEST}): {e}"


_OLLAMA_TEST_OK, _OLLAMA_TEST_REASON = _check_ollama_for_test()


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

    def test_github_provider_routing(self):
        """github / github_models / githubmodels 三个别名都应路由到 GitHubModelsClient。"""
        for alias in ("github", "github_models", "githubmodels"):
            client = create_llm_client(alias, token="ghp_fake_token_for_test")
            assert isinstance(client, GitHubModelsClient), f"alias={alias} 未路由到 GitHubModelsClient"
            assert client.provider_name == "github"

    def test_github_default_model(self):
        """GitHub Models 默认模型应为 gpt-4o。"""
        client = create_llm_client("github", token="ghp_fake_token_for_test")
        assert client.model == "gpt-4o"

    def test_github_custom_model(self):
        """指定 GitHub Models 模型名称应被正确传入。"""
        client = create_llm_client("github", model="gpt-4o-mini", token="ghp_fake_token_for_test")
        assert client.model == "gpt-4o-mini"

    def test_github_missing_token_raises(self):
        """未提供 GITHUB_TOKEN 时应抛出 ValueError。"""
        # 确保环境变量未设置
        env_backup = {}
        for k in ("GITHUB_TOKEN", "GH_TOKEN"):
            env_backup[k] = os.environ.pop(k, None)
        try:
            with pytest.raises(ValueError, match="GITHUB_TOKEN"):
                create_llm_client("github")
        finally:
            for k, v in env_backup.items():
                if v is not None:
                    os.environ[k] = v

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

    def test_ollama_provider_routing(self):
        """ollama / local 两个别名都应路由到 OllamaClient。"""
        from lens_migration.ai.llm_client import OllamaClient
        for alias in ("ollama", "local"):
            client = create_llm_client(alias, model="qwen3:8b")
            assert isinstance(client, OllamaClient), f"alias={alias} 未路由到 OllamaClient"
            assert client.provider_name == "ollama"

    def test_ollama_default_model(self):
        """Ollama 默认模型应为 qwen3:8b（无 OLLAMA_MODEL 环境变量时）。"""
        from lens_migration.ai.llm_client import OllamaClient
        env_backup = os.environ.pop("OLLAMA_MODEL", None)
        try:
            client = create_llm_client("ollama")
            assert client.model == "qwen3:8b"
        finally:
            if env_backup:
                os.environ["OLLAMA_MODEL"] = env_backup

    def test_ollama_api_key_from_env(self):
        """OLLAMA_API_KEY 环境变量应被 OllamaClient 正确读取（不报错）。"""
        from lens_migration.ai.llm_client import OllamaClient
        os.environ["OLLAMA_API_KEY"] = "test-key-from-env"
        try:
            client = OllamaClient(model="qwen3:8b")
            # 客户端应正常构建，不抛异常
            assert client.provider_name == "ollama"
        finally:
            os.environ.pop("OLLAMA_API_KEY", None)

    def test_ollama_api_key_explicit_param(self):
        """显式传入 api_key 参数时，OllamaClient 应使用该 key（不报错）。"""
        from lens_migration.ai.llm_client import OllamaClient
        client = OllamaClient(model="qwen3:8b", api_key="explicit-key")
        assert client.provider_name == "ollama"

    def test_ollama_no_api_key_fallback(self):
        """未设置 OLLAMA_API_KEY 时，OllamaClient 应 fallback 到 'ollama' 占位符（本地模式）。"""
        from lens_migration.ai.llm_client import OllamaClient
        env_backup = os.environ.pop("OLLAMA_API_KEY", None)
        try:
            # 不传 api_key，不设置 OLLAMA_API_KEY → 使用 "ollama" 占位符，不抛异常
            client = OllamaClient(model="qwen3:8b")
            assert client.provider_name == "ollama"
        finally:
            if env_backup:
                os.environ["OLLAMA_API_KEY"] = env_backup


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

    def test_output_xslt_written_to_disk(self, intent, input_xml, tmp_path):
        """成功时 output_xslt 文件应写入磁盘且内容非空。"""
        client = MockLLMClient(fixed_response=VALID_XSLT)
        refiner = XSLTRefiner(client, max_rounds=3)
        out = tmp_path / "result.xslt"
        result = refiner.refine(
            intent=intent,
            input_xml=input_xml,
            input_xml_path=INPUT_FILE,
            output_xslt=out,
        )
        assert result["success"] is True
        assert out.exists(), "输出文件应写入磁盘"
        content = out.read_text(encoding="utf-8")
        assert "xsl:stylesheet" in content, "输出文件应包含有效 XSLT 内容"

    def test_total_tokens_accumulated(self, intent, input_xml, tmp_path):
        """多轮迭代后 total_tokens 应为各轮之和。"""
        # 用一个能被 _extract_xslt 提取但 XML 语法无效的内容（触发验证失败而非提取失败）
        BROKEN_BUT_EXTRACTABLE = (
            "<?xml version=\"1.0\"?>\n"
            "<xsl:stylesheet xmlns:xsl=\"http://www.w3.org/1999/XSL/Transform\">\n"
            "  <UNCLOSED_TAG>\n"
            "</xsl:stylesheet>"
        )
        call_count = {"n": 0}
        original_do_chat = MockLLMClient._do_chat

        def patched(self_inner, messages, **kwargs):
            call_count["n"] += 1
            if call_count["n"] == 1:
                return LLMResponse(content=BROKEN_BUT_EXTRACTABLE, model="mock", provider="mock")
            return original_do_chat(self_inner, messages, **kwargs)

        client = MockLLMClient(fixed_response=VALID_XSLT)
        with patch.object(MockLLMClient, "_do_chat", patched):
            refiner = XSLTRefiner(client, max_rounds=3)
            result = refiner.refine(
                intent=intent,
                input_xml=input_xml,
                input_xml_path=INPUT_FILE,
                output_xslt=tmp_path / "out.xslt",
            )
        assert result["rounds_used"] >= 2, f"应至少 2 轮，实际={result['rounds_used']}"
        assert result["total_tokens"] > 0
        # total_tokens 应为各轮 tokens 之和（跳过无 tokens 字段的轮次）
        summed = sum(rec.get("tokens", 0) for rec in result["round_history"])
        assert result["total_tokens"] == summed, \
            f"total_tokens={result['total_tokens']} 应等于各轮之和 {summed}"


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

    def test_migrate_with_ai_workdir_created(self, tmp_path):
        """work_dir 不存在时应自动创建。"""
        work = tmp_path / "auto_created_work"
        assert not work.exists()
        engine = MigrationEngine(work_dir=work)
        engine.migrate_with_ai(
            intent_file=INTENT_FILE,
            input_xml=INPUT_FILE,
            llm_provider="mock",
            fixed_response=VALID_XSLT,
        )
        assert work.exists(), "work_dir 应被自动创建"

    def test_migrate_with_ai_xslt_content(self, tmp_path):
        """成功时，输出的 XSLT 文件应包含 xsl:stylesheet 标签。"""
        engine = MigrationEngine(work_dir=tmp_path / "work")
        out = tmp_path / "final.xslt"
        result = engine.migrate_with_ai(
            intent_file=INTENT_FILE,
            input_xml=INPUT_FILE,
            llm_provider="mock",
            fixed_response=VALID_XSLT,
            output_xslt=out,
        )
        assert result["success"] is True
        if out.exists():
            assert "xsl:stylesheet" in out.read_text(encoding="utf-8")


# =============================================================================
# 7. MigrationEngine + Ollama live 集成（需要 Ollama 可用，否则跳过）
# =============================================================================

@pytest.mark.skipif(not _OLLAMA_TEST_OK, reason=_OLLAMA_TEST_REASON)
class TestMigrationEngineOllamaLive:
    """MigrationEngine 端到端集成，使用真实 Ollama 模型。"""

    def test_migrate_with_ollama_success(self, tmp_path):
        """Ollama 端到端：migrate_with_ai 应返回 success=True，XSLT 语法合法。"""
        engine = MigrationEngine(work_dir=tmp_path / "work")
        out = tmp_path / "ollama-e2e.xslt"
        result = engine.migrate_with_ai(
            intent_file=INTENT_FILE,
            input_xml=INPUT_FILE,
            expected_output_xml=EXPECTED_FILE,
            output_xslt=out,
            llm_provider="ollama",
            llm_model=_OLLAMA_MODEL_TEST,
            base_url=_OLLAMA_BASE_URL_TEST,
            max_rounds=3,
        )
        print(f"\n[MigrationEngine Ollama] model={_OLLAMA_MODEL_TEST}")
        print(f"  success={result['success']}，rounds={result['rounds_used']}，"
              f"tokens={result['total_tokens']}")
        for i, rec in enumerate(result["round_history"], 1):
            print(f"  Round {i}: syntax={rec['syntax_valid']}，"
                  f"transform={rec.get('transformation_ok')}，"
                  f"tokens={rec['tokens']}，耗时={rec.get('latency_ms', 0):.0f}ms")

        assert result["rounds_used"] >= 1
        assert result["round_history"][0]["syntax_valid"], \
            f"第 1 轮应生成有效 XSLT，错误: {result['round_history'][0]['errors']}"


# =============================================================================
# 7. GitHub Models 真实集成测试（需要 GITHUB_TOKEN，否则自动跳过）
# =============================================================================

# 检测是否存在 GitHub Token
_GITHUB_TOKEN = os.environ.get("GITHUB_TOKEN") or os.environ.get("GH_TOKEN")


@pytest.mark.skipif(not _GITHUB_TOKEN, reason="未设置 GITHUB_TOKEN，跳过 GitHub Models 真实调用测试")
class TestGitHubModelsLiveIntegration:
    """
    GitHub Models 真实 API 集成测试。

    无需申请任何 API Key，只需 GitHub Personal Access Token（PAT）。

    获取 Token：
        1. 打开 https://github.com/settings/tokens
        2. 点击 "Generate new token (classic)"
        3. 勾选 "public_repo"（或 "repo"），生成 Token
        4. 复制 Token（格式：ghp_xxxxxxxxxxxx）

    运行命令：
        export GITHUB_TOKEN=ghp_xxxxxxxxxxxx
        PYTHONPATH=src/main/python \\
          venv/bin/python3 -m pytest tests/ai/test_phase2_ai.py::TestGitHubModelsLiveIntegration -v -s

    注意：GitHub Models 有频率限制，请勿频繁大量调用。
    """

    @pytest.fixture
    def intent(self):
        return IntentParser().parse(INTENT_FILE)

    def test_github_simple_chat(self):
        """GitHub Models 基础对话：验证 API 可达、响应非空。"""
        client = GitHubModelsClient(model="gpt-4o-mini")
        resp = client.chat("请用一句话回答：XSLT 是什么？不要超过 50 字。")
        assert resp.content, "GitHub Models 返回了空响应"
        assert resp.provider == "github"
        assert resp.total_tokens > 0
        assert resp.latency_ms > 0
        print(f"\n[GitHub Models simple chat] 响应: {resp.content[:200]}")
        print(f"[GitHub Models simple chat] tokens={resp.total_tokens}，耗时={resp.latency_ms:.0f}ms")

    def test_github_system_prompt(self, intent):
        """GitHub Models 支持 system_prompt，且响应遵循指令。"""
        client = GitHubModelsClient(model="gpt-4o-mini")
        resp = client.chat(
            "什么是 XSLT？",
            system_prompt="你是 XML 专家，用中文回答，不超过 20 字。",
        )
        assert resp.content
        assert resp.provider == "github"
        print(f"\n[GitHub system_prompt] 响应: {resp.content}")

    def test_github_xslt_generation(self, intent, tmp_path):
        """GitHub Models 完整 XSLT 生成：从意图文档生成可用的 XSLT 并通过语法验证。"""
        from lens_migration.ai.xslt_refiner import XSLTRefiner

        input_xml    = INPUT_FILE.read_text(encoding="utf-8")
        expected_xml = EXPECTED_FILE.read_text(encoding="utf-8")
        out_file     = tmp_path / "github-generated.xslt"

        client  = GitHubModelsClient(model="gpt-4o-mini")
        refiner = XSLTRefiner(client, max_rounds=3)

        result = refiner.refine(
            intent=intent,
            input_xml=input_xml,
            input_xml_path=INPUT_FILE,
            expected_output=expected_xml,
            expected_output_path=EXPECTED_FILE,
            output_xslt=out_file,
        )

        print(f"\n[GitHub Models XSLT gen] 结果: success={result['success']}，"
              f"rounds={result['rounds_used']}，tokens={result['total_tokens']}")
        for i, rec in enumerate(result["round_history"], 1):
            print(f"  Round {i}: syntax={rec['syntax_valid']}，"
                  f"transform={rec.get('transformation_ok')}，"
                  f"tokens={rec['tokens']}，耗时={rec['latency_ms']:.0f}ms")
        if result.get("errors"):
            print(f"  错误: {result['errors']}")

        assert result["rounds_used"] >= 1, "应至少完成一轮生成"
        assert out_file.exists(), "XSLT 输出文件应已写入磁盘"
        assert result["round_history"][0]["syntax_valid"], \
            f"第 1 轮 XSLT 语法应有效，错误: {result['round_history'][0]['errors']}"


# =============================================================================
# 8. Ollama 真实集成测试（需要 Ollama 服务运行，否则自动跳过）
# =============================================================================


@pytest.mark.skipif(not _OLLAMA_TEST_OK, reason=_OLLAMA_TEST_REASON)
class TestOllamaLiveIntegration:
    """
    Ollama 本地模型真实 API 集成测试。

    与 GitHub Models 测试完全对称，验证两者通过相同接口可互换。
    认证方式：OLLAMA_API_KEY 环境变量（本地无认证时可不设置）。

    运行前提：
        ollama serve &
        ollama pull qwen3:8b          # 或其他模型
        OLLAMA_MODEL=qwen3:8b \\
          PYTHONPATH=src/main/python \\
          venv/bin/python3 -m pytest tests/ai/test_phase2_ai.py::TestOllamaLiveIntegration -v -s
    """

    @pytest.fixture
    def intent(self):
        return IntentParser().parse(INTENT_FILE)

    def test_ollama_simple_chat(self):
        """
        Ollama 基础连通性：使用 create_llm_client('ollama') 工厂与 GitHub 完全对称调用。
        OLLAMA_API_KEY 环境变量控制认证，本地无认证时自动使用 'ollama' 占位符。
        """
        client = create_llm_client("ollama", model=_OLLAMA_MODEL_TEST)
        resp = client.chat("请用一句话回答：XSLT 是什么？不要超过 50 字。")
        assert resp.content, "Ollama 返回了空响应"
        assert resp.provider == "ollama"
        assert resp.total_tokens > 0
        print(f"\n[Ollama simple chat] 模型={_OLLAMA_MODEL_TEST}")
        print(f"[Ollama simple chat] 响应: {resp.content[:300]}")
        print(f"[Ollama simple chat] tokens={resp.total_tokens}，耗时={resp.latency_ms:.0f}ms")

    def test_ollama_xslt_generation(self, intent, tmp_path):
        """
        Ollama 完整 XSLT 生成：与 GitHub Models 测试相同的流程，
        验证本地模型也能生成语法合法的 XSLT。
        """
        from lens_migration.ai.xslt_refiner import XSLTRefiner

        input_xml    = INPUT_FILE.read_text(encoding="utf-8")
        expected_xml = EXPECTED_FILE.read_text(encoding="utf-8")

        client  = create_llm_client("ollama", model=_OLLAMA_MODEL_TEST)
        refiner = XSLTRefiner(client, max_rounds=3)

        result = refiner.refine(
            intent=intent,
            input_xml=input_xml,
            input_xml_path=INPUT_FILE,
            expected_output=expected_xml,
            expected_output_path=EXPECTED_FILE,
            output_xslt=tmp_path / f"ollama-{_OLLAMA_MODEL_TEST.replace(':', '-')}-generated.xslt",
        )

        print(f"\n[Ollama XSLT gen] 模型={_OLLAMA_MODEL_TEST}")
        print(f"[Ollama XSLT gen] 结果: success={result['success']}，"
              f"rounds={result['rounds_used']}，tokens={result['total_tokens']}")
        for i, rec in enumerate(result["round_history"], 1):
            print(f"  Round {i}: syntax={rec['syntax_valid']}，"
                  f"transform={rec.get('transformation_ok')}，"
                  f"tokens={rec['tokens']}，耗时={rec.get('latency_ms', 0):.0f}ms")
        if result.get("errors"):
            print(f"  错误: {result['errors']}")

        assert result["rounds_used"] >= 1, "应至少完成一轮生成"
        assert result["round_history"][0]["syntax_valid"], \
            f"第 1 轮 XSLT 语法应有效，错误: {result['round_history'][0]['errors']}"

