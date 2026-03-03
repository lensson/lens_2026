<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0"
                xmlns:onuNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount"
                xmlns:cls="urn:bbf:yang:bbf-qos-classifiers-mounted"
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
<xsl:template match="cls:classifiers/cls:classifier-entry/cls:filter-method/cls:inline/cls:match-criteria/cls:vlan-tag-match-type/cls:match-all/cls:match-all"/>
<xsl:template match="cls:classifiers/cls:classifier-entry/cls:filter-method/cls:inline/cls:match-criteria/cls:protocols"/>
<xsl:template match="cls:classifiers/cls:classifier-entry/cls:classifier-action-entry-cfg/cls:action-cfg-params/cls:dei-marking"/>
<xsl:template match="cls:classifiers/cls:classifier-entry/cls:classifier-action-entry-cfg/cls:action-cfg-params/cls:dscp-marking"/>
<xsl:template match="cls:classifiers/cls:classifier-entry/cls:filter-method/cls:inline/cls:match-criteria/cls:vlan-tag-match-type/cls:vlan-tagged/cls:tag/cls:in-dei"/>

</xsl:stylesheet>


