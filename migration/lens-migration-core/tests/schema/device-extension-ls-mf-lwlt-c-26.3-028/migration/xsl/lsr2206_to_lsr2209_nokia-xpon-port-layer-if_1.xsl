<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces" xmlns:bbfXpon="urn:bbf:yang:bbf-xpon" xmlns:bbfIfPortRef="urn:bbf:yang:bbf-interface-port-reference" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

    <!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <!-- check if port-layer-if is configured for channel termination -->
    <xsl:template match="ifNs:interfaces/ifNs:interface/bbfXpon:channel-termination">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>

        <xsl:choose>
            <xsl:when test="current()/../bbfIfPortRef:port-layer-if">
            </xsl:when>
            <xsl:otherwise>
                <wrong-configuration-detected>port-layer-if under channel termination is missing - Migration is not Successful</wrong-configuration-detected>
                <xsl:comment>xslt warning: port-layer-if under channel termination is missing, operator need configure it first.</xsl:comment>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
 
</xsl:stylesheet>
