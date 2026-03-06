#!/usr/bin/env bash
# =============================================================================
# run_ollama_test.sh — 本地 Ollama 模型 VLAN 迁移 XSLT 生成测试
#
# 用法：
#   ./run_ollama_test.sh                          # 默认 qwen3:8b
#   ./run_ollama_test.sh qwen3:4b                 # Qwen3 精简版（~2.5GB）
#   ./run_ollama_test.sh qwen2.5-coder:7b         # 代码专用（~4.7GB）
#
# Ollama 模型说明：
#   qwen3:8b          — Qwen 最新版（2025.04 发布），~5GB，默认推荐
#   qwen3:4b          — Qwen3 精简，~2.5GB，速度快
#   qwen2.5-coder:7b  — 代码专用，~4.7GB，XSLT生成准确
#   qwen2.5-coder:3b  — 最小版，~2GB，CPU可运行
#   注意：Ollama 上没有 "qwen3.5"，最新版就是 qwen3
#   完整列表：https://ollama.com/library
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CORE_DIR="$(cd "${SCRIPT_DIR}/../../../" && pwd)"

MODEL="${1:-${OLLAMA_MODEL:-qwen3:8b}}"

echo "=================================================="
echo " Ollama VLAN XSLT 生成测试"
echo " 模型: ${MODEL}"
echo "=================================================="

if ! command -v ollama &>/dev/null; then
    echo "[ERROR] ollama 未安装，请先运行："
    echo "  curl -fsSL https://ollama.com/install.sh | sh"
    exit 1
fi

if ! curl -s --max-time 2 http://localhost:11434/ &>/dev/null; then
    echo "[INFO] 启动 Ollama 服务..."
    ollama serve &>/tmp/ollama.log &
    sleep 4
    if ! curl -s --max-time 2 http://localhost:11434/ &>/dev/null; then
        echo "[ERROR] Ollama 服务启动失败，查看: cat /tmp/ollama.log"
        exit 1
    fi
    echo "[INFO] Ollama 服务已就绪"
else
    echo "[INFO] Ollama 服务已运行"
fi

MODEL_BASE="${MODEL%:*}"
MODEL_EXISTS=$(ollama list 2>/dev/null | grep -c "${MODEL_BASE}" || true)
if [[ "$MODEL_EXISTS" -eq 0 ]]; then
    echo "[INFO] 拉取模型 ${MODEL}（首次约需几分钟）..."
    ollama pull "${MODEL}"
else
    echo "[INFO] 模型 ${MODEL} 已存在，跳过拉取"
fi

echo ""
echo "[INFO] 运行 Ollama 测试（模型=${MODEL}）..."
cd "${CORE_DIR}"

OLLAMA_MODEL="${MODEL}" \
PYTHONPATH=src/main/python \
venv/bin/python3 -m pytest \
    tests/vlan-policy-test/validation/test_ai_vlan_policy.py \
    -v -s -k "Ollama" \
    --tb=short

echo ""
echo "[INFO] 生成的 XSLT 文件："
ls -lh tests/vlan-policy-test/output/ollama-*.xslt 2>/dev/null || echo "  (暂无)"

