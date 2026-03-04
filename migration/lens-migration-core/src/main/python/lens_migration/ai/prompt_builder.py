"""
Prompt Builder Module（Prompt 构建模块）

将结构化的迁移意图 + XML 上下文组装成 LLM 可理解的 Prompt。

设计原则：
  - System Prompt  ：告诉 LLM 它是谁、输出格式要求
  - User Prompt    ：提供意图规则 + 输入 XML + 期望输出 + 具体任务
  - Refinement Prompt：在首次结果不满足时，携带错误信息要求 LLM 修正

两种使用场景：
  1. 初次生成（generate_xslt_prompt）
     输入：MigrationIntent + input_xml_str + expected_output_str（可选）
     输出：(system_prompt, user_prompt)

  2. 修正迭代（build_refinement_prompt）
     输入：上一轮 XSLT + 错误信息列表 + 原始 user_prompt
     输出：新的 user_prompt（system_prompt 不变）
"""

import logging
from typing import Optional, List, Tuple

from lens_migration.parser.intent_parser import MigrationIntent, MigrationRule, RuleType

logger = logging.getLogger(__name__)


# ── 系统提示词（固定，不随意图变化）────────────────────────────────────────────

SYSTEM_PROMPT = """\
你是一位 XSLT 1.0 专家，专门为 YANG 数据模型迁移生成 XSLT 转换样式表。

## 输出规范（严格遵守）
1. 只输出完整的、可直接使用的 XSLT 1.0 文件，不添加任何解释文字。
2. 文件以 `<?xml version="1.0" encoding="UTF-8"?>` 开头。
3. 根元素为 `<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" ...>`。
4. 必须包含 Identity Template（恒等变换），作为默认复制行为。
5. 针对每条迁移规则，生成专用的 `<xsl:template>` 覆盖 Identity Template。
6. 如果输入 XML 使用了命名空间，必须在 stylesheet 上声明 `xmlns:ns="<namespace_uri>"`，\
并在所有 match/select 表达式中使用 `ns:` 前缀，同时通过 `exclude-result-prefixes="ns"` \
防止前缀泄漏到输出。
7. 不添加 XML 注释，保持输出简洁。
8. 输出 XML 需保留输入的命名空间声明，不得添加或删除命名空间。

## 常见模式
- 节点重命名：用新元素名包裹 `<xsl:apply-templates>`
- 值替换：直接输出新值，不调用 `apply-templates`
- 删除节点：用空 template 匹配，body 留空
- 新增节点：在适当位置调用 `<xsl:copy>`，然后插入新子节点
"""


