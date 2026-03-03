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


  <!-- Add clientAliveInterval=300s when not there
       Add idleConnectionTimeout=1s when not there -->
  <xsl:template match="*[name() = 'ssh'] ">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
      <xsl:if test="namespace-uri() = $confdNS and ./parent::*[name()='confdConfig']">
        <xsl:if test="not(./child::*[name()='clientAliveInterval'])">
          <xsl:element name="clientAliveInterval" namespace="http://tail-f.com/ns/confd_dyncfg/1.0">PT300S</xsl:element>
        </xsl:if>
        <xsl:if test="not(./child::*[name()='idleConnectionTimeout'])">
          <xsl:element name="idleConnectionTimeout" namespace="http://tail-f.com/ns/confd_dyncfg/1.0">PT1S</xsl:element>
        </xsl:if>
      </xsl:if>
    </xsl:copy>
  </xsl:template>

  <!-- Overwrite clientAliveInterval=infinity with 300s
       Overwrite idleConnectionTimeout=10m with 1s -->
  <xsl:template match="*[name() = 'clientAliveInterval' and text()='infinity'] ">
    <xsl:choose>
      <xsl:when test="namespace-uri() = $confdNS and ./parent::*[name()='ssh'] and ./ancestor::*[name()='confdConfig'] ">
          <xsl:element name="clientAliveInterval" namespace="http://tail-f.com/ns/confd_dyncfg/1.0">PT300S</xsl:element>
      </xsl:when>
      <xsl:otherwise>
         <xsl:copy>
            <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
      </xsl:otherwise>
   </xsl:choose>
  </xsl:template>

  <xsl:template match="*[name() = 'idleConnectionTimeout' and text()='PT10M'] ">
    <xsl:choose>
      <xsl:when test="namespace-uri() = $confdNS and ./parent::*[name()='ssh'] and ./ancestor::*[name()='confdConfig']">
          <xsl:element name="idleConnectionTimeout" namespace="http://tail-f.com/ns/confd_dyncfg/1.0">PT1S</xsl:element>
      </xsl:when>
      <xsl:otherwise>
         <xsl:copy>
            <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
      </xsl:otherwise>
   </xsl:choose>
  </xsl:template>


  <!-- Add idleTimeout=24h when not there -->
  <xsl:template match="*[name() = 'netconf']">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
      <xsl:if test="namespace-uri() = $confdNS and ./parent::*[name()='confdConfig']">
        <xsl:if test="not(./child::*[name()='idleTimeout'])">
          <xsl:element name="idleTimeout" namespace="http://tail-f.com/ns/confd_dyncfg/1.0">PT24H</xsl:element>
        </xsl:if>
      </xsl:if>
    </xsl:copy>
  </xsl:template>

  <!-- Overwrite idleTimeout=0 with 24h-->
  <xsl:template match="*[name() = 'idleTimeout' and text()='PT0S']">
    <xsl:choose>
      <xsl:when test="namespace-uri() = $confdNS and ./parent::*[name()='netconf'] and ./ancestor::*[name()='confdConfig']">
          <xsl:element name="idleTimeout" namespace="http://tail-f.com/ns/confd_dyncfg/1.0">PT24H</xsl:element>
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
