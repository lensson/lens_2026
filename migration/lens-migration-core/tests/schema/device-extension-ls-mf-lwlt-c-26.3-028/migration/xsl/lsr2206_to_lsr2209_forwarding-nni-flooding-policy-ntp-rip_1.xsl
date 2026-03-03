<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:cfgNs="urn:ietf:params:xml:ns:netconf:base:1.0"
    xmlns:multicastNs="urn:bbf:yang:bbf-mgmd"
    xmlns:forwardingNs="urn:bbf:yang:bbf-l2-forwarding"
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

        1. remove all ipv4-prefix flooding policy
        2. add subtend-node-port to all downstream flooding policy out-interface-usages except ipv4-multicast-address
        3. modify ipv4-multicast-address dowanstream flooding policy
           3.1 add a child node to identify the forwarder which include a flooding-policy-profile(include ipv4-multicast-address downstream policy) and network vsi(refered by a igmp channel)
           3.2 add a child node to identify the flooding-policy-profile refered by a forwarder which identifed
           3.3 modify the ipv4-multicast-address downstream flooding policy according the identification
           3.4 if ipv4-multicast-address downstream flooding policy is discard, will add ipv4-prefix 224.0.0.0/24 to the flooding-policies-profile
           3.5 remove the forwarder and flooding-policy-profile identification node
      >>4. modify the ntp&rip-multicast-address downstream flooding policy
    -->

    <xsl:variable name="both-user-port-subtended-node-port">
        <xsl:element name="out-interface-usages" namespace="urn:bbf:yang:bbf-l2-forwarding">
            <xsl:element name="interface-usages" namespace="urn:bbf:yang:bbf-l2-forwarding">user-port</xsl:element>
            <xsl:element name="interface-usages" namespace="urn:bbf:yang:bbf-l2-forwarding">subtended-node-port</xsl:element>
        </xsl:element>
    </xsl:variable>

   <xsl:variable name="subtended-node-port">
        <xsl:element name="out-interface-usages" namespace="urn:bbf:yang:bbf-l2-forwarding">
            <xsl:element name="interface-usages" namespace="urn:bbf:yang:bbf-l2-forwarding">subtended-node-port</xsl:element>
        </xsl:element>
    </xsl:variable>


    <!--
        match match ntp-multicast-address flooding-policy out-interface-usage
        expected behavior:
            if ipm4-multicast-address discard exist
                ntp-multicast-address need discard
            else
                ntp-multicast-address must flooding to user-port and subtented-node-port

    -->
    <xsl:template match="/*
        /*[name()='forwarding' and namespace-uri() = 'urn:bbf:yang:bbf-l2-forwarding']
        /*[name() ='flooding-policies-profiles']
        /*[name() = 'flooding-policies-profile']
        /*[name() = 'flooding-policy' and ./*[name()='in-interface-usages']/*[name()='interface-usages' and text() = 'network-port'] and descendant::*[name()='ntp-multicast-address']]
        /*[name() = 'out-interface-usages']
        ">

        <xsl:variable name="ipv4-multicast-discard-exist" select="../../*[name() = 'flooding-policy' and ./*[name()='in-interface-usages']/*[name()='interface-usages' and text() = 'network-port'] and descendant::*[name()='ipv4-multicast-address'] and descendant::*[name()='discard']]"/>
        <xsl:choose>
            <xsl:when test="$ipv4-multicast-discard-exist">
                <xsl:element name="discard" namespace="urn:bbf:yang:bbf-l2-forwarding"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="$both-user-port-subtended-node-port"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
        match match rip-multicast-address flooding-policy out-interface-usage
        expected behavior:
            if ipm4-multicast-address discard exist
                rip-multicast-address flooding to subtented-node-port
            else
                ntp-multicast-address must flooding to user-port and subtented-node-port
    -->
    <xsl:template match="/*
        /*[name()='forwarding' and namespace-uri() = 'urn:bbf:yang:bbf-l2-forwarding']
        /*[name() ='flooding-policies-profiles']
        /*[name() = 'flooding-policies-profile']
        /*[name() = 'flooding-policy' and ./*[name()='in-interface-usages']/*[name()='interface-usages' and text() = 'network-port'] and descendant::*[name()='rip-multicast-address']]
        /*[name() = 'out-interface-usages']
        ">

        <xsl:variable name="ipv4-multicast-discard-exist" select="../../*[name() = 'flooding-policy' and ./*[name()='in-interface-usages']/*[name()='interface-usages' and text() = 'network-port'] and descendant::*[name()='ipv4-multicast-address'] and descendant::*[name()='discard']]"/>
        <xsl:choose>
            <xsl:when test="$ipv4-multicast-discard-exist">
                <xsl:copy-of select="$subtended-node-port"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="$both-user-port-subtended-node-port"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
