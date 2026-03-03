<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dyncfg-ns="http://tail-f.com/ns/confd_dyncfg/1.0" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

<xsl:param name="dyncfg-ns" select="'http://tail-f.com/ns/confd_dyncfg/1.0'"/>


<!-- change netconfLog -> enabled to true -->
<xsl:template match="dyncfg-ns:confdConfig/dyncfg-ns:logs/dyncfg-ns:netconfLog/dyncfg-ns:enabled">
    <xsl:element name="enabled" namespace="http://tail-f.com/ns/confd_dyncfg/1.0">
        <xsl:text>true</xsl:text>
    </xsl:element>
</xsl:template>

<!-- change netconfLog file -> enabled to true -->
<xsl:template match="dyncfg-ns:confdConfig/dyncfg-ns:logs/dyncfg-ns:netconfLog/dyncfg-ns:file/dyncfg-ns:enabled">
    <xsl:element name="enabled" namespace="http://tail-f.com/ns/confd_dyncfg/1.0">
        <xsl:text>true</xsl:text>
    </xsl:element>
</xsl:template>

<!-- change netconfLog -> file -> name to /isam/logs/confd_internal/netconf.log -->
<xsl:template match="dyncfg-ns:confdConfig/dyncfg-ns:logs/dyncfg-ns:netconfLog/dyncfg-ns:file/dyncfg-ns:name">
    <xsl:element name="name" namespace="http://tail-f.com/ns/confd_dyncfg/1.0">
        <xsl:text>/isam/logs/confd_internal/netconf.log</xsl:text>
    </xsl:element>
</xsl:template>

<xsl:template match="dyncfg-ns:confdConfig/dyncfg-ns:logs/dyncfg-ns:netconfLog/dyncfg-ns:logReplyStatus">
    <xsl:element name="logReplyStatus" namespace="http://tail-f.com/ns/confd_dyncfg/1.0">
        <xsl:text>true</xsl:text>
    </xsl:element>
</xsl:template>

<!-- add netconfLog  if not there -->
<xsl:template match="dyncfg-ns:confdConfig/dyncfg-ns:logs">
  <xsl:copy>
      <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
<xsl:if test="not(./child::*[name()='netconfLog'])">
          <xsl:element name="netconfLog" namespace="http://tail-f.com/ns/confd_dyncfg/1.0">
            <xsl:element name="enabled" namespace="http://tail-f.com/ns/confd_dyncfg/1.0">
              <xsl:text>true</xsl:text>
            </xsl:element>
            <xsl:element name="file" namespace="http://tail-f.com/ns/confd_dyncfg/1.0">
              <xsl:element name="enabled" namespace="http://tail-f.com/ns/confd_dyncfg/1.0">
                <xsl:text>true</xsl:text>
              </xsl:element>
              <xsl:element name="name" namespace="http://tail-f.com/ns/confd_dyncfg/1.0">
                <xsl:text>/isam/logs/confd_internal/netconf.log</xsl:text>
              </xsl:element>
            </xsl:element>
            <xsl:element name="logReplyStatus" namespace="http://tail-f.com/ns/confd_dyncfg/1.0">
              <xsl:text>true</xsl:text>
            </xsl:element>
          </xsl:element>
        </xsl:if>
  </xsl:copy>
</xsl:template>

<!-- add file in netconfLog if not there -->
<xsl:template match="dyncfg-ns:confdConfig/dyncfg-ns:logs/dyncfg-ns:netconfLog">
  <xsl:copy>
        <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
<xsl:if test="not(./child::*[name()='enabled'])">
            <xsl:element name="enabled" namespace="http://tail-f.com/ns/confd_dyncfg/1.0">
              <xsl:text>true</xsl:text>
            </xsl:element>
        </xsl:if>
        <xsl:if test="not(./child::*[name()='file'])">
          <xsl:element name="file" namespace="http://tail-f.com/ns/confd_dyncfg/1.0">
            <xsl:element name="enabled" namespace="http://tail-f.com/ns/confd_dyncfg/1.0">
              <xsl:text>true</xsl:text>
            </xsl:element>
            <xsl:element name="name" namespace="http://tail-f.com/ns/confd_dyncfg/1.0">
              <xsl:text>/isam/logs/confd_internal/netconf.log</xsl:text>
            </xsl:element>
          </xsl:element>
        </xsl:if>
        <xsl:if test="not(./child::*[name()='logReplyStatus'])">
          <xsl:element name="logReplyStatus" namespace="http://tail-f.com/ns/confd_dyncfg/1.0">
            <xsl:text>true</xsl:text>
          </xsl:element>
        </xsl:if>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
