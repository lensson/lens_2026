<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:cfgNs="urn:ietf:params:xml:ns:netconf:base:1.0"
    xmlns:multicastNs="urn:bbf:yang:bbf-mgmd"
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
        remove the interface mark
    -->
    <xsl:template match="/*
        /*[name()='interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']
        /*[name() ='interface' and ./*[name() = 'type' and text() = 'bbfift:vlan-sub-interface']]
        /*[name() = 'statistics-function-enable']
        ">
    </xsl:template>

    <!--
        remove the statistics mark
    -->
    <xsl:template match="/*
        /*[name()='interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']
        /*[name() ='statistics-exceed-the-hardware-resource']
        ">
    </xsl:template>

</xsl:stylesheet>
