# 迁移意图文档：VLAN Sub-interfaces Policy v1 to v2

## 版本信息

- **源版本**: v1
- **目标版本**: v2
- **模块**: bbf-sub-interfaces / bbf-vlan-sub-interfaces
- **根节点**: `/interfaces`

## 迁移场景

设备固件从 v1 升级到 v2 时，VLAN sub-interface 的配置结构发生了以下变化：
- 旧版中 `ingress-rule` 下的 VLAN 匹配使用 `vlan-tag-match-type` 字段，新版改为 `match-criteria`
- 旧版 `egress-rewrite` 操作类型名称从 `push-vlan` 改为 `push-2-tags`，以明确双标签场景
- 旧版中 `priority` 字段存在于 ingress-rule 下，新版移至 `match-criteria/dot1q-tag` 下作为子元素
- 旧版某些 sub-interface 使用废弃的 `legacy-mode` 标志，需要删除
- 新版要求所有 sub-interface 必须包含 `admin-state` 字段，默认值为 `enabled`

## 迁移规则

### 规则 1: 重命名 egress-rewrite 操作类型

**描述**: 将所有 `egress-rewrite/pop-and-push-vlan` 元素重命名为 `pop-and-push-2-tags`

**XPath**: `/interfaces/interface/subif-lower-layer/inline-frame-processing/egress-rewrite/pop-and-push-vlan`

**迁移动作**:
- 找到所有 `pop-and-push-vlan` 元素
- 将元素名改为 `pop-and-push-2-tags`
- 保留所有子元素不变

**XSLT 实现思路**:
```xslt
<xsl:template match="ns:pop-and-push-vlan">
  <pop-and-push-2-tags>
    <xsl:apply-templates select="@*|node()"/>
  </pop-and-push-2-tags>
</xsl:template>
```

---

### 规则 2: 修改 VLAN ID 值

**描述**: 将 sub-interface `eth0.100` 的 ingress 匹配 VLAN ID 从 `100` 改为 `101`，反映 v2 VLAN 重新规划

**XPath**: `/interfaces/interface[name='eth0.100']/subif-lower-layer/inline-frame-processing/ingress-rule/rule/match-criteria/dot1q-tag/vlan-id`

**重要约束**:
- **只修改** interface name 为 `eth0.100` 下的 `ingress-rule` 中的 `vlan-id`
- **不修改** `eth0.200` 或其他任何 interface 的 vlan-id
- **不修改** `egress-rewrite` 部分的 `push-tag` 下的 vlan-id（保持 100）
- 其他所有 vlan-id 值保持原样

**迁移动作**:
- 仅匹配 interface name 为 `eth0.100` 下 ingress-rule 内的 vlan-id 元素
- 将该 vlan-id 的值从 `100` 修改为 `101`

**XSLT 实现思路**:
```xslt
<xsl:template match="ns:interface[ns:name='eth0.100']
                     /ns:subif-lower-layer/ns:inline-frame-processing
                     /ns:ingress-rule/ns:rule/ns:match-criteria
                     /ns:dot1q-tag/ns:vlan-id">
  <vlan-id>101</vlan-id>
</xsl:template>
```

---

### 规则 3: 新增 admin-state 字段

**描述**: 在每个 `interface` 元素中添加 `admin-state` 子元素，值为 `enabled`

**XPath**: `/interfaces/interface`

**迁移动作**:
- 对每个 `interface` 元素，在其所有子元素之前插入 `<admin-state>enabled</admin-state>`
- 如果已存在 `admin-state`，则保留原值，不重复添加

**XSLT 实现思路**:
```xslt
<xsl:template match="ns:interface">
  <interface>
    <xsl:if test="not(ns:admin-state)">
      <admin-state>enabled</admin-state>
    </xsl:if>
    <xsl:apply-templates select="@*|node()"/>
  </interface>
</xsl:template>
```

---

### 规则 4: 删除废弃的 legacy-mode 字段

**描述**: 删除所有 `interface` 下的 `legacy-mode` 元素（v2 中该字段已废弃移除）

**XPath**: `/interfaces/interface/legacy-mode`

**迁移动作**:
- 找到所有 `legacy-mode` 元素
- 将其完全删除，不复制到输出

**XSLT 实现思路**:
```xslt
<xsl:template match="ns:legacy-mode">
  <!-- 删除：不输出任何内容 -->
</xsl:template>
```

---

## 验证要点

1. `pop-and-push-vlan` 元素全部重命名为 `pop-and-push-2-tags`，子元素保留完整
2. `eth0.100` 的 vlan-id 从 `100` 变为 `101`，其他 interface 的 vlan-id 不变
3. 所有 `interface` 都包含 `admin-state` 字段，值为 `enabled`
4. 所有 `legacy-mode` 元素被删除
5. 其余元素结构和内容保持不变（Identity Transform）

