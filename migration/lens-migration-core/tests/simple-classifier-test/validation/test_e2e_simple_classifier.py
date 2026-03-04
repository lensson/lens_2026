"""
端到端联调测试：simple-classifier-test

测试完整流程：
  IntentParser -> XSLTGenerator -> XSLT 变换 -> 语义比较

运行方式：
  cd migration/lens-migration-core
  venv/bin/python3 -m pytest tests/simple-classifier-test/validation/test_e2e_simple_classifier.py -v
"""

import sys
import pytest
from pathlib import Path
from lxml import etree

# 把源码路径加入 sys.path
SRC = Path(__file__).parent.parent.parent.parent / "src" / "main" / "python"
sys.path.insert(0, str(SRC))

from lens_migration.parser.intent_parser import IntentParser, RuleType
from lens_migration.generator.xslt_generator import XSLTGenerator

# ── 测试用例路径 ──────────────────────────────────────────────────────────────
BASE = Path(__file__).parent.parent
INTENT_FILE   = BASE / "input" / "request"     / "migration-intent-v1-to-v2.md"
INPUT_FILE    = BASE / "input" / "old-version" / "classifier-sample-01-v1.xml"
EXPECTED_FILE = BASE / "input" / "new-version" / "classifier-sample-01-v2.xml"
OUTPUT_XSLT   = BASE / "output" / "e2e-generated-transform.xslt"


# ── 工具函数 ──────────────────────────────────────────────────────────────────

def normalize_xml(root: etree._Element) -> str:
    """去除注释和纯空白，返回规范化 XML 字符串用于语义比较。"""
    for comment in root.xpath("//comment()"):
        p = comment.getparent()
        if p is not None:
            p.remove(comment)
    for el in root.iter():
        if el.text  and el.text.strip()  == "": el.text  = None
        if el.tail  and el.tail.strip()  == "": el.tail  = None
    return etree.tostring(root, encoding="unicode")


def apply_xslt(xslt_path: Path, input_path: Path) -> etree._Element:
    """执行 XSLT 变换，返回结果根节点。"""
    xslt_doc  = etree.parse(str(xslt_path))
    transform = etree.XSLT(xslt_doc)
    input_doc = etree.parse(str(input_path))
    result    = transform(input_doc)
    # XSLT 结果转成普通 ElementTree
    return etree.fromstring(etree.tostring(result))


# ── 测试 ──────────────────────────────────────────────────────────────────────