class PromptBuilder:
    """
    迁移 Prompt 构建器。

    根据迁移意图和 XML 示例，构建发送给 LLM 的 Prompt 对。
    """

    def build_generate_prompt(
        self,
        intent: MigrationIntent,
        input_xml: str,
        expected_output: Optional[str] = None,
    ) -> Tuple[str, str]:
        """
        构建初次 XSLT 生成 Prompt。

        Args:
            intent:          已解析的迁移意图
            input_xml:       输入 XML 示例字符串
            expected_output: 期望输出 XML 字符串（可选，提供时作为参考）

        Returns:
            (system_prompt, user_prompt) 元组
        """
        logger.info(f"[PromptBuilder] 构建生成 Prompt，规则数={len(intent.rules)}")

        user_prompt = self._build_user_prompt(intent, input_xml, expected_output)

        logger.debug(f"[PromptBuilder] system_prompt 长度={len(SYSTEM_PROMPT)}")
        logger.debug(f"[PromptBuilder] user_prompt 长度={len(user_prompt)}")

        return SYSTEM_PROMPT, user_prompt

    def build_refinement_prompt(
        self,
        previous_xslt: str,
        errors: List[str],
        warnings: List[str],
        original_user_prompt: str,
        actual_output: Optional[str] = None,
        expected_output: Optional[str] = None,
    ) -> str:
        """
        构建修正迭代 Prompt。

        Args:
            previous_xslt:       上一轮生成的 XSLT 内容
            errors:              上一轮验证产生的错误列表
            warnings:            上一轮验证产生的警告列表
            original_user_prompt: 原始用户 Prompt（保持上下文连续性）
            actual_output:       上一轮实际输出的 XML（可选）
            expected_output:     期望输出的 XML（可选）

        Returns:
            新的 user_prompt 字符串（system_prompt 保持不变）
        """
        logger.info(f"[PromptBuilder] 构建修正 Prompt，errors={len(errors)}，warnings={len(warnings)}")

        parts = [
            "## 上一轮生成结果有误，请修正",
            "",
            "### 上一轮 XSLT",
            "```xml",
            previous_xslt.strip(),
            "```",
            "",
        ]

        if errors:
            parts += ["### 错误信息（必须修复）", ""]
            for i, err in enumerate(errors, 1):
                parts.append(f"{i}. {err}")
            parts.append("")

        if warnings:
            parts += ["### 警告信息（建议修复）", ""]
            for i, w in enumerate(warnings, 1):
                parts.append(f"{i}. {w}")
            parts.append("")

        if actual_output and expected_output:
            parts += [
                "### 实际输出（有误）",
                "```xml",
                actual_output.strip()[:2000],  # 截断，避免 Prompt 过长
                "```",
                "",
                "### 期望输出（正确）",
                "```xml",
                expected_output.strip()[:2000],
                "```",
                "",
            ]

        parts += [
            "### 原始需求（供参考）",
            original_user_prompt[:3000],  # 截断原始 prompt，保留核心上下文
            "",
            "请根据上述错误信息，输出修正后的完整 XSLT 文件（只输出 XML，不加任何解释）。",
        ]

        return "\n".join(parts)

    # ── 内部辅助方法 ─────────────────────────────────────────────────────────

    def _build_user_prompt(
        self,
        intent: MigrationIntent,
        input_xml: str,
        expected_output: Optional[str],
    ) -> str:
        """构建完整的用户 Prompt。"""
        parts = [
            f"# 迁移任务：{intent.title}",
            "",
        ]

        # 版本信息
        if intent.source_version or intent.target_version:
            parts += [
                "## 版本信息",
                f"- 源版本：{intent.source_version or '未知'}",
                f"- 目标版本：{intent.target_version or '未知'}",
                "",
            ]

        # 迁移规则
        parts += [
            f"## 迁移规则（共 {len(intent.rules)} 条）",
            "",
        ]
        for rule in sorted(intent.rules, key=lambda r: r.priority):
            parts.append(self._format_rule(rule))

        # 输入 XML
        parts += [
            "",
            "## 输入 XML 示例",
            "```xml",
            input_xml.strip()[:3000],  # 截断，防止 token 超限
            "```",
            "",
        ]

        # 期望输出（可选）
        if expected_output:
            parts += [
                "## 期望输出 XML（参考）",
                "```xml",
                expected_output.strip()[:3000],
                "```",
                "",
            ]

        # 最终指令
        parts += [
            "## 任务",
            "请根据以上迁移规则和 XML 示例，生成完整的 XSLT 1.0 样式表。",
            "直接输出 XML 文件内容，不添加任何 Markdown 格式或解释文字。",
        ]

        return "\n".join(parts)

    def _format_rule(self, rule: MigrationRule) -> str:
        """将单条迁移规则格式化为 Prompt 中的文本块。"""
        lines = [
            f"### 规则 {rule.rule_id}：{rule.description}",
            f"- **类型**: {rule.rule_type.value}",
        ]
        if rule.xpath:
            lines.append(f"- **XPath**: `{rule.xpath}`")
        if rule.source_value:
            lines.append(f"- **旧值**: `{rule.source_value}`")
        if rule.target_value:
            lines.append(f"- **新值**: `{rule.target_value}`")
        if rule.xslt_hint:
            lines += [
                "- **XSLT 参考片段**:",
                "  ```xml",
                *[f"  {line}" for line in rule.xslt_hint.strip().splitlines()],
                "  ```",
            ]
        lines.append("")
        return "\n".join(lines)

