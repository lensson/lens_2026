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

    <!-- clear empty egress-rewrite. inline-frame-processing can't be empty as at least 1 ingress rule in it. -->
    <xsl:template match="/*
        /*[local-name() = 'interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']
        /*[local-name() = 'interface' and child::*[local-name() = 'type' and text() = 'bbfift:vlan-sub-interface']]
        /*[local-name() = 'inline-frame-processing']
        /*[local-name() = 'egress-rewrite' and count(child::*) = 0]
        ">
    </xsl:template>

    <!-- clear empty mac-learning -->
    <xsl:template match="/*
        /*[local-name() = 'interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']
        /*[local-name() = 'interface']
        /*[local-name() = 'mac-learning' and count(child::*) = 0]
        ">
    </xsl:template>

</xsl:stylesheet>
