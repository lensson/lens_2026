<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
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
         >>3.4 if ipv4-multicast-address downstream flooding policy is discard, will add ipv4-prefix 224.0.0.0/24 to the flooding-policies-profile
           3.5 remove the forwarder and flooding-policy-profile identification node
        4. modify the ntp&rip-multicast-address downstream flooding policy
    -->

    <!-- downstream ipv4-prefix flooding policy profile-->
    <xsl:variable name="ipv4_prefix_dn">
        <xsl:element name="flooding-policy" namespace="urn:bbf:yang:bbf-l2-forwarding">
            <xsl:element name="name" namespace="urn:bbf:yang:bbf-l2-forwarding">ipv4_prefix_dn</xsl:element>
            <xsl:element name="in-interface-usages" namespace="urn:bbf:yang:bbf-l2-forwarding">
                <xsl:element name="interface-usages" namespace="urn:bbf:yang:bbf-l2-forwarding">network-port</xsl:element>
            </xsl:element>
            <xsl:element name="destination-address" namespace="urn:bbf:yang:bbf-l2-forwarding">
                <xsl:element name="ipv4-prefix" namespace="urn:bbf:yang:bbf-l2-forwarding">224.0.0.0/24</xsl:element>
            </xsl:element>
            <xsl:element name="out-interface-usages" namespace="urn:bbf:yang:bbf-l2-forwarding">
                <xsl:element name="interface-usages" namespace="urn:bbf:yang:bbf-l2-forwarding">subtended-node-port</xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:variable>

    <!--
        match the flooding-policy which include downstream ipv4-multicast-address discard policy
        expected behavior:  ipv4_prefix_dn will be added as the policy brother node
        /*[name() = 'flooding-policies-profile' and ./*[name() = 'flooding-policy']
                                                     /*[descendant::*[name()='interface-usages' and text() = 'network-port']] and descendant::*[name()='ipv4-multicast-address'] and descendant::*[name()='discard']
    -->
    <xsl:template match="/*         /*[name()='forwarding' and namespace-uri() = 'urn:bbf:yang:bbf-l2-forwarding']         /*[name() ='flooding-policies-profiles']         /*[name() = 'flooding-policies-profile']         ">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
<xsl:for-each select="./*[name() = 'flooding-policy' and ./*[name()='in-interface-usages']/*[name()='interface-usages' and text() = 'network-port'] and descendant::*[name()='ipv4-multicast-address'] and descendant::*[name()='discard']]">
                <xsl:if test="position() = last()">
                    <xsl:copy-of select="$ipv4_prefix_dn"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
