#!/usr/bin/env bash
# =============================================================================
# run_live_tests.sh — 运行所有 Live Integration 测试
#
# 覆盖范围：
#   - tests/ai/          : GitHub Models + 本地 Ollama + 远端 Ollama 连通性与性能
#   - tests/vlan-policy-test/validation/ : vlan 策略生成 XSLT 验证
#
# 运行：
#   cd migration/lens-migration-core
#   bash scripts/run_live_tests.sh
#
# 前提：.env.test 中已配置 GITHUB_TOKEN、OLLAMA_TARGET 等变量
# =============================================================================
set -e
cd "$(dirname "$0")/.."
echo "=================================================="
echo " Live Integration Tests Runner"
echo "=================================================="
# 1. 加载 .env.test
if [[ -f .env.test ]]; then
    echo "[INFO] 加载 .env.test ..."
    while IFS= read -r line; do
        [[ -z "$line" || "$line" == \#* ]] && continue
        [[ "$line" != *=* ]] && continue
        key="${line%%=*}"
        val="${line#*=}"
        val="${val//\"/}"
        val="${val//\'/}"
        [[ -n "$key" && -z "${!key}" ]] && export "$key=$val"
    done < .env.test
else
    echo "[WARN] 未找到 .env.test，请先创建并填入 GITHUB_TOKEN 等配置"
fi
# 2. 检查 GitHub Token
if [[ -n "$GITHUB_TOKEN" ]]; then
    echo "[INFO] GITHUB_TOKEN: ${GITHUB_TOKEN:0:12}..."
else
    echo "[WARN] GITHUB_TOKEN 未设置，GitHub 测试将跳过"
fi
# 3. Ollama 目标（由 .env.test 中 OLLAMA_TARGET 控制）
OLLAMA_TARGET="${OLLAMA_TARGET:-remote}"
echo "[INFO] OLLAMA_TARGET: $OLLAMA_TARGET  (可选值: local / remote / both)"
# 检查本地 Ollama（仅 local/both 时）
if [[ "$OLLAMA_TARGET" == "local" || "$OLLAMA_TARGET" == "both" ]]; then
    LOCAL_MODEL="${OLLAMA_LOCAL_MODEL:-qwen2.5-coder:3b}"
    echo "[INFO] 本地模型: $LOCAL_MODEL"
    if ! curl -s --max-time 2 http://localhost:11434/ &>/dev/null; then
        echo "[WARN] 本地 Ollama 未运行，可用 scripts/start_ollama_local.sh 启动"
    else
        echo "[INFO] 本地 Ollama 服务已运行"
    fi
fi
# 检查远端隧道（仅 remote/both 时）
if [[ "$OLLAMA_TARGET" == "remote" || "$OLLAMA_TARGET" == "both" ]]; then
    REMOTE_MODEL="${OLLAMA_REMOTE_MODEL:-qwen2.5-coder:14b}"
    TUNNEL_PORT="${OLLAMA_TUNNEL_LOCAL_PORT:-11435}"
    echo "[INFO] 远端模型: $REMOTE_MODEL  (通过 localhost:$TUNNEL_PORT)"
    if ! curl -s --max-time 2 "http://localhost:$TUNNEL_PORT/" &>/dev/null; then
        echo "[WARN] SSH 隧道未建立，conftest.py 会自动尝试建立"
    else
        echo "[INFO] SSH 隧道已就绪"
    fi
fi
echo ""
echo "=================================================="
echo " 运行 tests/ai/ (GitHub + 本地 Ollama + 远端 Ollama)"
echo "=================================================="
venv/bin/python3 -m pytest tests/ai/ -v -s --tb=short
echo ""
echo "=================================================="
echo " 运行 vlan-policy-test (GitHub + Ollama)"
echo "=================================================="
venv/bin/python3 -m pytest tests/vlan-policy-test/validation/ -v -s --tb=short
echo ""
echo "=========================================="
echo " All tests done"
echo "=========================================="
