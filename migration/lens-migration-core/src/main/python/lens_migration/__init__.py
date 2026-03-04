#!/usr/bin/env python3
"""
Lens Migration Core —— 主入口模块

提供 YANG 数据迁移工具的顶层接口。
支持"意图驱动迁移"，无需解析 YANG Schema 即可完成数据转换。

三种迁移模式（按实现进度）：
  1. 意图驱动（Intent-Driven） ✅ 当前可用
     —— 依赖：迁移意图文档（Markdown）+ XML 示例
     —— 使用规则引擎生成 XSLT
  2. AI 驱动（AI-Driven） ✅ Phase 2 完成
     —— 依赖：迁移意图文档 + XML 示例 + LLM（OpenAI / Anthropic / Ollama）
     —— 使用 LLM 生成 XSLT，验证失败时自动迭代修正
  3. Schema 驱动（Schema-Driven） 📋 待实现
     —— 依赖：新旧版本 YANG Schema 目录
  4. 混合（Hybrid） 📋 待实现
     —— 同时使用意图文档和 Schema 差异
"""

from pathlib import Path
from typing import Optional, Dict, Any
import json
import logging

from lens_migration.parser.intent_parser import IntentParser
from lens_migration.generator.xslt_generator import XSLTGenerator
from lens_migration.validator.validator import XSLTValidator

# 配置根日志：INFO 级别，格式含时间戳、模块名、级别
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)

logger = logging.getLogger(__name__)


