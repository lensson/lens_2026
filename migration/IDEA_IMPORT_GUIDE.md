# Migration 项目 IDEA 导入指南

## 概述

migration 目录下包含 3 个子项目：

1. **lens-migration-backend** - Java Spring Boot 后端服务（Maven 项目）
2. **lens-migration-core** - Python XSLT 生成核心（Python 项目）
3. **lens-migration-frontend** - Web 前端界面（Maven + Node.js 项目）

## 导入步骤

### 1. 刷新 Maven 项目

在 IDEA 中：

1. 打开 Maven 面板（View → Tool Windows → Maven）
2. 点击 "Reload All Maven Projects" 按钮（刷新图标）
3. 等待 Maven 同步完成

此时 `lens-migration-backend` 和 `lens-migration-frontend` 应该会作为 Maven 模块被识别。

### 2. 配置 Python SDK（lens-migration-core）

#### 方式一：通过 Project Structure 配置（推荐）

1. **打开 Project Structure**
   - 快捷键：`Ctrl + Alt + Shift + S`
   - 或：File → Project Structure

2. **添加 Python SDK**
   - 左侧选择 "Platform Settings" → "SDKs"
   - 点击 `+` 按钮
   - 选择 "Add Python SDK..."
   - 选择 "Virtualenv Environment"
   - 选择 "Existing environment"
   - **Interpreter 路径**：
     ```
     /home/zhenac/my/lens_2026/migration/lens-migration-core/venv/bin/python3
     ```
   - 点击 "OK"

3. **添加 Python Facet 到项目**
   - 在 Project Structure 中，左侧选择 "Project Settings" → "Facets"
   - 点击 `+` 按钮，选择 "Python"
   - 选择 `lens_2026` 项目
   - 点击 "OK"

4. **配置内容根（Content Root）**
   - 在 Project Structure 中，左侧选择 "Project Settings" → "Modules"
   - 找到 `lens_2026` 模块
   - 在右侧，确保 `migration/lens-migration-core` 显示在模块的内容根中
   - 展开 `migration/lens-migration-core` 节点
   - 标记目录类型：
     - 右键 `src/main/python` → 选择蓝色文件夹图标（Sources）
     - 右键 `tests` → 选择绿色文件夹图标（Tests）
     - 右键 `venv` → 选择灰色文件夹图标（Excluded）

5. **设置 Python SDK**
   - 在 "Modules" 视图中选中 `lens_2026` 模块
   - 在 "Dependencies" 标签页
   - 找到 "Module SDK" 下拉框
   - 选择刚才添加的 Python SDK（应显示为 "Python 3.x (lens-migration-core)"）
   - 点击 "Apply" 和 "OK"

#### 方式二：通过 Python 文件自动配置

1. **打开 Python 文件**
   - 在项目浏览器中导航到：
     ```
     migration/lens-migration-core/src/main/python/
     ```
   - 双击打开任意 `.py` 文件（如 `xslt_generator.py`）

2. **配置解释器提示**
   - IDEA 会在文件顶部显示黄色提示条："No Python interpreter configured for the module"
   - 点击提示条上的 "Configure Python Interpreter"
   - 在弹出的对话框中，选择 "Add Interpreter"
   - 选择 "Existing environment"
   - 浏览并选择：
     ```
     /home/zhenac/my/lens_2026/migration/lens-migration-core/venv/bin/python3
     ```
   - 点击 "OK"

3. **标记源码目录**
   - 在项目浏览器中，右键点击 `src/main/python` 目录
   - 选择 "Mark Directory as" → "Sources Root"（蓝色文件夹图标）
   - 右键点击 `tests` 目录
   - 选择 "Mark Directory as" → "Test Sources Root"（绿色文件夹图标）

### 3. 验证配置

#### 验证 Java 项目（backend/frontend）

1. 在 Maven 面板中展开：
   ```
   lens_2026
   └── migration
       ├── lens-migration-backend
       └── lens-migration-frontend
   ```

2. 双击 `lens-migration-backend` → `Lifecycle` → `compile`
   - 应该能成功编译

#### 验证 Python 项目（core）

1. **检查文件状态**
   - 打开 `migration/lens-migration-core/src/main/python/xslt_generator.py`
   - 文件顶部不应该有"No Python interpreter"警告
   - 代码应该有语法高亮和智能提示

2. **测试 import**
   - 在任意 Python 文件中输入：
     ```python
     import lxml
     from lxml import etree
     ```
   - 应该不会显示红色波浪线错误
   - `Ctrl + 点击` 可以跳转到 lxml 源码

3. **运行测试**
   - 右键点击 `tests/test_simple_classifier.py`
   - 选择 "Run 'pytest in test_simple_classifier.py'"
   - 应该能正常运行（可能测试失败，但能运行说明配置正确）

## 常见问题

### Q1: Maven 无法找到父 POM

**症状**：构建时报错 `Non-resolvable parent POM`

**解决**：
```bash
cd /home/zhenac/my/lens_2026
mvn clean install -DskipTests
```

### Q2: Python 模块导入失败

**症状**：`import lxml` 显示红色波浪线

**解决**：
1. 确认虚拟环境已激活并安装依赖：
   ```bash
   cd /home/zhenac/my/lens_2026/migration/lens-migration-core
   source venv/bin/activate
   pip list | grep lxml
   ```
2. 如果没有安装，运行：
   ```bash
   pip install -r requirements.txt
   ```
3. 在 IDEA 中重新配置 Python SDK（使用上述步骤）

### Q3: IDEA 中看不到 lens-migration-core

**症状**：项目浏览器中 Python 项目没有显示为模块

**解决**：lens-migration-core 是 Python 项目，不会作为 Maven 模块显示。它以普通目录形式存在，但配置了 Python SDK 后可以正常开发。

### Q4: 前端项目构建失败

**症状**：lens-migration-frontend 构建时找不到 Node.js

**解决**：frontend-maven-plugin 会自动下载 Node.js。如果失败：
```bash
cd /home/zhenac/my/lens_2026/migration/lens-migration-frontend
mvn frontend:install-node-and-npm
```

## 项目结构说明

```
migration/
├── pom.xml                          # 父 POM，管理 backend 和 frontend
├── lens-migration-backend/          # Spring Boot 后端
│   ├── pom.xml
│   └── src/
├── lens-migration-core/             # Python 核心库（非 Maven）
│   ├── requirements.txt
│   ├── venv/                        # Python 虚拟环境
│   ├── src/
│   │   └── main/python/
│   └── tests/
└── lens-migration-frontend/         # 前端项目
    ├── pom.xml
    └── src/
```

## 下一步

配置完成后，你可以：

1. **开发后端**：在 `lens-migration-backend` 中编写 Java 代码
2. **开发核心**：在 `lens-migration-core/src/main/python` 中编写 Python 代码
3. **开发前端**：在 `lens-migration-frontend/src` 中开发前端界面
4. **运行测试**：
   - Java: `mvn test -pl migration/lens-migration-backend`
   - Python: `cd migration/lens-migration-core && pytest`

## 快速命令

```bash
# 构建所有 Maven 项目
cd /home/zhenac/my/lens_2026
mvn clean install -DskipTests

# 运行 Python 测试
cd migration/lens-migration-core
source venv/bin/activate
pytest

# 运行后端
cd migration/lens-migration-backend
mvn spring-boot:run
```

