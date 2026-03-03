# Device Extension Test Data: ls-mf / lwlt-c (26.3-028)

## 概述

本目录包含了一个真实的设备固件版本的完整 YANG schema 数据集，用于测试和开发 YANG 数据迁移工具。

**设备信息：**
- 设备型号: ls-mf (Light Speed Multi-Function)
- 板卡类型: lwlt-c (LightWave Line Termination - C variant)
- 固件版本: 26.3-028
- Schema 集合 ID: 121102d3ba5bd65593039c7a72e31228

## 目录结构

```
device-extension-ls-mf-lwlt-c-26.3-028/
├── yang/                   # YANG 模块文件
│   ├── bbf-*.yang         # Broadband Forum 标准 YANG 模块
│   ├── ietf-*.yang        # IETF 标准 YANG 模块
│   ├── iana-*.yang        # IANA 标准 YANG 模块
│   └── nokia-*.yang       # Nokia 厂商特定扩展和 deviation
│
├── annotations/            # YIN 格式的注解文件
│   └── nokia-*-pae.yin    # PAE (Platform Annotation Extensions)
│
├── model/                  # 模型配置和元数据
│   ├── yang-library.xml   # YANG 库清单（RFC 8525）
│   ├── device.xml         # 设备配置
│   ├── defaults.xml       # 默认值配置
│   ├── alarm.xml          # 告警配置
│   ├── *.csv              # 各种映射表
│   └── *.json             # JSON 格式的配置
│
├── samples/                # XML 样本数据
│   ├── input/             # 输入样本
│   └── output/            # 期望输出样本
│
└── migration/              # 迁移相关文件
    ├── intent/            # 迁移意图文档
    └── xslt/              # 生成的 XSLT 文件
```

## YANG Library 结构

`model/yang-library.xml` 文件定义了完整的 YANG 模块依赖关系和 deviation 映射。

### 关键信息

**1. 模块类型 (conformance-type):**
- `implement`: 已实现的模块，设备完全支持
- `import`: 被引用的模块，仅用于类型定义

**2. Deviation 关系:**
```xml
<module>
  <name>bbf-ethernet-performance-management</name>
  <revision>2022-03-01</revision>
  <namespace>urn:bbf:yang:bbf-ethernet-performance-management</namespace>
  <deviation>
    <name>nokia-bbf-ethernet-performance-management-common-dev</name>
    <revision>2022-07-12</revision>
  </deviation>
  <deviation>
    <name>nokia-bbf-ethernet-performance-management-xpon-dev</name>
    <revision>2024-03-03</revision>
  </deviation>
  <conformance-type>implement</conformance-type>
</module>
```

这表示：
- 基础模块: `bbf-ethernet-performance-management`
- 应用了两个 deviation 模块来修改/限制基础模块的行为
- Nokia 特定的定制

**3. Feature 标志:**
```xml
<module>
  <name>bbf-frame-classification</name>
  <revision>2020-10-13</revision>
  <feature>filter-on-ip-prefix</feature>
  <conformance-type>implement</conformance-type>
</module>
```

表示该模块启用了特定的可选功能。

## 模块分类

### 标准模块

**1. Broadband Forum (BBF) 模块:**
- `bbf-xpon-*`: XPON (10G-PON) 相关
- `bbf-qos-*`: QoS (服务质量) 相关
- `bbf-interfaces-*`: 接口管理
- `bbf-subscriber-*`: 用户管理
- `bbf-fiber-*`: 光纤网络管理

**2. IETF 标准模块:**
- `ietf-interfaces`: RFC 8343 接口模型
- `ietf-system`: RFC 7317 系统管理
- `ietf-routing`: RFC 8349 路由管理
- `ietf-hardware`: RFC 8348 硬件管理
- `ietf-alarms`: RFC 8632 告警管理

**3. IANA 模块:**
- `iana-hardware`: IANA 硬件类型
- `iana-if-type`: IANA 接口类型

### Nokia 扩展模块

**1. Deviation 模块 (nokia-*-dev.yang):**
限制或修改标准模块的行为以适配 Nokia 设备特性。

示例：
- `nokia-bbf-frame-processing-profile-common-dev.yang`
- `nokia-sdan-xpon-channel-termination-not-hs-capable-dev.yang`

**2. Extension 模块 (nokia-*-extension.yang):**
扩展标准模块，增加 Nokia 特定功能。

示例：
- `nokia-sdan-qos-classifier-extension.yang`
- `nokia-sdan-voice-pm-threshold-profiles-mounted.yang`

**3. Mounted 模块 (*-mounted.yang):**
用于 vOMCI (虚拟 ONU 管理和控制接口) 架构的挂载点模块。

## 使用场景

### 场景 1: Schema 差异分析

比较两个固件版本的 YANG schema：

