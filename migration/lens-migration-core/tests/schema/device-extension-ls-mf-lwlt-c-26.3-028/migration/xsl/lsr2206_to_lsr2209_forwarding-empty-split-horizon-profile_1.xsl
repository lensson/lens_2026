<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:param name="forwardingNameSpace" select="'urn:bbf:yang:bbf-l2-forwarding'" />

    <!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <!--
         if split-horizon_profile not include split-horizon, then warning msg will be added.
    -->

    <xsl:template match="/*
        /*[name()='forwarding' and namespace-uri() = 'urn:bbf:yang:bbf-l2-forwarding']
        /*[name() ='split-horizon-profiles']
        /*[name() = 'split-horizon-profile' and not (child::*[name()='split-horizon'])]
        ">
        <xsl:variable name="spname" select="*[name() = 'name']"/>
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
            <wrong-configuration-detected> No split horizon existed in split-horzion-profile <xsl:value-of select="$spname"/> - Migration is not successful</wrong-configuration-detected>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
