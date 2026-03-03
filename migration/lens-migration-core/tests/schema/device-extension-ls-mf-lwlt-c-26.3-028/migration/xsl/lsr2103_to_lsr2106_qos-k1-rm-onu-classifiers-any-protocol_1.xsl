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

    <xsl:template match="*[name() = 'any-protocol'
        and parent::*[name() = 'match-criteria']
        and ancestor::*[name() = 'classifier-entry']
        and ancestor::*[name() = 'classifiers']
        and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers-mounted'
        and ancestor::*[name() = 'onu']
    ]">
    </xsl:template>
</xsl:stylesheet>
