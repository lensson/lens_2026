# Migration 工具研发路线图
> 基于 `request.md` 需求拆解，按研发阶段规划，记录已完成步骤与后续方向。

**图例**：✅ 已完成　🔧 部分完成／进行中　⬜ 未开始　📋 待规划

---
## 背景回顾
设备固件升级时，老版本 Netconf Datastore XML 需转换为新版本 Yang Schema 格式。
**三种迁移场景**：
| 场景 | 描述 | 是否需要 Yang |
|------|------|:---:|
| 意图驱动 (Intent-Driven) | Schema 未变，仅配置语义调整 | 否 |
| Schema 驱动 (Schema-Driven) | Yang 模型发生结构变化 | 是 |
| 混合 (Hybrid) | 既有 Schema 变化，又有语义调整 | 是 |
---
## Phase 0 — 项目初始化与基础架构 ✅

### 框架
- ✅ 在 `lens_2026` monorepo 下创建 `migration/` 子系统，与 platform 模块并列
- ✅ 定义三模块分工：`lens-migration-backend`（Java REST）、`lens-migration-core`（Python 核心）、`lens-migration-frontend`（Web UI）
- ✅ `lens-migration-backend` 注册到 Nacos，接入 Gateway 路由 `/v2/lens/migration/**`

### 业务
- ✅ 分析原始需求，明确输入/输出边界
- ✅ 确认三种迁移场景，以"意图驱动"作为 MVP 首要场景
- ✅ 核心交付物定义：XSLT 文件 + 自动化测试通过

### 技术
- ✅ `migration/pom.xml` 继承 `parent-poms`，获得 Spring Boot/Cloud BOM，Maven 编译通过
- ✅ `lens-migration-backend` 骨架：`SecurityConfig`（JWT/JWK）、`OpenAPIConfig`（Swagger）、`MigrationController`（REST 占位）
- ✅ Python 虚拟环境（`venv/`）配置完毕，依赖安装：`lxml`、`pyang`、`pytest`、`black`、`mypy` 等
- ✅ Python 包结构：`src/main/python/lens_migration/`，含 `generator/`、`analyzer/`、`parser/`、`validator/`、`ai/`、`utils/` 子包，每个子包有 `__init__.py` 暴露公共 API

---
## Phase 1 — 意图驱动迁移 MVP ✅

### 框架
- ✅ `MigrationEngine`（`__init__.py`）作为 Python 核心入口，串联完整流程
- ✅ 测试用例目录规范：`tests/<name>/{input/old-version/, input/new-version/, input/request/, output/, validation/}`
- ✅ Python 子包按模块整理完成（`parser/`、`generator/`、`validator/`、`analyzer/`、`ai/`、`utils/`）

### 业务
- ✅ 以 `simple-classifier-test` 为首个端到端用例
  - ✅ 意图文档：`input/request/migration-intent-v1-to-v2.md`（4 条规则：RENAME / MODIFY_VALUE / ADD_NODE / DELETE_NODE）
  - ✅ 输入：`input/old-version/classifier-sample-01-v1.xml`（classifiers XPath 根节点，含 BBF 命名空间）
  - ✅ 期望输出：`input/new-version/classifier-sample-01-v2.xml`
  - ✅ 端到端测试 **21/21 全部通过**（见 `validation/TEST_RESULTS.md`）
- ✅ 真实设备数据集已导入：`tests/schema/device-extension-ls-mf-lwlt-c-26.3-028`（含 `yang/`、`samples/`、`model/yang-library.xml`）

### 技术
- ✅ `parser/intent_parser.py`：从 Markdown 提取迁移规则（RENAME / MODIFY_VALUE / ADD_NODE / DELETE_NODE / TRANSFORM / REORDER），含完整中文注释
- ✅ `generator/xslt_generator.py`：基于规则生成 XSLT（Identity Template + 规则特定模板），支持 BBF 命名空间；增强 DEBUG/INFO 日志（规则排序表、每条模板状态、XSLT 大小统计）
- ✅ `validator/validator.py`：验证 XSLT 语法、执行转换、字符串 + 语义双重比对期望输出
- ✅ `analyzer/schema_analyzer.py`：骨架实现（`DiffEngine`、`ChangeDetector`、`ImpactAnalyzer`），待 Phase 3 完整化
- ✅ `parser/yang_parser.py`：骨架实现（`SchemaTree`、`YangParser`、`DeviationProcessor`），待 Phase 3 完整化
- ✅ 手写验证 XSLT：`output/generated-transform.xslt`（作为生成结果基准）
- ✅ 代码生成 XSLT：`output/e2e-generated-transform.xslt`（测试产物，语义与手写版一致）
- ✅ pytest 端到端测试：`validation/test_e2e_simple_classifier.py`（21 个用例，支持 `--log-cli-level=DEBUG`）

