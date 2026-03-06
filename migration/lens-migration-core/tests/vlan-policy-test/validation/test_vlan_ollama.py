"""
VLAN Policy XSLT 生成测试 — Ollama Provider（本地 / 远端）

使用 Ollama（由 OLLAMA_MODEL / OLLAMA_BASE_URL 控制）从迁移意图文档自动生成 XSLT，
验证 4 条迁移规则均正确执行。

目标服务由 conftest.py 根据 OLLAMA_TARGET 自动设置：
  OLLAMA_TARGET=local  → localhost:11434  (qwen2.5-coder:3b)
  OLLAMA_TARGET=remote → localhost:11435  (qwen2.5-coder:14b，SSH 隧道到 10.99.79.20)

认证：OLLAMA_API_KEY 环境变量，本地无认证时无需设置。

运行：
  cd migration/lens-migration-core
  # 使用 .env.test 中的 OLLAMA_TARGET=remote（默认）
  venv/bin/python3 -m pytest tests/vlan-policy-test/validation/test_vlan_ollama.py -v -s

跳过条件：OLLAMA_BASE_URL 指向的服务不可达或目标模型未安装时自动跳过。
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

OUTPUT_DIR.mkdir(exist_ok=True)

# ── Ollama 环境变量（conftest.py 根据 OLLAMA_TARGET 自动设置）──────────────
# OLLAMA_TARGET=remote → OLLAMA_MODEL=qwen2.5-coder:14b, OLLAMA_BASE_URL=http://localhost:11435/v1
# OLLAMA_TARGET=local  → OLLAMA_MODEL=qwen2.5-coder:3b,  OLLAMA_BASE_URL=http://localhost:11434/v1
_OLLAMA_MODEL  = os.environ.get("OLLAMA_MODEL",    "qwen2.5-coder:14b")
_OLLAMA_URL    = os.environ.get("OLLAMA_BASE_URL", "http://localhost:11434/v1")


def _check_ollama() -> tuple:
    """检测 _OLLAMA_URL 指向的 Ollama 服务是否可达，且目标模型已安装。"""
    try:
        import urllib.request, json
        api_base = _OLLAMA_URL.replace("/v1", "").rstrip("/")
        with urllib.request.urlopen(f"{api_base}/api/tags", timeout=5) as r:
            data = json.loads(r.read())
        models = [m.get("name", "") for m in data.get("models", [])]
        base = _OLLAMA_MODEL.split(":")[0]
        found = any(m == _OLLAMA_MODEL or m.startswith(base + ":") or m == base for m in models)
        if not found:
            return False, (f"Ollama 在线但未找到 '{_OLLAMA_MODEL}'，已有: {models}。"
                           f"请运行: ollama pull {_OLLAMA_MODEL}")
        return True, f"Ollama 可用，model={_OLLAMA_MODEL}，url={_OLLAMA_URL}"
    except Exception as e:
        return False, f"Ollama 不可达 ({_OLLAMA_URL}): {e}"


_OLLAMA_OK, _OLLAMA_SKIP_REASON = _check_ollama()

pytestmark = pytest.mark.skipif(not _OLLAMA_OK, reason=_OLLAMA_SKIP_REASON)


# ── 工具函数（与 test_vlan_github.py 完全相同） ──────────────────────────────

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
    """调用 Ollama 生成 XSLT，模块级（只生成一次）。"""
    output_xslt = OUTPUT_DIR / f"ollama-{_OLLAMA_MODEL.replace(':', '-')}-transform.xslt"
    # base_url 使用 _OLLAMA_URL（conftest 已根据 OLLAMA_TARGET 设置为正确端口）
    client  = create_llm_client("ollama", model=_OLLAMA_MODEL, base_url=_OLLAMA_URL)
    refiner = XSLTRefiner(client, max_rounds=3)
    result  = refiner.refine(
        intent=intent,
        input_xml=INPUT_FILE.read_text(encoding="utf-8"),
        input_xml_path=INPUT_FILE,
        expected_output=EXPECTED_FILE.read_text(encoding="utf-8"),
        expected_output_path=EXPECTED_FILE,
        output_xslt=output_xslt,
    )
    print(f"\n{'='*60}")
    print(f"[Ollama VLAN] model={_OLLAMA_MODEL}  url={_OLLAMA_URL}")
    print(f"  success={result['success']}  rounds={result['rounds_used']}")
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

class TestVlanOllama:
    """
    VLAN XSLT 生成验证 — 本地 Ollama（默认 qwen3:8b）

    20 个断言与 TestVlanGitHub 完全对称，验证两种 provider 的接口一致性。
    通过 OLLAMA_MODEL 环境变量可切换模型：qwen3:4b / qwen2.5-coder:7b 等。
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
    def test_ollama_model_info(self, xslt_result):
        """打印当前使用的模型，方便比对不同模型效果。"""
        print(f"\n[Ollama] 模型={_OLLAMA_MODEL}, url={_OLLAMA_URL}")
        assert _OLLAMA_MODEL

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

