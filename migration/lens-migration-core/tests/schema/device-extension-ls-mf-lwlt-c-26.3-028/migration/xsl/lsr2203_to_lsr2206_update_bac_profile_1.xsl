<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

    <xsl:param name="maxbuffersize" select="'4000000000'"/>
    <xsl:template name="max_buffersize_replace">
        <xsl:copy>
            <xsl:value-of select="$maxbuffersize"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- adjust max-buffer-size parameter -->
    <xsl:template match="*[name() = 'max-queue-size'           and parent::*[name() = 'bac-entry']           and namespace-uri() = 'urn:bbf:yang:bbf-qos-traffic-mngt'     ]">
        <xsl:choose>
        <xsl:when test="current()/text() &gt; 4000000000">
            <xsl:call-template name="max_buffersize_replace"/>
        </xsl:when>
    <xsl:otherwise>
            <xsl:copy>
                <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
    	</xsl:otherwise>
        </xsl:choose>
         </xsl:template>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
