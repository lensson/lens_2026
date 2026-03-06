# 硬件配置与模型选型指南

> 更新时间：2026-03-06

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

### 2.1 GPU Persistence Mode 启用后（2026-03-06，当前）

测试问题：`请用中文一句话回答：XSLT 是什么？不要超过 20 字。`

| Provider | Model | 延迟（热加载） | Tokens | 吞吐量 | 备注 |
|---|---|---|---|---|---|
| **GitHub Models** | gpt-4o-mini-2024-07-18 | **~3.8s** | 25+14=39 | — | 云端 API，受网络波动影响 |
| **Ollama 本地** | qwen2.5-coder:3b | **~24.6s** | 47+14=61 | 2.5 tokens/s | CPU 推理 |
| **Ollama 远程** | qwen2.5-coder:14b | **~2.1s** | 47+28=75 | 36.2 tokens/s | GPU + Persistence Mode |

性能对比（三 Provider 同一问题，`test_performance_comparison`）：

```
🏆 #1  远端  qwen2.5-coder:14b      321ms   ← RTX 4090 + Persistence Mode
   #2  GitHub gpt-4o-mini          2029ms   ← 云端 API
   #3  本地  qwen2.5-coder:3b      2686ms   ← CPU（本地模型已热加载）
```

> ⚠️ 本地 qwen2.5-coder:3b 本次 2686ms 是因为模型已预热驻留内存（OLLAMA_KEEP_ALIVE=24h），
> 冷启动仍约 24-37s。

性能基准（`test_performance_benchmark`，较长问题）：

| 指标 | 值 |
|---|---|
| 模型 | qwen2.5-coder:14b（远端 RTX 4090） |
| 总延迟 | **473ms** |
| Tokens | 93 |
| **吞吐量** | **196.4 tokens/s** 🚀 |

### 2.2 启用前对比（2026-03-06 早）

| Provider | 延迟 | 吞吐量 |
|---|---|---|
| 远端 qwen2.5-coder:14b | ~1.9s (simple) / 499ms (benchmark) | 186.2 tokens/s |

**GPU Persistence Mode 效果：benchmark 吞吐量从 186.2 → 196.4 tokens/s（+5.5%）；**
**三方对比中本地模型热加载延迟从 23738ms → 2686ms（模型已常驻内存）。**

> **注**：本地冷加载约 24-37s，`OLLAMA_KEEP_ALIVE=24h` 生效后热加载约 2.5-3.5s。
> 远端 GPU Persistence Mode 峰值吞吐量达 **196 tokens/s**，约为本地 CPU 的 **78 倍**（热加载对比）。

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
| `qwen2.5:7b` | 4.7GB | ~60-80s | 通用能力 | ⭐ 较慢 |

**结论：维持 `qwen2.5-coder:3b`，性价比最优。**

---

### 4.2 远程（RTX 4090，24GB VRAM）

GPU 推理瓶颈是 **VRAM 容量**，24GB 空闲可装载非常大的模型。
针对本项目的 XSLT 生成任务（XML 结构理解 + 代码推理），专项代码模型效果优于通用模型。

| 模型 | VRAM 占用 | 预估延迟 | 能力 | 推荐度 |
|---|---|---|---|---|
| `qwen3.5:latest` (9.7B) | ~6GB | ~10-30s | 通用，支持 thinking（token 极多） | 已替换 |
| `qwen2.5-coder:14b` | ~9GB | **~2.1s** | 代码/XML 专项，已验证 196 tokens/s | ⭐⭐⭐ **当前选择，已验证** |
| `qwen2.5-coder:32b` | ~20GB | ~15-25s | 顶级代码能力，适合复杂 XSLT 生成 | 🏆 **最优选，24GB VRAM 可装** |
| `deepseek-r1:14b` | ~9GB | ~10-15s | 强推理，适合复杂逻辑分析 | ⭐⭐ 可选 |
| `deepseek-r1:32b` | ~20GB | ~20-30s | 极强推理 | ⭐⭐ 可选 |
| `qwen3:30b-a3b` | ~18GB | ~15-20s | MoE 架构，高效 | ⭐⭐ 可选 |

**结论：推荐升级到 `qwen2.5-coder:32b`（24GB VRAM 完全够用，XSLT 生成任务最优）。**

安装命令：

```bash
sshpass -p 'air@2026' ssh air@10.99.79.20 "ollama pull qwen2.5-coder:32b"
```

---

## 5. 切换方式

修改 `migration/lens-migration-core/.env.test` 中的 `OLLAMA_TARGET` 一行即可：

```bash
OLLAMA_TARGET=local    # 本地 qwen2.5-coder:3b（CPU，~30s）
OLLAMA_TARGET=remote   # 远端 qwen2.5-coder:14b（RTX 4090，~1.9s）默认
OLLAMA_TARGET=both     # 同时测试两台
```

SSH 隧道由 `conftest.py` 自动管理，无需手动建立。

---

## 6. 连接测试

```bash
cd migration/lens-migration-core

# 测试所有 provider（GitHub + 本地 + 远端）
venv/bin/python3 -m pytest tests/ai/test_api_connectivity.py -v -s

# 只测试 GitHub
venv/bin/python3 -m pytest tests/ai/test_api_connectivity.py -v -s -k GitHub

# 只测试本地 Ollama
venv/bin/python3 -m pytest tests/ai/test_api_connectivity.py -v -s -k LocalOllama

# 只测试远端 Ollama（含性能基准）
venv/bin/python3 -m pytest tests/ai/test_api_connectivity.py -v -s -k RemoteOllama
```
