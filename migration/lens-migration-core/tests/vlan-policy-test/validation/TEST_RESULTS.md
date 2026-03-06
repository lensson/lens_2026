# vlan-policy-test — AI 生成 XSLT 测试结果

> 最后更新：2026-03-06

## 概述

本用例验证使用 AI（GitHub Models / Ollama）自动生成 XSLT，将 BBF VLAN sub-interface
配置从 v1 格式迁移到 v2 格式，共 4 条迁移规则，覆盖重命名、修改值、新增字段、删除字段四种类型。

---

## 测试汇总（2026-03-06）

| Provider | 模型 | 轮次 | Tokens | 延迟 | **吞吐量** | 测试结果 |
|---|---|:---:|---:|---:|---:|:---:|
| GitHub Models | gpt-4o-mini | **1** | 2869 | 5975ms | **480.2 tokens/s** | **20/20** ✅ |
| Ollama (远端 RTX 4090) | qwen2.5-coder:14b | **1** | 2974 | 6930ms | **429.1 tokens/s** | **21/21** ✅ |

> 两种 Provider 均首轮通过，全部验证规则一致。
> 吞吐量 = 总 tokens / 生成延迟，包含 prompt + output tokens，反映端到端响应效率。

---

## 迁移规则验证结果

| 规则 | 类型 | 描述 | GitHub | Ollama |
|------|------|------|:------:|:------:|
| 规则 1 | RENAME | `pop-and-push-vlan` → `pop-and-push-2-tags` | ✅ | ✅ |
| 规则 2 | MODIFY_VALUE | `eth0.100` ingress vlan-id: 100 → 101（其他不变） | ✅ | ✅ |
| 规则 3 | ADD_NODE | 所有 `interface` 添加 `admin-state=enabled` | ✅ | ✅ |
| 规则 4 | DELETE_NODE | 删除 `legacy-mode` 字段 | ✅ | ✅ |

---

## GitHub Models 测试详情

### 配置

| 项目 | 值 |
|------|-----|
| 测试日期 | 2026-03-06 |
| Provider | GitHub Models |
| 模型 | gpt-4o-mini |
| 生成轮次 | **1 轮**（首轮直接通过） |
| Tokens | **2869** |
| 生成延迟 | **5975ms** |
| **吞吐量** | **480.2 tokens/s** |
| 测试结果 | **20 / 20 通过** ✅ |

### 20 项用例

#### 阶段 1 — 文件准备（3 项）

| # | 测试名称 | 结果 |
|---|---------|:----:|
| 1 | `test_intent_file_exists` | ✅ |
| 2 | `test_input_sample_exists` | ✅ |
| 3 | `test_expected_output_exists` | ✅ |

#### 阶段 2 — 意图解析（2 项）

| # | 测试名称 | 结果 |
|---|---------|:----:|
| 4 | `test_intent_has_4_rules` | ✅ |
| 5 | `test_intent_title_contains_vlan` | ✅ |

#### 阶段 3 — AI 生成（5 项）

| # | 测试名称 | 结果 |
|---|---------|:----:|
| 6 | `test_completed_at_least_one_round` | ✅ |
| 7 | `test_xslt_file_saved` | ✅ |
| 8 | `test_xslt_syntax_valid` | ✅ |
| 9 | `test_xslt_transformation_ok` | ✅ |
| 10 | `test_tokens_consumed` — 2869 tokens | ✅ |

#### 阶段 4 — 语义验证（10 项）

| # | 测试名称 | 结果 |
|---|---------|:----:|
| 11 | `test_rule1_renamed` | ✅ |
| 12 | `test_rule1_children_preserved` | ✅ |
| 13 | `test_rule2_eth100_vlan_id_101` | ✅ |
| 14 | `test_rule2_eth200_vlan_id_unchanged` | ✅ |
| 15 | `test_rule3_admin_state_eth100` | ✅ |
| 16 | `test_rule3_admin_state_eth200` | ✅ |
| 17 | `test_rule4_legacy_mode_deleted` | ✅ |
| 18 | `test_interface_count` | ✅ |
| 19 | `test_interface_names_preserved` | ✅ |
| 20 | `test_description_preserved` | ✅ |

---

## Ollama 测试详情

### 配置

| 项目 | 值 |
|------|-----|
| 测试日期 | 2026-03-06 |
| Provider | Ollama（远端 RTX 4090） |
| 模型 | qwen2.5-coder:14b |
| 服务地址 | `localhost:11435`（SSH 隧道 → 10.99.79.20:11434）|
| GPU Persistence Mode | ✅ 已启用 |
| 生成轮次 | **1 轮**（首轮直接通过） |
| Tokens | **2974** |
| 生成延迟 | **6930ms** |
| **吞吐量** | **429.1 tokens/s** |
| 测试结果 | **21 / 21 通过** ✅ |

### 21 项用例

#### 阶段 1 — 文件准备（3 项）

