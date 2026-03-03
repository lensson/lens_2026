<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:onusNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount" xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted" xmlns:qosNs="urn:bbf:yang:bbf-qos-policies-mounted" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="var_onusNs">urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount</xsl:variable>
    <xsl:variable name="var_ifNs">urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted</xsl:variable>
    <xsl:variable name="var_qosNs">urn:bbf:yang:bbf-qos-policies-mounted</xsl:variable>
    <!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>


    <xsl:template match="*[name() = 'pbit-value'          and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies-mounted'         and parent::*[name() = 'soure_classifier']     ]">
        <xsl:variable name="ns" select="namespace-uri()"/>
        <xsl:variable name="var_value" select="."/>
        <xsl:choose>
            <xsl:when test="1=string-length($var_value)">
                <xsl:element name="pbit-value" namespace="{$ns}">
                    <xsl:element name="item" namespace="{$ns}">
                        <xsl:value-of select="$var_value"/>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
