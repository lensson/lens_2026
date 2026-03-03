<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:newns="http://tail-f.com/ns/confd_dyncfg/1.0" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

<xsl:param name="confdNS" select="'http://tail-f.com/ns/confd_dyncfg/1.0'"/>

<!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

  <!-- Add topLevelCmdsInSubMode=true when not there -->
  <xsl:template match="*[name() = 'cli']">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
      <xsl:if test="namespace-uri() = $confdNS and ./parent::*[name()='confdConfig']">
        <xsl:if test="not(./child::*[name()='topLevelCmdsInSubMode'])">
          <xsl:element name="topLevelCmdsInSubMode" namespace="http://tail-f.com/ns/confd_dyncfg/1.0">true</xsl:element>
        </xsl:if>
      </xsl:if>
    </xsl:copy>
  </xsl:template>

  <!-- Overwrite topLevelCmdsInSubMode=0 with true-->
  <xsl:template match="*[name() = 'topLevelCmdsInSubMode' and text()='false']">
    <xsl:choose>
      <xsl:when test="namespace-uri() = $confdNS and ./parent::*[name()='cli'] and ./ancestor::*[name()='confdConfig']">
          <xsl:element name="topLevelCmdsInSubMode" namespace="http://tail-f.com/ns/confd_dyncfg/1.0">true</xsl:element>
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
