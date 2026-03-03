<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:policingPrfNs="urn:bbf:yang:bbf-qos-policing" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:param name="minburst" select="'1024'"/>
    <xsl:param name="maxburst" select="'134216704'"/>
    <xsl:template name="min_burst_replace">
        <xsl:copy>
            <xsl:value-of select="$minburst"/>
	</xsl:copy>
    </xsl:template>
    <xsl:template name="max_burst_replace">
        <xsl:copy>
            <xsl:value-of select="$maxburst"/>
        </xsl:copy>
    </xsl:template>
 
    <xsl:param name="maxrate" select="'137438951424'"/>
    <xsl:template name="max_rate_replace">
        <xsl:copy>
            <xsl:value-of select="$maxrate"/>
        </xsl:copy>
    </xsl:template>
    <!-- adjust cir parameter -->
    <xsl:template match="*[name() = 'cir'          and ancestor::*[name() = 'policing-profile']          and namespace-uri() = 'urn:bbf:yang:bbf-qos-policing'     ]">
        <xsl:choose>
        <xsl:when test="current()/text() &gt; 137438951424">
            <xsl:call-template name="max_rate_replace"/>
    	</xsl:when>
	<xsl:otherwise>
            <xsl:copy>
                <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
    	</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- adjust cbs parameter -->
    <xsl:template match="*[name() = 'cbs'          and ancestor::*[name() = 'policing-profile']          and namespace-uri() = 'urn:bbf:yang:bbf-qos-policing'     ]">
        <xsl:choose>
        <xsl:when test="current()/text() &lt; 1024">
            <xsl:call-template name="min_burst_replace"/>
        </xsl:when>
        <xsl:when test="current()/text() &gt; 134216704">
            <xsl:call-template name="max_burst_replace"/>
    	</xsl:when>
	<xsl:otherwise>
            <xsl:copy>
                <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
    	</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- adjust eir parameter -->
    <xsl:template match="*[name() = 'eir'          and ancestor::*[name() = 'policing-profile']          and namespace-uri() = 'urn:bbf:yang:bbf-qos-policing'     ]">
        <xsl:choose>
        <xsl:when test="current()/text() &gt; 137438951424">
            <xsl:call-template name="max_rate_replace"/>
    	</xsl:when>
	<xsl:otherwise>
            <xsl:copy>
                <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
    	</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- adjust ebs parameter -->
    <xsl:template match="*[name() = 'ebs'          and ancestor::*[name() = 'policing-profile']          and namespace-uri() = 'urn:bbf:yang:bbf-qos-policing'     ]">
        <xsl:choose>
        <xsl:when test="current()/text() &lt; 1024">
            <xsl:call-template name="min_burst_replace"/>
        </xsl:when>
        <xsl:when test="current()/text() &gt; 134216704">
            <xsl:call-template name="max_burst_replace"/>
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
