# 硬件配置与模型选型指南

> 更新时间：2026-03-07（全量测试 133 项）

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

### 2.1 简单 Chat 性能（2026-03-07，全量测试）

测试问题：`请用中文一句话回答：XSLT 是什么？不要超过 20 字。`

| Provider | Model | 冷加载延迟 | 热推理延迟 | 吞吐量（热） | 备注 |
|---|---|---|---|---|---|
| **GitHub Models** | gpt-4o-mini | — | ~2-4s | — | 云端 API，受网络波动 |
| **Ollama 本地** | qwen2.5-coder:3b | ~24-37s | ~2.5-35s | 1.7 tokens/s | CPU only |
| **Ollama 远程** | qwen2.5-coder:14b | ~2.0s | **395ms** | — | RTX 4090 |
| **Ollama 远程** | qwen3.5:35b | ~7.0s | **853ms** | — | RTX 4090，think=false |

性能基准（较长问题，`test_performance_benchmark`）：

| 模型 | 总延迟 | Tokens | 吞吐量 |
|---|---|---|---|
| qwen2.5-coder:14b | **471ms** | 94 | **199.4 tokens/s** 🚀 |
| qwen3.5:35b | **922ms** | 97 | **105.2 tokens/s** |

三 Provider 延迟对比（`test_performance_comparison`，热推理）：

| 排名 | Provider | 延迟 | Tokens |
|---|---|---|---|
| 🥇 | 远端 qwen2.5-coder:14b | **340ms** | 67 |
| 🥈 | GitHub gpt-4o-mini | ~1965-4112ms | 53 |
| 🥉 | 本地 qwen2.5-coder:3b | ~9000-34000ms | 58 |

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

### 2.3 全量 AI Case 对比（2026-03-07，133 项）

> 全量：`TestRemoteOllama`(7) + `TestThreeProviderComparison`(2) + `TestMigrationEngineOllamaLive`(1) + `TestOllamaLiveIntegration`(2) + `TestQwenLiveIntegration`(3,skip) + `TestSimpleClassifierE2E`(21) + `TestVlanOllama`(21) + `TestVlanGitHub`(20) + 单元测试(56)

**全量测试结果：14b 跑 133 项（130 passed, 3 skipped），35b 跑 57 Ollama 项（54 passed, 3 skipped）**

| 指标 | GitHub gpt-4o-mini | qwen2.5-coder:14b | qwen3.5:35b | 备注 |
|---|---|---|---|---|
| **simple_chat（冷加载）** | — | 2039ms | 6998ms | 首次加载含切换 |
| **simple_chat（热）** | ~1965-4112ms | **395ms** | **853ms** | 热推理 |
| **performance_benchmark** | — | **471ms / 199 t/s** | 922ms / 105 t/s | — |
| **phase2 XSLT 生成** | 5376ms / 2300 tok | 5859ms / 2337 tok | 13281ms / 2478 tok | MigrationEngine |
| **vlan XSLT 生成** | 5086ms / 2848 tok | 5305ms / 2975 tok | 11896ms / 3191 tok | 热加载 |
| **vlan 吞吐量** | 560 t/s | 561 t/s | 268 t/s | — |
| **simple-classifier** | ✅ 21/21 | ✅ 21/21 | ✅ 21/21 | 规则引擎，无 AI |
| **XSLT 生成轮次** | 1 轮 | 1 轮 | 1 轮 | 均首轮通过 |
| **4 条 vlan 规则** | ✅ | ✅ | ✅ | — |

**关键结论（全量）：**
- **全量 133 项：14b 130 passed / 3 skipped，0 failed** ✅
- **35b Ollama 57 项：54 passed / 3 skipped，0 failed** ✅（3 skipped 均为 Qwen Cloud API，未配置 KEY）
- **速度**：14b benchmark **199 t/s**，35b **105 t/s**，14b 快 **1.9x**
- **vlan 生成**：14b（5.3s）vs 35b（11.9s），14b 快 **2.2x**；35b vlan 因热加载已无冷启动开销
- **质量**：三模型均 1 轮完成，所有语义验证通过，tokens 差异 ≤7%

### 2.4 vlan-policy-test 三模型对比（2026-03-07，全量）

> 测试集：`TestVlanOllama`（21 项）+ `TestVlanGitHub`（20 项）= 共 41 项

| 指标 | GitHub gpt-4o-mini | qwen2.5-coder:14b | qwen3.5:35b |
|---|---|---|---|
| **XSLT 生成延迟** | **5086ms** | **5305ms** | 11896ms（热加载）|
| **吞吐量** | **560 t/s** | **561 t/s** | 268 t/s |
| tokens | 2848 | 2975 | 3191（最详细）|
| 生成轮次 | **1 轮** | **1 轮** | **1 轮** |
| 4 条规则全通过 | ✅ | ✅ | ✅ |
| 通过测试数 | 20/20 | 21/21 | 21/21 |
| **套件总耗时** | — | **21.9s** | ~35s（热） |

> ℹ️ 35b vlan 延迟 **11.9s**（热加载，本轮模型已预热），较上次 47.8s（冷加载）大幅缩短。

**结论：**
- **质量完全一致**：三模型均 1 轮完成，4 条业务规则 100% 通过
- **GitHub ≈ 14b**（~5s，~560 t/s），速度相当；**35b 慢 2.2x**（热加载）
- **35b tokens 最多**（多 7%），内容更丰富，验证结果无差异
- **日常开发首选 14b**；需要更高推理质量时换 35b

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
