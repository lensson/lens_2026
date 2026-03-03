# YANG Data Migration Tool

## 项目概述

YANG数据迁移工具是一个AI驱动的自动化工具，用于设备固件升级时的配置数据迁移。该工具能够理解自然语言描述的迁移意图，分析YANG Schema变化，并自动生成XSLT转换文件。

## 项目结构

```
lens_2026/
├── migration/                          # 迁移工具主项目
│   ├── pom.xml                        # Maven父POM
│   ├── lens-migration-backend/        # 后端服务（Spring Boot）
│   │   ├── pom.xml
│   │   └── src/main/
│   │       ├── java/com/lens/migration/
│   │       │   ├── LensMigrationBackend.java    # 主应用类
│   │       │   ├── controller/                   # REST Controllers
│   │       │   ├── service/                      # 业务逻辑
│   │       │   ├── domain/                       # 领域模型
│   │       │   ├── repository/                   # 数据访问
│   │       │   └── config/                       # 配置类
│   │       └── resources/
│   │           └── application.yml
│   ├── lens-migration-frontend/       # 前端应用（Vue/React）
│   │   └── src/
│   └── lens-migration-core/          # Python核心引擎
│       ├── requirements.txt
│       ├── src/main/python/lens_migration/
│       │   ├── parser/               # YANG解析器
│       │   ├── analyzer/             # Schema分析器
│       │   ├── generator/            # XSLT生成器
│       │   ├── ai/                   # AI集成
│       │   └── utils/                # 工具类
│       └── tests/                    # 测试
└── doc/
    ├── migration/                     # 文档和脚本
    │   ├── request.md                # 需求文档
    │   ├── README.md                 # 主文档（移动到这里）
    │   ├── architecture.md           # 架构设计
    │   ├── examples/                 # 示例文件
    │   └── scripts/                  # 工具脚本
    └── nacos-backup/
        └── lens-migration-backend.yaml  # Nacos配置
```

## 架构设计

### 1. 微服务架构

```
┌─────────────────────────────────────────────────────────────┐
│                      Lens Gateway (8050)                     │
│  路由: /v2/lens/migration/** → lens-migration-backend       │
└─────────────────────────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────┐
│              Lens Migration Backend (8044)                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │ Controllers  │  │  Services    │  │  Repositories│     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
│         │                  │                  │             │
│         └──────────────────┼──────────────────┘             │
│                            ▼                                 │
│                ┌────────────────────────┐                   │
│                │  Python Core Engine    │                   │
│                │  (Process/gRPC)        │                   │
│                └────────────────────────┘                   │
└─────────────────────────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────┐
│                  Python Core Engine                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │ YANG Parser  │  │Schema Analyzer│  │AI Processor │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │XSLT Generator│  │Test Generator │  │  Validator   │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
└─────────────────────────────────────────────────────────────┘
```

### 2. 技术栈

**后端服务 (lens-migration-backend)**:
- Spring Boot 3.x
- Spring Cloud (Nacos Discovery & Config)
- Spring Security OAuth2 Resource Server
- Spring Data JPA
- Springdoc OpenAPI

**前端应用 (lens-migration-frontend)**:
- Vue 3 / React 18
- TypeScript
- Ant Design / Element Plus
- Axios

**核心引擎 (lens-migration-core)**:
- Python 3.10+
- pyang (YANG解析)
- lxml (XML/XSLT处理)
- OpenAI/Anthropic API (AI集成)

## 快速开始

### 1. 环境准备

**Java环境**:
```bash
java --version  # Java 21+
mvn --version   # Maven 3.8+
```

