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
       add a warning message under root element
    -->
    <xsl:template match="/">
        <xsl:copy>
            <xsl:if test="/*
                /*[local-name() = 'interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']
                /*[local-name() = 'interface' and child::*[local-name() = 'type' and text() = 'bbfift:vlan-sub-interface']]
                /*[local-name() = 'enabled' and text() = 'changed-to-true']
                ">
                <xsl:comment>xslt warning: there are admin-down network VSIs which are not supported, so change them to admin-up. </xsl:comment>
            </xsl:if>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
