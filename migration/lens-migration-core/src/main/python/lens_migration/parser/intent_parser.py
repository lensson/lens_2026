"""
Intent Parser Module（意图解析模块）

解析 Markdown 格式的迁移意图文档，提取迁移规则。
每条规则描述了从旧版本 XML 到新版本 XML 的一种转换操作。
"""

import re
from pathlib import Path
from typing import List, Dict, Any, Optional
from dataclasses import dataclass, field
from enum import Enum
import logging

logger = logging.getLogger(__name__)


class RuleType(Enum):
    """迁移规则类型枚举。"""
    RENAME = "rename"           # 节点重命名
    MODIFY_VALUE = "modify_value"  # 修改节点值
    ADD_NODE = "add_node"       # 新增节点
    DELETE_NODE = "delete_node" # 删除节点
    TRANSFORM = "transform"     # 数据格式转换
    REORDER = "reorder"         # 节点重新排序


@dataclass
class MigrationRule:
    """
    单条迁移规则。

    从意图文档中解析出的一条具体转换规则，包含：
    - 规则唯一 ID
    - 规则类型（重命名/修改值/新增/删除等）
    - 文字描述
    - 目标 XPath 路径
    - 源值和目标值（用于值替换类规则）
    - XSLT 实现提示（如意图文档中附有代码片段）
    - 执行优先级（数值越小越先执行）
    """
    rule_id: str
    rule_type: RuleType
    description: str
    xpath: Optional[str] = None
    source_value: Optional[str] = None
    target_value: Optional[str] = None
    xslt_hint: Optional[str] = None
    priority: int = 100
    metadata: Dict[str, Any] = field(default_factory=dict)


@dataclass
class MigrationIntent:
    """
    完整的迁移意图。

    对应一份迁移意图文档的全部内容，包含：
    - 文档标题
    - 源版本 / 目标版本号
    - 所有迁移规则列表
    - 验证点列表（用于校验转换结果是否正确）
    """
    title: str
    source_version: Optional[str] = None
    target_version: Optional[str] = None
    rules: List[MigrationRule] = field(default_factory=list)
    validation_points: List[str] = field(default_factory=list)
    metadata: Dict[str, Any] = field(default_factory=dict)


