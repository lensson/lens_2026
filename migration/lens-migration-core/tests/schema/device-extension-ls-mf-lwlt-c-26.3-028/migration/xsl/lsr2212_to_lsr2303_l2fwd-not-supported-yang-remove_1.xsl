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

    <!-- remove port-groups -->
    <xsl:template match="/*
        /*[local-name() = 'forwarding' and namespace-uri() = 'urn:bbf:yang:bbf-l2-forwarding']
        /*[local-name() = 'forwarders']
        /*[local-name() = 'forwarder']
        /*[local-name() = 'port-groups']
        ">
    </xsl:template>

    <!-- remove egress pop -->
    <xsl:template match="/*
        /*[local-name() = 'interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']
        /*[local-name() = 'interface' and child::*[local-name() = 'type' and text() = 'bbfift:vlan-sub-interface']]
        /*[local-name() = 'inline-frame-processing']
        /*[local-name() = 'egress-rewrite']
        /*[local-name() = 'pop-tags']
        ">
    </xsl:template>

    <!-- remove number-committed-mac-addresses -->
    <xsl:template match="/*
        /*[local-name() = 'interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']
        /*[local-name() = 'interface']
        /*[local-name() = 'mac-learning']
        /*[local-name() = 'number-committed-mac-addresses']
        ">
    </xsl:template>

</xsl:stylesheet>
