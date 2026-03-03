<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ns="urn:bbf:yang:bbf-qos-classifiers"
                xmlns="urn:bbf:yang:bbf-qos-classifiers"
                exclude-result-prefixes="ns">

  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

  <!-- Identity Template：默认行为，原样复制所有节点和属性 -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!--
    规则: 重命名分类器
    类型: rename
  -->
  <xsl:template match="ns:classifier-entry[ns:name='high-priority-classifier']/ns:name">
    <name>priority-high-class</name>
  </xsl:template>

  <!--
    规则: 修改流量类别值
    类型: modify_value
  -->
  <xsl:template match="ns:classifier-entry[ns:name='high-priority-classifier']/
                       ns:classifier-action-entry-cfg/ns:scheduling-traffic-class">
    <scheduling-traffic-class>0</scheduling-traffic-class>
  </xsl:template>

  <!--
    规则: 添加新分类器
    类型: add_node
  -->
  <xsl:template match="ns:classifiers">
    <classifiers>
      <xsl:apply-templates select="ns:classifier-entry[ns:name='high-priority-classifier']"/>

      <!-- 添加新的中等优先级分类器 -->
      <classifier-entry>
        <name>medium-priority-classifier</name>
        <description>Classifier for medium priority traffic with P-bit 4 and 5</description>
        <classifier-action-entry-cfg>
          <action-type>scheduling-traffic-class</action-type>
          <scheduling-traffic-class>2</scheduling-traffic-class>
        </classifier-action-entry-cfg>
      </classifier-entry>

      <xsl:apply-templates select="ns:classifier-entry[ns:name='low-priority-classifier']"/>
    </classifiers>
  </xsl:template>

  <!--
    规则: 删除分类器
    类型: delete_node
  -->
  <!-- 匹配但不输出，即删除 -->
  <xsl:template match="ns:classifier-entry[ns:name='best-effort-classifier']"/>

</xsl:stylesheet>