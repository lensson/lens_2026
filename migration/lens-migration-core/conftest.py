"""
pytest 全局配置文件

位置说明：conftest.py 必须放在项目根目录（pytest rootdir），
负责 sys.path 注入和全局环境变量加载，不能移入 tests/ 子目录。

职责：
  1. 自动加载 .env.test 文件中的环境变量（如 GITHUB_TOKEN / OLLAMA_MODEL）
  2. 启动时打印各 Live Integration 测试的跳过/运行状态，方便诊断
  3. 提供 PYTHONPATH 注入（补充 pytest.ini pythonpath 配置）

目录结构：
  lens-migration-core/
  ├── conftest.py          ← 此文件（必须在根目录）
  ├── pytest.ini           ← pytest 配置
  ├── .env.test            ← 环境变量（不提交 git）
  ├── src/main/python/     ← 源码
  ├── tests/               ← 测试（与 src/ 平行，标准位置）
  ├── scripts/             ← 脚本（run_live_tests.sh 等）
  └── examples/            ← 示例代码

文档统一放在项目根目录 doc/migration/ 下：
  lens_2026/doc/migration/
  ├── QUICKSTART.md
  ├── IMPLEMENTATION.md
  ├── IDEA_PYTHON_SETUP.md
  └── HARDWARE_AND_MODEL_GUIDE.md

环境变量配置方式（三选一）：
  A. 创建 .env.test 文件（推荐，不会提交到 git）：
       echo 'GITHUB_TOKEN=ghp_xxxx' >> .env.test
       echo 'OLLAMA_MODEL=qwen3:8b' >> .env.test

  B. IDEA Run Configuration → Environment variables 填入：
       GITHUB_TOKEN=ghp_xxxx;OLLAMA_MODEL=qwen3:8b

  C. 命令行直接传入：
       GITHUB_TOKEN=ghp_xxxx OLLAMA_MODEL=qwen3:8b pytest ...
       # 或使用脚本：
       bash scripts/run_live_tests.sh
"""

import os
import sys
import subprocess
import atexit
from pathlib import Path

# ── 1. PYTHONPATH 注入 ────────────────────────────────────
ROOT = Path(__file__).parent
SRC  = ROOT / "src" / "main" / "python"
if str(SRC) not in sys.path:
    sys.path.insert(0, str(SRC))

# ── 2. 加载 .env.test ─────────────────────────────────────
_ENV_FILE = ROOT / ".env.test"
if _ENV_FILE.exists():
    with open(_ENV_FILE) as _f:
        for _line in _f:
            _line = _line.strip()
            if _line and not _line.startswith("#") and "=" in _line:
                _key, _, _val = _line.partition("=")
                _key = _key.strip()
                _val = _val.strip().strip('"').strip("'")
                if _key and _key not in os.environ:
                    os.environ[_key] = _val

# ── 3. 根据 OLLAMA_TARGET 解析 OLLAMA_MODEL / OLLAMA_BASE_URL ──
_TARGET = os.environ.get("OLLAMA_TARGET", "local").lower()
_TUNNEL_PROC = None

if _TARGET == "remote":
    # 填充统一变量（供 OllamaClient 使用）
    if "OLLAMA_MODEL" not in os.environ:
        os.environ["OLLAMA_MODEL"] = os.environ.get("OLLAMA_REMOTE_MODEL", "qwen3.5:35b")
    if "OLLAMA_BASE_URL" not in os.environ:
        os.environ["OLLAMA_BASE_URL"] = os.environ.get("OLLAMA_REMOTE_URL", "http://localhost:11435/v1")

    # 自动建立 SSH 隧道（如果还没有）
    _host      = os.environ.get("OLLAMA_REMOTE_HOST", "10.99.79.20")
    _user      = os.environ.get("OLLAMA_REMOTE_USER", "air")
    _password  = os.environ.get("OLLAMA_REMOTE_PASS", "")
    _r_port    = os.environ.get("OLLAMA_REMOTE_PORT", "11434")
    _l_port    = os.environ.get("OLLAMA_TUNNEL_LOCAL_PORT", "11435")

    import socket
    def _tunnel_alive():
        try:
            s = socket.create_connection(("localhost", int(_l_port)), timeout=2)
            s.close(); return True
        except OSError:
            return False

    if not _tunnel_alive():
        try:
            _cmd = ["sshpass", f"-p{_password}",
                    "ssh", "-o", "StrictHostKeyChecking=no",
                    "-N", "-L", f"{_l_port}:localhost:{_r_port}",
                    f"{_user}@{_host}"]
            _TUNNEL_PROC = subprocess.Popen(
                _cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
            )
            import time; time.sleep(2)   # 等隧道建立
            if _tunnel_alive():
                sys.stderr.write(f"[conftest] SSH 隧道已建立: localhost:{_l_port} → {_host}:{_r_port}\n")
            else:
                sys.stderr.write(f"[conftest] SSH 隧道建立失败，请手动运行:\n"
                                 f"  sshpass -p'{_password}' ssh -N -L {_l_port}:localhost:{_r_port} {_user}@{_host} &\n")
        except FileNotFoundError:
            sys.stderr.write("[conftest] sshpass 未安装，请手动建立隧道：\n"
                             f"  ssh -N -L {_l_port}:localhost:{_r_port} {_user}@{_host} &\n")

    def _close_tunnel():
        if _TUNNEL_PROC and _TUNNEL_PROC.poll() is None:
            _TUNNEL_PROC.terminate()
            sys.stderr.write("[conftest] SSH 隧道已关闭\n")
    atexit.register(_close_tunnel)

