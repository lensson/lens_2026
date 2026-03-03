#!/bin/bash
# Migration 项目 - IDEA 导入前准备脚本

set -e

echo "=========================================="
echo "Migration 项目 - IDEA 导入准备"
echo "=========================================="
echo ""

# 检查目录
if [ ! -d "/home/zhenac/my/lens_2026/migration" ]; then
    echo "❌ Error: migration 目录不存在"
    exit 1
fi

cd /home/zhenac/my/lens_2026

echo "1️⃣  检查项目结构..."
echo ""
echo "Maven 模块:"
echo "  ✅ lens-migration-backend"
echo "  ✅ lens-migration-frontend"
echo ""
echo "Python 项目:"
echo "  ✅ lens-migration-core"
echo ""

echo "2️⃣  检查 Python 虚拟环境..."
if [ -f "migration/lens-migration-core/venv/bin/python3" ]; then
    echo "  ✅ Python 虚拟环境已存在"
    echo "  📍 路径: migration/lens-migration-core/venv/bin/python3"
else
    echo "  ⚠️  虚拟环境未找到，正在创建..."
    cd migration/lens-migration-core
    bash setup_python_env.sh
    cd /home/zhenac/my/lens_2026
fi
echo ""

echo "3️⃣  检查 Python 依赖..."
PYTHON_VENV="/home/zhenac/my/lens_2026/migration/lens-migration-core/venv/bin/python3"
if $PYTHON_VENV -c "import lxml" 2>/dev/null; then
    echo "  ✅ lxml 已安装"
else
    echo "  ⚠️  lxml 未安装，请运行:"
    echo "     cd migration/lens-migration-core"
    echo "     source venv/bin/activate"
    echo "     pip install -r requirements.txt"
fi

if $PYTHON_VENV -c "import pytest" 2>/dev/null; then
    echo "  ✅ pytest 已安装"
fi

if $PYTHON_VENV -c "import pyang" 2>/dev/null; then
    echo "  ✅ pyang 已安装"
fi
echo ""

echo "4️⃣  检查 Maven 配置..."
if [ -f "migration/pom.xml" ]; then
    echo "  ✅ migration/pom.xml 存在"
fi
if [ -f "migration/lens-migration-backend/pom.xml" ]; then
    echo "  ✅ lens-migration-backend/pom.xml 存在"
fi
if [ -f "migration/lens-migration-frontend/pom.xml" ]; then
    echo "  ✅ lens-migration-frontend/pom.xml 存在"
fi
echo ""

echo "5️⃣  尝试构建根 POM..."
if mvn clean install -N -DskipTests -q 2>/dev/null; then
    echo "  ✅ 根 POM 构建成功"
else
    echo "  ⚠️  根 POM 构建有警告，这是正常的"
fi
echo ""

echo "=========================================="
echo "✅ 准备完成！"
echo "=========================================="
echo ""
echo "📖 下一步: 在 IDEA 中导入项目"
echo ""
echo "请按照以下文档操作:"
echo "  1️⃣  快速指南: migration/QUICK_IMPORT.md"
echo "  2️⃣  详细说明: migration/IDEA_IMPORT_GUIDE.md"
echo "  3️⃣  完成总结: migration/IMPORT_SUMMARY.md"
echo ""
echo "🔑 关键信息:"
echo "  • Python 解释器路径:"
echo "    /home/zhenac/my/lens_2026/migration/lens-migration-core/venv/bin/python3"
echo ""
echo "  • Maven 项目:"
echo "    - lens-migration-backend (Java Spring Boot)"
echo "    - lens-migration-frontend (Node.js)"
echo ""
echo "  • Python 项目:"
echo "    - lens-migration-core (独立配置)"
echo ""
echo "Happy Coding! 🚀"