---
## Phase 2 — AI 集成（智能 XSLT 生成）✅

### 框架
- ✅ `ai/` 子包实现 LLM Provider 抽象层，屏蔽不同模型 API 差异
- ✅ 重试逻辑（指数退避）由基类 `LLMClient` 统一处理
- ✅ `MockLLMClient` 支持 `call_history` 记录，便于测试断言
- ✅ 本地 Ollama 部署（`ollama serve`），安装 `qwen3:8b`（Qwen最新版，2025.04）

### 业务
- ✅ 意图文档 → 结构化 Prompt（System + User），含 Yang 节点路径、XSLT 规范、XML 示例片段
- ✅ 多轮对话迭代：XSLT 验证失败时，将错误信息 + 上一轮 XSLT 反馈给 AI 自动修正（最多 N 轮）
- ✅ 防幻觉：`XSLTRefiner._extract_xslt()` 从 LLM 输出中可靠提取 XSLT，识别代码块和纯 XML
- ✅ `vlan-policy-test`：第二个端到端测试用例，覆盖 GitHub Models + 本地 Ollama 双 provider

### 技术
- ✅ `ai/llm_client.py`：统一 LLM 调用接口，支持 OpenAI、Anthropic Claude、Qwen、Deepseek、本地 Ollama（默认 `qwen3:8b`）、GitHub Models、Mock
- ✅ `ai/prompt_builder.py`：`build_generate_prompt()` + `build_refinement_prompt()`，含完整中文注释
- ✅ `ai/xslt_refiner.py`：编排 LLM 调用 → 验证 → 错误反馈 → 迭代修正主循环，记录每轮历史
- ✅ `MigrationEngine.migrate_with_ai()`：AI 路径顶层入口，与规则引擎路径并存可配置
- ✅ `ai/__init__.py`：暴露所有公共 API（`create_llm_client`、`XSLTRefiner`、`PromptBuilder` 等）
- ✅ 单元测试：`tests/ai/test_phase2_ai.py`，**25/25 全部通过**，全离线 Mock，无需 API Key
  - `TestMockLLMClient`（6项）：固定响应、关键字映射、调用历史、reset、token 估算
  - `TestCreateLLMClient`（3项）：工厂函数路由、未知 provider 报错、大小写不敏感
  - `TestPromptBuilder`（6项）：system/user prompt 内容验证、修正 prompt 结构
  - `TestXSLTRefiner`（7项）：首轮成功、二轮修正成功、max_rounds 耗尽、XSLT 提取逻辑
  - `TestMigrationEngineAI`（3项）：端到端 Mock 集成、字段完整性、非法 provider 错误处理
- ✅ `vlan-policy-test`：4规则 VLAN XSLT 生成测试，`TestAIVlanPolicyGeneration`（GitHub）+ `TestOllamaVlanPolicyGeneration`（本地 Ollama）各20个断言
- ✅ Ollama 远端部署（RTX 4090，10.99.79.20）：`qwen2.5-coder:14b`（速度优先）+ `qwen3.5:35b`（质量优先），SSH 隧道自动管理
- ✅ 全量测试（2026-03-07）：**133 项 / 130 passed / 3 skipped（Qwen Cloud API 未配置）/ 0 failed**
  - GitHub gpt-4o-mini + qwen2.5-coder:14b：全量 133 项，120.7s
  - qwen3.5:35b：Ollama 相关 57 项，126.7s
  - 三模型均 1 轮完成 XSLT 生成，benchmark 吞吐：14b **199 t/s**，35b **105 t/s**
  - vlan-policy-test：GitHub ≈ 14b（~5s，~560 t/s），35b 热加载 11.9s