**Python环境**:
```bash
cd /home/zhenac/my/lens_2026/migration/lens-migration-core
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

**数据库**:
```bash
# 创建数据库
mysql -u root -p
CREATE DATABASE lens_migration CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
GRANT ALL PRIVILEGES ON lens_migration.* TO 'lens'@'%';
FLUSH PRIVILEGES;
```

### 2. 配置Nacos

上传配置到Nacos:
```bash
cd /home/zhenac/my/lens_2026/doc/nacos-backup
curl -X POST "http://localhost:8848/nacos/v1/cs/configs" \
  -d "dataId=lens-migration-backend.yaml" \
  -d "group=DEFAULT_GROUP" \
  -d "tenant=lens_2026" \
  -d "type=yaml" \
  --data-urlencode "content@lens-migration-backend.yaml"
```

更新Gateway路由配置（已包含migration路由）。

### 3. 编译项目

```bash
cd /home/zhenac/my/lens_2026/migration
mvn clean install
```

### 4. 启动服务

```bash
# 启动后端服务
cd lens-migration-backend
mvn spring-boot:run

# 服务将在端口8044启动
# Swagger UI: http://localhost:8050/v2/lens/migration/swagger-ui/index.html
```

### 5. 访问API

通过Gateway访问:
```
http://localhost:8050/v2/lens/migration/swagger-ui/index.html
```

直接访问:
```
http://localhost:8044/swagger-ui.html
```

## 核心功能

### 真实设备测试数据

项目包含了真实的设备 YANG schema 数据集用于测试和开发：

**设备信息：**
- 设备型号: ls-mf (Light Speed Multi-Function)
- 板卡类型: lwlt-c (LightWave Line Termination - C variant)
- 固件版本: 26.3-028
- 数据位置: `lens-migration-core/tests/device-extension-ls-mf-lwlt-c-26.3-028/`

**数据集包含：**
- 完整的 YANG 模块文件（BBF、IETF、IANA、Nokia）
- yang-library.xml（定义模块依赖和 deviation 关系）
- 设备配置和默认值
- 注解文件（PAE - Platform Annotation Extensions）
- 样本 XML 数据

**使用示例：**
```python
from lens_migration.parser import YangParser

# 从 yang-library.xml 加载完整的 schema
parser = YangParser("tests/device-extension-ls-mf-lwlt-c-26.3-028/yang")
schema = parser.parse_from_library(
    "tests/device-extension-ls-mf-lwlt-c-26.3-028/model/yang-library.xml"
)

# Schema 包含约 300+ 模块，包括所有 deviation 关系
print(f"Loaded {len(schema.modules)} YANG modules")
```

详细说明请参考：`lens-migration-core/tests/device-extension-ls-mf-lwlt-c-26.3-028/README.md`

---

### 1. 创建迁移项目

```bash
POST /api/v1/migrations
{
  "name": "Firmware v2.0 to v3.0",
  "description": "Migrate from firmware 2.0 to 3.0",
  "boardType": "board-type-a"
}
```

### 2. 上传YANG Schema

```bash
POST /api/v1/migrations/{id}/schemas
{
  "oldSchema": "base64_encoded_yang_files",
  "newSchema": "base64_encoded_yang_files",
  "deviations": ["base64_encoded_deviation_files"]
}
```

### 3. 上传迁移意图

```bash
POST /api/v1/migrations/{id}/intent
{
  "content": "将配置节点 'old-interface-name' 重命名为 'new-interface-name'..."
}
```

### 4. 生成XSLT

```bash
POST /api/v1/migrations/{id}/generate
```

AI将分析Schema变化和迁移意图，自动生成XSLT转换文件。

### 5. 生成测试用例

```bash
POST /api/v1/migrations/{id}/tests/generate
```

自动生成N-1版本的测试XML文件。

### 6. 运行测试

```bash
POST /api/v1/migrations/{id}/tests/run
```

执行测试并生成报告。

### 7. 下载XSLT

```bash
GET /api/v1/migrations/{id}/xslt
```

下载生成的XSLT转换文件。

## 开发指南

### 后端开发

添加新的API endpoint:

```java
@RestController
@RequestMapping("/api/v1/migrations")
public class MigrationController {
    
