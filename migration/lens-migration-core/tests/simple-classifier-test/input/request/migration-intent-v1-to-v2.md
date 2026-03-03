# 迁移意图文档：QoS Classifiers v1 to v2

## 版本信息

- **源版本**: v1
- **目标版本**: v2
- **模块**: bbf-qos-classifiers
- **根节点**: `/classifiers`

## 迁移场景

这是一个简单的QoS分类器配置迁移测试用例。

## 迁移规则

### 规则 1: 重命名分类器

**描述**: 将高优先级分类器的名称从 `high-priority-classifier` 重命名为 `priority-high-class`

**XPath**: `/classifiers/classifier-entry[name='high-priority-classifier']/name`

**迁移动作**:
- 如果找到名称为 `high-priority-classifier` 的 classifier-entry
- 将其 `name` 元素的值改为 `priority-high-class`
- 保持其他属性和子元素不变

**XSLT 实现思路**:
```xslt
<xsl:template match="classifier-entry[name='high-priority-classifier']/name">
  <name>priority-high-class</name>
</xsl:template>
```

---

### 规则 2: 修改流量类别值

**描述**: 将高优先级分类器的流量类别从 1 改为 0

**XPath**: `/classifiers/classifier-entry[name='high-priority-classifier']/classifier-action-entry-cfg/scheduling-traffic-class`

**迁移动作**:
- 如果 classifier-entry 的 name 是 `high-priority-classifier`
- 将 `scheduling-traffic-class` 的值从 `1` 改为 `0`

**XSLT 实现思路**:
```xslt
<xsl:template match="classifier-entry[name='high-priority-classifier']/
                     classifier-action-entry-cfg/scheduling-traffic-class">
  <scheduling-traffic-class>0</scheduling-traffic-class>
</xsl:template>
```

---

### 规则 3: 添加新分类器

**描述**: 添加一个新的中等优先级分类器

**迁移动作**:
- 在 `classifiers` 容器中添加一个新的 `classifier-entry`
- 名称: `medium-priority-classifier`
- 描述: "Classifier for medium priority traffic with P-bit 4 and 5"
- 流量类别: 2

**XSLT 实现思路**:
```xslt
<xsl:template match="classifiers">
  <classifiers>
    <xsl:apply-templates select="classifier-entry[name='high-priority-classifier']"/>

    <!-- 添加新的中等优先级分类器 -->
    <classifier-entry>
      <name>medium-priority-classifier</name>
      <description>Classifier for medium priority traffic with P-bit 4 and 5</description>
      <classifier-action-entry-cfg>
        <action-type>scheduling-traffic-class</action-type>
        <scheduling-traffic-class>2</scheduling-traffic-class>
      </classifier-action-entry-cfg>
    </classifier-entry>

    <xsl:apply-templates select="classifier-entry[name='low-priority-classifier']"/>
  </classifiers>
</xsl:template>
```

---

### 规则 4: 删除分类器

**描述**: 删除 `best-effort-classifier` 分类器

**XPath**: `/classifiers/classifier-entry[name='best-effort-classifier']`

**迁移动作**:
- 如果找到名称为 `best-effort-classifier` 的 classifier-entry
- 将其完全删除（不复制到输出）

**XSLT 实现思路**:
```xslt
<!-- 匹配但不输出，即删除 -->
<xsl:template match="classifier-entry[name='best-effort-classifier']"/>
```

---

## 测试 Sample 说明

| Sample | old-version 文件 | new-version 文件 | 说明 |
|--------|-----------------|-----------------|------|
| sample-01 | classifier-sample-01-v1.xml | classifier-sample-01-v2.xml | 3条entry（标准用例） |
| sample-02 | classifier-sample-02-v1.xml | classifier-sample-02-v2.xml | 5条entry（含更多分类器） |

## 注意事项

1. **命名空间**: 必须正确处理 `urn:bbf:yang:bbf-qos-classifiers` 命名空间
2. **顺序**: 输出中 classifier-entry 的顺序按规则 3 的模板决定
3. **属性保留**: 所有未明确修改的属性和子元素必须保留

