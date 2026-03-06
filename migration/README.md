# YANG 数据迁移工具

## 项目概述

YANG 数据迁移工具是一个 AI 驱动的自动化工具，用于设备固件升级时的配置数据迁移。  
该工具能够理解自然语言描述的迁移意图，分析 YANG Schema 变化，并自动生成 XSLT 转换文件。

**当前状态**：Phase 0 ✅ · Phase 1 ✅ · Phase 2 ✅ · Phase 3–6 规划中

---

## 项目结构

```
lens_2026/
├── migration/                              # 迁移工具主项目
│   ├── pom.xml                            # Maven 父 POM
│   ├── lens-migration-backend/            # 后端服务（Spring Boot）
│   │   ├── pom.xml
│   │   └── src/main/
│   │       ├── java/com/lens/migration/
│   │       │   ├── LensMigrationBackend.java
│   │       │   ├── controller/            # REST Controllers
│   │       │   ├── service/               # 业务逻辑（骨架）
│   │       │   ├── domain/                # 领域模型（骨架）
│   │       │   ├── repository/            # 数据访问（骨架）
│   │       │   └── config/                # SecurityConfig, OpenAPIConfig
│   │       └── resources/
│   │           └── application.yml
│   ├── lens-migration-frontend/           # 前端应用（规划中）
│   │   └── src/
│   └── lens-migration-core/              # Python 核心引擎
│       ├── requirements.txt
│       ├── src/main/python/lens_migration/
│       │   ├── __init__.py               # MigrationEngine 入口
│       │   ├── parser/
│       │   │   ├── intent_parser.py      # 从 Markdown 提取迁移规则
│       │   │   └── yang_parser.py        # YANG 解析（骨架，Phase 3）
│       │   ├── generator/
│       │   │   └── xslt_generator.py     # 规则驱动 XSLT 生成
│       │   ├── analyzer/
│       │   │   └── schema_analyzer.py    # Schema 差异分析（骨架，Phase 3）
│       │   ├── ai/
│       │   │   ├── llm_client.py         # 多 Provider LLM 客户端
│       │   │   ├── prompt_builder.py     # Prompt 构建器
│       │   │   └── xslt_refiner.py       # AI 迭代修正器
│       │   ├── validator/
│       │   │   └── validator.py          # XSLT 语法 + 转换验证
│       │   └── utils/
│       └── tests/
│           ├── ai/                        # Phase 2 AI 单元测试
│           ├── schema/                    # 真实设备 YANG 数据集
│           └── simple-classifier-test/   # Phase 1 端到端测试用例
└── doc/
    ├── migration/
    │   ├── request.md                    # 需求文档
    │   ├── roadmap.md                    # 研发路线图（含完成状态）
    │   ├── architecture.md               # 架构设计
    │   └── HISTORY.md                    # 变更记录
    └── nacos-backup/
        └── lens-migration-backend.yaml   # Nacos 配置
```

---

## 架构设计

### 微服务架构

```
┌─────────────────────────────────────────────────────────────┐
│                    Lens Gateway (8050)                       │
│  路由: /v2/lens/migration/** → lens-migration-backend       │
└─────────────────────────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────┐
│              Lens Migration Backend (8044)                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │ Controllers  │  │  Services    │  │  Repositories│     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
│                        ProcessBuilder                        │
│                            │ JSON                           │
│                            ▼                                 │
│                ┌────────────────────────┐                   │
│                │   Python Core Engine   │                   │
│                └────────────────────────┘                   │
└─────────────────────────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────┐
│                  Python Core Engine                          │
│                                                              │
│  ┌───────────────┐  ┌────────────────┐  ┌───────────────┐ │
│  │ IntentParser  │  │ XSLTGenerator  │  │  XSLTValidator│ │
│  └───────────────┘  └────────────────┘  └───────────────┘ │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐│
│  │                  AI 层（Phase 2）                       ││
│  │  ┌────────────┐  ┌───────────────┐  ┌──────────────┐ ││
│  │  │ LLMClient  │  │ PromptBuilder │  │ XSLTRefiner  │ ││
│  │  │ (多 Provider│  └───────────────┘  └──────────────┘ ││
│  │  │ 统一接口)   │                                        ││
│  │  └────────────┘                                        ││
│  └────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────┘
                             │
                    ┌────────┴────────┐
                    ▼                 ▼
             LLM Provider       YANG Schema
         (OpenAI/Qwen/etc.)  device-extension-*
```

### 两种 XSLT 生成路径

| 路径 | 描述 | 入口方法 |
|------|------|---------|
| **规则引擎**（Phase 1）| 解析意图 Markdown → 规则列表 → 模板化生成 | `MigrationEngine.migrate()` |
| **AI 生成**（Phase 2）| 意图 + XML 示例 → LLM Prompt → XSLT → 验证 → 迭代修正 | `MigrationEngine.migrate_with_ai()` |

---

## 技术栈