```python
from lens_migration.parser import YangParser
from lens_migration.analyzer import SchemaAnalyzer

# 解析旧版本 schema
old_parser = YangParser("tests/device-extension-ls-mf-lwlt-c-26.3-028/yang")
old_schema = old_parser.parse_from_library(
    "tests/device-extension-ls-mf-lwlt-c-26.3-028/model/yang-library.xml"
)

# 解析新版本 schema
new_parser = YangParser("tests/device-extension-ls-mf-lwlt-c-27.0-001/yang")
new_schema = new_parser.parse_from_library(
    "tests/device-extension-ls-mf-lwlt-c-27.0-001/model/yang-library.xml"
)

# 分析差异
analyzer = SchemaAnalyzer()
diff_report = analyzer.analyze(old_schema, new_schema)
print(diff_report)
```

### 场景 2: 生成迁移 XSLT

```python
from lens_migration.generator import XSLTGenerator

# 生成 XSLT
generator = XSLTGenerator()
xslt_content = generator.generate(
    schema_diff=diff_report,
    migration_intent="migration/intent/26.3-to-27.0.md",
    examples_dir="samples/"
)

# 保存 XSLT
with open("migration/xslt/26.3-028_to_27.0-001.xslt", "w") as f:
    f.write(xslt_content)
```

### 场景 3: REST API 调用

```bash
# 创建迁移项目
curl -X POST http://localhost:8050/v2/lens/migration/api/v1/migrations \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "name": "ls-mf lwlt-c: 26.3-028 to 27.0-001",
    "description": "Firmware upgrade migration",
    "boardType": "lwlt-c"
  }'

# 上传 YANG schemas
curl -X POST http://localhost:8050/v2/lens/migration/api/v1/migrations/{id}/schemas \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -F "oldSchema=@device-extension-ls-mf-lwlt-c-26.3-028.tar.gz" \
  -F "newSchema=@device-extension-ls-mf-lwlt-c-27.0-001.tar.gz"
```

## 关键文件说明

### yang-library.xml

RFC 8525 格式的 YANG 库清单，包含：
- 所有模块的名称、版本、命名空间
- 模块间的依赖关系
- Deviation 和 augment 关系
- 启用的 feature 标志
- 一致性类型 (implement/import)

### device.xml

设备特定配置，包含：
- 设备类型和能力
- 支持的协议
- 硬件信息

### defaults.xml

YANG 模块的默认值配置，用于：
- 未指定值时的默认行为
- 向后兼容性
- 配置迁移时的默认值填充

## 统计信息

根据 yang-library.xml 统计：

- **总模块数**: ~300+ 个模块
- **Implement 模块**: ~150+ 个
- **Deviation 模块**: ~80+ 个
- **Mounted 模块**: ~40+ 个
- **Standard 模块**: BBF, IETF, IANA
- **Vendor 模块**: Nokia extensions

## 迁移测试建议

### 1. 单模块测试

选择一个简单的模块进行单元测试：
```
bbf-qos-types.yang (类型定义，无依赖)
```

### 2. 带 Deviation 的测试

测试 deviation 的应用：
```
Base: bbf-frame-processing-profile.yang
Dev:  nokia-bbf-frame-processing-profile-common-dev.yang
```

### 3. 复杂依赖测试

测试多层依赖关系：
```
bbf-interfaces-performance-management-mounted.yang
  ├── bbf-interfaces-performance-management.yang
  │   └── ietf-interfaces.yang
  └── nokia-bbf-interfaces-performance-management-dev.yang
```

## 注意事项

### 1. 命名空间

所有模块使用完全限定的命名空间：
- BBF: `urn:bbf:yang:*`
- IETF: `urn:ietf:params:xml:ns:yang:*`
- Nokia: `urn:nokia:*` 或特定前缀

### 2. Revision 管理

- 所有模块都有明确的 revision 日期
- Deviation 模块的 revision 必须晚于或等于基础模块
- 迁移时需要检查 revision 兼容性

### 3. Feature 依赖

某些功能依赖 feature 标志：
- 检查 yang-library.xml 中的 `<feature>` 标签
- 生成 XSLT 时考虑 feature 的启用状态

### 4. Mounted 架构

部分模块使用 mounted 架构（vOMCI）：
- 这些模块在 ONU (Optical Network Unit) 上运行
- 需要特殊的挂载点处理
- 迁移时注意挂载路径的变化

## 参考资料

- [RFC 8525 - YANG Library](https://datatracker.ietf.org/doc/html/rfc8525)
- [RFC 7950 - YANG 1.1](https://datatracker.ietf.org/doc/html/rfc7950)
- [Broadband Forum - YANG Modules](https://wiki.broadband-forum.org/)
- [Nokia YANG Models](https://github.com/nokia/yang)

## 更新历史

- **2026-02-28**: 初始版本，导入 ls-mf lwlt-c 26.3-028 数据集

---

**数据集版本**: 26.3-028  
**板卡**: lwlt-c  
**设备**: ls-mf  
**Schema ID**: 121102d3ba5bd65593039c7a72e31228
