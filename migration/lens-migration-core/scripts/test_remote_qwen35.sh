#!/usr/bin/env bash
# test_remote_qwen35.sh
# 监控远端 GPU 资源，同时测试 qwen3.5:35b 连接和 chat
# 用法：bash scripts/test_remote_qwen35.sh

set -euo pipefail

REMOTE_HOST="10.99.79.20"
REMOTE_USER="air"
REMOTE_PASS="air@2026"
TUNNEL_PORT="11435"
MODEL="qwen3.5:35b"

SSH="sshpass -p ${REMOTE_PASS} ssh -o StrictHostKeyChecking=no ${REMOTE_USER}@${REMOTE_HOST}"

echo "============================================================"
echo "  远端 qwen3.5:35b 测试 + GPU 监控"
echo "  Remote: ${REMOTE_HOST}  Tunnel: localhost:${TUNNEL_PORT}"
echo "============================================================"

# 1. 测试前 GPU 状态
echo ""
echo "── [1] 测试前 GPU 状态 ─────────────────────────────────────"
$SSH "nvidia-smi --query-gpu=name,memory.used,memory.free,utilization.gpu,temperature.gpu \
  --format=csv,noheader"

# 2. 确认 ollama 服务和模型
echo ""
echo "── [2] Ollama 服务 & 模型列表 ──────────────────────────────"
$SSH "ollama list"

# 3. 发起 chat（think=false，简短问题）
echo ""
echo "── [3] Chat 测试（think=false）────────────────────────────"
echo "    问题：用一句话解释 XSLT 是什么"
CHAT_RESULT=$($SSH "curl -s -X POST http://localhost:11434/api/chat \
  -H 'Content-Type: application/json' \
  -d '{\"model\":\"${MODEL}\",\"think\":false,\"stream\":false,\
\"messages\":[{\"role\":\"user\",\"content\":\"用一句话解释 XSLT 是什么\"}]}'" 2>/dev/null)

echo "    原始响应（部分）："
echo "${CHAT_RESULT}" | python3 -c "
import sys, json
d = json.load(sys.stdin)
msg = d.get('message', {})
content = msg.get('content', '(空)')
total_ns = d.get('total_duration', 0)
eval_cnt = d.get('eval_count', 0)
prompt_cnt = d.get('prompt_eval_count', 0)
load_ns  = d.get('load_duration', 0)
total_s  = total_ns / 1e9
load_s   = load_ns  / 1e9
tps = eval_cnt / total_s if total_s > 0 else 0
print(f'    内容   : {content[:300]}')
print(f'    tokens : prompt={prompt_cnt}  output={eval_cnt}  total={prompt_cnt+eval_cnt}')
print(f'    耗时   : 总计={total_s:.1f}s  模型加载={load_s:.1f}s')
print(f'    吞吐量 : {tps:.1f} tokens/s')
" 2>/dev/null || echo "    [解析失败] 原始：${CHAT_RESULT:0:200}"

# 4. chat 过程中 GPU 状态（模型应已加载）
echo ""
echo "── [4] Chat 后 GPU 状态（模型已加载）──────────────────────"
$SSH "nvidia-smi --query-gpu=name,memory.used,memory.free,utilization.gpu,temperature.gpu \
  --format=csv,noheader"
$SSH "ollama ps"

# 5. 通过隧道用 Python llm_client 验证
echo ""
echo "── [5] Python llm_client 验证（走本地隧道 :${TUNNEL_PORT}）──"
cd "$(dirname "$0")/.."
if [ -f ".env.test" ]; then
  set -o allexport
  # shellcheck disable=SC1091
  source <(grep -v '^#' .env.test | grep -v '^$')
  set +o allexport
fi

venv/bin/python3 - <<'PYEOF'
import sys, time, os
sys.path.insert(0, "src/main/python")
from lens_migration.ai.llm_client import create_llm_client

url   = os.environ.get("OLLAMA_REMOTE_URL", "http://localhost:11435/v1")
model = os.environ.get("OLLAMA_REMOTE_MODEL", "qwen3.5:35b")

print(f"    model={model}  url={url}")
client = create_llm_client("ollama", model=model, base_url=url)

t0 = time.time()
resp = client.chat("用一句话解释什么是 XSLT，不超过 30 字。",
                   system_prompt="你是 XML 专家，请简洁回答。")
elapsed = (time.time() - t0) * 1000

print(f"    响应  : {resp.content}")
print(f"    tokens: in={resp.input_tokens}  out={resp.output_tokens}  total={resp.total_tokens}")
print(f"    延迟  : {elapsed:.0f}ms")
tps = resp.output_tokens / (elapsed / 1000) if elapsed > 0 else 0
print(f"    吞吐量: {tps:.1f} tokens/s")

assert resp.content, "ERROR: 响应内容为空！"
print("    ✅ llm_client 调用成功")
PYEOF

# 6. 测试后 GPU 状态
echo ""
echo "── [6] 测试后 GPU 最终状态 ─────────────────────────────────"
$SSH "nvidia-smi --query-gpu=name,memory.used,memory.free,utilization.gpu,temperature.gpu \
  --format=csv,noheader"

echo ""
echo "============================================================"
echo "  ✅ 全部测试完成"
echo "============================================================"

