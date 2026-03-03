<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:cfgNs="urn:ietf:params:xml:ns:netconf:base:1.0"
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

    <!--
       change the max mac number of vsi lower-layer interfaces to default value
    -->
    <xsl:template match="/*
        /*[local-name()='interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']
        /*[local-name() ='interface' and ./*[local-name() = 'type' and (text() = 'bbf-xponift:olt-v-enet' or text() = 'ianaift:ethernetCsmacd' or text() = 'ianaift:ieee8023adLag')]]
        /*[local-name() = 'mac-learning']
        /*[local-name() = 'max-number-mac-addresses']
        /text()
        ">

        <xsl:choose>
            <xsl:when test="(. = '4294967295')">
                <xsl:copy-of select="." />
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>4294967295</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
