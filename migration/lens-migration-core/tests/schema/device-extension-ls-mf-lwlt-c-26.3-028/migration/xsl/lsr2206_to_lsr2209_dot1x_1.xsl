<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:tailf="http://tail-f.com/ns/config/1.0" 
xmlns:ietfif="urn:ietf:params:xml:ns:yang:ietf-interfaces" 
xmlns:ieeedot1x="http://www.nokia.com/Fixed-Networks/BBA/yang/ieee802-dot1x" exclude-result-prefixes="tailf ietfif ieeedot1x" version="1.0">
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    <xsl:param name="ipfix_ns" select="'urn:ietf:params:xml:ns:yang:ietf-ipfix-psamp'" />

<!-- default rule -->
    <!-- Identity transform -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>

    </xsl:template>

    <xsl:template match="*[name() = 'nid-group']">
        <xsl:choose>
            <xsl:when test="parent::*[name() = 'config']">
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="*[name() = 'authentication-failure-threshold']">
        <xsl:choose>
            <xsl:when test="parent::*[name() = 'pae-system']">
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
