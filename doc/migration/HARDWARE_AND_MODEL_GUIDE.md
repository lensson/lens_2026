# 硬件配置与模型选型指南

> 更新时间：2026-03-07

---

## 1. 硬件概况

### 本地机器（开发机）

| 项目 | 配置 |
|---|---|
| **主机名** | host-192-168-0-5 |
| **CPU** | Intel Xeon E5-2680 v3 @ 2.50GHz × 2 socket，共 16 核 |
| **RAM** | 54GB（可用 ~36GB） |
| **GPU** | ❌ 无 |
| **推理方式** | CPU only（100% CPU） |
| **Ollama 端口** | `localhost:11434` |
| **Ollama 版本** | 0.17.5 |

### 远程机器（GPU 服务器）

| 项目 | 配置 |
|---|---|
| **IP** | 10.99.79.20 |
| **CPU** | Intel Core i9-14900KF，16 核 |
| **RAM** | 30GB（可用 ~28GB） |
| **GPU** | ✅ NVIDIA GeForce RTX 4090 |
| **VRAM** | 24GB（空闲 ~23.5GB） |
| **推理方式** | GPU（CUDA） |
| **GPU Persistence Mode** | ✅ **已启用**（`nvidia-smi -pm 1`，GPU 常驻，消除冷启动开销） |
| **Ollama 端口** | `localhost:11434`（通过 SSH 隧道映射到本地 `localhost:11435`） |
| **SSH 用户** | `air` |

---

## 2. 实测性能

### 2.1 简单 Chat 性能（2026-03-07）

测试问题：`请用中文一句话回答：XSLT 是什么？不要超过 20 字。`

| Provider | Model | 冷加载延迟 | 热推理延迟 | 吞吐量（热） | 备注 |
|---|---|---|---|---|---|
| **GitHub Models** | gpt-4o-mini | — | ~2-3.8s | — | 云端 API，受网络波动 |
| **Ollama 本地** | qwen2.5-coder:3b | ~24-37s | ~2.5-3.5s | 2.5 tokens/s | CPU only |
| **Ollama 远程** | qwen2.5-coder:14b | ~1.9s | **321ms** | **196 tokens/s** | RTX 4090 |
| **Ollama 远程** | qwen3.5:35b | ~6.5s | **784ms** | **40 tokens/s** | RTX 4090，思考模型 |

性能基准（较长问题，`test_performance_benchmark`）：

| 模型 | 总延迟 | Tokens | 吞吐量 |
|---|---|---|---|
| qwen2.5-coder:14b | **473ms** | 93 | **196 tokens/s** 🚀 |
| qwen3.5:35b | **1007ms** | 101 | **100 tokens/s** |

### 2.2 模型切换开销实测（2026-03-07）

> 场景：RTX 4090 同时安装两个模型，交替调用，测量切换损耗。

```
Round 1  qwen3.5:35b       冷加载：6.53s  推理：1.12s  总计：7.65s  tps=40.2
Round 2  qwen2.5-coder:14b 切换加载：1.91s  推理：0.39s  总计：2.30s  tps=87.5
Round 3  qwen3.5:35b       切换加载：6.82s  推理：0.81s  总计：7.63s  tps=34.5
Round 4  qwen3.5:35b       热推理：0.10s    推理：0.77s  总计：0.87s  tps=37.5 ← 基准
```

**结论：**
- **切换本身有一次性等待**：35b 切换约 **6.8s**，14b 切换约 **1.9s**（体积小）
- **切换后连续调用无额外损失**：热推理加载时间仅 0.10s
- **两模型共存不影响推理 tps**（切换前后 tps 相同）
- **同一 case 固定用一个模型**：切换开销可忽略
- **推荐策略**：代码/XSLT 生成任务用 `qwen2.5-coder:14b`（速度快 2x），复杂推理/质量优先用 `qwen3.5:35b`

### 2.3 两模型完整 AI Case 对比（2026-03-07）

> 相同测试集：`TestRemoteOllama`（7项）+ `TestMigrationEngineOllamaLive`（1项）+ `TestOllamaLiveIntegration`（2项）= 共 10 项

| 指标 | qwen2.5-coder:14b | qwen3.5:35b | 差异 |
|---|---|---|---|
| **simple_chat 延迟** | **764ms** | 7471ms（含冷加载） | 35b 慢 **9.8x** |
| **simple_chat 延迟（热）** | **390ms** | **916ms** | 35b 慢 2.4x |
| performance_benchmark 延迟 | **499ms** | 1101ms | 35b 慢 2.2x |
| performance_benchmark 吞吐 | **196 t/s** | **100 t/s** | 14b 快 2x |
| **XSLT 生成耗时（MigrationEngine）** | **5744ms** | 14645ms | 35b 慢 2.6x |
| XSLT 生成 tokens | 2327 | 2478（多 6%） | 35b 更详细 |
| **XSLT 生成耗时（OllamaLive）** | **5844ms** | 14716ms | 35b 慢 2.5x |
| XSLT 生成轮次 | **1 轮** | **1 轮** | 持平 ✅ |
| XSLT syntax 验证 | ✅ pass | ✅ pass | 持平 ✅ |
| XSLT transform 验证 | ✅ pass | ✅ pass | 持平 ✅ |
| 通过测试数 | **10/10** | **10/10** | 持平 ✅ |
| **套件总耗时** | **15.1s** | 41.1s | 35b 慢 2.7x |

