# Migration 工具研发路线图
> 基于 `request.md` 需求拆解，按研发阶段规划，记录已完成步骤与后续方向。
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
- 在 `lens_2026` monorepo 下创建 `migration/` 子系统，与 platform 模块并列
- 定义三模块分工：`lens-migration-backend`（Java REST）、`lens-migration-core`（Python 核心）、`lens-migration-frontend`（Web UI）
- `lens-migration-backend` 注册到 Nacos，接入 Gateway 路由 `/v2/lens/migration/**`
### 业务
- 分析原始需求，明确输入/输出边界
- 确认三种迁移场景，以"意图驱动"作为 MVP 首要场景
- 核心交付物定义：XSLT 文件 + 自动化测试通过
### 技术
- `migration/pom.xml` 继承 `parent-poms`，获得 Spring Boot/Cloud BOM，Maven 编译通过
- `lens-migration-backend` 骨架：`SecurityConfig`（JWT/JWK）、`OpenAPIConfig`（Swagger）、`MigrationController`（REST 占位）
- Python 虚拟环境（`venv/`）配置完毕，依赖安装：`lxml`、`pyang`、`pytest`、`black`、`mypy` 等
- Python 包结构：`src/main/python/lens_migration/`，含 `generator/`、`analyzer/`、`parser/`、`ai/`、`utils/` 子包骨架
---
## Phase 1 — 意图驱动迁移 MVP ✅ / 🔧
### 框架
- `MigrationEngine`（`__init__.py`）作为 Python 核心入口，串联完整流程
- 测试用例目录规范：`tests/<name>/{old-version/, new-version/, migration/}`
### 业务
- 以 `simple-classifier-test` 为首个端到端用例
  - 意图文档：`migration-intent-v1-to-v2.md`（4 条规则）
  - 输入：`old-version/input-v1.xml`（classifiers XPath 根节点）
  - 期望输出：`new-version/expected-output-v2.xml`
