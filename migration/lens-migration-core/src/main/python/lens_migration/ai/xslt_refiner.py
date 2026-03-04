"""
XSLT Refiner Module（XSLT 迭代修正模块）

当 LLM 首次生成的 XSLT 验证失败时，将错误信息反馈给 LLM 进行自动修正。
最多迭代 N 次，每次携带上一轮的 XSLT + 错误详情，要求 LLM 输出修正版本。

迭代流程：
  Round 1：LLM 根据意图文档 + XML 示例生成初始 XSLT
    ↓ 验证失败？
  Round 2：携带 [初始 XSLT + 错误信息] 请求 LLM 修正
    ↓ 仍然失败？
  Round N：继续迭代，直到通过或达到最大轮次
    ↓
  返回最后一轮结果（无论成功与否）

使用示例：
    refiner = XSLTRefiner(llm_client, max_rounds=3)
    result = refiner.refine(
        intent=intent,
        input_xml=xml_str,
        expected_output=expected_str,
        output_xslt=Path("output.xslt"),
    )
    if result["success"]:
        print(f"第 {result['rounds_used']} 轮通过！")
"""

import re
import logging
from pathlib import Path
from typing import Optional, Dict, Any, List

from lens_migration.ai.llm_client import LLMClient
from lens_migration.ai.prompt_builder import PromptBuilder
from lens_migration.parser.intent_parser import MigrationIntent
from lens_migration.validator.validator import XSLTValidator

logger = logging.getLogger(__name__)


