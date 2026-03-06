"""
API 连通性与性能测试

测试三种 LLM Provider 的可用性和响应性能：
  1. GitHub Models  — 通过 GITHUB_TOKEN（Bearer Token）
  2. 本地 Ollama    — localhost:11434，模型 OLLAMA_LOCAL_MODEL
  3. 远端 Ollama    — SSH 隧道 localhost:11435 → 10.99.79.20:11434，模型 OLLAMA_REMOTE_MODEL

环境变量由 conftest.py 自动从 .env.test 加载，无需手动设置。

运行方式：
  # 测试所有 provider（.env.test 已配置）
  cd lens-migration-core
  venv/bin/python3 -m pytest tests/ai/test_api_connectivity.py -v -s

  # 只测试某一类
  pytest tests/ai/test_api_connectivity.py -v -s -k GitHub
  pytest tests/ai/test_api_connectivity.py -v -s -k LocalOllama
  pytest tests/ai/test_api_connectivity.py -v -s -k RemoteOllama
"""

import os
import sys
import time
import socket
import urllib.request
import json
import pytest
from pathlib import Path

SRC = Path(__file__).parent.parent.parent / "src" / "main" / "python"
sys.path.insert(0, str(SRC))

from lens_migration.ai.llm_client import (
    GitHubModelsClient,
    OllamaClient,
    create_llm_client,
)

# ─────────────────────────────────────────────────────────────────────────────
# 环境变量读取（由 conftest.py 从 .env.test 加载）
# ─────────────────────────────────────────────────────────────────────────────
_GITHUB_TOKEN      = os.environ.get("GITHUB_TOKEN") or os.environ.get("GH_TOKEN")
_LOCAL_MODEL       = os.environ.get("OLLAMA_LOCAL_MODEL", "qwen2.5-coder:3b")
_LOCAL_URL         = os.environ.get("OLLAMA_LOCAL_URL", "http://localhost:11434/v1")
_REMOTE_MODEL      = os.environ.get("OLLAMA_REMOTE_MODEL", "qwen2.5-coder:14b")
_REMOTE_URL        = os.environ.get("OLLAMA_REMOTE_URL", "http://localhost:11435/v1")
_TUNNEL_LOCAL_PORT = int(os.environ.get("OLLAMA_TUNNEL_LOCAL_PORT", "11435"))

# ─────────────────────────────────────────────────────────────────────────────
# 可用性检测辅助函数
# ─────────────────────────────────────────────────────────────────────────────

def _check_ollama_service(url: str, model: str, timeout: int = 5) -> tuple:
    """检测指定地址的 Ollama 服务是否可达，且目标模型已安装。"""
    api_base = url.replace("/v1", "").rstrip("/")
    root_url = f"{api_base}/"
    tags_url = f"{api_base}/api/tags"
    try:
        with urllib.request.urlopen(root_url, timeout=timeout) as r:
            body = r.read().decode()
        if "Ollama" not in body and r.status != 200:
            return False, f"服务响应异常: {body[:80]}"
    except Exception as e:
        return False, f"服务不可达 ({root_url}): {e}"
    try:
        with urllib.request.urlopen(tags_url, timeout=timeout) as r:
            data = json.loads(r.read())
        models = [m.get("name", "") for m in data.get("models", [])]
        base = model.split(":")[0]
        found = any(m == model or m.startswith(base + ":") or m == base for m in models)
        if not found:
            return False, f"服务在线但未找到模型 '{model}'，已有: {models}"
        return True, f"OK (url={url}, model={model})"
    except Exception as e:
        return False, f"获取模型列表失败: {e}"


def _check_tunnel_alive(port: int, timeout: int = 2) -> bool:
    """检测本地端口是否可连接（SSH 隧道是否建立）。"""
    try:
        s = socket.create_connection(("localhost", port), timeout=timeout)
        s.close()
        return True
    except OSError:
        return False


# ─────────────────────────────────────────────────────────────────────────────
# 跳过条件（模块级，避免重复 HTTP 请求）
# ─────────────────────────────────────────────────────────────────────────────
_LOCAL_OK,  _LOCAL_REASON  = _check_ollama_service(_LOCAL_URL, _LOCAL_MODEL)
_TUNNEL_OK                 = _check_tunnel_alive(_TUNNEL_LOCAL_PORT)
_REMOTE_OK, _REMOTE_REASON = (
    _check_ollama_service(_REMOTE_URL, _REMOTE_MODEL, timeout=8)
    if _TUNNEL_OK
    else (False, f"SSH 隧道未建立（localhost:{_TUNNEL_LOCAL_PORT}），conftest.py 会自动尝试建立")
)