> **Ollama 模型说明**：Ollama 上没有 "qwen3.5"，Qwen 系列最新版叫 **qwen3**（2025.04 Alibaba 发布），Ollama tag 为 `qwen3:8b` / `qwen3:4b` 等。远端部署模型 `qwen3.5:35b` 为第三方量化版本。

---
## Phase 3 — Schema 驱动迁移（Yang 分析）📋

### 框架
- ⬜ `pyang`（已安装）作为 Yang 解析引擎，升级为真正调用
- ⬜ `SchemaAnalyzer` 从骨架实现升级为完整实现

### 业务
- ⬜ 读取 `tests/schema/device-extension-ls-mf-lwlt-c-26.3-028/yang/` 下的完整 Yang 库
- ⬜ 支持 Deviation Yang 叠加（不同板卡的差异层）
- ⬜ 对比两版本 Yang，输出差异报告：新增节点、删除节点、类型变更、重命名
- ⬜ 差异报告 → 自动生成迁移规则候选列表，供人工确认或送入 AI 细化

### 技术
- 🔧 `parser/yang_parser.py`：骨架已有（`SchemaTree`、`YangParser`、`DeviationProcessor`），需接入 `pyang` 真实解析
- 🔧 `analyzer/schema_analyzer.py`：骨架已有（`DiffEngine`、`ChangeDetector`、`ImpactAnalyzer`），需实现真实 diff 逻辑
- ⬜ `analyzer/schema_diff.py`：对比两棵节点树，生成 `SchemaDiff` 对象
- ⬜ `analyzer/deviation_handler.py`：处理 Deviation Yang 的覆盖逻辑
- ⬜ 集成 `model/yang-library.xml` 确定板卡 Yang 组合范围
- ⬜ 单元测试：使用 `device-extension-ls-mf-lwlt-c-26.3-028` 数据集验证

---
## Phase 4 — 测试框架集成（自动化验证）📋

### 框架
- ⬜ 对接现有测试框架（CLI / Python API），定义调用接口规范
- ⬜ 测试用例目录格式标准化，与现有框架对齐

### 业务
- ⬜ 从 `samples/` 中选取代表性 XML（按板卡类型 × 操作类型：create/edit/delete/get）
- ⬜ 自动生成 N-1 版本 input XML（基于逆向推导或 AI 生成）
- ⬜ 测试覆盖率指标：每种板卡、每种操作类型至少一个通过用例
- ⬜ 输出测试报告：通过率、失败原因分类、XSLT 规则覆盖率

### 技术
- ⬜ `utils/test_runner.py`：批量执行 XSLT 转换并对比结果
- ⬜ `utils/test_case_generator.py`：基于现有 XML 样本自动生成测试用例
- ⬜ `pytest` parametrize：支持批量用例数据驱动
- ⬜ Maven 集成：`exec-maven-plugin` 在 `mvn test` 时触发 Python pytest

---
## Phase 5 — Java 后端完整实现 🔧

### 框架
- ✅ 迁移任务持久化（MariaDB + MyBatis Plus）— 数据库 `auto_migration` 已建立，7 张表完整建模
- ⬜ 异步任务（Spring `@Async`），避免长时间生成阻塞 HTTP
- ✅ 完整接入 Gateway + Nacos + OAuth2

### 数据库建模（2026-03-09）✅

数据库名：**`auto_migration`**（MariaDB，端口 33306，用户 lens）

| 表名 | 实体类 | 说明 |
|------|--------|------|
| `migration_project` | `MigrationProject` | 迁移项目主表，记录设备型号、版本、AI配置、状态 |
| `migration_schema` | `MigrationSchema` | Yang Schema 上传记录（支持 source/target 版本 + Deviation） |
| `migration_example` | `MigrationExample` | XML 样本对（输入旧版本 + 期望输出新版本），含命名空间映射 |
| `migration_intent` | `MigrationIntent` | 意图文档（Markdown），含解析后规则 JSON，支持多版本 |
| `migration_artifact` | `MigrationArtifact` | 生成产物（XSLT/XML），含 AI 对话历史、Token 消耗、耗时 |
| `migration_test_run` | `MigrationTestRun` | 测试执行批次，记录通过/失败/出错数量 |
| `migration_test_case_result` | `MigrationTestCaseResult` | 单条样本对的验证结果，含 diff 详情 |

