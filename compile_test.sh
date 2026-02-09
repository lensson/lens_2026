#!/bin/bash

# Lens 2026 编译测试脚本

set -e

echo "========================================="
echo "Lens 2026 - Maven 编译测试"
echo "========================================="
echo ""

cd /home/zhenac/my/lens_2026

echo "📦 编译parent-poms模块..."
mvn -f parent-poms/pom.xml clean install -q
if [ $? -eq 0 ]; then
    echo "✅ parent-poms 编译成功"
else
    echo "❌ parent-poms 编译失败"
    exit 1
fi

echo ""
echo "📦 编译infra模块..."
mvn -f infra/pom.xml clean install -q
if [ $? -eq 0 ]; then
    echo "✅ infra 编译成功"
else
    echo "❌ infra 编译失败"
    exit 1
fi

echo ""
echo "📦 编译common模块..."
mvn -f common/pom.xml clean install -q
if [ $? -eq 0 ]; then
    echo "✅ common 编译成功"
else
    echo "❌ common 编译失败"
    exit 1
fi

echo ""
echo "📦 编译platform模块..."
mvn -f platform/pom.xml clean install -q
if [ $? -eq 0 ]; then
    echo "✅ platform 编译成功"
else
    echo "❌ platform 编译失败"
    exit 1
fi

echo ""
echo "📦 编译lens-blog模块..."
mvn -f lens-blog/pom.xml clean install -q
if [ $? -eq 0 ]; then
    echo "✅ lens-blog 编译成功"
else
    echo "❌ lens-blog 编译失败"
    exit 1
fi

echo ""
echo "========================================="
echo "✅ 所有模块编译成功!"
echo "========================================="