class MigrationEngine:
    """
    迁移引擎 —— 核心编排类。

    负责协调以下组件完成完整的迁移流程：
      - IntentParser  : 解析 Markdown 意图文档，提取迁移规则
      - XSLTGenerator : 根据规则生成 XSLT 样式表
      - XSLTValidator : 验证 XSLT 并比对转换结果
    """

    def __init__(self, work_dir: Path = None):
        """
        初始化迁移引擎。

        Args:
            work_dir: 临时工作目录，用于保存中间文件（XSLT、实际输出等）。
                      默认为当前目录下的 migration_work/。
        """
        self.work_dir = work_dir or Path.cwd() / "migration_work"
        self.work_dir.mkdir(parents=True, exist_ok=True)   # 目录不存在时自动创建

        # 初始化三大核心组件
        self.intent_parser = IntentParser()
        self.xslt_generator = XSLTGenerator()
        self.validator = XSLTValidator()

        logger.info(f"迁移引擎初始化完成，工作目录: {self.work_dir}")

    def migrate_from_intent(
        self,
        intent_file: Path,
        input_xml: Path,
        expected_output_xml: Optional[Path] = None,
        output_xslt: Optional[Path] = None
    ) -> Dict[str, Any]:
        """
        执行意图驱动迁移（当前主要入口）。

        本方法无需 YANG Schema 分析，直接基于：
          1. 自然语言描述的迁移意图文档
          2. 输入 XML 示例
          3. 期望输出 XML 示例（可选，用于验证）

        处理流程：
          Step 1 —— 解析意图文档，提取迁移规则
          Step 2 —— 加载 XML 示例文件
          Step 3 —— 调用 XSLTGenerator 生成 XSLT
          Step 4 —— 将 XSLT 保存到磁盘
          Step 5 —— 调用 XSLTValidator 验证并比对结果

        Args:
            intent_file:        迁移意图文档路径（Markdown 格式）
            input_xml:          输入 XML 示例文件路径
            expected_output_xml: 期望输出 XML 文件路径（可选）
            output_xslt:        生成的 XSLT 保存路径（默认写入 work_dir）

        Returns:
            结果字典，包含：
              success     —— 整体是否成功
              intent_file —— 意图文档路径
              input_xml   —— 输入 XML 路径
              xslt_file   —— 生成的 XSLT 路径
              validation  —— XSLTValidator 返回的验证详情
              errors      —— 错误信息列表
        """
        logger.info("=" * 80)
        logger.info("开始执行意图驱动迁移")
        logger.info("=" * 80)

        result = {
            "success": False,
            "intent_file": str(intent_file),
            "input_xml": str(input_xml),
            "xslt_file": None,
            "validation": None,
            "errors": []
        }

        try:
            # ── Step 1：解析迁移意图 ─────────────────────────────────────────
            logger.info("Step 1：解析迁移意图文档...")
            intent = self.intent_parser.parse(intent_file)
            logger.info(f"  ✓ 提取到 {len(intent.rules)} 条迁移规则")

            # ── Step 2：加载 XML 示例 ────────────────────────────────────────
            logger.info("Step 2：加载 XML 示例文件...")
            with open(input_xml, 'r') as f:
                input_xml_content = f.read()
            logger.info(f"  ✓ 输入 XML 加载完成（{len(input_xml_content)} 字节）")

            expected_output_content = None
            if expected_output_xml and expected_output_xml.exists():
                with open(expected_output_xml, 'r') as f:
                    expected_output_content = f.read()
                logger.info(f"  ✓ 期望输出加载完成（{len(expected_output_content)} 字节）")

            # ── Step 3：生成 XSLT ────────────────────────────────────────────
            logger.info("Step 3：生成 XSLT 转换样式表...")
            xslt_content = self.xslt_generator.generate(
                intent=intent,
                input_xml=input_xml_content,
                expected_output=expected_output_content
            )
            logger.info(f"  ✓ XSLT 生成完成（{len(xslt_content)} 字节）")

            # ── Step 4：保存 XSLT ────────────────────────────────────────────
            if output_xslt is None:
                output_xslt = self.work_dir / "generated-transform.xslt"

            output_xslt.parent.mkdir(parents=True, exist_ok=True)
            with open(output_xslt, 'w') as f:
                f.write(xslt_content)
            logger.info(f"  ✓ XSLT 已保存至: {output_xslt}")

            result["xslt_file"] = str(output_xslt)

            # ── Step 5：验证 XSLT ────────────────────────────────────────────
            logger.info("Step 5：验证 XSLT 并比对输出...")
            validation_result = self.validator.validate(
                xslt_file=output_xslt,
                input_xml=input_xml,
                expected_output=expected_output_xml
            )

            result["validation"] = validation_result

            if validation_result["valid"]:
                logger.info("  ✓ XSLT 验证通过")
                if validation_result.get("all_tests_passed"):
                    logger.info("  ✓ 转换结果与期望一致，所有测试通过")
                result["success"] = True
            else:
                logger.warning("  ✗ XSLT 验证失败")
                result["errors"] = validation_result.get("errors", [])

            logger.info("=" * 80)
            logger.info("意图驱动迁移完成")
            logger.info("=" * 80)

        except Exception as e:
            logger.error(f"迁移执行异常: {e}", exc_info=True)
            result["errors"].append(str(e))

        return result

    def migrate_with_ai(
        self,
        intent_file: Path,
        input_xml: Path,
        expected_output_xml: Optional[Path] = None,
        output_xslt: Optional[Path] = None,
        llm_provider: str = "mock",
        llm_model: Optional[str] = None,
        max_rounds: int = 3,
        **llm_kwargs,
    ) -> Dict[str, Any]:
        """
        执行 AI 驱动迁移（Phase 2）。

        使用 LLM 生成 XSLT，若验证失败则自动多轮迭代修正。
        与 migrate_from_intent() 互补：规则引擎处理结构清晰的规则，
        AI 路径处理复杂嵌套或规则引擎无法推导的情况。

        Args:
            intent_file:        迁移意图文档路径（Markdown 格式）
            input_xml:          输入 XML 示例文件路径
            expected_output_xml: 期望输出 XML 文件路径（可选，用于验证和 Prompt）
            output_xslt:        生成的 XSLT 保存路径（默认写入 work_dir）
            llm_provider:       LLM Provider："openai"/"anthropic"/"ollama"/"mock"
            llm_model:          模型名称（不传则使用 Provider 默认值）
            max_rounds:         最大迭代轮次（含首次生成），默认 3
            **llm_kwargs:       传递给 LLMClient 的额外参数（如 api_key、base_url）

        Returns:
            结果字典，包含：
              success         —— 最终是否验证通过
              intent_file     —— 意图文档路径
              input_xml       —— 输入 XML 路径
              xslt_file       —— 生成的 XSLT 路径
              rounds_used     —— 实际迭代轮次
              total_tokens    —— 累计消耗 token 数
              validation      —— 最后一轮验证详情
              round_history   —— 每轮迭代历史
              errors          —— 最终错误列表
        """
        from lens_migration.ai.llm_client import create_llm_client
        from lens_migration.ai.xslt_refiner import XSLTRefiner

        logger.info("=" * 80)
        logger.info("开始执行 AI 驱动迁移")
        logger.info(f"  provider={llm_provider}，model={llm_model or '(default)'}，max_rounds={max_rounds}")
        logger.info("=" * 80)

        result: Dict[str, Any] = {
            "success": False,
            "intent_file": str(intent_file),
            "input_xml": str(input_xml),
            "xslt_file": None,
            "rounds_used": 0,
            "total_tokens": 0,
            "validation": None,
            "round_history": [],
            "errors": [],
        }

        try:
            # Step 1：解析意图
            logger.info("Step 1：解析迁移意图文档...")
            intent = self.intent_parser.parse(intent_file)
            logger.info(f"  ✓ 提取到 {len(intent.rules)} 条迁移规则")

            # Step 2：加载 XML 文件
            logger.info("Step 2：加载 XML 示例文件...")
            input_xml_content = input_xml.read_text(encoding="utf-8")
            expected_output_content = None
            if expected_output_xml and expected_output_xml.exists():
                expected_output_content = expected_output_xml.read_text(encoding="utf-8")
                logger.info(f"  ✓ 期望输出加载完成（{len(expected_output_content)} 字节）")

            # Step 3：创建 LLM 客户端
            logger.info(f"Step 3：创建 LLM 客户端（{llm_provider}）...")
            llm_client = create_llm_client(llm_provider, model=llm_model, **llm_kwargs)
            logger.info(f"  ✓ LLM 客户端就绪")

            # Step 4：XSLT 生成 + 迭代修正
            if output_xslt is None:
                output_xslt = self.work_dir / "ai-generated-transform.xslt"

            logger.info(f"Step 4：启动 XSLT 生成迭代（max_rounds={max_rounds}）...")
            refiner = XSLTRefiner(llm_client, max_rounds=max_rounds, validator=self.validator)
            refine_result = refiner.refine(
                intent=intent,
                input_xml=input_xml_content,
                input_xml_path=input_xml,
                expected_output=expected_output_content,
                expected_output_path=expected_output_xml,
                output_xslt=output_xslt,
            )

            # 汇总结果
            result.update({
                "success": refine_result["success"],
                "xslt_file": refine_result["xslt_file"],
                "rounds_used": refine_result["rounds_used"],
                "total_tokens": refine_result["total_tokens"],
                "validation": refine_result["validation"],
                "round_history": refine_result["round_history"],
                "errors": refine_result["errors"],
            })

            if result["success"]:
                logger.info(f"  ✅ AI 迁移成功（第 {result['rounds_used']} 轮通过）")
            else:
                logger.warning(f"  ✗ AI 迁移失败（{max_rounds} 轮后仍未通过）")

            logger.info("=" * 80)
            logger.info("AI 驱动迁移完成")
            logger.info("=" * 80)

        except Exception as e:
            logger.error(f"AI 迁移执行异常: {e}", exc_info=True)
            result["errors"].append(str(e))

        return result

    def migrate_from_schema_diff(
        self,
        old_yang_dir: Path,
        new_yang_dir: Path,
        intent_file: Optional[Path] = None,
        output_xslt: Optional[Path] = None
    ) -> Dict[str, Any]:
        """
        执行 Schema 驱动迁移（待实现）。

        通过分析新旧 YANG Schema 差异自动生成 XSLT，适用于
        Yang 模型结构发生变化的升级场景。

        Args:
            old_yang_dir: 旧版本 YANG 文件目录
            new_yang_dir: 新版本 YANG 文件目录
            intent_file:  可选的补充意图文档（处理 Schema 差异无法覆盖的情况）
            output_xslt:  生成的 XSLT 保存路径

        Raises:
            NotImplementedError: 该功能尚未实现，请使用 migrate_from_intent()
        """
        raise NotImplementedError(
            "Schema 驱动迁移尚未实现，请使用 migrate_from_intent()。"
        )


