<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0"
                xmlns:onuNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount"
                xmlns:enh_filt="urn:bbf:yang:bbf-qos-enhanced-filters"
                xmlns:cls="urn:bbf:yang:bbf-qos-classifiers"
                xmlns:filt="urn:bbf:yang:bbf-qos-filters"
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
<xsl:template match="cls:classifiers/cls:classifier-entry/enh_filt:ipv4/enh_filt:identification"/>
<xsl:template match="filt:filters/enh_filt:enhanced-filter/enh_filt:filter/enh_filt:ipv4/enh_filt:identification"/>

</xsl:stylesheet>


