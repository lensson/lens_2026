<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0"
                              xmlns:bbfmgmd="urn:bbf:yang:bbf-mgmd"
                              xmlns:ipv6spoof="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-mgmd-ipv6spoof">
  <xsl:output method="xml" encoding="utf-8" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/tailf:config/bbfmgmd:multicast/bbfmgmd:mgmd/bbfmgmd:multicast-vpn/bbfmgmd:multicast-interface-to-host/ipv6spoof:ipv6-mgmd-antispoof">
  </xsl:template>

</xsl:stylesheet>
