<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:param name="interfacesNs" select="'urn:ietf:params:xml:ns:yang:ietf-interfaces'" />

    <!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <!--
        remove l2cp from uni interface
    -->
    <xsl:template match="/*
        /*[name()='interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']
        /*[name() ='interface' and ./*[name() = 'interface-usage']/*[name() = 'interface-usage' and text() = 'user-port'] and ./*[name() = 'type' and text() = 'bbfift:vlan-sub-interface']]
        /*[name() = 'l2cp']
        /*[name() = 'l2cp-address-service']
        /text()
        ">

        <xsl:variable name="user-port-vsi" select="../../../*[name() = 'name']"/>
        <xsl:choose>
            <xsl:when test="/*
                /*[name()='forwarding' and namespace-uri() = 'urn:bbf:yang:bbf-l2-forwarding']
                /*[name() ='forwarders']
                /*[name() = 'forwarder' and ./*[name() = 'flooding-policies']/*[name() = 'flooding-policies-profile']]
                /*[name() = 'ports']
                /*[name() = 'port']
                /*[name() = 'sub-interface' and text() = $user-port-vsi]
                and . = 'l2cp-pass-00-02to0f-10-2x'
                ">
                <xsl:text>block-l2cp</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="." />
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

</xsl:stylesheet>