- 已导入真实设备数据集：`device-extension-ls-mf-lwlt-c-26.3-028`（含 yang/ 和 samples/）
### 技术
- `IntentParser`：从 Markdown 提取迁移规则（RENAME / MODIFY_VALUE / ADD_NODE / DELETE_NODE / TRANSFORM / REORDER）
- `XsltGenerator`：基于规则生成 XSLT（Identity Template + 规则特定模板）
- `Validator`：验证 XSLT 语法、执行转换、对比期望输出
- `SchemaAnalyzer`：占位实现（待 Phase 3 完整化）
- 测试脚本：`run_test.py`、`test_simple_classifier.py`、`run_simple_classifier_test.sh`
- 已生成：`generated-transform.xslt`、`auto-generated-transform.xslt`
### 待改进 🔧
- XSLT 生成质量：命名空间处理、复杂嵌套、ADD_NODE 容器重建
- 测试通过率：需达到 100%（当前见 `TEST_RESULTS.md`）
- `generator/` 子包目前为空，XsltGenerator 逻辑需迁移至 `generator/xslt_builder.py`
---
## Phase 2 — AI 集成（智能 XSLT 生成）📋
### 框架
- `ai/` 子包实现 LLM Provider 抽象层，屏蔽不同模型差异
- AI 调用结果缓存，避免重复调用
### 业务
- 意图文档 → 结构化 Prompt 的转换策略（含 Yang 节点路径、数据类型、XML 示例片段）
- 多轮对话迭代：XSLT 测试失败时，将错误信息反馈给 AI 自动修正
- 防幻觉：AI 生成后，规则引擎做二次格式校验
### 技术
- `ai/llm_client.py`：统一 LLM 调用接口，支持 OpenAI GPT-4、本地 Ollama、Azure OpenAI
- `ai/prompt_builder.py`：从意图 + Yang 上下文构建 Prompt
- `ai/xslt_refiner.py`：基于测试失败结果对 XSLT 做 AI 迭代修正
- 在 `XsltGenerator` 中加入 AI 生成路径（与规则引擎并存，可配置）
- 单元测试：Mock LLM 响应，测试 Prompt 构建逻辑
---
## Phase 3 — Schema 驱动迁移（Yang 分析）📋
### 框架
- `pyang`（已安装）作为 Yang 解析引擎
- `SchemaAnalyzer` 从占位实现升级为完整实现
### 业务
- 读取 `tests/device-extension-ls-mf-lwlt-c-26.3-028/yang/` 下的完整 Yang 库
- 支持 Deviation Yang 叠加（不同板卡的差异层）
- 对比两版本 Yang，输出差异报告：新增节点、删除节点、类型变更、重命名
- 差异报告 → 自动生成迁移规则候选列表，供人工确认或送入 AI 细化
### 技术
- `parser/yang_parser.py`：加载 Yang 文件，构建节点树，处理 import/include
- `analyzer/schema_diff.py`：对比两棵节点树，生成 `SchemaDiff` 对象
- `analyzer/deviation_handler.py`：处理 Deviation Yang 的覆盖逻辑
- 集成 `model/yang-library.xml` 确定板卡 Yang 组合范围
- 单元测试：使用 `device-extension-ls-mf-lwlt-c-26.3-028` 数据集验证
---
## Phase 4 — 测试框架集成（自动化验证）📋
### 框架
- 对接现有测试框架（CLI / Python API），定义调用接口规范
- 测试用例目录格式标准化，与现有框架对齐
### 业务
- 从 `samples/` 中选取代表性 XML（按板卡类型 × 操作类型：create/edit/delete/get）
- 自动生成 N-1 版本 input XML（基于逆向推导或 AI 生成）
- 测试覆盖率指标：每种板卡、每种操作类型至少一个通过用例
- 输出测试报告：通过率、失败原因分类、XSLT 规则覆盖率
### 技术
- `utils/test_runner.py`：批量执行 XSLT 转换并对比结果
- `utils/test_case_generator.py`：基于现有 XML 样本自动生成测试用例
- `pytest` parametrize：支持批量用例数据驱动
- Maven 集成：`exec-maven-plugin` 在 `mvn test` 时触发 Python pytest
---
## Phase 5 — Java 后端完整实现 📋
### 框架
- 迁移任务持久化（MariaDB JPA），支持历史记录查询
- 异步任务（Spring `@Async`），避免长时间生成阻塞 HTTP
- 完整接入 Gateway + Nacos + OAuth2
### 业务
| 接口 | 说明 |
|------|------|
| `POST /api/v1/migrations` | 创建迁移项目（设备型号、版本信息） |
| `POST /api/v1/migrations/{id}/schemas` | 上传 Yang Schema 包 |
| `POST /api/v1/migrations/{id}/examples` | 上传 XML 示例对（输入+期望输出） |
| `POST /api/v1/migrations/{id}/intent` | 上传意图文档（Markdown） |
| `POST /api/v1/migrations/{id}/generate` | 触发 XSLT 生成（异步） |
| `GET  /api/v1/migrations/{id}/generate/status` | 查询生成进度 |
| `GET  /api/v1/migrations/{id}/xslt` | 下载生成的 XSLT |
| `POST /api/v1/migrations/{id}/tests/run` | 触发自动化测试 |
| `GET  /api/v1/migrations/{id}/tests/results` | 获取测试报告 |
### 技术
- `domain/`：JPA 实体 `MigrationProject`、`MigrationArtifact`、`TestResult`
- `repository/`：Spring Data JPA Repository
- `service/MigrationService`：通过 `ProcessBuilder` 调用 Python，传参、捕获输出、解析 JSON
- 文件存储：上传的 Yang/XML/意图文档存至本地文件系统或对象存储
- Swagger：所有 API 补全 OpenAPI 注解
---
## Phase 6 — 前端 UI 📋
### 框架
- Vue 3 + Vite，与 lens-platform 前端风格一致
- 接入 Gateway OAuth2（Token 由 Keycloak 颁发，自动刷新）
- `frontend-maven-plugin` 集成到 Maven 构建
### 业务
- 迁移项目列表页：创建、查看、删除
- 迁移工作台：分步骤上传 Schema、示例、意图文档
- 生成进度页：实时显示 XSLT 生成状态（SSE 或轮询）
- XSLT 预览：代码高亮展示，支持下载
- 测试报告页：通过率图表，失败用例详情，差异对比视图
### 技术
- Nginx 托管静态资源（接入 `lens-infra-nginx`）
- API 请求统一走 Gateway，前端配置代理
---
## 里程碑总览
| 阶段 | 关键交付物 | 状态 |
|------|-----------|:----:|
| Phase 0 — 基础架构 | 项目骨架、Maven 编译通过、Python 环境就绪 | ✅ |
| Phase 1 — 意图驱动 MVP | simple-classifier-test 端到端、XSLT 生成 | 🔧 完善中 |
| Phase 2 — AI 集成 | LLM 生成 XSLT，自动迭代修正 | 📋 |
| Phase 3 — Schema 驱动 | Yang 差异分析，自动生成迁移规则 | 📋 |
| Phase 4 — 测试框架 | N-1 批量用例，CI 集成 | 📋 |
| Phase 5 — 后端完整实现 | REST API 全覆盖，异步任务，DB 持久化 | 📋 |
| Phase 6 — 前端 UI | Vue 3 可视化操作全流程 | 📋 |
---
## 当前优先事项（Phase 1 收尾）
1. 提升 `test_simple_classifier.py` 通过率 — 定位失败用例，修复 XSLT 输出
2. 将 `XsltGenerator` 逻辑提取到 `generator/xslt_builder.py`，清理主包结构
3. `ai/llm_client.py` 接口定义（即使暂不实现），为 Phase 2 预留扩展点
4. `service/MigrationService.java` 实现 `callPythonCore()` 基础骨架
---
*最后更新：2026-03-02*