**后端服务 (lens-migration-backend)**：
- Spring Boot 3.x
- Spring Cloud (Nacos Discovery & Config)
- Spring Security OAuth2 Resource Server
- Spring Data JPA
- Springdoc OpenAPI

**核心引擎 (lens-migration-core)**：
- Python 3.10+
- pyang（YANG 解析）
- lxml（XML/XSLT 处理）
- openai SDK（兼容 OpenAI / Qwen / Deepseek / Ollama）
- anthropic SDK（Claude）
- tenacity（重试 + 指数退避）

---

## 快速开始

### 1. 环境准备

**Java 环境**：
```bash
java --version  # Java 21+
mvn --version   # Maven 3.8+
```

**Python 环境**：
```bash
cd /home/zhenac/my/lens_2026/migration/lens-migration-core
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### 2. 配置环境变量

复制并编辑环境文件：
```bash
cp /home/zhenac/my/lens_2026/conf/env/lens_2026.env .env
# 填写 AI API Key（至少一个）
export DASHSCOPE_API_KEY=sk-xxx   # Qwen（推荐）
export OPENAI_API_KEY=sk-xxx      # OpenAI
export ANTHROPIC_API_KEY=sk-xxx   # Anthropic Claude
export DEEPSEEK_API_KEY=sk-xxx    # Deepseek
```

### 3. 运行测试

```bash
cd migration/lens-migration-core
source venv/bin/activate

# Phase 1 端到端测试（规则引擎，无需 API Key）
pytest tests/simple-classifier-test/validation/ -v
# 预期：21/21 通过

# Phase 2 AI 单元测试（全 Mock，无需 API Key）
pytest tests/ai/ -v
# 预期：25/25 通过
```

### 4. 编译后端

```bash
cd /home/zhenac/my/lens_2026/migration
mvn clean install
```

### 5. 启动后端服务

```bash
# 启动后端
cd lens-migration-backend
mvn spring-boot:run
# 服务端口：8044
# Swagger UI：http://localhost:8050/v2/lens/migration/swagger-ui/index.html
```

---

## AI 集成（Phase 2）

### 支持的 LLM Provider

| Provider | 推荐模型 | 所需环境变量 | 说明 |
|----------|----------|-------------|------|
| **GitHub Models**（在线测试首选）| `gpt-4o` / `gpt-4o-mini` | `GITHUB_TOKEN` | 只需 GitHub PAT，无需单独申请 Key，免费配额 |
| **Qwen** | `qwen-plus` / `qwen-max` | `DASHSCOPE_API_KEY` | 阿里云通义千问，OpenAI 兼容接口 |
| **OpenAI** | `gpt-4o` / `gpt-4-turbo` | `OPENAI_API_KEY` | 效果最佳，成本较高 |
| **Deepseek** | `deepseek-chat` / `deepseek-reasoner` | `DEEPSEEK_API_KEY` | 代码能力强，成本低 |
| **Anthropic** | `claude-3-5-sonnet-20241022` | `ANTHROPIC_API_KEY` | 长上下文能力强 |
| **Ollama**（本地）| `llama3.2` / `qwen2.5-coder` | `OLLAMA_BASE_URL`（可选）| 离线运行，无需 API Key |
| **Mock**（测试）| — | — | 单元测试专用，无需网络 |

### 工厂函数创建客户端

```python
from lens_migration.ai.llm_client import create_llm_client

# GitHub Models（推荐用于在线测试，只需 GitHub Personal Access Token）
# 1. 打开 https://github.com/settings/tokens → Generate new token (classic)
# 2. 勾选 public_repo，复制 Token
# 3. export GITHUB_TOKEN=ghp_xxxxxxxxxxxx
client = create_llm_client("github", model="gpt-4o-mini")  # mini 更快、配额更宽松

# Qwen（需设置 DASHSCOPE_API_KEY）
client = create_llm_client("qwen", model="qwen-plus")

# OpenAI
client = create_llm_client("openai", model="gpt-4o")

# Deepseek
client = create_llm_client("deepseek", model="deepseek-chat")

# 本地 Ollama（需先 ollama serve && ollama pull qwen2.5-coder:7b）
client = create_llm_client("ollama", model="qwen2.5-coder:7b")

# Mock（测试用）
client = create_llm_client("mock", fixed_response="<xsl:stylesheet .../>")
```

也可通过环境变量指定默认 provider：
```bash
export LLM_PROVIDER=qwen
export LLM_MODEL=qwen-plus
```

### AI 生成 XSLT 流程

```python
from lens_migration import MigrationEngine
from lens_migration.ai.llm_client import create_llm_client

engine = MigrationEngine()
llm = create_llm_client("qwen", model="qwen-plus")