class XSLTRefiner:
    """
    XSLT 迭代修正器。

    编排 LLM 调用 → XSLT 验证 → 错误反馈 → 再次调用的迭代循环。
    """

    def __init__(
        self,
        llm_client: LLMClient,
        max_rounds: int = 3,
        validator: Optional[XSLTValidator] = None,
        prompt_builder: Optional[PromptBuilder] = None,
    ):
        """
        Args:
            llm_client:     已配置的 LLM 客户端（OpenAI / Anthropic / Ollama / Mock）
            max_rounds:     最大迭代轮次（含首次生成），默认 3
            validator:      XSLT 验证器（不传则自动创建）
            prompt_builder: Prompt 构建器（不传则自动创建）
        """
        self.llm = llm_client
        self.max_rounds = max_rounds
        self.validator = validator or XSLTValidator()
        self.prompt_builder = prompt_builder or PromptBuilder()
        logger.info(f"[XSLTRefiner] 初始化完成，provider={llm_client.provider_name}，"
                    f"model={llm_client.model}，max_rounds={max_rounds}")

    def refine(
        self,
        intent: MigrationIntent,
        input_xml: str,
        input_xml_path: Path,
        expected_output: Optional[str] = None,
        expected_output_path: Optional[Path] = None,
        output_xslt: Optional[Path] = None,
    ) -> Dict[str, Any]:
        """
        执行 LLM 生成 + 迭代修正主流程。

        Args:
            intent:               迁移意图对象
            input_xml:            输入 XML 字符串（给 Prompt 用）
            input_xml_path:       输入 XML 文件路径（给 Validator 用）
            expected_output:      期望输出 XML 字符串（给 Prompt 用，可选）
            expected_output_path: 期望输出 XML 文件路径（给 Validator 用，可选）
            output_xslt:          XSLT 输出路径（默认：/tmp/ai-generated.xslt）

        Returns:
            结果字典：
              success         —— 是否最终验证通过
              rounds_used     —— 实际迭代轮次
              xslt_content    —— 最终 XSLT 字符串
              xslt_file       —— XSLT 保存路径
              validation      —— 最后一轮验证结果
              round_history   —— 每轮详情列表
              total_tokens    —— 累计消耗 token 数
              errors          —— 最终错误列表（成功时为空）
        """
        logger.info("=" * 60)
        logger.info(f"[XSLTRefiner] 开始 AI 生成迭代，max_rounds={self.max_rounds}")
        logger.info(f"[XSLTRefiner] 意图：{intent.title}，规则数={len(intent.rules)}")
        logger.info("=" * 60)

        output_xslt = output_xslt or Path("/tmp/ai-generated.xslt")
        output_xslt.parent.mkdir(parents=True, exist_ok=True)

        result: Dict[str, Any] = {
            "success": False,
            "rounds_used": 0,
            "xslt_content": "",
            "xslt_file": str(output_xslt),
            "validation": None,
            "round_history": [],
            "total_tokens": 0,
            "errors": [],
        }

        # 首次生成 Prompt（system + user 固定，后续 refinement 只替换 user）
        system_prompt, user_prompt = self.prompt_builder.build_generate_prompt(
            intent=intent,
            input_xml=input_xml,
            expected_output=expected_output,
        )
        current_user_prompt = user_prompt
        previous_xslt: Optional[str] = None
        previous_validation: Optional[Dict[str, Any]] = None

        for round_num in range(1, self.max_rounds + 1):
            logger.info(f"[XSLTRefiner] ── Round {round_num}/{self.max_rounds} ──")

            # ── 构建本轮 Prompt ───────────────────────────────────────────────
            if round_num > 1 and previous_xslt and previous_validation:
                # 修正轮：在原 prompt 基础上追加错误信息
                current_user_prompt = self.prompt_builder.build_refinement_prompt(
                    previous_xslt=previous_xslt,
                    errors=previous_validation.get("errors", []),
                    warnings=previous_validation.get("warnings", []),
                    original_user_prompt=user_prompt,
                    expected_output=expected_output,
                )
                logger.info(f"[XSLTRefiner]   修正 Prompt 构建完成，"
                            f"错误数={len(previous_validation.get('errors', []))}")

            # ── 调用 LLM ─────────────────────────────────────────────────────
            try:
                llm_response = self.llm.chat(
                    prompt=current_user_prompt,
                    system_prompt=system_prompt,
                    temperature=0.15,      # 代码生成场景，低温度更稳定
                    max_tokens=4096,
                )
                result["total_tokens"] += llm_response.total_tokens
                logger.info(f"[XSLTRefiner]   LLM 响应，tokens={llm_response.total_tokens}，"
                            f"耗时={llm_response.latency_ms:.0f}ms")
            except Exception as e:
                logger.error(f"[XSLTRefiner]   LLM 调用失败: {e}")
                result["errors"].append(f"Round {round_num} LLM 调用失败: {e}")
                break

            # ── 提取 XSLT 内容 ───────────────────────────────────────────────
            xslt_content = self._extract_xslt(llm_response.content)
            result["rounds_used"] = round_num   # 无论是否提取成功，都记录本轮

            if not xslt_content:
                logger.warning(f"[XSLTRefiner]   无法从 LLM 响应中提取有效 XSLT")
                result["errors"].append(f"Round {round_num}: LLM 未返回有效的 XSLT 内容")
                # 记录本轮历史但继续下一轮
                result["round_history"].append({
                    "round": round_num,
                    "success": False,
                    "error": "无有效 XSLT",
                    "raw_response": llm_response.content[:500],
                })
                previous_xslt = llm_response.content  # 原样传给下一轮修正
                previous_validation = {"errors": ["LLM 未返回有效 XSLT"], "warnings": []}
                continue

            logger.info(f"[XSLTRefiner]   提取 XSLT：{len(xslt_content)} 字节")

            # ── 保存 XSLT 到磁盘 ─────────────────────────────────────────────
            output_xslt.write_text(xslt_content, encoding="utf-8")

            # ── 验证 XSLT ────────────────────────────────────────────────────
            validation = self.validator.validate(
                xslt_file=output_xslt,
                input_xml=input_xml_path,
                expected_output=expected_output_path,
            )

            round_record = {
                "round": round_num,
                "success": validation["valid"],
                "syntax_valid": validation["syntax_valid"],
                "transformation_ok": validation["transformation_successful"],
                "tests_passed": validation.get("all_tests_passed", False),
                "errors": validation.get("errors", []),
                "warnings": validation.get("warnings", []),
                "tokens": llm_response.total_tokens,
                "latency_ms": llm_response.latency_ms,
            }
            result["round_history"].append(round_record)
            result["xslt_content"] = xslt_content
            result["validation"] = validation

            # ── 检查是否通过 ─────────────────────────────────────────────────
            if validation["valid"]:
                logger.info(f"[XSLTRefiner]   ✅ Round {round_num} 验证通过！")
                result["success"] = True
                result["errors"] = []
                break
            else:
                errors = validation.get("errors", [])
                warnings = validation.get("warnings", [])
                logger.warning(f"[XSLTRefiner]   ✗ Round {round_num} 验证失败，"
                               f"errors={len(errors)}，warnings={len(warnings)}")
                for err in errors:
                    logger.warning(f"[XSLTRefiner]     错误: {err}")
                result["errors"] = errors
                previous_xslt = xslt_content
                previous_validation = validation

                if round_num == self.max_rounds:
                    logger.warning(f"[XSLTRefiner]   已达最大轮次 {self.max_rounds}，停止迭代")

        # ── 最终汇总 ──────────────────────────────────────────────────────────
        logger.info("=" * 60)
        logger.info(f"[XSLTRefiner] 迭代结束："
                    f"{'✅ 成功' if result['success'] else '✗ 失败'}，"
                    f"共 {result['rounds_used']} 轮，"
                    f"累计 tokens={result['total_tokens']}")
        logger.info("=" * 60)

        return result

    @staticmethod
    def _extract_xslt(llm_output: str) -> str:
        """
        从 LLM 输出中提取纯 XSLT 内容。

        处理以下情况：
          1. LLM 直接输出 XML（理想情况）
          2. LLM 将 XSLT 包裹在 ```xml ... ``` 代码块中
          3. LLM 将 XSLT 包裹在 ```xslt ... ``` 代码块中
          4. LLM 在 XSLT 前后添加了解释文字
        """
        text = llm_output.strip()

        # 尝试提取代码块
        for pattern in [
            r'```(?:xml|xslt)\s*([\s\S]*?)```',  # ```xml/xslt 块
            r'```\s*([\s\S]*?)```',                # 无语言标注的代码块
        ]:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                candidate = match.group(1).strip()
                if candidate.startswith("<?xml") or candidate.startswith("<xsl:"):
                    return candidate

        # 未找到代码块，尝试直接定位 XML 声明或 xsl:stylesheet
        for start_marker in ["<?xml", "<xsl:stylesheet"]:
            idx = text.find(start_marker)
            if idx >= 0:
                return text[idx:].strip()

        # 无法识别
        return ""

