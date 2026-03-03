<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:onusNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount"
    xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted"
    xmlns:qosNs="urn:bbf:yang:bbf-qos-policies-mounted"
    xmlns:clsNs="urn:bbf:yang:bbf-qos-classifiers-mounted"
>
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="var_onusNs">urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount</xsl:variable>
    <xsl:variable name="var_ifNs">urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted</xsl:variable>
    <xsl:variable name="var_qosNs">urn:bbf:yang:bbf-qos-policies-mounted</xsl:variable>
    <xsl:variable name="var_clsNs">urn:bbf:yang:bbf-qos-classifiers-mounted</xsl:variable>
    <!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*[((name() = 'untagged_pbit') or (name() = 'untagged_dcsp') or (name() = 'tagged_copy') or (name() = 'tagged_pbit'))
        and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies-mounted'
        and parent::*[name() = 'policy']
        and ancestor::*[name() = 'policies-new']
    ]">
   </xsl:template>

    <xsl:template match="*[((name() = 'old_name_pol_pbit') or (name() = 'old_name_pol_tc') or (name() = 'old_name_vsi') or (name() = 'name0'))
        and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies-mounted'
        and parent::*[name() = 'policy-profile']
        and ancestor::*[name() = 'qos-policy-profiles-new']
    ]">
    </xsl:template>
</xsl:stylesheet>