_Q_SHORT = "请用一句话回答：XSLT 是什么？不要超过 30 字。"


def _assert_response(resp, provider_name: str):
    """统一断言 LLMResponse 格式正确。"""
    assert resp.content,                  f"[{provider_name}] 响应内容为空"
    assert resp.provider == provider_name, f"[{provider_name}] provider 字段错误"
    assert resp.total_tokens > 0,         f"[{provider_name}] total_tokens 应 > 0"
    assert resp.latency_ms > 0,           f"[{provider_name}] latency_ms 应 > 0"
    assert resp.model,                    f"[{provider_name}] model 字段不应为空"


# =============================================================================
# 1. GitHub Models
# =============================================================================

@pytest.mark.skipif(not _GITHUB_TOKEN, reason="未设置 GITHUB_TOKEN，跳过 GitHub 测试")
class TestGitHubModels:
    """GitHub Models API 连通性与性能测试（gpt-4o-mini）。"""

    _MODEL = "gpt-4o-mini"

    def test_token_set(self):
        """GITHUB_TOKEN 环境变量已设置且格式正确。"""
        assert _GITHUB_TOKEN.startswith("ghp_") or len(_GITHUB_TOKEN) > 10
        print(f"\n  token 前缀: {_GITHUB_TOKEN[:12]}...")

    def test_client_creation(self):
        """通过工厂函数创建 GitHub 客户端。"""
        client = create_llm_client("github", model=self._MODEL)
        assert isinstance(client, GitHubModelsClient)
        assert client.provider_name == "github"
        assert client.model == self._MODEL

    def test_simple_chat(self):
        """基础对话：chat() 返回非空响应，记录性能。"""
        client = create_llm_client("github", model=self._MODEL)
        t0 = time.time()
        resp = client.chat(_Q_SHORT)
        elapsed = (time.time() - t0) * 1000

        print(f"\n  模型  : {resp.model}")
        print(f"  响应  : {resp.content[:200]}")
        print(f"  tokens: input={resp.input_tokens}, output={resp.output_tokens}, total={resp.total_tokens}")
        print(f"  延迟  : {elapsed:.0f}ms")

        _assert_response(resp, "github")

    def test_system_prompt(self):
        """GitHub Models 支持 system_prompt。"""
        client = create_llm_client("github", model=self._MODEL)
        resp = client.chat(
            "什么是 XML？",
            system_prompt="你是 XML 专家，用中文回答，不超过 15 字。",
        )
        assert resp.content
        print(f"\n  system_prompt 响应: {resp.content}")

    def test_response_stability(self):
        """连续两次调用，provider/model 字段稳定。"""
        client = create_llm_client("github", model=self._MODEL)
        r1 = client.chat("回答 yes：1+1=2？")
        r2 = client.chat("回答 yes：2+2=4？")
        assert r1.provider == r2.provider == "github"
        assert r1.model == r2.model
        print(f"\n  两次调用 provider={r1.provider}, model={r1.model} ✅")


# =============================================================================
# 2. 本地 Ollama（localhost:11434，qwen2.5-coder:3b）
# =============================================================================

@pytest.mark.skipif(not _LOCAL_OK, reason=f"本地 Ollama 不可用: {_LOCAL_REASON}")
class TestLocalOllama:
    """本地 Ollama 连通性与性能测试（localhost:11434，模型 qwen2.5-coder:3b）。"""

    def test_service_reachable(self):
        """本地 Ollama HTTP 服务可达。"""
        api_base = _LOCAL_URL.replace("/v1", "").rstrip("/")
        r = urllib.request.urlopen(f"{api_base}/", timeout=5)
        body = r.read().decode()
        print(f"\n  服务响应: {body.strip()}")
        assert "Ollama" in body or r.status == 200

    def test_model_available(self):
        """目标模型已安装。"""
        api_base = _LOCAL_URL.replace("/v1", "").rstrip("/")
        r = urllib.request.urlopen(f"{api_base}/api/tags", timeout=5)
        data = json.loads(r.read())
        models = [m.get("name", "") for m in data.get("models", [])]
        print(f"\n  已安装模型: {models}")
        print(f"  目标模型  : {_LOCAL_MODEL}")
        base = _LOCAL_MODEL.split(":")[0]
        found = any(m == _LOCAL_MODEL or m.startswith(base + ":") for m in models)
        assert found, f"模型 '{_LOCAL_MODEL}' 未安装，请运行: ollama pull {_LOCAL_MODEL}"

    def test_client_creation(self):
        """通过工厂函数创建本地 Ollama 客户端。"""
        client = create_llm_client("ollama", model=_LOCAL_MODEL, base_url=_LOCAL_URL)
        assert isinstance(client, OllamaClient)
        assert client.provider_name == "ollama"

    def test_simple_chat(self):
        """基础对话：chat() 返回非空响应，记录 CPU 推理性能。"""
        client = create_llm_client("ollama", model=_LOCAL_MODEL, base_url=_LOCAL_URL)
        t0 = time.time()
        resp = client.chat(_Q_SHORT)
        elapsed = (time.time() - t0) * 1000

        print(f"\n  模型  : {_LOCAL_MODEL} (本地 CPU)")
        print(f"  响应  : {resp.content[:300]}")
        print(f"  tokens: input={resp.input_tokens}, output={resp.output_tokens}, total={resp.total_tokens}")
        print(f"  延迟  : {elapsed:.0f}ms ⚠️  本地 CPU 推理较慢属正常")
        if resp.total_tokens > 0 and elapsed > 0:
            print(f"  吞吐量: {resp.total_tokens / (elapsed / 1000):.1f} tokens/s")

        _assert_response(resp, "ollama")

    def test_system_prompt(self):
        """本地 Ollama 支持 system_prompt。"""
        client = create_llm_client("ollama", model=_LOCAL_MODEL, base_url=_LOCAL_URL)
        resp = client.chat(
            "什么是 XSLT？",
            system_prompt="你是 XML 专家，用中文回答，不超过 20 字。",
        )
        assert resp.content
        print(f"\n  system_prompt 响应: {resp.content[:200]}")


