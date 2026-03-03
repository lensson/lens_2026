<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

    <!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <!-- remove invalied node which added before -->
    <xsl:template match="/*[local-name() = 'config']/*[local-name() = 'us-flow-rule-temp']">
    </xsl:template>

    <xsl:template match="/*[local-name() = 'config']
        /*[local-name() = 'forwarding' and namespace-uri() = 'urn:bbf:yang:bbf-l2-forwarding']
        /*[local-name() = 'forwarders']/*[local-name() = 'forwarder']
        /*[local-name() = 'marked-by-net-vsi']
        ">
    </xsl:template>

</xsl:stylesheet>
