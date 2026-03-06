"""
VLAN Policy XSLT 生成测试 — 入口文件（同时运行 GitHub 和 Ollama 两个 case）

本文件不包含测试逻辑，两种 provider 的测试分别在：
  test_vlan_github.py  — GitHub Models (gpt-4o-mini)，需要 GITHUB_TOKEN
  test_vlan_ollama.py  — 本地 Ollama（默认 qwen3:8b），需要 Ollama 服务运行

运行方式：
  # 同时运行两种 provider（推荐，pytest 自动发现同目录下所有 test_*.py）
  GITHUB_TOKEN=ghp_xxx OLLAMA_MODEL=qwen3:8b PYTHONPATH=src/main/python \\
    venv/bin/python3 -m pytest tests/vlan-policy-test/validation/ -v -s

  # 只运行 GitHub
  GITHUB_TOKEN=ghp_xxx PYTHONPATH=src/main/python \\
    venv/bin/python3 -m pytest tests/vlan-policy-test/validation/test_vlan_github.py -v -s

  # 只运行 Ollama
  OLLAMA_MODEL=qwen3:8b PYTHONPATH=src/main/python \\
    venv/bin/python3 -m pytest tests/vlan-policy-test/validation/test_vlan_ollama.py -v -s

  # 通过一键脚本运行 Ollama 测试（自动启动服务/拉取模型）
  ./tests/vlan-policy-test/validation/run_ollama_test.sh qwen3:8b

环境变量：
  GITHUB_TOKEN     — GitHub PAT，用于 GitHub Models 认证
  OLLAMA_MODEL     — Ollama 模型名，默认 qwen3:8b
  OLLAMA_BASE_URL  — Ollama 服务地址，默认 http://localhost:11434/v1
  OLLAMA_API_KEY   — Ollama API Key（本地无认证时可不设置）

两种 provider 的调用接口完全一致（create_llm_client / client.chat），
只有认证方式不同，业务代码对 provider 完全透明。
"""
# 本文件为说明性入口，实际测试在 test_vlan_github.py 和 test_vlan_ollama.py
