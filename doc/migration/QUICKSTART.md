# lens-migration-core - 快速开始

## 项目结构

```
lens-migration-core/
├── src/main/python/     # 源码（lens_migration 包）
├── tests/               # 测试用例
│   ├── ai/              # AI 模块单元 + 集成测试
│   ├── simple-classifier-test/
│   └── vlan-policy-test/
├── scripts/             # 脚本
│   ├── run_live_tests.sh      # 一键运行 Live 集成测试
│   ├── setup_python_env.sh    # 初始化 Python 环境
│   ├── test_connections.py    # GitHub + Ollama 连接测试
│   └── start_ollama_local.sh  # 本地 Ollama 优化启动
├── examples/            # 示例代码
├── conftest.py          # pytest 配置（必须在根目录）
├── pytest.ini           # pytest 选项
└── .env.test            # 环境变量（不提交 git，需自行创建）

# 文档统一放在项目根目录 doc/migration/ 下
lens_2026/doc/migration/
├── QUICKSTART.md               # 本文件
├── IMPLEMENTATION.md           # 实现总结
├── IDEA_PYTHON_SETUP.md        # IDEA Python 环境配置
├── HARDWARE_AND_MODEL_GUIDE.md # 硬件配置与模型选型
├── roadmap.md                  # 研发路线图
└── HISTORY.md                  # 变更历史
```

## 安装依赖

```bash
cd /home/zhenac/my/lens_2026/migration/lens-migration-core

# 创建虚拟环境并安装依赖（一键）
bash scripts/setup_python_env.sh

# 或手动
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

## 配置环境变量

创建 `.env.test` 文件（不提交 git），填入 API Key：

```bash
cat > .env.test << 'EOF'
# GitHub Models（获取：https://github.com/settings/tokens）
GITHUB_TOKEN=ghp_your_token_here

# 本地 Ollama 模型（需先 ollama pull qwen3:8b）
OLLAMA_MODEL=qwen3:8b
EOF
```

## 运行测试

### 离线 Mock 测试（无需 API Key）

```bash
venv/bin/python3 -m pytest tests/ai/test_phase2_ai.py::TestMockLLMClient -v
venv/bin/python3 -m pytest tests/ai/test_phase2_ai.py::TestCreateLLMClient -v
```

### Live 集成测试（需要配置 .env.test）

```bash
# 一键运行所有 Live 测试（含 GitHub + Ollama + vlan-policy-test）
bash scripts/run_live_tests.sh

# 只运行 GitHub 测试
venv/bin/python3 -m pytest tests/ai/test_phase2_ai.py::TestGitHubModelsLiveIntegration -v -s

# 只运行 Ollama 测试（需先 ollama serve && ollama pull qwen3:8b）
venv/bin/python3 -m pytest tests/ai/test_phase2_ai.py::TestOllamaLiveIntegration -v -s

# API 连通性测试
venv/bin/python3 -m pytest tests/ai/test_api_connectivity.py -v -s

# vlan-policy-test（GitHub + Ollama 两个独立 case）
venv/bin/python3 -m pytest tests/vlan-policy-test/validation/test_vlan_github.py -v -s
venv/bin/python3 -m pytest tests/vlan-policy-test/validation/test_vlan_ollama.py -v -s
```

### IDEA 里运行

直接点击测试类左侧的运行按钮即可，`conftest.py` 会自动加载 `.env.test`，
不需要在 Run Configuration 里手动填 Environment variables。

## 文档

所有文档位于 `doc/migration/`（项目根目录）：

- 实现总结: `doc/migration/IMPLEMENTATION.md`
- IDEA Python 环境配置: `doc/migration/IDEA_PYTHON_SETUP.md`
- 硬件配置与模型选型: `doc/migration/HARDWARE_AND_MODEL_GUIDE.md`
- 研发路线图: `doc/migration/roadmap.md`
- 变更历史: `doc/migration/HISTORY.md`
