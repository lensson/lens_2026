"""
VLAN Policy XSLT 生成测试 — GitHub Models Provider

使用 GitHub Models (gpt-4o-mini) 从迁移意图文档自动生成 XSLT，
验证 4 条迁移规则均正确执行。

运行（需要 GITHUB_TOKEN）：
  GITHUB_TOKEN=ghp_xxx PYTHONPATH=src/main/python \\
    venv/bin/python3 -m pytest tests/vlan-policy-test/validation/test_vlan_github.py -v -s

跳过条件：未设置 GITHUB_TOKEN 时自动跳过，不影响其他测试。
"""

import sys
import os
import pytest
from pathlib import Path
from lxml import etree

SRC = Path(__file__).parent.parent.parent.parent / "src" / "main" / "python"
sys.path.insert(0, str(SRC))

from lens_migration.ai.llm_client import create_llm_client
from lens_migration.ai.xslt_refiner import XSLTRefiner
from lens_migration.parser.intent_parser import IntentParser

# ── 路径常量 ──────────────────────────────────────────────────────────────────
BASE          = Path(__file__).parent.parent
INTENT_FILE   = BASE / "input" / "request"     / "migration-intent-v1-to-v2.md"
INPUT_FILE    = BASE / "input" / "old-version" / "vlan-sample-01-v1.xml"
EXPECTED_FILE = BASE / "input" / "new-version" / "vlan-sample-01-v2.xml"
OUTPUT_DIR    = BASE / "output"
OUTPUT_XSLT   = OUTPUT_DIR / "github-transform.xslt"

OUTPUT_DIR.mkdir(exist_ok=True)

_GITHUB_TOKEN = os.environ.get("GITHUB_TOKEN") or os.environ.get("GH_TOKEN")

pytestmark = pytest.mark.skipif(
    not _GITHUB_TOKEN,
    reason="未设置 GITHUB_TOKEN，跳过 GitHub VLAN XSLT 生成测试"
)

# ── 工具函数（与 test_vlan_ollama.py 共用同一套，命名空间无关）─────────────────

def apply_xslt(xslt_path: Path, input_path: Path) -> etree._Element:
    xslt_doc  = etree.parse(str(xslt_path))
    transform = etree.XSLT(xslt_doc)
    result    = transform(etree.parse(str(input_path)))
    return etree.fromstring(etree.tostring(result))

def ln(tag: str) -> str:
    return f"*[local-name()='{tag}']"

def find_all(root, *tags):
    return root.xpath(".//" + "/".join(ln(t) for t in tags))

def find_children(parent, *tags):
    return parent.xpath(".//" + "/".join(ln(t) for t in tags))

def find_iface(root, name: str):
    for iface in root.xpath(f"//{ln('interface')}"):
        ns = iface.xpath(ln("name"))
        if ns and ns[0].text and ns[0].text.strip() == name:
            return iface
    return None


# ── Fixtures ──────────────────────────────────────────────────────────────────

@pytest.fixture(scope="module")
def intent():
    return IntentParser().parse(INTENT_FILE)


@pytest.fixture(scope="module")
def xslt_result(intent):
    """调用 GitHub Models 生成 XSLT，模块级（只生成一次）。"""
    client  = create_llm_client("github", model="gpt-4o-mini")
    refiner = XSLTRefiner(client, max_rounds=3)
    result  = refiner.refine(
        intent=intent,
        input_xml=INPUT_FILE.read_text(encoding="utf-8"),
        input_xml_path=INPUT_FILE,
        expected_output=EXPECTED_FILE.read_text(encoding="utf-8"),
        expected_output_path=EXPECTED_FILE,
        output_xslt=OUTPUT_XSLT,
    )
    print(f"\n{'='*60}")
    print(f"[GitHub VLAN] model=gpt-4o-mini  success={result['success']}  rounds={result['rounds_used']}")
    for i, r in enumerate(result["round_history"], 1):
        lat = r.get('latency_ms', 0)
        tok = r.get('tokens', 0)
        tps = tok / (lat / 1000) if lat > 0 else 0
        print(f"  Round {i}: syntax={r['syntax_valid']}  transform={r.get('transformation_ok')}"
              f"  tokens={tok}  latency={lat:.0f}ms  tps={tps:.1f} tokens/s")
    print(f"  total_tokens={result['total_tokens']}")
    if result.get("errors"):
        print(f"  errors: {result['errors']}")
    print(f"{'='*60}")
    return result


@pytest.fixture
def actual(xslt_result):
    return apply_xslt(Path(xslt_result["xslt_file"]), INPUT_FILE)


# =============================================================================
# 测试类
# =============================================================================