else:  # local
    if "OLLAMA_MODEL" not in os.environ:
        os.environ["OLLAMA_MODEL"] = os.environ.get("OLLAMA_LOCAL_MODEL", "qwen2.5-coder:3b")
    if "OLLAMA_BASE_URL" not in os.environ:
        os.environ["OLLAMA_BASE_URL"] = os.environ.get("OLLAMA_LOCAL_URL", "http://localhost:11434/v1")


# ── 3. Ollama 可用性检测（模块级缓存，供 skipif 条件使用）─────────────────────
def _ollama_status() -> tuple[bool, str]:
    model = os.environ.get("OLLAMA_MODEL", "qwen3:8b")
    try:
        import urllib.request, json
        with urllib.request.urlopen("http://localhost:11434/api/tags", timeout=3) as r:
            data = json.loads(r.read())
        models = [m.get("name", "") for m in data.get("models", [])]
        base = model.split(":")[0]
        found = any(m == model or m.startswith(base + ":") or m == base for m in models)
        if not found:
            return False, f"Ollama在线但未找到模型 '{model}'，已有: {models}。运行: ollama pull {model}"
        return True, f"OK (model={model})"
    except Exception as e:
        return False, f"服务不可达: {e}"


# ── 4. pytest 启动钩子：打印环境状态面板 ─────────────────────────────────────
def pytest_configure(config):
    gh_token   = os.environ.get("GITHUB_TOKEN") or os.environ.get("GH_TOKEN")
    ollama_ok, ollama_reason = _ollama_status()
    model      = os.environ.get("OLLAMA_MODEL", "qwen3:8b")
    target     = _TARGET
    env_file_loaded = _ENV_FILE.exists()

    lines = [
        "",
        "╔══════════════════════════════════════════════════════════╗",
        "║          Live Integration Tests 环境状态                 ║",
        f"║  .env.test : {'已加载 ✅' if env_file_loaded else '未找到 ❌（建议创建）':<46}║",
        f"║  Ollama 目标: {('🏠 local' if target=='local' else '🌐 remote (SSH tunnel)'):<44}║",
        "╠══════════════════════════════════════════════════════════╣",
    ]

    if gh_token:
        lines.append(f"║  GitHub Models  ✅  token={gh_token[:12]}...{' ' * 27}║")
    else:
        lines.append( "║  GitHub Models  ❌  未设置 GITHUB_TOKEN                  ║")
        lines.append( "║    设置方法: echo 'GITHUB_TOKEN=ghp_xxx' >> .env.test    ║")

    lines.append(    "║                                                          ║")

    if ollama_ok:
        lines.append(f"║  Ollama         ✅  {ollama_reason:<42}║")
    else:
        short = ollama_reason[:40]
        lines.append(f"║  Ollama         ❌  {short:<42}║")
        if target == "remote":
            lines.append( "║    隧道端口: localhost:11435 → 10.99.79.20:11434         ║")
        else:
            lines.append(f"║    运行: ollama serve && ollama pull {model:<22}║")

    lines += [
        "╚══════════════════════════════════════════════════════════╝",
        "",
    ]
    sys.stderr.write("\n".join(lines) + "\n")
    sys.stderr.flush()
