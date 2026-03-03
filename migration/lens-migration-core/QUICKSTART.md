# lens-migration-core - 快速开始

## 安装依赖

```bash
cd /home/zhenac/my/lens_2026/migration/lens-migration-core

# 创建虚拟环境（推荐）
python3 -m venv venv
source venv/bin/activate

# 安装依赖
pip install -r requirements.txt
```

## 运行测试

### 使用测试脚本

```bash
python3 tests/run_test.py
```

### 使用命令行

```bash
python3 -m lens_migration \
  --intent tests/simple-classifier-test/migration/migration-intent-v1-to-v2.md \
  --input-xml tests/simple-classifier-test/old-version/input-v1.xml \
  --expected-output tests/simple-classifier-test/new-version/expected-output-v2.xml \
  --output-xslt tests/simple-classifier-test/migration/auto-generated-transform.xslt
```

## 查看结果

生成的文件将保存在：
- XSLT: `tests/simple-classifier-test/migration/auto-generated-transform.xslt`
- 实际输出: `tests/simple-classifier-test/migration/actual-output.xml`

## 下一步

1. 查看生成的 XSLT
2. 对比 actual-output.xml 和 expected-output-v2.xml
3. 分析生成质量
4. 迭代改进

## 文档

- 实现总结: `IMPLEMENTATION.md`
- 测试用例: `tests/simple-classifier-test/README.md`
- XSLT 生成过程: `tests/simple-classifier-test/XSLT_GENERATION_PROCESS.md`