class TestVlanGitHub:
    """
    VLAN XSLT 生成验证 — GitHub Models (gpt-4o-mini)

    20 个断言覆盖：意图解析 → AI 生成 → 4条规则语义验证。
    """

    # ── 阶段1：意图解析 ───────────────────────────────────────────────────────
    def test_intent_file_exists(self):
        assert INTENT_FILE.exists(), f"找不到意图文档: {INTENT_FILE}"

    def test_input_sample_exists(self):
        assert INPUT_FILE.exists()

    def test_expected_output_exists(self):
        assert EXPECTED_FILE.exists()

    def test_intent_has_4_rules(self, intent):
        assert len(intent.rules) == 4, f"期望4条规则，实际 {len(intent.rules)} 条"

    def test_intent_title_contains_vlan(self, intent):
        assert "VLAN" in intent.title or "vlan" in intent.title.lower()

    # ── 阶段2：AI 生成 ────────────────────────────────────────────────────────
    def test_completed_at_least_one_round(self, xslt_result):
        assert xslt_result["rounds_used"] >= 1, f"未完成任何生成: {xslt_result['errors']}"

    def test_xslt_file_saved(self, xslt_result):
        p = Path(xslt_result["xslt_file"])
        assert p.exists() and p.stat().st_size > 100

    def test_xslt_syntax_valid(self, xslt_result):
        assert xslt_result["round_history"][0]["syntax_valid"]

    def test_xslt_transformation_ok(self, xslt_result):
        assert xslt_result["round_history"][0].get("transformation_ok") is not False

    def test_tokens_consumed(self, xslt_result):
        assert xslt_result["total_tokens"] > 0

    # ── 阶段3：规则验证 ───────────────────────────────────────────────────────
    def test_rule1_renamed(self, actual):
        """[规则1] pop-and-push-vlan → pop-and-push-2-tags。"""
        assert len(find_all(actual, "pop-and-push-vlan")) == 0
        assert len(find_all(actual, "pop-and-push-2-tags")) >= 1

    def test_rule1_children_preserved(self, actual):
        """[规则1] pop-and-push-2-tags 下 pop-tags/push-tag 子元素保留。"""
        for el in find_all(actual, "pop-and-push-2-tags"):
            assert len(find_children(el, "pop-tags")) == 1
            assert len(find_children(el, "push-tag")) >= 1

    def test_rule2_eth100_vlan_id_101(self, actual):
        """[规则2] eth0.100 ingress vlan-id → 101。"""
        iface = find_iface(actual, "eth0.100")
        assert iface is not None
        vids = find_children(iface, "ingress-rule", "rule", "match-criteria", "dot1q-tag", "vlan-id")
        assert vids and vids[0].text.strip() == "101"

    def test_rule2_eth200_vlan_id_unchanged(self, actual):
        """[规则2] eth0.200 vlan-id 保持 200。"""
        iface = find_iface(actual, "eth0.200")
        assert iface is not None
        vids = find_children(iface, "ingress-rule", "rule", "match-criteria", "dot1q-tag", "vlan-id")
        assert vids and vids[0].text.strip() == "200"

    def test_rule3_admin_state_eth100(self, actual):
        """[规则3] eth0.100 添加 admin-state=enabled。"""
        iface = find_iface(actual, "eth0.100")
        assert iface is not None
        admin = iface.xpath(ln("admin-state"))
        assert len(admin) == 1 and admin[0].text.strip() == "enabled"

    def test_rule3_admin_state_eth200(self, actual):
        """[规则3] eth0.200 添加 admin-state=enabled。"""
        iface = find_iface(actual, "eth0.200")
        assert iface is not None
        admin = iface.xpath(ln("admin-state"))
        assert len(admin) == 1 and admin[0].text.strip() == "enabled"

    def test_rule4_legacy_mode_deleted(self, actual):
        """[规则4] legacy-mode 元素被删除。"""
        assert len(find_all(actual, "legacy-mode")) == 0

    def test_interface_count(self, actual):
        """顶层 interface 数量保持 2。"""
        assert len(actual.xpath(ln("interface"))) == 2

    def test_interface_names_preserved(self, actual):
        """eth0.100 和 eth0.200 名称保留。"""
        names = [el.text.strip() for el in actual.xpath(f"//{ln('interface')}/{ln('name')}")]
        assert "eth0.100" in names and "eth0.200" in names

    def test_description_preserved(self, actual):
        """description 字段未被修改。"""
        iface = find_iface(actual, "eth0.100")
        assert iface is not None
        descs = iface.xpath(ln("description"))
        assert len(descs) == 1 and "Customer VLAN 100" in descs[0].text

