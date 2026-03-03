<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:bbf-qos-filt="urn:bbf:yang:bbf-qos-filters" xmlns:bbf-qos-enhfilt="urn:bbf:yang:bbf-qos-enhanced-filters" xmlns:bbf-qos-pol="urn:bbf:yang:bbf-qos-policies" xmlns:bbf-qos-cls="urn:bbf:yang:bbf-qos-classifiers" xmlns:bbf-qos-plc="urn:bbf:yang:bbf-qos-policing" xmlns:nokia-qos-filt="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-qos-filters-ext" xmlns:nokia-sdan-qos-policing-extension="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension" xmlns:nokia-qos-cls-ext="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-classifier-extension" xmlns="" version="1.0">

  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" indent="yes"/>

  <!-- default rule -->
  <xsl:template match="*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!-- update counter for policing profile -->
  <xsl:template match="*[     local-name() = 'policing-profile'     and parent::*[local-name() = 'policing-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policing']   ]">
    <xsl:variable name="curRealName">
      <xsl:value-of select="child::*[local-name() = 'realName']"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="boolean($curRealName) and string-length(normalize-space($curRealName))&gt;0">
        <xsl:copy>
          <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
<xsl:variable name="sameElementNumber" select="count(//*[               local-name() = 'policing-profile'               and parent::*[local-name() = 'policing-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policing']               and child::*[local-name() = 'realName' and text() = $curRealName]           ])"/>
          <xsl:element name="counter" namespace="urn:bbf:yang:bbf-qos-policing">
            <xsl:value-of select="$sameElementNumber"/>
          </xsl:element>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- update counter for classifier profile -->
  <xsl:template match="*[     local-name() = 'classifier-entry'     and parent::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']   ]">
    <xsl:variable name="curRealName">
      <xsl:value-of select="child::*[local-name() = 'realName']"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="boolean($curRealName) and string-length(normalize-space($curRealName))&gt;0">
        <xsl:copy>
          <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
<xsl:variable name="sameElementNumber" select="count(//*[               local-name() = 'classifier-entry'               and parent::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']               and child::*[local-name() = 'realName' and text() = $curRealName]           ])"/>
          <xsl:element name="counter" namespace="urn:bbf:yang:bbf-qos-classifiers">
            <xsl:value-of select="$sameElementNumber"/>
          </xsl:element>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- update counter for policy profile -->
  <xsl:template match="*[     local-name() = 'policy'     and parent::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']   ]">
    <xsl:variable name="curRealName">
      <xsl:value-of select="child::*[local-name() = 'realName']"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="boolean($curRealName) and string-length(normalize-space($curRealName))&gt;0">
        <xsl:copy>
          <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
<xsl:variable name="sameElementNumber" select="count(//*[               local-name() = 'policy'               and parent::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']               and child::*[local-name() = 'realName' and text() = $curRealName]           ])"/>
          <xsl:element name="counter" namespace="urn:bbf:yang:bbf-qos-policies">
            <xsl:value-of select="$sameElementNumber"/>
          </xsl:element>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
 
</xsl:stylesheet>
