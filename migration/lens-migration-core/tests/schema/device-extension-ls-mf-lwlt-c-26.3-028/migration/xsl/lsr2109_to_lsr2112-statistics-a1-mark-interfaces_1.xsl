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
        marke interface which enable statitics counter(include all-available or ip anti-spoofing)
    -->
    <xsl:template match="/*
        /*[name()='interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']
        /*[name() ='interface' and ./*[name() = 'type' and text() = 'bbfift:vlan-sub-interface']]
        ">

        <xsl:variable name="vsi-name" select="./*[name() = 'name']"/>
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>

            <xsl:if test="(./*[name() ='statistics']/*[name() = 'enable' and text() = 'all-available']) or
                (/*
                /*[name()='interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']
                /*[name()='ipv4-security-statistics']
                /*[name()='interface']
                /*[name()='name' and text() = $vsi-name])   or
                (/*
                /*[name()='interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']
                /*[name()='ipv6-security-statistics']
                /*[name()='interface']
                /*[name()='name' and text() = $vsi-name])
                ">
                <statistics-function-enable/>
        </xsl:if>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
