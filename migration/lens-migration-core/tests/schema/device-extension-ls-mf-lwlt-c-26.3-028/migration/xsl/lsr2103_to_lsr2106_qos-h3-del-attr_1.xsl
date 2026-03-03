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

    <xsl:template match="*[name() = 'classifier-entry'
         and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers-mounted'
         and parent::*[name() = 'classifiers']
    ]">
        <xsl:variable name="ns" select="namespace-uri()"/>
        <xsl:variable name="var_name" select="child::*[name() = 'name']"/>
        <xsl:element name="classifier-entry" namespace="{$ns}">
            <xsl:copy-of select="child::*"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="*[name() = 'policy'
         and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies-mounted'
         and parent::*[name() = 'policies']
    ]">
        <xsl:variable name="ns" select="namespace-uri()"/>
        <xsl:variable name="var_name" select="child::*[name() = 'name']"/>
        <xsl:element name="policy" namespace="{$ns}">
            <xsl:copy-of select="child::*"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="*[name() = 'policy-profile'
         and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies-mounted'
         and parent::*[name() = 'qos-policy-profiles']
    ]">
        <xsl:variable name="ns" select="namespace-uri()"/>
        <xsl:variable name="var_name" select="child::*[name() = 'name']"/>
        <xsl:element name="policy-profile" namespace="{$ns}">
            <xsl:copy-of select="child::*"/>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
