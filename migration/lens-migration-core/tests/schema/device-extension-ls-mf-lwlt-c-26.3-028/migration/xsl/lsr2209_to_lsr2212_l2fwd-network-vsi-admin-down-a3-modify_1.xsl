<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cfgNs="urn:ietf:params:xml:ns:netconf:base:1.0" version="1.0">
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
        change all marked VSI to admin-up
    -->
    <xsl:template match="/*         /*[local-name() = 'interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']         /*[local-name() = 'interface' and child::*[local-name() = 'type' and text() = 'bbfift:vlan-sub-interface']]         /*[local-name() = 'enabled' and text() = 'changed-to-true']         ">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
<xsl:text>true</xsl:text>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