# =============================================================================
# 3. 远端 Ollama（SSH 隧道 → 10.99.79.20 RTX 4090，qwen2.5-coder:14b）
# =============================================================================

@pytest.mark.skipif(not _REMOTE_OK, reason=f"远端 Ollama 不可用: {_REMOTE_REASON}")
class TestRemoteOllama:
    """远端 Ollama 连通性与性能测试（SSH 隧道 localhost:11435 → 10.99.79.20:11434）。"""

    def test_tunnel_alive(self):
        """SSH 隧道端口可连接（localhost:11435）。"""
        alive = _check_tunnel_alive(_TUNNEL_LOCAL_PORT)
        print(f"\n  隧道端口 localhost:{_TUNNEL_LOCAL_PORT} → 10.99.79.20:11434  {'✅' if alive else '❌'}")
        assert alive, "隧道未建立，请确认 conftest.py 的 sshpass 命令已执行"

    def test_service_reachable(self):
        """远端 Ollama HTTP 服务（通过隧道）可达。"""
        api_base = _REMOTE_URL.replace("/v1", "").rstrip("/")
        r = urllib.request.urlopen(f"{api_base}/", timeout=8)
        body = r.read().decode()
        print(f"\n  服务响应 ({_REMOTE_URL}): {body.strip()}")
        assert "Ollama" in body or r.status == 200

    def test_model_available(self):
        """目标模型已在远端安装。"""
        api_base = _REMOTE_URL.replace("/v1", "").rstrip("/")
        r = urllib.request.urlopen(f"{api_base}/api/tags", timeout=8)
        data = json.loads(r.read())
        models = [m.get("name", "") for m in data.get("models", [])]
        print(f"\n  远端已安装模型: {models}")
        print(f"  目标模型      : {_REMOTE_MODEL}")
        base = _REMOTE_MODEL.split(":")[0]
        found = any(m == _REMOTE_MODEL or m.startswith(base + ":") for m in models)
        assert found, f"模型 '{_REMOTE_MODEL}' 未在远端安装，请运行: ollama pull {_REMOTE_MODEL}"

    def test_client_creation(self):
        """通过工厂函数创建远端 Ollama 客户端。"""
        client = create_llm_client("ollama", model=_REMOTE_MODEL, base_url=_REMOTE_URL)
        assert isinstance(client, OllamaClient)
        assert client.provider_name == "ollama"

    def test_simple_chat(self):
        """基础对话：chat() 返回非空响应，记录 GPU 推理性能。"""
        client = create_llm_client("ollama", model=_REMOTE_MODEL, base_url=_REMOTE_URL)
        t0 = time.time()
        resp = client.chat(_Q_SHORT)
        elapsed = (time.time() - t0) * 1000

        print(f"\n  模型  : {_REMOTE_MODEL} (远端 RTX 4090)")
        print(f"  响应  : {resp.content[:300]}")
        print(f"  tokens: input={resp.input_tokens}, output={resp.output_tokens}, total={resp.total_tokens}")
        print(f"  延迟  : {elapsed:.0f}ms 🚀 GPU 加速推理")
        if resp.total_tokens > 0 and elapsed > 0:
            print(f"  吞吐量: {resp.total_tokens / (elapsed / 1000):.1f} tokens/s")

        _assert_response(resp, "ollama")

    def test_system_prompt(self):
        """远端 Ollama 支持 system_prompt。"""
        client = create_llm_client("ollama", model=_REMOTE_MODEL, base_url=_REMOTE_URL)
        resp = client.chat(
            "什么是 XSLT？",
            system_prompt="你是 XML 专家，用中文回答，不超过 20 字。",
        )
        assert resp.content
        print(f"\n  system_prompt 响应: {resp.content[:200]}")

    def test_performance_benchmark(self):
        """性能基准：远端 GPU 推理，记录吞吐量。"""
        client = create_llm_client("ollama", model=_REMOTE_MODEL, base_url=_REMOTE_URL)
        question = "请解释 XSLT 中 xsl:template 和 xsl:apply-templates 的区别，用中文，不超过 60 字。"
        t0 = time.time()
        resp = client.chat(question)
        elapsed = (time.time() - t0) * 1000

        print(f"\n  ── 性能基准（远端 RTX 4090）──")
        print(f"  模型    : {_REMOTE_MODEL}")
        print(f"  问题长度: {len(question)} 字符")
        print(f"  响应长度: {len(resp.content)} 字符")
        print(f"  总延迟  : {elapsed:.0f}ms")
        print(f"  tokens  : {resp.total_tokens}")
        if resp.total_tokens > 0 and elapsed > 0:
            tps = resp.total_tokens / (elapsed / 1000)
            print(f"  吞吐量  : {tps:.1f} tokens/s")
        print(f"  响应    : {resp.content}")

        assert resp.content
        assert elapsed < 60_000, f"推理超时（{elapsed:.0f}ms > 60s）"


