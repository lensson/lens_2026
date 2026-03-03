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

    <xsl:template match="*[name() = 'policy-profile'
        and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies-mounted'
        and parent::*[name() = 'qos-policy-profiles-new']
    ]">
        <xsl:variable name="ns" select="namespace-uri()"/>
        <xsl:variable name="var_name" select="child::*[name() = 'mig_tmp_name']"/>
        <xsl:variable name="var_name0" select="child::*[name() = 'name']"/>
        <xsl:element name="policy-profile" namespace="{$ns}">
            <xsl:element name="name" namespace="{$ns}">
                <xsl:value-of select="$var_name"/>
            </xsl:element>
            <xsl:element name="name0" namespace="{$ns}">
                <xsl:value-of select="$var_name0"/>
            </xsl:element>
            <xsl:element name="policy-list" namespace="{$ns}">
                <xsl:element name="name" namespace="{$ns}"><xsl:value-of select="$var_name"/>_pbit</xsl:element>
            </xsl:element>
            <xsl:element name="policy-list" namespace="{$ns}">
                <xsl:element name="name" namespace="{$ns}"><xsl:value-of select="$var_name"/>_tc</xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
