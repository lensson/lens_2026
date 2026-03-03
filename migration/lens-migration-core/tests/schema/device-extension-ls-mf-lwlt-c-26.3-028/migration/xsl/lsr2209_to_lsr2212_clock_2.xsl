<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:systemAug ="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-ietf-system-aug"
                              xmlns:freq ="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-conf-clock-frequency"
                              xmlns:ptp = "urn:ietf:params:xml:ns:yang:nokia-conf-clock-ptp">

<xsl:strip-space elements="*"/>
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    

<!-- default rule -->

<xsl:template match="node()|@*">
    <xsl:copy>
        <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
</xsl:template>

<!-- system region to be removed -->
<xsl:template match="systemAug:region">
</xsl:template>

<!-- clock-freq-port to be removed -->
<xsl:template match="freq:clock-freq-src-port">
</xsl:template>

<!-- system frequency to be removed -->
<xsl:template match="freq:frequency">
</xsl:template>

<!-- ptp g8275.1 profiles to be removed -->
<xsl:template match="ptp:ptp-g8275dot1-profiles">
</xsl:template>

<!-- ptp ccsa profiles to be removed -->
<xsl:template match="ptp:ptp-ccsa-profiles">
</xsl:template>

<!-- ptp port to be removed -->
<xsl:template match="ptp:ptp-port">
</xsl:template>

<!-- system ptp to be removed -->
<xsl:template match="ptp:ptp">
</xsl:template>

</xsl:stylesheet>

