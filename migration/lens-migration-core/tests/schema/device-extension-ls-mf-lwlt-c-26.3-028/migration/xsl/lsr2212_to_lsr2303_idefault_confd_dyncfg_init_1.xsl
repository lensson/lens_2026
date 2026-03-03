<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:newns="http://tail-f.com/ns/confd_dyncfg/1.0" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

<xsl:param name="dyncfg-ns" select="'http://tail-f.com/ns/confd_dyncfg/1.0'"/>

<!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

<!-- change developerLog -> enabled to true -->
<xsl:template match="*[name() = 'enabled']">
        <xsl:choose>
            <xsl:when test="node() = 'false' and namespace-uri() = $dyncfg-ns and ./parent::*[name()='developerLog']">
		    <xsl:element name="enabled" namespace="http://tail-f.com/ns/confd_dyncfg/1.0"><xsl:text>true</xsl:text></xsl:element>
            </xsl:when>
            <xsl:otherwise>
             <xsl:copy>
                <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
          </xsl:otherwise>
        </xsl:choose>
</xsl:template>

<!-- change developerLog -> file -> name to /isam/logs/confd_internal/devel.log -->
<xsl:template match="*[name() = 'name']">
        <xsl:choose>
            <xsl:when test="namespace-uri() = $dyncfg-ns and ./parent::*[name()='file'] and ./ancestor::*[name()='developerLog']">
		        <xsl:element name="name" namespace="http://tail-f.com/ns/confd_dyncfg/1.0"><xsl:text>/isam/logs/confd_internal/devel.log</xsl:text></xsl:element>
            </xsl:when>
            <xsl:otherwise>
             <xsl:copy>
                <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
          </xsl:otherwise>
        </xsl:choose>
</xsl:template>

<!-- add developerLog if not there, add developerLogLevel if not there -->
<xsl:template match="*[name() = 'logs']">
  <xsl:copy>
      <xsl:copy-of select="@*"/>
<xsl:if test="namespace-uri() = $dyncfg-ns and ./parent::*[name()='confdConfig']">
        <xsl:apply-templates/>
<xsl:if test="not(./child::*[name()='developerLog'])">
            <xsl:element name="developerLog" namespace="http://tail-f.com/ns/confd_dyncfg/1.0">
              <xsl:element name="enabled" namespace="http://tail-f.com/ns/confd_dyncfg/1.0"><xsl:text>true</xsl:text></xsl:element>
              <xsl:element name="file" namespace="http://tail-f.com/ns/confd_dyncfg/1.0">
                <xsl:element name="enabled" namespace="http://tail-f.com/ns/confd_dyncfg/1.0"><xsl:text>true</xsl:text></xsl:element>
                <xsl:element name="name" namespace="http://tail-f.com/ns/confd_dyncfg/1.0"><xsl:text>/isam/logs/confd_internal/devel.log</xsl:text></xsl:element>
              </xsl:element>
              <xsl:element name="syslog" namespace="http://tail-f.com/ns/confd_dyncfg/1.0">
                <xsl:element name="enabled" namespace="http://tail-f.com/ns/confd_dyncfg/1.0"><xsl:text>false</xsl:text></xsl:element>
              </xsl:element>
            </xsl:element>
        </xsl:if>
        <xsl:if test="not(./child::*[name()='developerLogLevel'])">
          <xsl:element name="developerLogLevel" namespace="http://tail-f.com/ns/confd_dyncfg/1.0"><xsl:text>info</xsl:text></xsl:element>
        </xsl:if>
      </xsl:if>
  </xsl:copy>
</xsl:template>

<!-- add file in developerLog if not there -->
<xsl:template match="*[name() = 'developerLog']">
  <xsl:copy>
      <xsl:copy-of select="@*"/>
<xsl:if test="namespace-uri() = $dyncfg-ns and ./parent::*[name()='logs']">
        <xsl:apply-templates/>
<xsl:if test="not(./child::*[name()='file'])">
          <xsl:element name="file" namespace="http://tail-f.com/ns/confd_dyncfg/1.0">
            <xsl:element name="enabled" namespace="http://tail-f.com/ns/confd_dyncfg/1.0"><xsl:text>true</xsl:text></xsl:element>
            <xsl:element name="name" namespace="http://tail-f.com/ns/confd_dyncfg/1.0"><xsl:text>/isam/logs/confd_internal/devel.log</xsl:text></xsl:element>
          </xsl:element>
        </xsl:if>
       </xsl:if>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