# =============================================================================
# 4. 三 Provider 对比（GitHub + 本地 + 远端同时可用时）
# =============================================================================

@pytest.mark.skipif(
    not (_GITHUB_TOKEN and _LOCAL_OK and _REMOTE_OK),
    reason="需要 GitHub Token + 本地 Ollama + 远端 Ollama 同时可用才运行对比测试"
)
class TestThreeProviderComparison:
    """三 Provider 横向对比：接口一致性 + 性能对比。"""

    def test_interface_consistency(self):
        """三种 provider 使用相同调用接口，响应结构一致。"""
        providers = [
            ("github",        create_llm_client("github", model="gpt-4o-mini")),
            ("ollama-local",  create_llm_client("ollama", model=_LOCAL_MODEL, base_url=_LOCAL_URL)),
            ("ollama-remote", create_llm_client("ollama", model=_REMOTE_MODEL, base_url=_REMOTE_URL)),
        ]

        print("\n  ── 三 Provider 接口一致性对比 ──")
        q = "用 10 字以内回答：XML 是什么？"
        results = []
        for name, client in providers:
            t0 = time.time()
            resp = client.chat(q)
            elapsed = (time.time() - t0) * 1000
            results.append((name, resp, elapsed))
            print(f"  [{name:14}] 延迟={elapsed:6.0f}ms  tokens={resp.total_tokens:4d}  响应={resp.content[:60]}")

        for name, resp, _ in results:
            assert resp.content,         f"[{name}] 响应为空"
            assert resp.total_tokens > 0, f"[{name}] total_tokens=0"
            assert resp.latency_ms > 0,   f"[{name}] latency_ms=0"

    def test_performance_comparison(self):
        """性能对比：记录三者延迟排名。"""
        print("\n  ── 性能对比（同一问题）──")
        question = "请用中文解释 XSLT 的作用，不超过 40 字。"
        data = []
        for label, model, url in [
            ("GitHub gpt-4o-mini",        "gpt-4o-mini",  None),
            (f"本地  {_LOCAL_MODEL}",      _LOCAL_MODEL,   _LOCAL_URL),
            (f"远端  {_REMOTE_MODEL}",     _REMOTE_MODEL,  _REMOTE_URL),
        ]:
            client = (create_llm_client("github", model=model)
                      if url is None
                      else create_llm_client("ollama", model=model, base_url=url))
            t0 = time.time()
            resp = client.chat(question)
            ms = (time.time() - t0) * 1000
            data.append((label, ms, resp.total_tokens))
            print(f"  {label:<35} {ms:7.0f}ms  {resp.total_tokens:4d} tokens")

        print("\n  🏆 延迟排名（越低越好）：")
        for rank, (label, ms, _) in enumerate(sorted(data, key=lambda x: x[1]), 1):
            print(f"    #{rank} {label:<35} {ms:.0f}ms")