result = engine.migrate_with_ai(
    intent_file="tests/simple-classifier-test/input/request/migration-intent-v1-to-v2.md",
    input_xml_file="tests/simple-classifier-test/input/old-version/classifier-sample-01-v1.xml",
    expected_output_file="tests/simple-classifier-test/input/new-version/classifier-sample-01-v2.xml",
    output_xslt="output/ai-generated.xslt",
    llm_client=llm,
    max_rounds=3,          # 最多迭代 3 轮
)

print(f"成功: {result['success']}")
print(f"迭代轮次: {result['rounds_used']}")
print(f"消耗 Token: {result['total_tokens']}")
```

### 多轮迭代修正机制

```
Round 1：LLM 根据意图文档 + XML 示例 → 生成初始 XSLT
         ↓ 验证失败（语法错误 / 输出不符）？
Round 2：[初始 XSLT + 错误信息] → LLM 修正
         ↓ 仍然失败？
Round N：继续迭代，直到通过或达到 max_rounds
         ↓
         返回最终结果（含每轮历史记录）
```

### AI 模块结构

```
ai/
├── llm_client.py      # LLM Provider 抽象基类 + 5 个实现 + Mock + 工厂函数
│                        重试逻辑（指数退避）、调用耗时统计、Token 计数
├── prompt_builder.py  # System Prompt + User Prompt 构建
│                        build_generate_prompt()  — 初次生成
│                        build_refinement_prompt() — 迭代修正
└── xslt_refiner.py    # 编排 LLM 调用 → 验证 → 反馈 → 修正主循环
                         _extract_xslt()          — 从 LLM 输出中可靠提取 XSLT
```

---

## 测试结果

| 测试套件 | 测试文件 | 通过 / 总计 | 说明 |
|---------|---------|:----------:|------|
| Phase 1 端到端 | `tests/simple-classifier-test/validation/test_e2e_simple_classifier.py` | **21 / 21** | 规则引擎，无需 API Key |
| Phase 2 AI 单元 | `tests/ai/test_phase2_ai.py` | **34 / 34** | 全 Mock，无需 API Key（含 GitHub Provider 路由测试）|

Phase 2 测试覆盖：
- `TestMockLLMClient`（6 项）：固定响应、关键字映射、调用历史、reset、token 估算
- `TestCreateLLMClient`（12 项）：工厂函数路由（含 github/github_models/githubmodels 三别名）、默认模型、缺少 Token 报错、大小写不敏感
- `TestPromptBuilder`（6 项）：system/user prompt 内容验证、修正 prompt 结构
- `TestXSLTRefiner`（7 项）：首轮成功、二轮修正成功、max_rounds 耗尽、XSLT 提取
- `TestMigrationEngineAI`（3 项）：端到端 Mock 集成、字段完整性、非法 provider 错误

---

## 真实设备测试数据

**设备信息**：
- 型号：ls-mf（Light Speed Multi-Function）
- 板卡：lwlt-c（LightWave Line Termination - C variant）
- 固件版本：26.3-028
- 位置：`lens-migration-core/tests/schema/device-extension-ls-mf-lwlt-c-26.3-028/`

数据集包含：完整 YANG 模块（BBF、IETF、IANA、Nokia）、yang-library.xml、设备样本 XML 等。

---

## Nacos 配置

上传配置：
```bash
cd /home/zhenac/my/lens_2026/doc/nacos-backup
curl -X POST "http://localhost:8848/nacos/v1/cs/configs" \
  -d "dataId=lens-migration-backend.yaml" \
  -d "group=DEFAULT_GROUP" \
  -d "tenant=lens_2026" \
  -d "type=yaml" \
  --data-urlencode "content@lens-migration-backend.yaml"
```

---

## API 访问

通过 Gateway（需登录 Keycloak）：
```
http://localhost:8050/v2/lens/migration/swagger-ui/index.html
```

直接访问：
```
http://localhost:8044/swagger-ui/index.html
```

---

## 路线图

| 阶段 | 关键交付物 | 状态 |
|------|-----------|:----:|
| Phase 0 — 基础架构 | 项目骨架、Maven 编译、Python 环境 | ✅ 完成 |
| Phase 1 — 意图驱动 MVP | 规则引擎生成 XSLT，21/21 测试通过 | ✅ 完成 |
| Phase 2 — AI 集成 | 多 Provider LLM，迭代修正，25/25 测试通过 | ✅ 完成 |
| Phase 3 — Schema 驱动 | pyang 真实解析，Yang diff 分析 | ⬜ 未开始（骨架已有）|
| Phase 4 — 测试框架 | 批量用例，CI 集成 | ⬜ 未开始 |
| Phase 5 — 后端完整实现 | REST API 全覆盖，异步任务，DB 持久化 | 🔧 骨架完成 |
| Phase 6 — 前端 UI | Vue 3 可视化操作全流程 | ⬜ 未开始 |

详细路线图：[doc/migration/roadmap.md](../doc/migration/roadmap.md)

---

**最后更新**：2026-03-04  
**版本**：0.2.0-alpha（Phase 2 完成）