def main():
    """
    命令行入口函数。

    支持的参数：
      --intent          意图文档路径（必填）
      --input-xml       输入 XML 路径（必填）
      --expected-output 期望输出 XML 路径（可选，用于验证）
      --output-xslt     XSLT 输出路径（可选）
      --work-dir        临时工作目录（可选）
      --json-output     以 JSON 格式输出结果（可选）
    """
    import argparse

    parser = argparse.ArgumentParser(
        description="YANG 数据迁移工具 —— 从迁移意图生成 XSLT 转换样式表"
    )

    parser.add_argument(
        "--intent",
        type=Path,
        required=True,
        help="迁移意图文档路径（Markdown 格式，必填）"
    )

    parser.add_argument(
        "--input-xml",
        type=Path,
        required=True,
        help="输入 XML 示例路径（必填）"
    )

    parser.add_argument(
        "--expected-output",
        type=Path,
        help="期望输出 XML 路径（可选，用于验证转换结果）"
    )

    parser.add_argument(
        "--output-xslt",
        type=Path,
        help="生成的 XSLT 保存路径（默认：migration_work/generated-transform.xslt）"
    )

    parser.add_argument(
        "--work-dir",
        type=Path,
        help="临时工作目录（默认：./migration_work）"
    )

    parser.add_argument(
        "--json-output",
        action="store_true",
        help="以 JSON 格式输出结果（适合程序化调用）"
    )

    args = parser.parse_args()

    # 创建迁移引擎实例
    engine = MigrationEngine(work_dir=args.work_dir)

    # 执行意图驱动迁移
    result = engine.migrate_from_intent(
        intent_file=args.intent,
        input_xml=args.input_xml,
        expected_output_xml=args.expected_output,
        output_xslt=args.output_xslt
    )

    # 输出结果
    if args.json_output:
        # JSON 模式：输出机器可读的结果
        print(json.dumps(result, indent=2))
    else:
        # 人类可读模式
        if result["success"]:
            print("\n✅ 迁移完成！")
            print(f"XSLT 已保存至: {result['xslt_file']}")
        else:
            print("\n❌ 迁移失败！")
            for error in result["errors"]:
                print(f"  错误: {error}")
            return 1

    return 0 if result["success"] else 1


if __name__ == "__main__":
    exit(main())