    @PostMapping("/{id}/custom-action")
    public ResponseEntity<?> customAction(@PathVariable String id) {
        // 实现逻辑
        return ResponseEntity.ok(result);
    }
}
```

### Python核心引擎

添加新的分析器:

```python
from lens_migration.analyzer.base import BaseAnalyzer

class CustomAnalyzer(BaseAnalyzer):
    def analyze(self, schema):
        # 实现分析逻辑
        return analysis_result
```

### AI Prompt优化

编辑AI提示模板:

```python
# lens_migration/ai/prompts.py
XSLT_GENERATION_PROMPT = """
你是YANG数据迁移专家...
{schema_changes}
{migration_intent}
生成XSLT代码...
"""
```

## 配置说明

### Nacos配置项

```yaml
migration:
  python:
    executable: python3              # Python解释器
    venv-path: /path/to/venv        # 虚拟环境路径
  storage:
    base-path: /var/lens/migration  # 存储根目录
  ai:
    provider: openai                 # AI提供商
    api-key: ${AI_API_KEY}          # API密钥
    model: gpt-4-turbo              # 模型名称
    temperature: 0.3                 # 生成温度
```

### 环境变量

```bash
# .env文件
MIGRATION_PORT=8044
DB_HOST=localhost
DB_PORT=33306
DB_USERNAME=lens
DB_PASSWORD=lens
KEYCLOAK_URL=http://172.28.0.1:28080
AI_API_KEY=your-api-key
```

## API认证

使用OAuth2 Authorization Code流程:

1. 打开Swagger UI
2. 点击"Authorize"按钮
3. 登录Keycloak（用户名/密码）
4. 自动获取JWT token
5. 所有API请求自动携带token

客户端凭证已预配置:
- Client ID: `lens-client`
- Client Secret: `x6lEH0DMcT27eop2cszIP3Brc2sDQHLb`

## 测试

### 单元测试

```bash
cd lens-migration-backend
mvn test
```

### 集成测试

```bash
cd lens-migration-core
pytest tests/
```

## 部署

### Docker部署

```bash
# 构建镜像
cd lens-migration-backend
docker build -t lens-migration-backend:latest .

# 运行容器
docker run -d \
  -p 8044:8044 \
  -e NACOS_SERVER=nacos-server:8848 \
  -e DB_HOST=mariadb-server \
  lens-migration-backend:latest
```

### Kubernetes部署

```bash
kubectl apply -f k8s/lens-migration-backend.yaml
```

## 监控

访问Actuator endpoints:
```
http://localhost:8044/actuator/health
http://localhost:8044/actuator/metrics
http://localhost:8044/actuator/prometheus
```

## 常见问题

### Q: Python引擎启动失败？

检查Python环境和依赖:
```bash
source venv/bin/activate
pip list
python -c "import pyang; print('OK')"
```

### Q: AI生成失败？

检查AI API配置:
- API密钥是否正确
- 网络是否可达AI服务
- 查看日志获取详细错误

### Q: XSLT验证失败？

检查生成的XSLT语法:
```bash
xmllint --xslt generated.xslt
```

## 路线图

- [x] Phase 1: 基础框架和后端服务
- [ ] Phase 2: Python核心引擎实现
- [ ] Phase 3: AI集成和XSLT生成
- [ ] Phase 4: 前端UI开发
- [ ] Phase 5: 测试自动化
- [ ] Phase 6: 生产环境优化

## 贡献

欢迎贡献代码！请遵循以下流程:

1. Fork项目
2. 创建feature分支
3. 提交代码
4. 发起Pull Request

## 许可证

[待定]

## 联系方式

- 项目负责人: Lens Team
- 技术支持: lens-support@example.com
- Issue跟踪: [GitHub Issues]

---

**Last Updated**: 2026-02-28  
**Version**: 0.1.0-alpha  
**Status**: In Active Development
