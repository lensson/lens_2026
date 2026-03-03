<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0"
                xmlns:onuNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount"
				xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted"
                xmlns:cls="urn:bbf:yang:bbf-qos-classifiers-mounted"
				xmlns:pol_subitf="urn:bbf:yang:bbf-qos-policies-sub-interfaces-mounted"
				xmlns:subitf="urn:bbf:yang:bbf-sub-interfaces-mounted"
				xmlns:subitf_tagging="urn:bbf:yang:bbf-sub-interface-tagging-mounted"
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
<xsl:template match="ifNs:interfaces/ifNs:interface/subitf:frame-processing/subitf:inline-frame-processing/subitf:inline-frame-processing/subitf:ingress-rule/subitf:rule/subitf:ingress-rewrite/subitf_tagging:push-tag/subitf_tagging:dot1q-tag/subitf_tagging:dei/pol_subitf:generate-dei-via-profile-or-0/pol_subitf:dei-marking-index"/>
<xsl:template match="ifNs:interfaces/ifNs:interface/subitf:frame-processing/subitf:inline-frame-processing/subitf:inline-frame-processing/subitf:egress-rewrite/subitf_tagging:push-tag/subitf_tagging:dot1q-tag/subitf_tagging:pbit/pol_subitf:generate-pbit-via-profile-or-0/pol_subitf:pbit-marking-index"/>
<xsl:template match="ifNs:interfaces/ifNs:interface/subitf:frame-processing/subitf:inline-frame-processing/subitf:inline-frame-processing/subitf:egress-rewrite/subitf_tagging:push-tag/subitf_tagging:dot1q-tag/subitf_tagging:dei/ pol_subitf:generate-dei-via-profile-or-0/pol_subitf:dei-marking-index"/>
</xsl:stylesheet>


