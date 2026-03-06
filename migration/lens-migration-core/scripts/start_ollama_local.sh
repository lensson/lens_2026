#!/usr/bin/env bash
# =============================================================================
# start_ollama_local.sh — 以优化参数重启本地 Ollama（CPU 推理专用）
#
# 本机配置：Intel Xeon E5-2680 v3 @ 2.50GHz，16 核，54GB RAM，无 GPU
# 优化方向：CPU 线程数、模型常驻内存、并发控制
#
# 硬件详情与模型选型建议：doc/migration/HARDWARE_AND_MODEL_GUIDE.md（项目根目录）
#
# 运行：
#   bash scripts/start_ollama_local.sh
#   bash scripts/start_ollama_local.sh --preload    # 同时预加载模型到内存
# =============================================================================

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# 加载 .env.test 获取模型名
ENV_FILE="$PROJECT_DIR/.env.test"
LOCAL_MODEL="qwen2.5-coder:3b"
if [[ -f "$ENV_FILE" ]]; then
    v=$(grep "^OLLAMA_LOCAL_MODEL=" "$ENV_FILE" | cut -d= -f2 | tr -d '"' | tr -d "'")
    [[ -n "$v" ]] && LOCAL_MODEL="$v"
fi

echo "=================================================="
echo " 本地 Ollama CPU 优化启动"
echo " 模型: $LOCAL_MODEL"
echo " CPU:  Intel Xeon E5-2680 v3 @ 2.50GHz, 16 核"
echo " RAM:  54GB"
echo " 注意：本机无 GPU，推理速度较慢（~30s/次）"
echo " 建议：OLLAMA_TARGET=remote 使用远程 RTX 4090"
echo "=================================================="

# ── 停止旧进程 ────────────────────────────────────────────
OLD_PID=$(pgrep -f "ollama serve" 2>/dev/null || true)
if [[ -n "$OLD_PID" ]]; then
    echo "[INFO] 停止旧 Ollama 进程 (pid=$OLD_PID)..."
    kill "$OLD_PID" 2>/dev/null || true
    sleep 2
fi

# ── 优化环境变量说明 ──────────────────────────────────────
# OLLAMA_NUM_THREAD    : 使用全部 16 核（默认只用一半）
# OLLAMA_KEEP_ALIVE    : 模型常驻内存 24h（默认 5min 后卸载，下次冷加载很慢）
# OLLAMA_NUM_PARALLEL  : 并发请求数=1（单用户开发场景，减少内存竞争）
# OLLAMA_MAX_LOADED_MODELS: 只保留 1 个模型在内存（节省 RAM）
# OLLAMA_FLASH_ATTENTION: 启用 Flash Attention（若支持，可降低显存/内存占用）

export OLLAMA_NUM_THREAD=16
export OLLAMA_KEEP_ALIVE=24h
export OLLAMA_NUM_PARALLEL=1
export OLLAMA_MAX_LOADED_MODELS=1
export OLLAMA_HOST=127.0.0.1:11434

echo "[INFO] 启动参数:"
echo "  OLLAMA_NUM_THREAD     = $OLLAMA_NUM_THREAD  (全部 CPU 核心)"
echo "  OLLAMA_KEEP_ALIVE     = $OLLAMA_KEEP_ALIVE   (模型常驻内存，避免冷加载)"
echo "  OLLAMA_NUM_PARALLEL   = $OLLAMA_NUM_PARALLEL     (单并发，减少内存竞争)"
echo "  OLLAMA_MAX_LOADED_MODELS = $OLLAMA_MAX_LOADED_MODELS  (只保留1个模型)"
echo ""

# ── 后台启动 ─────────────────────────────────────────────
nohup ollama serve > /tmp/ollama_local.log 2>&1 &
NEW_PID=$!
echo "[INFO] Ollama 已启动 (pid=$NEW_PID)，日志: /tmp/ollama_local.log"
sleep 3

# ── 验证启动 ─────────────────────────────────────────────
if curl -s --max-time 2 http://localhost:11434/ &>/dev/null; then
    echo "[INFO] ✅ Ollama 服务就绪"
else
    echo "[ERROR] ❌ Ollama 启动失败，查看日志: cat /tmp/ollama_local.log"
    exit 1
fi

# ── 可选：预加载模型 ──────────────────────────────────────
if [[ "$1" == "--preload" ]]; then
    # 先检查模型是否已存在
    if ! ollama list 2>/dev/null | grep -q "${LOCAL_MODEL%%:*}"; then
        echo "[WARN] 模型 $LOCAL_MODEL 未找到，尝试拉取..."
        if ! ollama pull "$LOCAL_MODEL" 2>&1; then
            echo "[ERROR] 拉取失败（网络不通？）"
            echo "[INFO]  备选方案: OLLAMA_TARGET=remote 使用 10.99.79.20 的 RTX 4090"
            exit 1
        fi
    fi
    echo ""
    echo "[INFO] 预加载模型 $LOCAL_MODEL 到内存（keep_alive=24h）..."
    curl -s http://localhost:11434/api/generate \
        -d "{\"model\": \"$LOCAL_MODEL\", \"prompt\": \"hi\", \"stream\": false, \"keep_alive\": \"86400\"}" \
        > /dev/null
    echo "[INFO] ✅ 模型已加载到内存"
    echo "[INFO] 当前运行模型:"
    ollama ps
fi

echo ""
echo "=================================================="
echo " ✅ 本地 Ollama 已就绪"
echo " 停止: kill \$(pgrep -f 'ollama serve')"
echo " 日志: tail -f /tmp/ollama_local.log"
echo " 预加载: bash scripts/start_ollama_local.sh --preload"
echo "=================================================="