class IntentParser:
    """
    迁移意图文档解析器。

    支持 Markdown 格式的意图文档，识别以下标准章节：
    - ### 规则 N / ### Rule N  —— 迁移规则
    - ## 验证 / ## Validation  —— 验证点
    - 版本信息（源版本 / 目标版本）

    用法示例：
        intent = IntentParser().parse(Path("migration-intent.md"))
        for rule in intent.rules:
            print(rule.rule_id, rule.rule_type, rule.description)
    """

    def parse(self, intent_file: Path) -> MigrationIntent:
        """
        解析迁移意图文档，返回结构化的 MigrationIntent 对象。

        Args:
            intent_file: Markdown 格式的意图文档路径

        Returns:
            MigrationIntent —— 包含所有规则和验证点
        """
        logger.info(f"正在解析意图文档: {intent_file}")

        with open(intent_file, 'r', encoding='utf-8') as f:
            content = f.read()

        intent = MigrationIntent(title="")

        # 提取文档标题（一级标题）
        title_match = re.search(r'^#\s+(.+)$', content, re.MULTILINE)
        if title_match:
            intent.title = title_match.group(1).strip()

        # 提取版本信息
        self._extract_versions(content, intent)

        # 提取所有迁移规则
        self._extract_rules(content, intent)

        # 提取验证点
        self._extract_validation_points(content, intent)

        logger.info(f"解析完成：共 {len(intent.rules)} 条规则，"
                    f"{len(intent.validation_points)} 个验证点")

        return intent

    def _extract_versions(self, content: str, intent: MigrationIntent):
        """
        从文档中提取源版本和目标版本号。

        支持中英文两种写法，例如：
            源版本: v1   /   Source Version: v1
            目标版本: v2  /   Target Version: v2
        """
        # 匹配源版本
        source_match = re.search(
            r'(?:源版本|Source Version|源)\s*:?\s*([^\n]+)',
            content,
            re.IGNORECASE
        )
        if source_match:
            intent.source_version = source_match.group(1).strip()

        # 匹配目标版本
        target_match = re.search(
            r'(?:目标版本|Target Version|目标)\s*:?\s*([^\n]+)',
            content,
            re.IGNORECASE
        )
        if target_match:
            intent.target_version = target_match.group(1).strip()

    def _extract_rules(self, content: str, intent: MigrationIntent):
        """
        从文档中提取所有迁移规则。

        规则以三级标题开头，格式为：
            ### 规则 1: 重命名 classifier-entry
            ### Rule 2: Modify value
        每条规则的正文包含 XPath、源值、目标值、XSLT 提示和优先级等字段。
        """
        # 匹配形如 "### 规则 1: ..." 或 "### Rule 1: ..." 的规则块
        rule_pattern = r'###\s+(?:规则|Rule)\s+(\d+)\s*:?\s*([^\n]+)(.*?)(?=###|$)'

        for match in re.finditer(rule_pattern, content, re.DOTALL | re.IGNORECASE):
            rule_num = match.group(1)       # 规则序号
            rule_title = match.group(2).strip()  # 规则标题（简述）
            rule_content = match.group(3)   # 规则正文

            # 根据标题和正文判断规则类型
            rule_type = self._determine_rule_type(rule_title, rule_content)

            # 提取 XPath 目标路径
            xpath = self._extract_xpath(rule_content)

            # 提取源值和目标值
            source_value = self._extract_value(rule_content, 'source|源')
            target_value = self._extract_value(rule_content, 'target|目标')

            # 提取 XSLT 代码提示
            xslt_hint = self._extract_xslt_hint(rule_content)

            # 提取优先级
            priority = self._extract_priority(rule_content)

            rule = MigrationRule(
                rule_id=f"rule_{rule_num}",
                rule_type=rule_type,
                description=rule_title,
                xpath=xpath,
                source_value=source_value,
                target_value=target_value,
                xslt_hint=xslt_hint,
                priority=priority
            )

            intent.rules.append(rule)
            logger.debug(f"提取规则: {rule.rule_id} [{rule.rule_type.value}] - {rule.description}")

    def _determine_rule_type(self, title: str, content: str) -> RuleType:
        """
        根据规则标题和正文内容推断规则类型。

        优先匹配标题关键字（中英文），无法匹配时默认为 MODIFY_VALUE。
        """
        title_lower = title.lower()

        if '重命名' in title or 'rename' in title_lower:
            return RuleType.RENAME
        elif '修改' in title or 'modify' in title_lower or 'change' in title_lower:
            return RuleType.MODIFY_VALUE
        elif '新增' in title or '添加' in title or 'add' in title_lower:
            return RuleType.ADD_NODE
        elif '删除' in title or 'delete' in title_lower or 'remove' in title_lower:
            return RuleType.DELETE_NODE
        elif '转换' in title or 'transform' in title_lower or 'convert' in title_lower:
            return RuleType.TRANSFORM
        else:
            # 默认为值修改类型
            return RuleType.MODIFY_VALUE

    def _extract_xpath(self, content: str) -> Optional[str]:
        """
        从规则正文中提取 XPath 路径。

        支持以下格式：
            **XPath**: `/classifiers/classifier-entry`
            XPath: /classifiers/classifier-entry
            xpath: `//ns:name`
            路径: /foo/bar
        """
        xpath_patterns = [
            r'\*{0,2}XPath\*{0,2}\s*\*{0,2}\s*:?\s*\*{0,2}\s*`?([^`\n]+)`?',
            r'\*{0,2}xpath\*{0,2}\s*\*{0,2}\s*:?\s*\*{0,2}\s*`?([^`\n]+)`?',
            r'\*{0,2}路径\*{0,2}\s*\*{0,2}\s*:?\s*\*{0,2}\s*`?([^`\n]+)`?',
        ]

        for pattern in xpath_patterns:
            match = re.search(pattern, content, re.IGNORECASE)
            if match:
                # 清理提取值中残留的 ** 标记、反引号、首尾空白
                val = match.group(1).strip().strip('`').strip('*').strip()
                if val:
                    return val

        return None

    def _extract_value(self, content: str, value_type: str) -> Optional[str]:
        """
        从规则正文中提取源值或目标值。

        value_type 为正则表达式，匹配 "source|源" 或 "target|目标"。
        支持格式：
            源值: high-priority-classifier
            旧名称: `high-priority-classifier`
            **旧名称**: `high-priority-classifier`
            Target: `priority-high-class`
        """
        # 针对 source：匹配 源值/旧名称/旧值/source/old
        # 针对 target：匹配 目标值/新名称/新值/target/new
        if 'source' in value_type or '源' in value_type:
            patterns = [
                r'\*{0,2}(?:源值?|旧名称|旧值|source|old value|old name)\*{0,2}\s*:?\s*`?([^`\n,，]+)`?',
            ]
        else:
            patterns = [
                r'\*{0,2}(?:目标值?|新名称|新值|target|new value|new name)\*{0,2}\s*:?\s*`?([^`\n,，]+)`?',
            ]

        for pattern in patterns:
            match = re.search(pattern, content, re.IGNORECASE)
            if match:
                val = match.group(1).strip().strip('`').strip('*').strip()
                if val:
                    return val
        return None

    def _extract_xslt_hint(self, content: str) -> Optional[str]:
        """
        从规则正文中提取 XSLT 代码提示片段。

        识别 Markdown 代码块（```xslt 或 ```xml），
        提取其中的 XSLT 片段作为生成器的参考实现。
        """
        # 匹配 ```xslt ... ``` 或 ```xml ... ``` 代码块
        xslt_pattern = r'```(?:xslt|xml)\s*(.*?)```'
        match = re.search(xslt_pattern, content, re.DOTALL)
        if match:
            return match.group(1).strip()
        return None

    def _extract_priority(self, content: str) -> int:
        """
        从规则正文中提取执行优先级。

        支持以下格式：
            优先级: 10        （数值越小越优先）
            Priority: 50
            高优先级           → 返回 10
            低优先级           → 返回 200
        未指定时默认返回 100。
        """
        priority_patterns = [
            r'(?:优先级|Priority)\s*:?\s*(\d+)',  # 数值优先级
            r'(?:高优先级|High.*Priority)',          # 高优先级 → 10
            r'(?:低优先级|Low.*Priority)',            # 低优先级 → 200
        ]

        for i, pattern in enumerate(priority_patterns):
            match = re.search(pattern, content, re.IGNORECASE)
            if match:
                if i == 0:
                    return int(match.group(1))
                elif i == 1:
                    return 10
                elif i == 2:
                    return 200

        return 100  # 默认优先级

    def _extract_validation_points(self, content: str, intent: MigrationIntent):
        """
        从文档的验证章节中提取验证点。

        验证章节以二级标题 "## 验证" 或 "## Validation" 开头，
        每行验证点格式为：
            验证点 1: /classifiers/classifier-entry 节点数量不变
            Check 2: output contains new node name
        """
        # 定位验证章节
        validation_section = re.search(
            r'##\s+(?:验证|Validation).*?$(.*?)(?=##|$)',
            content,
            re.DOTALL | re.MULTILINE | re.IGNORECASE
        )

        if not validation_section:
            return

        validation_content = validation_section.group(1)

        # 逐行提取验证点描述
        validation_pattern = r'(?:验证点?|Validation|Check)\s*\d*\s*:?\s*([^\n]+)'

        for match in re.finditer(validation_pattern, validation_content, re.IGNORECASE):
            validation_point = match.group(1).strip()
            # 跳过空行和子标题
            if validation_point and not validation_point.startswith('#'):
                intent.validation_points.append(validation_point)
                logger.debug(f"提取验证点: {validation_point}")
