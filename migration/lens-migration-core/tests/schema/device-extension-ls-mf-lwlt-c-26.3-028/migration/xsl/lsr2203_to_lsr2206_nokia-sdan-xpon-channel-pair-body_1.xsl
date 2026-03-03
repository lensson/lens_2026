<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
        <xsl:copy-of select="@*"/> 
        <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <!-- remove ultra-low-latency-mode node -->
    <xsl:template match="*[name() = 'nokia-sdan-channel-pair-body:ultra-low-latency-mode' or name() = 'ultra-low-latency-mode']">
    </xsl:template>

</xsl:stylesheet>
