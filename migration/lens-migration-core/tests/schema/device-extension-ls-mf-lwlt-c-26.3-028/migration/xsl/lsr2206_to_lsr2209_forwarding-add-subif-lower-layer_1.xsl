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
        add subif-lower-layer BP_Eth to sinband vlan-sub-interface
    -->

    <xsl:template match="/*
        /*[name()='interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']
        /*[name() ='interface' and ./*[name() = 'name' and text() ='sinband'] and ./*[name() = 'interface-usage']/*[name() = 'interface-usage' and text() = 'network-port'] and ./*[name() = 'type' and text() = 'bbfift:vlan-sub-interface']]
        /*[name() = 'interface-usage']
        ">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>

        <xsl:if test="not(../*[name()='subif-lower-layer'])">
            <xsl:element name= "subif-lower-layer" namespace="urn:bbf:yang:bbf-sub-interfaces">
                <xsl:element name="interface" namespace="urn:bbf:yang:bbf-sub-interfaces">BP_Eth</xsl:element>
            </xsl:element>
        </xsl:if>

    </xsl:template>

</xsl:stylesheet>

