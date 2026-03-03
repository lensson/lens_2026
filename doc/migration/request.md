# Migration 工具 - 需求说明

## 背景

设备由一系列不同类型的板卡组成，每种板卡拥有一套独立的 YANG 文件，用于定义其配置接口和状态描述。外部网管或客户端通过 NETCONF RPC 的方式与设备进行通信。

**YANG 文件特点：**

- 不同板卡之间共享大量 YANG 文件，但也存在少量板卡专属文件（甲板卡有、乙板卡无，或反之）
- 每次 Release，需要为所有板卡出具一组 YANG 文件组合
- 部分 YANG 文件附有 Deviation YANG，用于注释和修改基础定义
- 不同板卡的 Deviation YANG 各不相同

**升级与迁移问题：**

每次 Release 升级时，由于引入新 Feature，YANG 文件需要相应修改。当现场设备升级后，YANG 会升级到新版本，而老版本设备的数据（即基于老版本 YANG Schema 定义的 Datastore XML）需要进行 Migration。

我们需要通过理解 YANG Schema 的改动，自动生成 XSLT，将老版本 XML 数据转换为符合新 Schema 的数据。

---

## 业务需求

### 输入

- **Migration 意图文档**：自然语言描述（WIKI 或 Markdown 格式）
- **示例数据**：Migration 的示例输入文件（XML / XSM）及对应的示例输出文件（XML / XSM）
- **YANG Schema**：视需求可能需要板卡的完整或部分 YANG Schema

### 输出

- **XSLT 转换文件**：包含所有迁移意图、适配 YANG 更新的 XSLT，能够将任意老版本 XML 转换为符合新 Schema 的新版本 XML

### 测试

- 现有测试框架已包含大量 N-1 到 N 的 Migration 用例
- 由于 XSLT 负责从上一个版本到本版本的迁移，本项目需要：
  - 主动构造 N-1 版本的 input XML 作为测试用例
  - 能够自动化运行现有测试框架，覆盖多种测试场景

---

## 技术需求

- 需要将自然语言描述的迁移意图转换为 XSLT，并自动生成测试用例
- 计划引入 **AI** 完成以上工作（自然语言理解 + XSLT 生成 + 测试用例生成）