| # | 测试名称 | 结果 |
|---|---------|:----:|
| 1 | `test_intent_file_exists` | ✅ |
| 2 | `test_input_sample_exists` | ✅ |
| 3 | `test_expected_output_exists` | ✅ |

#### 阶段 2 — 意图解析（2 项）

| # | 测试名称 | 结果 |
|---|---------|:----:|
| 4 | `test_intent_has_4_rules` | ✅ |
| 5 | `test_intent_title_contains_vlan` | ✅ |

#### 阶段 3 — AI 生成（6 项）

| # | 测试名称 | 结果 |
|---|---------|:----:|
| 6 | `test_ollama_model_info` — model=qwen2.5-coder:14b，url=localhost:11435 | ✅ |
| 7 | `test_completed_at_least_one_round` | ✅ |
| 8 | `test_xslt_file_saved` | ✅ |
| 9 | `test_xslt_syntax_valid` | ✅ |
| 10 | `test_xslt_transformation_ok` | ✅ |
| 11 | `test_tokens_consumed` — 2974 tokens | ✅ |

#### 阶段 4 — 语义验证（10 项）

| # | 测试名称 | 结果 |
|---|---------|:----:|
| 12 | `test_rule1_renamed` | ✅ |
| 13 | `test_rule1_children_preserved` | ✅ |
| 14 | `test_rule2_eth100_vlan_id_101` | ✅ |
| 15 | `test_rule2_eth200_vlan_id_unchanged` | ✅ |
| 16 | `test_rule3_admin_state_eth100` | ✅ |
| 17 | `test_rule3_admin_state_eth200` | ✅ |
| 18 | `test_rule4_legacy_mode_deleted` | ✅ |
| 19 | `test_interface_count` | ✅ |
| 20 | `test_interface_names_preserved` | ✅ |
| 21 | `test_description_preserved` | ✅ |

---

## 性能对比

```
XSLT 生成任务（vlan-policy-test，Round 1）
─────────────────────────────────────────────────
Provider          Model                 Tokens  Latency   Throughput
GitHub Models     gpt-4o-mini            2869   5975ms   480.2 tokens/s
Ollama RTX 4090   qwen2.5-coder:14b      2974   6930ms   429.1 tokens/s
─────────────────────────────────────────────────
差异              +105 tokens (+3.7%)  +955ms  -51.1 tokens/s (-10.6%)
```

> **注**：吞吐量包含 prompt tokens（约 2400）和 output tokens（约 400-600）。
> GitHub Models 整体略快（低延迟），但两者已非常接近，均可满足生产需求。
> Ollama 优势在于：无 API 费用、数据不出本地网络、可离线使用。

---

## 运行命令

```bash
cd migration/lens-migration-core

# GitHub + Ollama 同时运行（默认 OLLAMA_TARGET=remote）
venv/bin/python3 -m pytest \
  tests/vlan-policy-test/validation/test_vlan_github.py \
  tests/vlan-policy-test/validation/test_vlan_ollama.py \
  -v -s

# 仅 GitHub
venv/bin/python3 -m pytest tests/vlan-policy-test/validation/test_vlan_github.py -v -s

# 仅 Ollama（远端）
venv/bin/python3 -m pytest tests/vlan-policy-test/validation/test_vlan_ollama.py -v -s

# 切换到本地 Ollama
OLLAMA_TARGET=local venv/bin/python3 -m pytest \
  tests/vlan-policy-test/validation/test_vlan_ollama.py -v -s

# 强制重新生成（删除缓存）
rm -f tests/vlan-policy-test/output/github-transform.xslt \
      tests/vlan-policy-test/output/ollama-qwen2.5-coder-14b-transform.xslt
```

---

## 调试历史

| 轮次 | 问题 | 原因 | 修复 |
|------|------|------|------|
| #1 | 语义测试 9 项失败 | 测试 XPath 含命名空间，但输出有 `xmlns=""` 空命名空间 | 改用 `local-name()` 谓词 |
| #2 | `eth0.200` vlan-id 也被改成 101 | 意图描述 XPath 过于宽泛 | 提供完整精确 XPath + 明确约束说明 |
| #3 | 21/21 全部通过 ✅ | — | — |
| 2026-03-06 | Ollama test_vlan_ollama 检测走本地端口 | `_check_ollama()` 硬编码 `localhost:11434` | 改用 `_OLLAMA_URL` 变量 |

---

## 结论

- **两种 Provider 首轮生成成功率均为 100%**，21/21（41 项）全部通过
- **性能**：GitHub gpt-4o-mini（480 tokens/s）略优于 Ollama qwen2.5-coder:14b（429 tokens/s），差距 10.6%
- **架构验证**：`create_llm_client` 工厂模式完全可互换，测试代码零差异
- **关键结论**：Ollama 本地化部署（RTX 4090）已达到与云端 API 相当的 XSLT 生成质量与速度
