# YANG迁移工具 - 快速启动指南

## ✅ 项目已创建完成

项目位置: `/home/zhenac/my/lens_2026/migration/`

## 项目结构验证

```
✅ migration/
   ✅ pom.xml                          - Maven父POM
   ✅ README.md                        - 项目文档
   ✅ lens-migration-backend/          - Spring Boot后端
   ✅ lens-migration-frontend/         - 前端应用（待开发）
   ✅ lens-migration-core/            - Python核心引擎

✅ doc/
   ✅ migration/                       - 文档目录
   ✅ nacos-backup/
      ✅ lens-migration-backend.yaml  - Nacos配置
      ✅ lens-platform-gateway.yaml   - Gateway配置（已更新）
```

## 快速启动步骤

### 1. 上传Nacos配置 ⚠️

```bash
cd /home/zhenac/my/lens_2026/doc/nacos-backup

# 上传Migration配置
curl -X POST "http://localhost:8848/nacos/v1/cs/configs" \
  -d "dataId=lens-migration-backend.yaml" \
  -d "group=DEFAULT_GROUP" \
  -d "tenant=lens_2026" \
  -d "type=yaml" \
  --data-urlencode "content@lens-migration-backend.yaml"

# 更新Gateway配置
curl -X POST "http://localhost:8848/nacos/v1/cs/configs" \
  -d "dataId=lens-platform-gateway.yaml" \
  -d "group=DEFAULT_GROUP" \
  -d "tenant=lens_2026" \
  -d "type=yaml" \
  --data-urlencode "content@lens-platform-gateway.yaml"
```

### 2. 创建数据库 ⚠️

```bash
mysql -u root -p
```

```sql
CREATE DATABASE lens_migration CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
GRANT ALL PRIVILEGES ON lens_migration.* TO 'lens'@'%';
FLUSH PRIVILEGES;
EXIT;
```

### 3. 准备Python环境 ⚠️

```bash
cd /home/zhenac/my/lens_2026/migration/lens-migration-core
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### 4. 编译项目 ⚠️

```bash
cd /home/zhenac/my/lens_2026
mvn clean install
```

### 5. 重启Gateway（重要！）⚠️

```bash
# 在IDEA中停止并重启 lens-platform-gateway
# 或在终端：
cd /home/zhenac/my/lens_2026/platform/lens-platform-gateway
mvn spring-boot:run
```

### 6. 启动Migration服务 ⚠️

```bash
cd /home/zhenac/my/lens_2026/migration/lens-migration-backend
mvn spring-boot:run
```

等待启动完成，看到:
```
Started LensMigrationBackend in X seconds
```

### 7. 访问服务 ✅

**通过Gateway访问（推荐）:**
```
Swagger UI: http://localhost:8050/v2/lens/migration/swagger-ui/index.html
```

**直接访问:**
```
Swagger UI: http://localhost:8044/swagger-ui.html
Health: http://localhost:8044/actuator/health
```

### 8. 测试API ✅

**方式1: 使用Swagger UI**
1. 打开: http://localhost:8050/v2/lens/migration/swagger-ui/index.html
2. 点击"Authorize"
3. 登录Keycloak
4. 测试"/api/v1/migrations/health" endpoint

**方式2: 使用curl**
```bash
# 健康检查（不需要认证）
curl http://localhost:8044/api/v1/migrations/health

# 期望返回:
{
  "status": "UP",
  "service": "lens-migration-backend",
  "version": "1.0.0"
}
```

## 服务端口

| 服务 | 端口 | 说明 |
|------|------|------|
| Gateway | 8050 | 统一网关入口 |
| Auth | 8041 | 认证服务 |
| System | 8042 | 系统服务 |
| Monitor | 8043 | 监控服务 |
| **Migration** | **8044** | **迁移服务（新）** |
| Nacos | 8848 | 配置中心 |
| Keycloak | 28080 | 认证服务器 |
| MariaDB | 33306 | 数据库 |

## URL汇总

### Swagger UI
```
Gateway: http://localhost:8050/swagger-ui.html
Auth:    http://localhost:8050/v2/lens/platform/auth/swagger-ui/index.html
System:  http://localhost:8050/v2/lens/platform/system/swagger-ui/index.html
Migration: http://localhost:8050/v2/lens/migration/swagger-ui/index.html  ⭐ 新增
```

### API Base URLs
```
Gateway:   http://localhost:8050
Auth:      http://localhost:8050/v2/lens/platform/auth
System:    http://localhost:8050/v2/lens/platform/system
Migration: http://localhost:8050/v2/lens/migration  ⭐ 新增
```

## 常见问题

### Q1: Migration服务启动失败？

**检查Nacos配置是否上传成功:**
```bash
curl "http://localhost:8848/nacos/v1/cs/configs?dataId=lens-migration-backend.yaml&group=DEFAULT_GROUP&tenant=lens_2026"
```

**检查数据库连接:**
```bash
mysql -h localhost -P 33306 -u lens -p lens_migration
```

### Q2: Gateway访问404？

**确认Gateway已重启并加载新配置:**
```bash
# 查看Gateway日志，应该看到migration路由
# 重启Gateway
```

**测试Gateway路由:**
```bash
curl -I http://localhost:8050/v2/lens/migration/actuator/health
# 应该返回 200 OK
```

### Q3: Swagger UI无法访问？

**检查服务是否注册到Nacos:**
```
访问: http://localhost:8848/nacos
检查: lens_2026 namespace
确认: lens-migration-backend 服务已注册
```

### Q4: Python模块找不到？

**确认虚拟环境激活:**
```bash
cd /home/zhenac/my/lens_2026/migration/lens-migration-core
source venv/bin/activate
python -c "import lens_migration; print('OK')"
```

## 下一步开发

### 立即可做:

1. **添加Domain模型**
   ```bash
   cd lens-migration-backend/src/main/java/com/lens/migration/domain
   # 创建 Migration.java, YangSchema.java 等实体类
   ```

2. **实现Service层**
   ```bash
   cd lens-migration-backend/src/main/java/com/lens/migration/service
   # 创建 MigrationService.java
   ```

3. **完善Python解析器**
   ```bash
   cd lens-migration-core/src/main/python/lens_migration/parser
   # 完善 yang_parser.py 实现
   ```

4. **添加单元测试**
   ```bash
   cd lens-migration-backend/src/test/java
   # 创建测试类
   ```

### 后续计划:

- [ ] 实现文件上传功能
- [ ] 集成Python引擎调用
- [ ] 实现AI接口
- [ ] 开发前端界面
- [ ] 完善测试用例

## 技术支持

- **项目文档**: `/home/zhenac/my/lens_2026/migration/README.md`
- **架构文档**: `/home/zhenac/my/lens_2026/doc/migration/architecture.md`
- **需求文档**: `/home/zhenac/my/lens_2026/doc/migration/request.md`
- **创建总结**: `/home/zhenac/my/lens_2026/doc/migration/PROJECT_CREATION_SUMMARY.md`

## 验证清单

启动后逐一检查:

- [ ] Nacos配置已上传
- [ ] Database lens_migration 已创建
- [ ] Python虚拟环境已创建
- [ ] Maven编译成功
- [ ] Gateway已重启
- [ ] Migration服务启动成功
- [ ] Migration服务已注册到Nacos
- [ ] Health endpoint返回正常
- [ ] Swagger UI可访问
- [ ] OAuth2认证正常

全部完成后，项目即可进入开发阶段！🎉

---

**快速启动指南版本**: 1.0  
**最后更新**: 2026-02-28  
**状态**: 项目框架就绪
