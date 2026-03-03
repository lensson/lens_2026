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

  <xsl:variable name="DELETEFROMPOLICY" select="'DELETEFROMPOLICY'"/>
  <xsl:variable name="POLICY_TYPE_MARKER" select="'POLICY_TYPE_MARKER'"/>

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
    <xsl:variable name="policySec" select="parent::*[local-name() = 'policy']"/>
    <xsl:variable name="isMarkerPolicy" select="$policySec/policy-migration-cache/child::*[local-name()='policy-type' and text()=$POLICY_TYPE_MARKER]"/>
    <xsl:variable name="isDelete">
      <xsl:value-of select="current()/child::*[local-name() = 'delete']"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$isMarkerPolicy=$POLICY_TYPE_MARKER">
        <xsl:choose>
          <xsl:when test="$isDelete=$DELETEFROMPOLICY">
            <!-- delete labeled policy -->
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy>
              <xsl:copy-of select="@*"/>
              <xsl:apply-templates/>
            </xsl:copy>
          </xsl:otherwise>
        </xsl:choose>
        <!-- delete labeled policy -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:apply-templates/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- clean policy-migration-cache -->
  <xsl:template match="*[
    local-name() = 'policy-migration-cache'
    and parent::*[local-name() = 'policy']
    and ancestor::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']
  ]">
  </xsl:template>
</xsl:stylesheet>
