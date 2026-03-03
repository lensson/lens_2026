# XSLT 生成过程说明

**版本**: v2（2026-03-03）  
**测试用例**: simple-classifier-test

---

## 目录结构

```
simple-classifier-test/
├── input/
│   ├── migration-intent-v1-to-v2.md    # 迁移需求文档（人工编写）
│   ├── input-v1.xml                    # 源版本 XML 输入样本
│   └── expected-output-v2.xml          # 期望输出 XML
├── output/
│   ├── generated-transform.xslt        # 手写验证 XSLT（参考基准）
│   └── e2e-generated-transform.xslt    # 代码自动生成的 XSLT（测试产物）
└── validation/
    ├── TEST_RESULTS.md                  # 测试结果
    └── XSLT_GENERATION_PROCESS.md      # 本文件
```

---

## 迁移场景

基于 `bbf-qos-classifiers` YANG 模块的 QoS 分类器配置从 v1 迁移到 v2。

### 4 条迁移规则

| 规则 | 类型 | 说明 |
|------|------|------|
| 规则 1 | RENAME | `high-priority-classifier` → `priority-high-class` |
| 规则 2 | MODIFY_VALUE | `scheduling-traffic-class` 值 1 → 0 |
| 规则 3 | ADD_NODE | 新增 `medium-priority-classifier`（class=2） |
| 规则 4 | DELETE_NODE | 删除 `best-effort-classifier` |

---

## 代码生成流程

```
input/migration-intent-v1-to-v2.md
        │
        ▼
  IntentParser.parse()
        │  解析出 4 条 MigrationRule
        ▼
  XSLTGenerator.generate(intent, input_xml, expected_output)
        │  1. 解析 input-v1.xml 提取命名空间: urn:bbf:yang:bbf-qos-classifiers
        │  2. 生成 XSLT header（xmlns:ns 声明）
        │  3. 生成 Identity Template（@*|node() 默认复制）
        │  4. 逐条规则生成模板（优先使用 xslt_hint）
        │     - 规则4(delete): <xsl:template match="ns:classifier-entry[...]"/>
        │     - 规则1(rename): match 旧名，输出新名
        │     - 规则2(modify): match 旧值节点，输出新值
        │     - 规则3(add):    重建 classifiers 容器，插入新条目
        ▼
  output/e2e-generated-transform.xslt
        │
        ▼
  XSLTValidator.validate(xslt, input_v1.xml, expected_output_v2.xml)
        │  - 语法验证（lxml XSLT parse）
        │  - 变换执行（input → actual output）
        │  - 语义比较（去注释/空白后与 expected 比较）
        ▼
  ✅ 21/21 测试通过
```

---

## 关键设计：优先使用 xslt_hint

`XSLTGenerator` 在生成每条规则的模板时，优先使用意图文档里 `xslt_hint` 代码块（已由人工验证），
只在没有 hint 时才用代码推导。

对 hint 的处理：
1. 把 `match=`/`select=` 属性值里的无前缀 XML 元素名加 `ns:` 前缀
2. 字符串字面量（`'...'`）内部不处理
3. XSLT 关键字（`and`/`or`/`not`/`text` 等）不处理

---

## 运行测试

```bash
cd migration/lens-migration-core
venv/bin/python3 -m pytest tests/test_e2e_simple_classifier.py -v
```

