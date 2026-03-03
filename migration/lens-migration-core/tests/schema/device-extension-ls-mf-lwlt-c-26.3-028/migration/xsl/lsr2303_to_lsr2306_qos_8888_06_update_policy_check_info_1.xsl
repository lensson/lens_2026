<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:bbf-qos-filt="urn:bbf:yang:bbf-qos-filters"
                xmlns:bbf-qos-enhfilt="urn:bbf:yang:bbf-qos-enhanced-filters"
                xmlns:bbf-qos-pol="urn:bbf:yang:bbf-qos-policies"
                xmlns:bbf-qos-cls="urn:bbf:yang:bbf-qos-classifiers"
                xmlns:bbf-qos-plc="urn:bbf:yang:bbf-qos-policing"
                xmlns:nokia-qos-filt="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-qos-filters-ext"
                xmlns:nokia-sdan-qos-policing-extension="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension"
                xmlns:nokia-qos-cls-ext="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-classifier-extension"
                version="1.0">

  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" indent="yes"/>

  <xsl:variable name="POLICY_TYPE_MARKER" select="'POLICY_TYPE_MARKER'"/>
  <xsl:variable name="CLASSIFIERDELETE" select="'CLASSIFIERDELETE'"/>
  <xsl:variable name="DELETEFROMPOLICY" select="'DELETEFROMPOLICY'"/>

  <!-- default rule -->
  <xsl:template match="*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="*[    
    local-name() = 'classifiers'
    and parent::*[local-name() = 'policy']
    and ancestor::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']
  ]">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>

      <xsl:variable name="policySec" select="parent::*[local-name() = 'policy']"/>
      <xsl:variable name="curClsName" select="current()/child::*[local-name() = 'name']"/>
      <xsl:variable name="isMarkerPolicy" select="$policySec/policy-migration-cache/child::*[local-name()='policy-type' and text()=$POLICY_TYPE_MARKER]"/>

      <xsl:if test="$isMarkerPolicy=$POLICY_TYPE_MARKER">
        <xsl:variable name="selectedCls" select="$policySec/policy-migration-cache/classifiers/classifier[child::*[local-name() = 'name' and text()=$curClsName]]"/>
        <xsl:variable name="isNeedToDelete">
          <xsl:if test="$selectedCls">
            <xsl:value-of select="$selectedCls/child::*[local-name() = 'delete']"/>
          </xsl:if>
        </xsl:variable>

        <xsl:if test="$isNeedToDelete=$CLASSIFIERDELETE">
          <xsl:element name="delete">
            <xsl:value-of select="$DELETEFROMPOLICY"/>
          </xsl:element>
        </xsl:if>
      </xsl:if>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
