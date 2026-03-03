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
- 如果 classifier-entry 的 name 是 `high-priority-classifier`（或重命名后的 `priority-high-class`）
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

## 迁移优先级

1. **高优先级**: 重命名操作（规则 1）
2. **高优先级**: 修改值操作（规则 2）
3. **中优先级**: 添加新元素（规则 3）
4. **低优先级**: 删除元素（规则 4）

## 测试验证

### 验证点 1: 名称正确重命名
```xpath
count(//classifier-entry[name='priority-high-class']) = 1
count(//classifier-entry[name='high-priority-classifier']) = 0
```

### 验证点 2: 流量类别值正确修改
```xpath
//classifier-entry[name='priority-high-class']/
  classifier-action-entry-cfg/scheduling-traffic-class = 0
```

### 验证点 3: 新分类器已添加
```xpath
count(//classifier-entry[name='medium-priority-classifier']) = 1
//classifier-entry[name='medium-priority-classifier']/
  classifier-action-entry-cfg/scheduling-traffic-class = 2
```

### 验证点 4: 旧分类器已删除
```xpath
count(//classifier-entry[name='best-effort-classifier']) = 0
```

### 验证点 5: 保留的分类器不变
```xpath
count(//classifier-entry[name='low-priority-classifier']) = 1
//classifier-entry[name='low-priority-classifier']/
  classifier-action-entry-cfg/scheduling-traffic-class = 4
```

### 验证点 6: 总分类器数量
```xpath
count(//classifier-entry) = 3
```

## 边界情况处理

### 情况 1: 输入没有 high-priority-classifier
- **处理**: 跳过规则 1 和规则 2
- **期望**: 其他规则正常执行

### 情况 2: 输入已经有 medium-priority-classifier
- **处理**: 不重复添加
- **期望**: 保持已有的配置

### 情况 3: 输入没有 best-effort-classifier
- **处理**: 跳过规则 4
- **期望**: 不产生错误

## 默认值处理

如果某些节点在输入中缺失，使用以下默认值：
- `description`: 空字符串
- `filter-operation`: `match-any-filter`（默认值）

## AI 提示词建议

```
请生成一个XSLT 2.0转换文件，实现以下QoS分类器配置迁移：

1. 将名为 'high-priority-classifier' 的分类器重命名为 'priority-high-class'
2. 将该分类器的流量类别值从 1 改为 0
3. 添加一个新的 'medium-priority-classifier'，流量类别为 2
4. 删除 'best-effort-classifier' 分类器
5. 保持 'low-priority-classifier' 不变

输入XML以 <classifiers> 为根节点，命名空间为 urn:bbf:yang:bbf-qos-classifiers。
请确保生成的XSLT使用identity template作为基础，只转换需要修改的部分。
```

## 注意事项

1. **命名空间**: 必须正确处理 `urn:bbf:yang:bbf-qos-classifiers` 命名空间
2. **顺序**: 分类器的顺序可能影响处理结果，需要保持或明确指定
3. **属性保留**: 所有未明确修改的属性和子元素必须保留
4. **空值处理**: 空的 `description` 应保留为空字符串，不应删除元素

---

**创建日期**: 2026-02-28  
**测试类型**: 简单迁移  
**复杂度**: 低  
**预期用时**: AI 生成 < 30 秒
