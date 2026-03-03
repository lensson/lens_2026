<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0"
                xmlns:onu="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount"
                xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted"
                xmlns:bbf-qos-classifiers="urn:bbf:yang:bbf-qos-classifiers-mounted"
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
<xsl:template match="//onu:onus/onu:onu/onu:root/bbf-qos-classifiers:classifiers/bbf-qos-classifiers:classifier-entry/bbf-qos-classifiers:match-criteria/bbf-qos-classifiers:any-protocol"/>

</xsl:stylesheet>

