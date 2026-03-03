<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:confdNS="http://tail-f.com/ns/confd_dyncfg/1.0" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

  <!-- Overwrite clientAliveInterval=300s with PT300s -->
  <xsl:template match="confdNS:ssh/confdNS:clientAliveInterval[text()='300s']">
          <xsl:element name="clientAliveInterval" namespace="http://tail-f.com/ns/confd_dyncfg/1.0">PT300S</xsl:element>
  </xsl:template>

  <!-- Overwrite idleConnectionTimeout=1s with PT1s -->
  <xsl:template match="confdNS:ssh/confdNS:idleConnectionTimeout[text()='1s']">
          <xsl:element name="idleConnectionTimeout" namespace="http://tail-f.com/ns/confd_dyncfg/1.0">PT1S</xsl:element>
  </xsl:template>

  <!-- Overwrite idleTimeout=24H with PT24H-->  
  <xsl:template match="confdNS:netconf/confdNS:idleTimeout[text()='24H']">
          <xsl:element name="idleTimeout" namespace="http://tail-f.com/ns/confd_dyncfg/1.0">PT24H</xsl:element>
  </xsl:template> 

  <!-- Overwrite maxDataLength=4096 with 8192-->  
  <xsl:template match="confdNS:parserLimits/confdNS:maxDataLength[text()='4096']">
          <xsl:element name="maxDataLength" namespace="http://tail-f.com/ns/confd_dyncfg/1.0">8192</xsl:element>
  </xsl:template> 
 
</xsl:stylesheet>