class TestSimpleClassifierE2E:

    def test_intent_file_exists(self):
        """意图文档存在"""
        assert INTENT_FILE.exists(), f"Intent file not found: {INTENT_FILE}"

    def test_input_file_exists(self):
        """输入 XML 存在"""
        assert INPUT_FILE.exists(), f"Input XML not found: {INPUT_FILE}"

    def test_expected_file_exists(self):
        """期望输出 XML 存在"""
        assert EXPECTED_FILE.exists(), f"Expected XML not found: {EXPECTED_FILE}"

    # ── Phase 1: IntentParser ─────────────────────────────────────────────────

    def test_intent_parser_runs(self):
        """IntentParser 能解析意图文档，不抛异常"""
        parser = IntentParser()
        intent = parser.parse(INTENT_FILE)
        assert intent is not None

    def test_intent_has_rules(self):
        """意图文档解析出 >= 1 条规则"""
        parser = IntentParser()
        intent = parser.parse(INTENT_FILE)
        assert len(intent.rules) >= 1, \
            f"Expected >=1 rules, got {len(intent.rules)}"
        print(f"\n  解析出 {len(intent.rules)} 条规则:")
        for r in intent.rules:
            print(f"    [{r.rule_type.value}] {r.rule_id}: {r.description[:60]}")

    def test_intent_has_rename_rule(self):
        """必须包含 RENAME 规则（high-priority-classifier → priority-high-class）"""
        parser = IntentParser()
        intent = parser.parse(INTENT_FILE)
        rename_rules = [r for r in intent.rules if r.rule_type == RuleType.RENAME]
        assert len(rename_rules) >= 1, \
            f"No RENAME rule found. Rules: {[r.rule_type for r in intent.rules]}"

    def test_intent_has_modify_rule(self):
        """必须包含 MODIFY_VALUE 规则（traffic class 1 → 0）"""
        parser = IntentParser()
        intent = parser.parse(INTENT_FILE)
        modify_rules = [r for r in intent.rules if r.rule_type == RuleType.MODIFY_VALUE]
        assert len(modify_rules) >= 1, \
            f"No MODIFY_VALUE rule found. Rules: {[r.rule_type for r in intent.rules]}"

    def test_intent_has_add_rule(self):
        """必须包含 ADD_NODE 规则（新增 medium-priority-classifier）"""
        parser = IntentParser()
        intent = parser.parse(INTENT_FILE)
        add_rules = [r for r in intent.rules if r.rule_type == RuleType.ADD_NODE]
        assert len(add_rules) >= 1, \
            f"No ADD_NODE rule found. Rules: {[r.rule_type for r in intent.rules]}"

    def test_intent_has_delete_rule(self):
        """必须包含 DELETE_NODE 规则（删除 best-effort-classifier）"""
        parser = IntentParser()
        intent = parser.parse(INTENT_FILE)
        del_rules = [r for r in intent.rules if r.rule_type == RuleType.DELETE_NODE]
        assert len(del_rules) >= 1, \
            f"No DELETE_NODE rule found. Rules: {[r.rule_type for r in intent.rules]}"

    # ── Phase 2: XSLTGenerator ────────────────────────────────────────────────

    def test_xslt_generator_runs(self):
        """XSLTGenerator 能生成 XSLT 字符串，不抛异常"""
        parser    = IntentParser()
        intent    = parser.parse(INTENT_FILE)
        generator = XSLTGenerator()
        input_xml = INPUT_FILE.read_text(encoding="utf-8")
        expected  = EXPECTED_FILE.read_text(encoding="utf-8")
        xslt_str  = generator.generate(intent=intent, input_xml=input_xml,
                                        expected_output=expected)
        assert xslt_str and len(xslt_str) > 100, "XSLT output is empty or too short"

    def test_xslt_is_valid_xml(self):
        """生成的 XSLT 是合法 XML"""
        parser    = IntentParser()
        intent    = parser.parse(INTENT_FILE)
        generator = XSLTGenerator()
        input_xml = INPUT_FILE.read_text(encoding="utf-8")
        expected  = EXPECTED_FILE.read_text(encoding="utf-8")
        xslt_str  = generator.generate(intent=intent, input_xml=input_xml,
                                        expected_output=expected)
        try:
            xslt_doc = etree.fromstring(xslt_str.encode("utf-8"))
            assert xslt_doc is not None
        except etree.XMLSyntaxError as e:
            pytest.fail(f"Generated XSLT is not valid XML: {e}")

    def test_xslt_is_valid_stylesheet(self):
        """生成的 XSLT 是合法的 XSLT 样式表（能被 lxml 加载）"""
        parser    = IntentParser()
        intent    = parser.parse(INTENT_FILE)
        generator = XSLTGenerator()
        input_xml = INPUT_FILE.read_text(encoding="utf-8")
        expected  = EXPECTED_FILE.read_text(encoding="utf-8")
        xslt_str  = generator.generate(intent=intent, input_xml=input_xml,
                                        expected_output=expected)
        try:
            xslt_doc  = etree.fromstring(xslt_str.encode("utf-8"))
            transform = etree.XSLT(etree.ElementTree(xslt_doc))
            assert transform is not None
        except etree.XSLTParseError as e:
            pytest.fail(f"Generated XSLT is not a valid stylesheet: {e}")

    def test_xslt_saved_to_file(self):
        """生成的 XSLT 保存到文件"""
        parser    = IntentParser()
        intent    = parser.parse(INTENT_FILE)
        generator = XSLTGenerator()
        input_xml = INPUT_FILE.read_text(encoding="utf-8")
        expected  = EXPECTED_FILE.read_text(encoding="utf-8")
        xslt_str  = generator.generate(intent=intent, input_xml=input_xml,
                                        expected_output=expected)
        OUTPUT_XSLT.write_text(xslt_str, encoding="utf-8")
        assert OUTPUT_XSLT.exists()
        print(f"\n  XSLT 保存至: {OUTPUT_XSLT}")

    # ── Phase 3: XSLT 变换结果验证 ───────────────────────────────────────────

    def test_transformation_runs(self):
        """用生成的 XSLT 对 input-v1.xml 执行变换，不报错"""
        # 先生成 XSLT
        parser    = IntentParser()
        intent    = parser.parse(INTENT_FILE)
        generator = XSLTGenerator()
        xslt_str  = generator.generate(
            intent=intent,
            input_xml=INPUT_FILE.read_text(encoding="utf-8"),
            expected_output=EXPECTED_FILE.read_text(encoding="utf-8"))
        OUTPUT_XSLT.write_text(xslt_str, encoding="utf-8")
        # 执行变换
        result = apply_xslt(OUTPUT_XSLT, INPUT_FILE)
        assert result is not None

    def test_rename_high_priority(self):
        """变换结果：high-priority-classifier 已重命名为 priority-high-class"""
        result = apply_xslt(
            BASE / "output" / "generated-transform.xslt", INPUT_FILE)
        ns = {"bbf": "urn:bbf:yang:bbf-qos-classifiers"}
        names = result.findall(".//bbf:classifier-entry/bbf:name", ns)
        name_values = [n.text for n in names]
        assert "priority-high-class" in name_values, \
            f"priority-high-class not found. Names: {name_values}"
        assert "high-priority-classifier" not in name_values, \
            f"old name still present. Names: {name_values}"

    def test_traffic_class_changed(self):
        """变换结果：priority-high-class 的 scheduling-traffic-class = 0"""
        result = apply_xslt(
            BASE / "output" / "generated-transform.xslt", INPUT_FILE)
        ns = {"bbf": "urn:bbf:yang:bbf-qos-classifiers"}
        entries = result.findall(".//bbf:classifier-entry", ns)
        for entry in entries:
            name = entry.findtext("bbf:name", namespaces=ns)
            if name == "priority-high-class":
                tc = entry.findtext(
                    ".//bbf:scheduling-traffic-class", namespaces=ns)
                assert tc == "0", \
                    f"Expected traffic-class=0 for priority-high-class, got {tc}"
                return
        pytest.fail("priority-high-class entry not found in result")

    def test_medium_priority_added(self):
        """变换结果：medium-priority-classifier 已新增"""
        result = apply_xslt(
            BASE / "output" / "generated-transform.xslt", INPUT_FILE)
        ns = {"bbf": "urn:bbf:yang:bbf-qos-classifiers"}
        names = [n.text for n in result.findall(".//bbf:classifier-entry/bbf:name", ns)]
        assert "medium-priority-classifier" in names, \
            f"medium-priority-classifier not found. Names: {names}"

    def test_best_effort_deleted(self):
        """变换结果：best-effort-classifier 已删除"""
        result = apply_xslt(
            BASE / "output" / "generated-transform.xslt", INPUT_FILE)
        ns = {"bbf": "urn:bbf:yang:bbf-qos-classifiers"}
        names = [n.text for n in result.findall(".//bbf:classifier-entry/bbf:name", ns)]
        assert "best-effort-classifier" not in names, \
            f"best-effort-classifier should be deleted. Names: {names}"

    def test_low_priority_unchanged(self):
        """变换结果：low-priority-classifier 保持不变（traffic-class = 4）"""
        result = apply_xslt(
            BASE / "output" / "generated-transform.xslt", INPUT_FILE)
        ns = {"bbf": "urn:bbf:yang:bbf-qos-classifiers"}
        entries = result.findall(".//bbf:classifier-entry", ns)
        for entry in entries:
            name = entry.findtext("bbf:name", namespaces=ns)
            if name == "low-priority-classifier":
                tc = entry.findtext(
                    ".//bbf:scheduling-traffic-class", namespaces=ns)
                assert tc == "4", \
                    f"Expected traffic-class=4 for low-priority-classifier, got {tc}"
                return
        pytest.fail("low-priority-classifier entry not found in result")

    def test_entry_count(self):
        """变换结果：共 3 条 classifier-entry（high→renamed, medium新增, low保留）"""
        result = apply_xslt(
            BASE / "output" / "generated-transform.xslt", INPUT_FILE)
        ns = {"bbf": "urn:bbf:yang:bbf-qos-classifiers"}
        entries = result.findall(".//bbf:classifier-entry", ns)
        assert len(entries) == 3, \
            f"Expected 3 entries, got {len(entries)}: " \
            f"{[e.findtext('bbf:name', namespaces=ns) for e in entries]}"

    def test_semantic_match_with_handcrafted_xslt(self):
        """手写 XSLT 的变换结果与 expected-output-v2.xml 语义完全一致"""
        result   = apply_xslt(BASE / "output" / "generated-transform.xslt", INPUT_FILE)
        expected = etree.parse(str(EXPECTED_FILE)).getroot()
        assert normalize_xml(result) == normalize_xml(expected), \
            "Semantic mismatch between actual output and expected-output-v2.xml"


