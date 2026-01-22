# Lens 2026 - All in One Platform

[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE)
[![Java](https://img.shields.io/badge/Java-21-orange.svg)](https://www.java.com/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.2.0-brightgreen.svg)](https://spring.io/projects/spring-boot)
[![Maven](https://img.shields.io/badge/Maven-3.8+-orange.svg)](https://maven.apache.org/)

Lens 2026 是一个完整的微服务架构解决方案，集成了博客、内容管理、身份认证、网关和基础设施服务于一体。基于最新的技术栈（Java 21、Spring Boot 3.2、Spring Cloud 2023）构建。

## 📋 项目概述

Lens 2026 是一个All-in-One的微服务平台，提供以下核心功能：

- **博客系统**: 完整的博客内容管理和发布系统
- **API网关**: 统一的API入口和路由管理
- **身份认证**: 基于Spring Security和Keycloak的认证和授权
- **系统管理**: 用户、权限、配置等系统管理功能
- **监控告警**: 实时监控和性能指标收集
- **基础设施**: Nginx、数据库、缓存等基础服务
- **搜索服务**: 全文搜索和内容检索功能
- **图片管理**: 图片上传、处理和CDN分发

## 🏗️ 项目结构

```
lens_2026/
├── README.md                      # 项目文档
├── pom.xml                        # Root POM - 版本2.0.0-SNAPSHOT
├── parent-poms/                   # 父POMs和依赖管理
│   └── pom.xml                   # 定义所有通用依赖和版本
├── common/                        # 公共模块
│   ├── lens-common-base/         # 基础类和工具
│   ├── lens-common-core/         # 核心功能库
│   ├── lens-common-web/          # Web相关工具和过滤器
│   ├── lens-common-mariadb/      # 数据库访问层
│   └── lens-common-redis/        # Redis缓存集成
├── infra/                         # 基础设施模块
│   └── lens-infra-nginx/         # Nginx配置和部署
├── platform/                      # 平台核心服务
│   ├── lens-platform-gateway/    # API网关 (Spring Cloud Gateway)
│   ├── lens-platform-auth/       # 认证和授权服务
│   ├── lens-platform-system/     # 系统管理服务
│   └── lens-platform-monitor/    # 监控和指标服务
└── lens-blog/                     # 博客系统模块
    ├── lens-blog-persistence/    # 数据库访问层
    ├── lens-blog-admin-backend/  # 管理后端API
    ├── lens-blog-backend/        # 公开API
    ├── lens-blog-frontend/       # 前端应用
    ├── lens-blog-search/         # 搜索服务
    └── lens-blog-picture/        # 图片管理服务
```

## 🚀 快速开始

### 前置条件

- **Java 21** 或更高版本
- **Maven 3.8+**
- **Docker & Docker Compose** (用于容器化部署)
- **Git**

### 编译项目

```bash
# 克隆仓库
git clone https://github.com/lensson/lens_2026.git
cd lens_2026

# 使用Maven编译整个项目
mvn clean install

# 跳过测试进行快速编译
mvn clean install -DskipTests

# 编译特定模块
mvn clean install -pl lens-platform/lens-platform-gateway
```

### 运行服务

#### 1. 启动基础设施服务
```bash
# 进入部署目录
cd ../lens_2026_deployment/chentown_cn/3rd-party

# 启动数据库
./lens-db/start.sh

# 启动Nacos（服务注册中心）
./lens-nacos/start.sh

# 启动其他基础服务
./lens-zipkin/start.sh
./lens-rabbitmq/start.sh
./lens-prometheus/start.sh
./lens-keycloak/start.sh
```

#### 2. 启动平台服务
```bash
cd ../lens-platform
./start.sh
```

#### 3. 启动博客服务
```bash
cd ../lens-blog
./start.sh
```

### 访问服务

| 服务 | URL | 说明 |
|------|-----|------|
| API网关 | http://localhost:8888 | 统一API入口 |
| 博客API | http://localhost:8888/blog | 博客相关接口 |
| Nacos | http://localhost:8848 | 服务注册中心 |
| Keycloak | http://localhost:8080 | 身份认证服务 |
| Prometheus | http://localhost:9090 | 监控系统 |
| Zipkin | http://localhost:9411 | 链路追踪 |
| RabbitMQ | http://localhost:15672 | 消息队列管理 |

## 🔧 技术栈

### 后端框架
- **Spring Boot 3.2.0** - 微服务框架
- **Spring Cloud 2023.0.0** - 云原生工具集
- **Spring Cloud Alibaba 2023.0.0** - 阿里开源组件

### 核心依赖
| 组件 | 版本 | 说明 |
|------|------|------|
| Java | 21 | 编程语言 |
| Spring Boot | 3.2.0 | 微服务框架 |
| Spring Cloud | 2023.0.0 | 分布式系统工具 |
| Spring Cloud Gateway | 2023.0.0 | API网关 |
| MyBatis Plus | 3.5.5 | ORM框架 |
| Druid | 1.2.21 | 数据库连接池 |
| FastJSON | 2.0.57 | JSON处理 |
| Hutool | 5.8.26 | Java工具库 |
| Lombok | 1.18.30 | 代码简化工具 |

### 基础设施
| 组件 | 版本 | 说明 |
|------|------|------|
| Nacos | latest | 服务注册和配置中心 |
| Keycloak | latest | 身份认证和授权 |
| MariaDB | latest | 关系型数据库 |
| Redis | latest | 缓存数据库 |
| RabbitMQ | latest | 消息队列 |
| Prometheus | latest | 监控系统 |
| Zipkin | latest | 分布式追踪 |
| Nginx | latest | 反向代理 |

## 📦 模块说明

### parent-poms 模块
定义全项目的依赖版本和插件配置，确保所有模块的版本统一。

**关键配置:**
- Java 21编译和运行环境
- Spring Boot/Cloud BOM导入
- Maven插件配置
- 通用依赖版本管理

### common 模块
提供所有微服务通用的基础功能和工具类。

**子模块:**
- `lens-common-base`: 基础类、常量、枚举等
- `lens-common-core`: 核心服务、拦截器、过滤器
- `lens-common-web`: Web工具、REST响应包装、异常处理
- `lens-common-mariadb`: 数据库配置、连接池、SQL工具
- `lens-common-redis`: Redis配置、缓存模板、分布式锁

### infra 模块
基础设施相关模块。

**子模块:**
- `lens-infra-nginx`: Nginx配置文件、反向代理规则、负载均衡

### platform 模块
平台核心服务模块。

**子模块:**
- `lens-platform-gateway`: API网关，负责请求路由、限流、认证
- `lens-platform-auth`: 认证服务，集成Keycloak和Spring Security
- `lens-platform-system`: 系统管理，用户、角色、权限、配置管理
- `lens-platform-monitor`: 监控服务，性能指标、日志、告警

### lens-blog 模块
博客系统完整实现。

**子模块:**
- `lens-blog-persistence`: MyBatis Plus配置、Entity、Mapper、Service
- `lens-blog-admin-backend`: 管理端后端API，文章、评论、标签等管理
- `lens-blog-backend`: 公开API，文章查询、评论、点赞等
- `lens-blog-frontend`: 前端应用（Vue.js或React）
- `lens-blog-search`: 全文搜索功能，集成Elasticsearch或Solr
- `lens-blog-picture`: 图片管理和CDN分发

## 🔐 安全性

### 认证和授权
- 基于OAuth2和JWT的token认证
- 集成Keycloak进行身份管理
- 微服务之间使用feign客户端进行安全通信

### 数据安全
- 数据库密码加密存储
- Redis连接认证
- SQL注入防护（MyBatis Plus参数化查询）

### API安全
- 请求签名验证
- 速率限制（Rate Limiting）
- 跨域资源共享（CORS）配置
- HTTPS/TLS加密传输

## 📊 监控和性能

### 性能监控
- Prometheus收集JVM、数据库、缓存等指标
- Grafana可视化监控面板
- 自定义业务指标收集

### 链路追踪
- Zipkin分布式追踪
- 请求链路详细跟踪
- 性能瓶颈识别

### 日志管理
- 统一日志格式
- ELK Stack集成（可选）
- 关键业务操作审计

## 🗄️ 数据库

### 数据库架构
```
Master (MariaDB)
  ├── lens_platform  (平台数据库)
  ├── lens_blog      (博客数据库)
  ├── lens_plumemo   (备忘录数据库)
  ├── nacos_config   (Nacos配置数据库)
  └── zipkin         (链路追踪数据库)
```

### 初始化脚本
```bash
cd ../lens_2026_deployment/sql
./initDb.sh
```

详见: [Deployment README](../lens_2026_deployment/README.md)

## 🚢 部署

### Docker容器化部署
参考 `lens_2026_deployment` 项目获取完整的Docker和Docker Compose配置。

### Kubernetes部署
提供Kubernetes YAML文件用于生产环境部署（可选）。

### 部署流程
1. 编译项目并生成Docker镜像
2. 将镜像上传到镜像仓库
3. 使用Docker Compose或Kubernetes编排部署
4. 执行数据库初始化脚本
5. 配置反向代理和负载均衡

详见: [部署指南](../lens_2026_deployment/README.md)

## 📝 开发指南

### 添加新的微服务模块

```bash
# 1. 在相应目录创建模块
mkdir platform/lens-platform-newservice
cd platform/lens-platform-newservice

# 2. 创建pom.xml，继承parent模块
# 3. 创建src目录结构
mkdir -p src/{main,test}/{java/com/lens/platform/newservice,resources}

# 4. 在root pom.xml中添加模块
# 5. 运行编译测试
mvn clean install
```

### 代码规范
- 遵循Google Java编程规范
- 使用Lombok简化代码
- 添加必要的Javadoc注释
- 单元测试覆盖率不低于80%

### Git提交规范
提交包含Copilot自动生成代码时，请在commit message中包含 `@copilot` 标签：

```bash
git commit -m "feat: add new feature @copilot"
```

## 🤝 贡献指南

1. Fork本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature @copilot'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启Pull Request

## 📚 相关文档

- [部署指南](../lens_2026_deployment/README.md) - 完整的部署和运维文档
- [项目模块总结](../MODULES_SUMMARY.md) - 所有项目的模块详细说明
- [API文档](./docs/API.md) - API接口文档（待完善）
- [架构设计](./docs/ARCHITECTURE.md) - 系统架构和设计文档（待完善）

## 🔍 常见问题

### Q: 如何修改数据库连接配置？
A: 在 `lens-common-mariadb` 模块中修改 `application.yml`，或通过Nacos配置中心动态修改。

### Q: 如何添加新的路由规则到网关？
A: 修改 `lens-platform-gateway/src/main/resources/application.yml`，添加新的路由配置，或通过Nacos配置中心动态管理。

### Q: 如何访问Keycloak管理界面？
A: 访问 `http://localhost:8080/auth/admin`，使用默认用户名 `admin` 和密码 `admin` 登录。

### Q: 如何查看微服务的实时日志？
A: 使用 `docker logs -f <container-name>` 查看容器日志。

### Q: 如何扩展博客功能（添加新字段）？
A: 
1. 在数据库中添加新字段
2. 更新Entity类和数据库mapper
3. 更新前后端业务逻辑
4. 添加相应的API接口

## 📧 支持

遇到问题？请提交Issue或联系开发团队。

## 📄 许可证

本项目采用 Apache License 2.0 许可证，详见 [LICENSE](LICENSE) 文件。

## 👥 作者

Lens Team - 高效、可靠、易用的微服务平台

---

**最后更新**: 2026-01-22  
**当前版本**: 2.0.0-SNAPSHOT  
**Spring Boot版本**: 3.2.0  
**Java版本**: 21
