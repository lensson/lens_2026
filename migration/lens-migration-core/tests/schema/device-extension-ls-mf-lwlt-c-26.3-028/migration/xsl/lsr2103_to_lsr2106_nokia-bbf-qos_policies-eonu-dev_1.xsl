<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0"
                xmlns:onuNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount"
				xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted"
                xmlns:qos_pol="urn:bbf:yang:bbf-qos-policies-mounted"
				xmlns:itf_type="urn:bbf:yang:bbf-if-type-mounted"
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
<xsl:template match="ifNs:interfaces/ifNs:interface/qos_pol:egress-qos-policy-profile"/>
<xsl:template match="ifNs:interfaces/ifNs:interface/qos_pol:ingress-qos-policy-profile[not(contains(../ifNs:type,'vlan-sub-interface'))]"/>

</xsl:stylesheet>


