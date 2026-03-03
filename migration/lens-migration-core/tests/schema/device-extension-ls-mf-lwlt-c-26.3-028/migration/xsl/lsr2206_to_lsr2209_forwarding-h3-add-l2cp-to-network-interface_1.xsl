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
       add l2cp pass to the network vsi which in the forwarder that marked by step 1
    -->

   <!--
    scenatio 1: if not configuration l2cp network vsi which included by nni-forwarder
    expected behavior:  below element will be added to this vsi
        <l2cp xmlns="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-l2cp">
            <l2cp-address-service>l2cp-pass-00-02to0f-10-2x</l2cp-address-service>
        </l2cp>
   -->
    <xsl:template match="/*
        /*[name()='interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']
        /*[name() ='interface' and ./*[name() = 'interface-usage']/*[name() = 'interface-usage' and text() = 'network-port'] and ./*[name() = 'type' and text() = 'bbfift:vlan-sub-interface']]
        /*[name() = 'type']
        ">

        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>

        <xsl:variable name="network-vsi" select="../*[name() = 'name']"/>
        <xsl:if test="/*
            /*[name()='forwarding' and namespace-uri() = 'urn:bbf:yang:bbf-l2-forwarding']
            /*[name() ='forwarders']
            /*[name() = 'forwarder' and ./*[name() = 'forwarder-include-nni-vsi']]
            /*[name() = 'ports']
            /*[name() = 'port']
            /*[name() = 'sub-interface' and text() = $network-vsi]
            and not(../*[name()='l2cp'])
            ">
            <xsl:element name= "l2cp" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-l2cp">
                <xsl:element name="l2cp-address-service" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-l2cp">l2cp-pass-00-02to0f-10-2x</xsl:element>
            </xsl:element>
        </xsl:if>
    </xsl:template>


    <!--
        scenatio 2: if l2cp block on network vsi which included by nni-forwarder
        expected behavior: change block-l2cp to pass
            <l2cp xmlns="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-l2cp">
                <l2cp-address-service>l2cp-pass-00-02to0f-10-2x</l2cp-address-service>
            </l2cp>
    -->
    <xsl:template match="/*
        /*[name()='interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']
        /*[name() ='interface' and ./*[name() = 'interface-usage']/*[name() = 'interface-usage' and text() = 'network-port'] and ./*[name() = 'type' and text() = 'bbfift:vlan-sub-interface']]
        /*[name() = 'l2cp']
        /*[name() = 'l2cp-address-service']
        /text()
        ">

        <xsl:variable name="network-vsi" select="../../../*[name() = 'name']"/>
        <xsl:choose>
            <xsl:when test="/*
                /*[name()='forwarding' and namespace-uri() = 'urn:bbf:yang:bbf-l2-forwarding']
                /*[name() ='forwarders']
                /*[name() = 'forwarder' and ./*[name() = 'forwarder-include-nni-vsi']]
                /*[name() = 'ports']
                /*[name() = 'port']
                /*[name() = 'sub-interface' and text() = $network-vsi]
                and . = 'block-l2cp'
                ">
                <xsl:text>l2cp-pass-00-02to0f-10-2x</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="." />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
