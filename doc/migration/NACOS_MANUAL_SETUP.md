# 手动在Nacos中配置 lens-migration-backend

由于自动上传脚本可能存在问题，请按以下步骤手动在Nacos控制台中配置：

## 步骤

### 1. 打开Nacos控制台

```
http://localhost:8848/nacos
```

登录：
- 用户名: `nacos`
- 密码: `nacos`

### 2. 切换到正确的命名空间

1. 点击顶部的 **"命名空间"** 标签
2. 找到并选择 **lens_2026** 命名空间
3. 如果没有，创建一个新命名空间：
   - 命名空间ID: `lens_2026`
   - 命名空间名: `lens_2026`

### 3. 进入配置管理

1. 点击左侧菜单 **"配置管理"** → **"配置列表"**
2. 确保右上角显示的命名空间是 **lens_2026**
3. 确保右上角的Group是 **DEFAULT_GROUP**

### 4. 创建新配置

点击右上角的 **"+"** 按钮或 **"新建配置"**

### 5. 填写配置信息

**基本信息:**
- **Data ID**: `lens-migration-backend.yaml`
- **Group**: `DEFAULT_GROUP`
- **配置格式**: `YAML`
- **描述**: `Lens Migration Backend Service Configuration`

### 6. 配置内容

将以下内容复制粘贴到配置内容区域：

```yaml
# Lens Migration Backend Service Configuration

# Spring Configuration
spring:
  application:
    name: lens-migration-backend
  
  datasource:
    url: jdbc:mariadb://${DB_HOST:localhost}:${DB_PORT:33306}/lens_migration?useUnicode=true&characterEncoding=utf8&useSSL=false
    username: ${DB_USERNAME:lens}
    password: ${DB_PASSWORD:lens}
    driver-class-name: org.mariadb.jdbc.Driver
  
  jpa:
    hibernate:
      ddl-auto: update
    show-sql: ${JPA_SHOW_SQL:false}
    properties:
      hibernate:
        dialect: org.hibernate.dialect.MariaDBDialect
        format_sql: true

# Server Configuration
server:
  port: ${MIGRATION_PORT:8044}
  forward-headers-strategy: framework
  tomcat:
    redirect-context-root: false
    use-relative-redirects: true

# OpenAPI Configuration
openapi:
  service:
    title: Lens Migration API
    version: 1.0.0
    url: ${MIGRATION_URL:http://localhost:8050/v2/lens/migration}

# Springdoc Configuration
springdoc:
  api-docs:
    path: /v3/api-docs
  swagger-ui:
    path: /swagger-ui.html
    url: /v2/lens/migration/v3/api-docs
    config-url: /v2/lens/migration/v3/api-docs/swagger-config
    oauth2-redirect-url: http://localhost:8050/v2/lens/migration/swagger-ui/oauth2-redirect.html
    oauth:
      clientId: lens-client
      clientSecret: x6lEH0DMcT27eop2cszIP3Brc2sDQHLb
      usePkceWithAuthorizationCodeGrant: true
      scopes:
        - openid
        - profile
        - email
  disable-swagger-default-url: false

# Keycloak Configuration
keycloak:
  url: ${KEYCLOAK_URL:http://172.28.0.1:28080}
  realm: ${KEYCLOAK_REALM:lens}

# Security Configuration
spring.security.oauth2.resourceserver.jwt:
  jwk-set-uri: ${KEYCLOAK_URL:http://172.28.0.1:28080}/realms/${KEYCLOAK_REALM:lens}/protocol/openid-connect/certs

# Migration Service Configuration
migration:
  python:
    executable: ${PYTHON_EXECUTABLE:python3}
    venv-path: ${PYTHON_VENV:/home/zhenac/my/lens_2026/migration/lens-migration-core/venv}
  storage:
    base-path: ${STORAGE_PATH:/var/lens/migration}
    yang-dir: ${STORAGE_PATH:/var/lens/migration}/yang
    xml-dir: ${STORAGE_PATH:/var/lens/migration}/xml
    xslt-dir: ${STORAGE_PATH:/var/lens/migration}/xslt
    test-dir: ${STORAGE_PATH:/var/lens/migration}/tests
  ai:
    provider: ${AI_PROVIDER:openai}
    api-key: ${AI_API_KEY:}
    model: ${AI_MODEL:gpt-4-turbo}
    max-tokens: ${AI_MAX_TOKENS:4000}
    temperature: ${AI_TEMPERATURE:0.3}

# Logging Configuration
logging:
  level:
    root: ${LOG_LEVEL_ROOT:INFO}
    com.lens: ${LOG_LEVEL_LENS:DEBUG}
    org.springframework.security: ${LOG_LEVEL_SPRING_SECURITY:DEBUG}

# Management & Actuator
management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,prometheus
  health:
    db:
      enabled: true
```

### 7. 发布配置

点击底部的 **"发布"** 按钮

### 8. 验证配置

1. 返回配置列表
2. 确认可以看到 `lens-migration-backend.yaml` 配置项
3. 点击配置项可以查看详情和编辑

## 同时检查Gateway配置

确保Gateway配置中包含migration路由：

1. 在配置列表中找到 `lens-platform-gateway.yaml`
2. 点击 **"编辑"**
3. 在routes部分应该包含：

```yaml
        # Migration service Swagger routes
        - id: lens-migration-backend-swagger
          uri: lb://lens-migration-backend
          order: 1
          predicates:
            - Path=/v2/lens/migration/swagger-ui.html,/v2/lens/migration/swagger-ui/**,/v2/lens/migration/v3/api-docs/**
          filters:
            - StripPrefix=3
            - PreserveHostHeader

        # Migration service API routes
        - id: lens-migration-backend
          uri: lb://lens-migration-backend
          order: 100
          predicates:
            - Path=/v2/lens/migration/**
          filters:
            - StripPrefix=3
            - AddRequestHeader=X-Forwarded-Prefix,/v2/lens/migration
```

4. 如果没有，添加这些路由配置
5. 点击 **"发布"** 保存

## 重启服务

配置完成后：

1. **重启Gateway**（如果修改了Gateway配置）
   ```bash
   # 在IDEA中停止并重启 lens-platform-gateway
   ```

2. **启动Migration服务**
   ```bash
   cd /home/zhenac/my/lens_2026/migration/lens-migration-backend
   mvn spring-boot:run
   ```

## 验证

启动后检查：

1. **服务注册**
   - Nacos控制台 → 服务管理 → 服务列表
   - 应该看到 `lens-migration-backend` 服务

2. **健康检查**
   ```bash
   curl http://localhost:8044/actuator/health
   ```

3. **Swagger UI**
   ```
   http://localhost:8050/v2/lens/migration/swagger-ui/index.html
   ```

## 如果配置文件在你的本地

配置文件位置：
```
/home/zhenac/my/lens_2026/doc/nacos-backup/lens-migration-backend.yaml
```

你可以直接复制文件内容到Nacos控制台中。

---

**完成后，lens-migration-backend就配置在Nacos中了！** ✅
