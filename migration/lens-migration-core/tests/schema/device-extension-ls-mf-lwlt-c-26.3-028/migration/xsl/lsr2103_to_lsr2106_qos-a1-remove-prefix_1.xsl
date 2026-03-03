<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:onusNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount"
    xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted"
    xmlns:qosNs="urn:bbf:yang:bbf-qos-policies-mounted"
>
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>
    <!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*[name() = 'bbf-qos-pol-mounted:ingress-qos-policy-profile'
                 and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies-mounted'
                 and parent::*[name() = 'interface']
                 and ancestor::*[name() = 'onus']
    ]">
        <xsl:variable name="ns" select="namespace-uri()"/>
        <xsl:variable name="value" select="text()"/>

        <xsl:element name="ingress-qos-policy-profile" namespace="{$ns}">
            <xsl:value-of select="$value"/>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
