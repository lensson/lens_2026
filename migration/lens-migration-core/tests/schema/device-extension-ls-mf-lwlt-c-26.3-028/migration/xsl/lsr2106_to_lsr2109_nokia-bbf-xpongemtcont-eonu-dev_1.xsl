<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0"
                xmlns:onuNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount"
                xmlns:bbf-xpongemtcont="urn:bbf:yang:bbf-xpongemtcont-mounted"
>
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

<!-- default rule -->
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

<!-- remove unsupported nodes -->
<xsl:template match="bbf-xpongemtcont:tconts-config/bbf-xpongemtcont:tcont/bbf-xpongemtcont:traffic-descriptor-profile-ref"/>

</xsl:stylesheet>