**枚举类型：**
- `MigrationStatus`：CREATED → SCHEMA_UPLOADED → INTENT_UPLOADED → GENERATING → GENERATED → TESTING → COMPLETED / FAILED
- `MigrationType`：INTENT_DRIVEN / SCHEMA_DRIVEN / HYBRID
- `AiProvider`：OPENAI / GITHUB / QWEN / DEEPSEEK / OLLAMA / NONE
- `ArtifactType`：XSLT / YANG_SCHEMA / INPUT_XML / EXPECTED_XML / ACTUAL_XML / INTENT_DOC / TEST_REPORT
- `TestStatus`：RUNNING / PASSED / FAILED / ERROR / SKIPPED

**持久层（MyBatis Plus Mapper — 2026-03-10）✅**

> 从 Spring Data JPA 重构为 **MyBatis Plus**（`@Mapper` + `BaseMapper<T>`）
- ✅ `MigrationProjectMapper`：按状态/类型/关键字分页查询
- ✅ `MigrationSchemaMapper`：按版本/Deviation 标志/校验值查询
- ✅ `MigrationExampleMapper`：按项目/操作类型查询
- ✅ `MigrationIntentMapper`：激活版本查询
- ✅ `MigrationArtifactMapper`：激活版本/产物类型查询
- ✅ `MigrationTestRunMapper`：最近执行/按状态查询
- ✅ `MigrationTestCaseResultMapper`：按测试批次/状态查询

**初始化文档：** `src/main/resources/db/schema-auto_migration.sql`（ddl-auto=none，手动建表）

### 业务（REST API — 2026-03-10）✅

| 接口 | 说明 | 状态 |
|------|------|:----:|
| `POST   /api/v1/projects` | 创建迁移项目（设备型号、版本信息） | ✅ |
| `GET    /api/v1/projects` | 分页查询项目列表（支持状态/类型/关键字过滤） | ✅ |
| `GET    /api/v1/projects/{id}` | 获取项目详情 | ✅ |
| `PUT    /api/v1/projects/{id}` | 更新项目信息 | ✅ |
| `DELETE /api/v1/projects/{id}` | 删除项目（级联删除关联数据） | ✅ |
| `POST   /api/v1/projects/{id}/schemas` | 上传 Yang Schema 包（文件 + 元数据） | ✅ |
| `GET    /api/v1/projects/{id}/schemas` | 查询项目的所有 Schema 记录 | ✅ |
| `POST   /api/v1/projects/{id}/examples` | 上传 XML 示例对（旧版本 + 新版本 + 操作类型） | ✅ |
| `GET    /api/v1/projects/{id}/examples` | 查询示例列表（支持按操作类型过滤） | ✅ |
| `POST   /api/v1/projects/{id}/intents` | 上传意图文档（Markdown 内容） | ✅ |
| `GET    /api/v1/projects/{id}/intents/active` | 获取当前激活的意图文档 | ✅ |
| `POST   /api/v1/projects/{id}/generate` | 触发 XSLT 生成（调用 Python 核心，同步） | ✅ |
| `GET    /api/v1/projects/{id}/artifacts` | 查询生成产物列表（XSLT/XML/报告） | ✅ |
| `GET    /api/v1/projects/{id}/artifacts/{artifactId}/download` | 下载产物内容 | ✅ |

### 技术（2026-03-10）✅
- ✅ `domain/`：7 个 MyBatis Plus 实体（`@TableName` + `@TableField`）+ `BaseEntity`（`createTime`/`updateTime` 自动填充）+ 5 个枚举
- ✅ `mapper/`：7 个 MyBatis Plus Mapper（`@Mapper` 继承 `BaseMapper<T>`）
- ✅ `dto/`：5 组 DTO（`CreateRequest` / `UpdateRequest` / `Response` / `ListItem`），含 `@Valid` 校验注解
- ✅ `service/`：5 个 Service 接口 + `impl/` 实现类，`MigrationGenerateService` 通过 `ProcessBuilder` 调用 Python 核心
- ✅ `controller/`：5 个 REST Controller，全部加 OpenAPI `@Tag` + `@Operation` 注解
- ✅ `common/`：`ApiResponse<T>`（统一响应体）+ `PageResult<T>`（分页结果）+ `GlobalExceptionHandler`
- ✅ `SecurityConfig`（JWT/JWK）、`OpenAPIConfig`（Swagger，支持 OAuth2 授权码流）
- ✅ Nacos 配置：datasource 指向 `auto_migration`，HikariCP 连接池，MyBatis Plus 配置，文件存储路径
- ✅ 持久层单元测试：`MigrationProjectMapperTest` + `MigrationSchemaMapperTest`（H2 内存数据库）
- ✅ Swagger UI 可访问（通过 Gateway：`http://localhost:8050/v2/lens/migration/swagger-ui/index.html`）
- ⬜ `service/MigrationService`：异步任务（`@Async`）+ 进度推送（SSE）
- ⬜ 文件存储：当前存本地文件系统，后续可对接对象存储

