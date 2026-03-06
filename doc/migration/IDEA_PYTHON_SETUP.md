# IntelliJ IDEA Python 解释器配置指南

## 问题
在 IntelliJ IDEA 中打开 Python 文件时，提示：
```
No Python interpreter configured for the module
```

## 解决方案

### 方法 1: 使用虚拟环境（推荐）

#### 步骤 1: 创建虚拟环境

在终端中运行：
```bash
cd /home/zhenac/my/lens_2026/migration/lens-migration-core
bash setup_python_env.sh
```

这将会：
- 创建 Python 虚拟环境（venv/）
- 安装所需依赖
- 提供配置路径

#### 步骤 2: 在 IDEA 中配置 Python SDK

1. **打开项目结构**
   - 快捷键：`Ctrl + Alt + Shift + S`
   - 或菜单：File → Project Structure

2. **添加 Python SDK**
   - 左侧选择 "Platform Settings" → "SDKs"
   - 点击 `+` 按钮
   - 选择 "Add Python SDK..."

3. **选择虚拟环境**
   - 选择 "Virtualenv Environment"
   - 选择 "Existing environment"
   - 路径：`/home/zhenac/my/lens_2026/migration/lens-migration-core/venv/bin/python3`
   - 点击 "OK"

4. **配置模块 SDK**
   - 左侧选择 "Project Settings" → "Modules"
   - 选择 `lens-migration-core` 模块
   - 在 "Dependencies" 标签
   - 设置 "Module SDK" 为刚才添加的 Python SDK
   - 点击 "Apply" 和 "OK"

5. **标记源码目录**
   - 在 Project 视图中，右键点击 `src/main/python` 目录
   - 选择 "Mark Directory as" → "Sources Root"

### 方法 2: 使用系统 Python

如果不想使用虚拟环境，可以直接使用系统 Python：

1. **查找系统 Python 路径**
   ```bash
   which python3
   # 通常是 /usr/bin/python3 或 /usr/local/bin/python3
   ```

2. **在 IDEA 中配置**
   - 按照上面的步骤 1-4
   - 在步骤 3 中选择 "System Interpreter"
   - 选择系统 Python 路径（如 `/usr/bin/python3`）

3. **安装依赖**
   ```bash
   pip3 install lxml
   ```

### 方法 3: 通过 IDEA 自动检测

1. **打开 Python 文件**
   - 在 IDEA 中打开任意 `.py` 文件

2. **配置提示**
   - IDEA 会在文件顶部显示黄色提示条
   - 点击 "Configure Python Interpreter"
   - 选择或添加 Python SDK

3. **选择解释器**
   - 选择现有的系统 Python
   - 或创建新的虚拟环境

## 验证配置

配置完成后，验证是否正确：

1. **检查文件头部**
   - 打开 Python 文件，不应再有黄色警告条

2. **测试代码补全**
   - 输入 `import lxml` 然后按 `Ctrl + Space`
   - 应该能看到代码补全提示

3. **运行测试**
   - 右键点击 `test_simple_classifier.py`
   - 选择 "Run 'test_simple_classifier'"
   - 或使用快捷键：`Ctrl + Shift + F10`

## 常见问题

### Q1: 找不到 venv 目录
**A**: 先运行 `setup_python_env.sh` 脚本创建虚拟环境

### Q2: pip install 失败
**A**: 
```bash
# 升级 pip
python3 -m pip install --upgrade pip

# 或使用国内镜像
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple lxml
```

### Q3: IDEA 仍然报错
**A**: 
- 重启 IDEA
- File → Invalidate Caches / Restart
- 选择 "Invalidate and Restart"

### Q4: 多个 Python 版本
**A**: 确保使用 Python 3.8 或更高版本
```bash
python3 --version
# 应该显示 Python 3.8.x 或更高
```

## 项目模块结构

配置完成后，项目结构应该如下：

```
lens-migration-core/
├── venv/                          # Python 虚拟环境（配置后）
│   ├── bin/python3               # Python 解释器
│   └── lib/python3.x/site-packages/
├── src/main/python/              # 标记为 Sources Root
│   └── lens_migration/
│       ├── __init__.py
│       ├── intent_parser.py
│       ├── xslt_generator.py
│       └── validator.py
└── tests/
    ├── test_simple_classifier.py
    └── run_test.py
```

## IntelliJ IDEA 配置文件

IDEA 会自动创建以下配置文件：
- `.idea/modules.xml` - 模块配置
- `.idea/misc.xml` - 项目 SDK 配置
- `.idea/lens-migration-core.iml` - 模块文件

这些文件会自动生成，无需手动创建。

## 快速配置命令

一键配置（推荐）：
```bash
cd /home/zhenac/my/lens_2026/migration/lens-migration-core

# 1. 创建虚拟环境
bash setup_python_env.sh

# 2. 激活虚拟环境
source venv/bin/activate

# 3. 测试安装
python3 -c "from lxml import etree; print('✓ lxml available')"

# 4. 运行测试
python3 tests/run_test.py
```

然后在 IDEA 中：
1. `Ctrl + Alt + Shift + S` 打开 Project Structure
2. 添加 SDK，选择 `venv/bin/python3`
3. 配置模块使用该 SDK
4. 完成！

## 参考资料

- [IntelliJ IDEA Python 插件文档](https://www.jetbrains.com/help/idea/python.html)
- [Python 虚拟环境指南](https://docs.python.org/3/library/venv.html)
- 项目快速开始: `QUICKSTART.md`
- 实现文档: `IMPLEMENTATION.md`

---

**最后更新**: 2026-03-02  
**适用版本**: IntelliJ IDEA 2023.x+
