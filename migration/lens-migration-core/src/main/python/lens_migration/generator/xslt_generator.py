"""
XSLT Generator Module（XSLT 生成模块）

基于迁移意图生成 XSLT 转换样式表。
当前采用模板化规则生成方式；未来可替换为 AI 驱动的生成方式。

生成策略：
  1. 以 Identity Template 为基础（默认复制所有节点）
  2. 针对每条迁移规则叠加专用模板，覆盖默认行为
  3. 按优先级排序规则，优先级越小越先匹配
"""

from typing import Optional
import logging
import re
from lxml import etree

from lens_migration.parser.intent_parser import MigrationIntent, MigrationRule, RuleType

logger = logging.getLogger(__name__)


class XSLTGenerator:
    """
    XSLT 样式表生成器。

    根据 MigrationIntent 中的规则列表生成完整的 XSLT 文件。

    生成流程：
      1. 解析输入 XML，提取命名空间
      2. 输出 XSLT 文件头（xmlns 声明）
      3. 输出 Identity Template（默认复制行为）
      4. 按优先级逐条输出规则模板
      5. 输出文件尾
    """

    def __init__(self):
        self.xslt_version = "1.0"   # 生成的 XSLT 版本
        self.indent = "  "           # 缩进单位（2 空格）

    def generate(
        self,
        intent: MigrationIntent,
        input_xml: str,
        expected_output: Optional[str] = None
    ) -> str:
        """
        根据迁移意图生成 XSLT 样式表。

        Args:
            intent:          已解析的迁移意图对象
            input_xml:       输入 XML 示例字符串（用于提取命名空间）
            expected_output: 期望输出 XML 字符串（保留参数，暂未使用）

        Returns:
            完整的 XSLT 样式表字符串
        """
        logger.info("=" * 60)
        logger.info("开始生成 XSLT 转换样式表")
        logger.info(f"  意图标题 : {intent.title}")
        logger.info(f"  规则总数 : {len(intent.rules)}")

        # 解析输入 XML，提取根命名空间和根元素名
        try:
            input_doc = etree.fromstring(input_xml.encode('utf-8'))
            root_ns = self._extract_namespace(input_doc)
            root_element = input_doc.tag.split('}')[-1]  # 去掉命名空间前缀，保留本地名
            logger.info(f"  输入 XML 根元素 : <{root_element}>")
            if root_ns:
                logger.info(f"  命名空间        : {root_ns}")
            else:
                logger.info("  命名空间        : 无（裸标签）")
        except Exception as e:
            logger.warning(f"解析输入 XML 失败，将不使用命名空间: {e}")
            root_ns = None
            root_element = "root"

        xslt_parts = []

        # 生成文件头（xmlns 声明 + xsl:output）
        logger.info("生成 XSLT 文件头...")
        xslt_parts.append(self._generate_header(root_ns))

        # 生成 Identity Template（默认行为：原样复制所有节点）
        logger.info("生成 Identity Template（原样复制所有节点）...")
        xslt_parts.append(self._generate_identity_template())

        # 按优先级从小到大排列规则（数值越小越优先匹配）
        sorted_rules = sorted(intent.rules, key=lambda r: r.priority)
        logger.info(f"规则排序完成（按优先级升序）：")
        for r in sorted_rules:
            logger.info(f"  [{r.priority:3d}] {r.rule_id} | {r.rule_type.value:15s} | {r.description}")

        # 逐条生成规则对应的 XSLT 模板
        generated_count = 0
        skipped_count = 0
        for rule in sorted_rules:
            logger.debug(f"处理规则 {rule.rule_id}: type={rule.rule_type.value}, xpath={rule.xpath}")
            if rule.xslt_hint:
                logger.info(f"  ✓ 规则 {rule.rule_id}: 使用 xslt_hint（人工验证片段）")
            template = self._generate_rule_template(rule, root_ns)
            if template:
                xslt_parts.append(template)
                generated_count += 1
                logger.info(f"  ✓ 规则 {rule.rule_id}: 模板生成成功（match={self._xpath_to_match_pattern(rule.xpath, root_ns)}）")
            else:
                skipped_count += 1
                logger.warning(f"  ✗ 规则 {rule.rule_id}: 跳过（类型={rule.rule_type.value}，无法生成）")

        # 生成文件尾
        xslt_parts.append(self._generate_footer())

        xslt_code = '\n\n'.join(xslt_parts)

        logger.info("-" * 60)
        logger.info(f"XSLT 生成完成：成功 {generated_count} 条，跳过 {skipped_count} 条")
        logger.info(f"XSLT 总大小  ：{len(xslt_code)} 字节，{xslt_code.count(chr(10))+1} 行")
        logger.info("=" * 60)

        return xslt_code

    def _extract_namespace(self, element) -> Optional[str]:
        """
        从 XML 元素的标签中提取命名空间 URI。

        例如：{http://example.com/ns}classifiers → http://example.com/ns
        若标签不含命名空间，返回 None。
        """
        tag = element.tag
        if tag.startswith('{'):
            return tag[1:tag.index('}')]
        return None

    def _generate_header(self, namespace: Optional[str]) -> str:
        """
        生成 XSLT 文件头部。

        包含：
        - xsl:stylesheet 根元素及版本声明
        - xmlns:xsl 命名空间
        - 若 XML 使用命名空间，则添加 xmlns:ns 和 xmlns 声明，
          并通过 exclude-result-prefixes 避免 ns 前缀泄漏到输出
        - xsl:output 指定输出格式（缩进 XML，UTF-8）
        """
        header = f'''<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="{self.xslt_version}" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"'''

        if namespace:
            # 添加源文档命名空间，供模板匹配使用
            header += f'\n                xmlns:ns="{namespace}"'
            # 同时将其设为默认命名空间，使输出节点自动带上正确的命名空间
            header += f'\n                xmlns="{namespace}"'
            # 排除 ns 前缀，防止其出现在输出 XML 中
            header += '\n                exclude-result-prefixes="ns"'

        header += '>\n'
        header += '\n  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>'

        return header

    def _generate_identity_template(self) -> str:
        """
        生成 Identity Template（恒等模板）。

        这是 XSLT 的基础模式：匹配所有属性和节点，原样复制到输出。
        后续的专用规则模板通过更精确的 match 表达式覆盖此默认行为。
        """
        return '''  <!-- Identity Template：默认行为，原样复制所有节点和属性 -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>'''

    def _generate_rule_template(
        self,
        rule: MigrationRule,
        namespace: Optional[str]
    ) -> Optional[str]:
        """
        根据规则类型分发生成对应的 XSLT 模板。

        优先使用意图文档中提供的 xslt_hint（已由人工验证），
        仅在没有 hint 时才用代码推导生成。
        """
        # ── 优先使用 xslt_hint ──────────────────────────────────────────────
        if rule.xslt_hint and rule.xslt_hint.strip():
            logger.debug(f"  规则 {rule.rule_id}: 使用 xslt_hint，长度={len(rule.xslt_hint)} 字节")
            return self._wrap_hint_as_template(rule, namespace)

        # ── 无 hint 时按类型推导 ────────────────────────────────────────────
        if rule.rule_type == RuleType.RENAME:
            logger.debug(f"  规则 {rule.rule_id}: 生成 RENAME 模板，{rule.source_value} → {rule.target_value}")
            return self._generate_rename_template(rule, namespace)
        elif rule.rule_type == RuleType.MODIFY_VALUE:
            logger.debug(f"  规则 {rule.rule_id}: 生成 MODIFY_VALUE 模板，{rule.source_value} → {rule.target_value}")
            return self._generate_modify_value_template(rule, namespace)
        elif rule.rule_type == RuleType.DELETE_NODE:
            logger.debug(f"  规则 {rule.rule_id}: 生成 DELETE_NODE 模板，xpath={rule.xpath}")
            return self._generate_delete_template(rule, namespace)
        elif rule.rule_type == RuleType.ADD_NODE:
            logger.warning(f"  规则 {rule.rule_id}: ADD_NODE 规则无 xslt_hint，已跳过: {rule.rule_id}")
            return None
        else:
            logger.warning(f"  规则 {rule.rule_id}: 不支持的规则类型，已跳过: {rule.rule_type}")
            return None

    def _wrap_hint_as_template(
        self,
        rule: MigrationRule,
        namespace: Optional[str]
    ) -> str:
        """
        将 xslt_hint 包装为带注释的完整 XSLT 模板块。

        若 hint 已是完整的 <xsl:template> 片段，直接使用。
        同时处理命名空间：将 hint 中 match/select 属性里的无前缀元素名
        替换为 ns: 前缀（字符串字面量内容不替换）。
        """
        hint = rule.xslt_hint.strip()

        # 若 hint 中没有命名空间前缀但文档有命名空间，添加 ns: 前缀
        if namespace and 'ns:' not in hint and 'xmlns' not in hint:
            hint = self._add_ns_prefix_to_hint(hint)

        comment = (f'  <!--\n'
                   f'    规则: {rule.description}\n'
                   f'    类型: {rule.rule_type.value}\n'
                   f'  -->')
        # 缩进 hint 为两空格
        indented = '\n'.join('  ' + line if line.strip() else line
                             for line in hint.splitlines())
        return f'{comment}\n{indented}'

    def _add_ns_prefix_to_hint(self, hint: str) -> str:
        """
        为 XSLT hint 中 match/select 属性值里的 XML 元素名加 ns: 前缀。
        字符串字面量（单引号或双引号包围的内容）不处理。
        """
        xslt_kw = {'and', 'or', 'div', 'mod', 'not', 'text', 'node',
                   'position', 'last', 'count', 'string', 'number',
                   'true', 'false', 'contains', 'normalize-space',
                   'ancestor', 'parent', 'child', 'descendant', 'self',
                   'following', 'preceding', 'attribute', 'namespace',
                   'ancestor-or-self', 'descendant-or-self',
                   'following-sibling', 'preceding-sibling'}

        def process_attr_value(val: str) -> str:
            """处理单个属性值字符串，元素名加 ns: 前缀，字符串字面量不动。"""
            result = []
            i = 0
            while i < len(val):
                c = val[i]
                # 字符串字面量：原样保留
                if c in ("'", '"'):
                    j = val.index(c, i + 1) + 1 if c in val[i+1:] else len(val)
                    result.append(val[i:j])
                    i = j
                # 已有前缀（ns: 或 xsl:）：原样保留
                elif val[i:i+3] in ('ns:', 'xsl') or val[i:i+4] == 'xsl:':
                    # 找到下一个非标识符字符
                    j = i
                    while j < len(val) and (val[j].isalnum() or val[j] in '-_:'):
                        j += 1
                    result.append(val[i:j])
                    i = j
                # @ 属性引用：保留 @
                elif c == '@':
                    result.append('@')
                    i += 1
                # 标识符开头：可能是元素名
                elif c.isalpha() or c == '_':
                    j = i
                    while j < len(val) and (val[j].isalnum() or val[j] in '-_'):
                        j += 1
                    word = val[i:j]
                    # 跳过 XSLT 关键字和函数名（后跟 '('）
                    if word in xslt_kw or (j < len(val) and val[j] == '('):
                        result.append(word)
                    else:
                        result.append(f'ns:{word}')
                    i = j
                else:
                    result.append(c)
                    i += 1
            return ''.join(result)

        def replace_match_select(m: re.Match) -> str:
            attr_name = m.group(1)   # match 或 select
            attr_val  = m.group(2)   # 属性值（不含引号）
            new_val = process_attr_value(attr_val)
            return f'{attr_name}="{new_val}"'

        return re.sub(r'\b(match|select)="([^"]*)"', replace_match_select, hint)

    def _generate_rename_template(
        self,
        rule: MigrationRule,
        namespace: Optional[str]
    ) -> str:
        """
        生成节点重命名模板。

        逻辑：
          - 匹配旧名称节点（由 XPath 或 source_value 确定 match 表达式）
          - 用 xsl:element 输出新名称节点
          - 通过 xsl:apply-templates 递归处理子节点，保留内部结构
        """
        match_pattern = self._xpath_to_match_pattern(rule.xpath, namespace)

        template = f'''  <!--
    规则: {rule.description}
    类型: 重命名（Rename）
    旧名称: {rule.source_value}
    新名称: {rule.target_value}
  -->
  <xsl:template match="{match_pattern}">
    <xsl:element name="{rule.target_value}"'''

        if namespace:
            # 保持原有命名空间，确保输出节点命名空间正确
            template += f' namespace="{namespace}"'

        template += '''>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>'''

        return template

    def _generate_modify_value_template(
        self,
        rule: MigrationRule,
        namespace: Optional[str]
    ) -> str:
        """
        生成节点值替换模板。

        逻辑：
          - 匹配含旧值的目标节点
          - 复制节点本身（保留标签名和命名空间）
          - 用 xsl:text 输出新值，替换原有文本内容
        """
        match_pattern = self._xpath_to_match_pattern(rule.xpath, namespace)

        template = f'''  <!--
    规则: {rule.description}
    类型: 修改值（Modify Value）
    旧值: {rule.source_value}
    新值: {rule.target_value}
  -->
  <xsl:template match="{match_pattern}">
    <xsl:copy>
      <xsl:text>{rule.target_value}</xsl:text>
    </xsl:copy>
  </xsl:template>'''

        return template

    def _generate_delete_template(
        self,
        rule: MigrationRule,
        namespace: Optional[str]
    ) -> str:
        """
        生成节点删除模板。

        逻辑：
          - 匹配需要删除的节点
          - 模板体为空（不产生任何输出），即相当于将该节点从输出中剔除
        """
        match_pattern = self._xpath_to_match_pattern(rule.xpath, namespace)

        template = f'''  <!--
    规则: {rule.description}
    类型: 删除节点（Delete Node）
    说明: 匹配该节点但不输出任何内容，达到删除效果
  -->
  <xsl:template match="{match_pattern}">
    <!-- 节点已删除，此处不产生输出 -->
  </xsl:template>'''

        return template

    def _xpath_to_match_pattern(
        self,
        xpath: Optional[str],
        namespace: Optional[str]
    ) -> str:
        """
        将 XPath 表达式简化转换为 XSLT match 属性值。

        转换规则：
          - 去除开头的 // 或 /
          - 若 XML 使用命名空间且 xpath 中无前缀，自动为元素名（非字符串字面量）加 ns: 前缀

        注意：字符串字面量（引号内）、通配符 * 不加前缀。
        """
        if not xpath:
            return "*"  # 无 XPath 时匹配任意元素（兜底）

        # 去除 XPath 开头的 // 或 /
        pattern = xpath.lstrip('/')

        # 若文档有命名空间且 pattern 中尚无 ns: 前缀，则只为元素名加 ns: 前缀
        # 规则：引号内的字符串字面量不处理；通配符 * 不处理；轴名（axis::）不处理
        if namespace and 'ns:' not in pattern:
            # 先把字符串字面量占位替换，防止被替换
            literals = []
            def save_literal(m):
                literals.append(m.group(0))
                return f'__LIT{len(literals)-1}__'
            pattern = re.sub(r"'[^']*'|\"[^\"]*\"", save_literal, pattern)

            # 只为独立的 XML 元素名（\w+ 且不是 XSLT 函数、轴名、已有前缀的）加 ns:
            # 不处理：通配符 *、@attr、数字、已有前缀的 x:name
            def add_prefix(m):
                word = m.group(0)
                # 通配符、数字开头、已有冒号紧跟、XSLT 轴关键字跳过
                xslt_axes = {'ancestor', 'ancestor-or-self', 'attribute', 'child',
                             'descendant', 'descendant-or-self', 'following',
                             'following-sibling', 'namespace', 'parent',
                             'preceding', 'preceding-sibling', 'self',
                             'and', 'or', 'div', 'mod', 'not', 'text',
                             'node', 'position', 'last', 'count', 'string',
                             'number', 'true', 'false', 'contains', 'normalize-space'}
                if word in xslt_axes:
                    return word
                return f'ns:{word}'

            # 匹配单独的元素名：字母开头，不紧跟 '(' 或 '::'，不以 @ 开头
            pattern = re.sub(
                r'(?<![:\@\*])(?<!\w)\b([a-zA-Z_][\w-]*)\b(?!\s*[\(:])',
                lambda m: add_prefix(m) if m.group(1) not in
                    {'ancestor','ancestor-or-self','attribute','child',
                     'descendant','descendant-or-self','following',
                     'following-sibling','namespace','parent',
                     'preceding','preceding-sibling','self',
                     'and','or','div','mod','not','text',
                     'node','position','last','count','string',
                     'number','true','false','contains','normalize-space'}
                    else m.group(1),
                pattern
            )

            # 还原字符串字面量
            for i, lit in enumerate(literals):
                pattern = pattern.replace(f'__LIT{i}__', lit)

        return pattern

    def _generate_footer(self) -> str:
        """生成 XSLT 文件尾（关闭根元素）。"""
        return '</xsl:stylesheet>'