---
## Phase 6 — 前端 UI 📋

### 框架
- ⬜ Vue 3 + Vite，与 lens-platform 前端风格一致
- ⬜ 接入 Gateway OAuth2（Token 由 Keycloak 颁发，自动刷新）
- ⬜ `frontend-maven-plugin` 集成到 Maven 构建

### 业务
- ⬜ 迁移项目列表页：创建、查看、删除
- ⬜ 迁移工作台：分步骤上传 Schema、示例、意图文档
- ⬜ 生成进度页：实时显示 XSLT 生成状态（SSE 或轮询）
- ⬜ XSLT 预览：代码高亮展示，支持下载
- ⬜ 测试报告页：通过率图表，失败用例详情，差异对比视图

### 技术
- ⬜ Nginx 托管静态资源（接入 `lens-infra-nginx`）
- ⬜ API 请求统一走 Gateway，前端配置代理

---
## 里程碑总览
| 阶段 | 关键交付物 | 状态 |
|------|-----------|:----:|
| Phase 0 — 基础架构 | 项目骨架、Maven 编译通过、Python 环境就绪 | ✅ 完成 |
| Phase 1 — 意图驱动 MVP | simple-classifier-test **21/21** 通过、XSLT 生成、子包重构 | ✅ 完成 |
| Phase 2 — AI 集成 | LLM 生成 XSLT，多轮迭代修正；GitHub Models + 远端 Ollama（qwen2.5-coder:14b / qwen3.5:35b）；**全量 133 项 130 passed / 3 skipped（2026-03-07）** | ✅ 完成 |
| Phase 3 — Schema 驱动 | Yang 差异分析，自动生成迁移规则 | ⬜ 未开始（骨架已有） |
| Phase 4 — 测试框架 | N-1 批量用例，CI 集成 | ⬜ 未开始 |
| Phase 5 — 后端完整实现 | REST API 14个接口全部实现，MyBatis Plus 持久层，Service 层，Swagger UI，DB 持久化（auto_migration，7表） | 🔧 核心 REST 实现完成，异步任务待实现 |
| Phase 6 — 前端 UI | Vue 3 可视化操作全流程 | ⬜ 未开始 |

---
## 当前优先事项（Phase 5 进行中）
1. **Phase 5 收尾（当前重点）**：
   - ✅ 数据库 `auto_migration` 建立完毕（MariaDB，7 张表）
   - ✅ 从 Spring Data JPA 重构为 **MyBatis Plus**（`@Mapper` + `BaseMapper<T>`）
   - ✅ 7 个实体 + 5 个枚举 + 7 个 Mapper + 5 个 Service（接口 + 实现）+ 5 个 Controller，Maven 编译通过
   - ✅ 14 个 REST API 接口实现（CRUD 项目 + Schema/Example/Intent/Generate/Artifact）
   - ✅ `MigrationGenerateService` 通过 `ProcessBuilder` 调用 Python 核心
   - ✅ Swagger UI + OpenAPI 注解完整；Nacos 配置同步到 `doc/nacos-backup/lens-migration-backend.yaml`
   - ✅ 持久层单元测试（H2 内存数据库）
   - ⬜ 下一步：异步任务（`@Async`）+ 进度推送（SSE）
   - ⬜ 下一步：文件存储对接（当前本地文件系统）
2. **Phase 3 启动**：`parser/yang_parser.py` 接入 `pyang` 真实解析，验证 `device-extension-ls-mf-lwlt-c-26.3-028` 数据集
3. **更多测试用例**：基于 `tests/schema/` 下的真实 Yang + samples 创建第二个端到端测试用例

---
*最后更新：2026-03-10*
