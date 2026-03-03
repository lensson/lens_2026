# 快速导入 Migration 3个项目到 IDEA

## 📦 项目概览

```
migration/
├── lens-migration-backend/    # ☕ Java/Spring Boot 后端
├── lens-migration-core/       # 🐍 Python XSLT生成核心  
└── lens-migration-frontend/   # 🎨 Web前端界面
```

## 🚀 快速开始

### 步骤 1: 刷新 Maven 项目

1. 在 IDEA 右侧打开 **Maven** 面板
2. 点击刷新按钮 🔄 **Reload All Maven Projects**
3. 等待同步完成

✅ 完成后 `lens-migration-backend` 和 `lens-migration-frontend` 会显示为 Maven 模块

---

### 步骤 2: 配置 Python SDK（3分钟）

#### 快速配置

1. **打开任意 Python 文件**
   - 导航到: `migration/lens-migration-core/src/main/python/`
   - 双击打开任意 `.py` 文件

2. **点击顶部黄色提示条**
   - 提示: "No Python interpreter configured"
   - 点击 **"Configure Python Interpreter"**

3. **选择已有虚拟环境**
   - 点击 **"Add Interpreter"** 或 **齿轮图标** → **"Add"**
   - 选择 **"Existing"** (或 "Virtualenv Environment" → "Existing environment")
   - 浏览到路径:
     ```
     /home/zhenac/my/lens_2026/migration/lens-migration-core/venv/bin/python3
     ```
   - 点击 **OK**

4. **标记源码目录**
   - 右键 `migration/lens-migration-core/src/main/python` 
   - 选择 **Mark Directory as** → **Sources Root** (蓝色文件夹)
   - 右键 `migration/lens-migration-core/tests`
   - 选择 **Mark Directory as** → **Test Sources Root** (绿色文件夹)

✅ 完成！现在 Python 代码应该有语法高亮和智能提示了

---

## ✅ 验证配置

### 验证 Java 项目

在 Maven 面板中应该看到:
```
lens_2026
└─ migration
   ├─ lens-migration-backend ✅
   └─ lens-migration-frontend ✅
```

### 验证 Python 项目  

1. 打开 `migration/lens-migration-core/src/main/python/xslt_generator.py`
2. 顶部不应有黄色警告
3. 输入 `import lxml` 不应有红色波浪线
4. 按 `Ctrl + Space` 应该有代码补全

---

## 🛠️ 故障排除

### ❌ Maven 项目不显示

**解决**: 
```bash
cd /home/zhenac/my/lens_2026
mvn clean install -DskipTests -rf :parent-pom
```
然后在 IDEA 中刷新 Maven

### ❌ Python 导入 lxml 失败

**解决**:
```bash
cd /home/zhenac/my/lens_2026/migration/lens-migration-core
source venv/bin/activate
pip install -r requirements.txt
```

### ❌ 看不到 Python 代码补全

1. File → Project Structure → SDKs
2. 确认有 Python SDK (显示为 "Python 3.x")
3. 在 Modules → Dependencies 中设置 Module SDK

---

## 📝 下一步

项目导入完成后:

- **运行后端**: `cd migration/lens-migration-backend && mvn spring-boot:run`
- **运行 Python 测试**: `cd migration/lens-migration-core && pytest`
- **查看详细文档**: `migration/IDEA_IMPORT_GUIDE.md`

---

## 💡 提示

- **lens-migration-core** 是 Python 项目，不会显示为 Maven 模块，这是正常的
- 虚拟环境已经创建好了，位于 `lens-migration-core/venv/`
- Python 解释器路径: `/home/zhenac/my/lens_2026/migration/lens-migration-core/venv/bin/python3`
- 所有依赖已安装 (lxml, pytest, pyang 等)

需要帮助？查看详细指南: `migration/IDEA_IMPORT_GUIDE.md`

---

## 🎯 完成检查清单

导入完成后，确认以下项目：

- [ ] Maven 面板中显示 `lens-migration-backend` 模块
- [ ] Maven 面板中显示 `lens-migration-frontend` 模块  
- [ ] 打开 Python 文件无黄色警告
- [ ] `src/main/python` 标记为蓝色 Sources Root
- [ ] `tests` 标记为绿色 Test Sources Root
- [ ] Python 代码有智能提示和补全

全部完成？恭喜！🎉 你已成功导入所有 3 个项目！

