# Migration 项目 - 导入指南索引

## 🎯 目标

将 migration 目录下的 3 个项目导入到 IntelliJ IDEA:
1. **lens-migration-backend** - Java/Spring Boot 后端
2. **lens-migration-core** - Python XSLT 生成核心
3. **lens-migration-frontend** - Web 前端界面

---

## 📚 文档导航

### 🚀 快速开始（推荐新手）
**文件**: [`QUICK_IMPORT.md`](./QUICK_IMPORT.md)

5 分钟快速配置指南，包含:
- ✅ Maven 项目刷新步骤（1分钟）
- ✅ Python SDK 配置步骤（3分钟）
- ✅ 验证清单
- ✅ 常见问题解决

👉 **如果你是第一次导入，从这里开始！**

---

### 📖 详细指南（遇到问题时查看）
**文件**: [`IDEA_IMPORT_GUIDE.md`](./IDEA_IMPORT_GUIDE.md)

完整的配置说明，包含:
- 详细的 Project Structure 配置步骤
- 多种 Python SDK 配置方式
- 目录标记详解（Sources Root, Test Root 等）
- 完整的故障排除指南
- 项目结构说明

👉 **快速指南无法解决问题时，查看这个！**

---

### 📝 完成总结（了解全貌）
**文件**: [`IMPORT_SUMMARY.md`](./IMPORT_SUMMARY.md)

项目配置总结，包含:
- ✅ 已完成的所有配置清单
- 📦 完整的项目结构树
- 🔧 常用命令速查
- 📋 重要文件索引
- 🎯 后续开发任务清单

👉 **配置完成后，查看这个确认一切就绪！**

---

### 🔧 准备脚本（自动检查）
**文件**: [`prepare-idea-import.sh`](./prepare-idea-import.sh)

自动化检查脚本，会验证:
- Python 虚拟环境
- Python 依赖安装
- Maven 配置文件
- 根 POM 构建

**运行方式**:
```bash
cd /home/zhenac/my/lens_2026
bash migration/prepare-idea-import.sh
```

👉 **导入前运行这个脚本，确保一切准备就绪！**

---

## 🏃 快速开始流程

### 步骤 1: 运行准备脚本（可选但推荐）
```bash
cd /home/zhenac/my/lens_2026
bash migration/prepare-idea-import.sh
```
如果全部显示 ✅，说明准备完成！

### 步骤 2: 按照快速指南操作
打开并按照 [`QUICK_IMPORT.md`](./QUICK_IMPORT.md) 操作

### 步骤 3: 验证配置
参考 [`IMPORT_SUMMARY.md`](./IMPORT_SUMMARY.md) 中的检查清单

---

## 📁 项目结构概览

```
migration/
├── 📖 QUICK_IMPORT.md           ⭐ 快速导入指南（从这里开始）
├── 📖 IDEA_IMPORT_GUIDE.md       详细配置说明
├── 📖 IMPORT_SUMMARY.md          配置完成总结
├── 📖 INDEX.md                   本文件（导航索引）
├── 🔧 prepare-idea-import.sh     准备检查脚本
│
├── lens-migration-backend/       ☕ Java 后端（Maven 模块）
│   ├── pom.xml
│   └── src/main/java/
│
├── lens-migration-core/          🐍 Python 核心（独立项目）
│   ├── venv/                     虚拟环境
│   │   └── bin/python3           解释器路径 ⭐
│   ├── requirements.txt
│   ├── src/main/python/          源码目录
│   ├── tests/                    测试目录
│   ├── 📖 IDEA_PYTHON_SETUP.md   Python 配置详解
│   ├── 📖 QUICKSTART.md          快速开始
│   └── 📖 IMPLEMENTATION.md      实现细节
│
└── lens-migration-frontend/      🎨 前端（Maven 模块）
    ├── pom.xml
    └── src/
```

---

## 🎯 三个项目的导入方式

| 项目 | 类型 | 导入方式 | 配置要点 |
|------|------|----------|---------|
| **lens-migration-backend** | Maven | 自动识别 | Maven 刷新后自动显示 |
| **lens-migration-frontend** | Maven | 自动识别 | Maven 刷新后自动显示 |
| **lens-migration-core** | Python | 手动配置 | 配置 Python SDK + 标记目录 |

---

## 🔑 关键信息速查

### Python 解释器路径
```
/home/zhenac/my/lens_2026/migration/lens-migration-core/venv/bin/python3
```

### 需要标记的目录
- `migration/lens-migration-core/src/main/python` → **Sources Root** (蓝色)
- `migration/lens-migration-core/tests` → **Test Sources Root** (绿色)
- `migration/lens-migration-core/venv` → **Excluded** (灰色)

### Maven 模块位置
- IDEA Maven 面板 → `lens_2026` → `migration` → 展开查看 2 个模块

---

## ✅ 验证清单

导入完成后，确认以下内容：

### Maven 项目
- [ ] Maven 面板中显示 `lens-migration-backend`
- [ ] Maven 面板中显示 `lens-migration-frontend`
- [ ] 可以执行 Maven 生命周期命令（compile, package 等）

### Python 项目
- [ ] 打开 `.py` 文件顶部无黄色警告
- [ ] `import lxml` 不显示红色波浪线
- [ ] 代码有语法高亮
- [ ] `Ctrl + Space` 有代码补全
- [ ] 可以右键运行 pytest 测试

---

## 🆘 遇到问题？

1. **首先**: 查看 [`QUICK_IMPORT.md`](./QUICK_IMPORT.md) 的故障排除部分
2. **其次**: 查看 [`IDEA_IMPORT_GUIDE.md`](./IDEA_IMPORT_GUIDE.md) 的常见问题
3. **最后**: 查看 `lens-migration-core/IDEA_PYTHON_SETUP.md` 的 Python 配置详解

---

## 📞 额外资源

### Python 相关
- `lens-migration-core/QUICKSTART.md` - Python 开发快速开始
- `lens-migration-core/IMPLEMENTATION.md` - 实现细节和架构

### 项目文档
- `migration/README.md` - 项目整体介绍
- `doc/migration/request.md` - 原始需求
- `doc/migration/architecture.md` - 架构设计

### 配置文件
- `doc/nacos-backup/lens-migration-backend.yaml` - Nacos 配置示例

---

## 🚀 开始导入

准备好了吗？

1. 运行准备脚本: `bash migration/prepare-idea-import.sh`
2. 打开 [`QUICK_IMPORT.md`](./QUICK_IMPORT.md)
3. 按步骤操作（只需 5 分钟）

**祝你导入顺利！Happy Coding! 🎉**

---

*最后更新: 2026-03-02*