**关键结论：**
- **质量持平**：两个模型均 1 轮完成 XSLT 生成，syntax + transform 全部验证通过，无需多轮迭代
- **速度差距**：14b 整体快 **2.5-2.7x**，XSLT 生成 5.7s vs 14.6s
- **tokens 差**：35b 多生成约 151 tokens（+6%），内容更详尽但不影响正确性
- **冷加载影响**：35b simple_chat 首次含 6.5s 冷加载（7.5s → 热加载后降至 916ms）

---

## 3. 本地 Ollama 优化参数

已通过 systemd 写入 `/etc/systemd/system/ollama.service`：

```ini
Environment="OLLAMA_NUM_THREAD=16"        # 用满全部 16 核（默认只用一半）
Environment="OLLAMA_KEEP_ALIVE=24h"       # 模型常驻内存，避免每次冷加载
Environment="OLLAMA_NUM_PARALLEL=1"       # 单并发，减少内存竞争
Environment="OLLAMA_MAX_LOADED_MODELS=1"  # 只保留 1 个模型，节省 RAM
```

验证命令：

```bash
sudo systemctl show ollama --property=Environment | tr ' ' '\n' | grep OLLAMA
```

---

## 4. 模型选型建议

### 4.1 本地（CPU，无 GPU）

本地 CPU 推理瓶颈是**内存带宽**，模型越大越慢，建议控制在 **2-5GB** 以内。

| 模型 | 大小 | 预估延迟 | 能力 | 推荐度 |
|---|---|---|---|---|
| `qwen2.5-coder:3b` | 1.9GB | ~25-30s | 代码/XML 专项优化 | ⭐⭐⭐ **当前选择，已验证** |
| `deepseek-r1:1.5b` | 1.1GB | ~15-20s | 推理/代码，极轻量 | ⭐⭐ 可尝试（质量稍弱） |
| `qwen2.5-coder:7b` | 4.7GB | ~60-80s | 更强代码理解 | ⭐ 较慢，不推荐日常用 |

**结论：维持 `qwen2.5-coder:3b`，性价比最优。**

---

### 4.2 远程（RTX 4090，24GB VRAM）

GPU 推理瓶颈是 **VRAM 容量**，24GB 可同时在磁盘存多个模型，但同一时刻只能加载一个。

| 模型 | 磁盘大小 | VRAM 占用 | 热推理延迟 | 吞吐量 | 能力 | 状态 |
|---|---|---|---|---|---|---|
| `qwen2.5-coder:14b` | 9 GB | ~9.5 GB | **~320ms** | **196 t/s** | 代码/XML 专项，速度最快 | ✅ **已安装，推荐日常** |
| `qwen3.5:35b` | 23 GB | ~23.7 GB | **~780ms** | **40 t/s** | 通用推理，质量更高，think=false | ✅ **已安装，推荐质量优先** |
| `qwen2.5-coder:32b` | ~20 GB | ~20 GB | ~1-2s | ~60 t/s | 顶级代码能力 | 🏆 可选，VRAM 仅够装一个 |
| `deepseek-r1:14b` | ~9 GB | ~9 GB | ~1s | ~80 t/s | 强推理 | ⭐⭐ 可选 |

**当前已安装（磁盘）：**
```
qwen3.5:35b          23 GB   ← 质量优先
qwen2.5-coder:14b     9 GB   ← 速度优先
合计：32 GB / 磁盘剩余 903 GB，完全充裕
```

**VRAM 同时加载限制：** `qwen3.5:35b`（23.7GB）+ `qwen2.5-coder:14b`（9.5GB）= 33.2GB > 24GB，
**只能二选一在显存中**，切换时有 1.9-6.8s 等待（见 §2.2）。

**推荐使用策略：**
- XSLT 生成、代码任务 → `qwen2.5-coder:14b`（快 2x，196 t/s）
- 复杂推理、高质量要求 → `qwen3.5:35b`（100 t/s，think=false）

---

## 5. 切换方式

修改 `migration/lens-migration-core/.env.test` 中的 `OLLAMA_REMOTE_MODEL` 一行即可：

```bash
OLLAMA_REMOTE_MODEL=qwen2.5-coder:14b   # 速度优先（默认，196 t/s）
OLLAMA_REMOTE_MODEL=qwen3.5:35b         # 质量优先（100 t/s，think=false）
```

或运行时临时传参：

```bash
OLLAMA_REMOTE_MODEL=qwen3.5:35b venv/bin/python3 -m pytest tests/ai/ -v -s -k Remote
```

SSH 隧道由 `conftest.py` 自动管理，无需手动建立。

---

## 6. 连接测试

```bash
cd migration/lens-migration-core

# 测试所有 provider（GitHub + 本地 + 远端）
venv/bin/python3 -m pytest tests/ai/test_api_connectivity.py -v -s

# 只测试远端 Ollama（含性能基准）
venv/bin/python3 -m pytest tests/ai/test_api_connectivity.py -v -s -k RemoteOllama

# 切换基准测试脚本（直接在远端测量切换开销）
bash scripts/test_remote_qwen35.sh
```
