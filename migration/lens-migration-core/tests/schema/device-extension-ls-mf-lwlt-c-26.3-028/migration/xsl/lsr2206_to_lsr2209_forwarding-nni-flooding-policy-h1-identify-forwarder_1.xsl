<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cfgNs="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:multicastNs="urn:bbf:yang:bbf-mgmd" version="1.0">
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
         >>3.1 add a child node to identify the forwarder which include a flooding-policy-profile(include ipv4-multicast-address downstream policy) and network vsi(refered by a igmp channel)
           3.2 add a child node to identify the flooding-policy-profile refered by a forwarder which identifed
           3.3 modify the ipv4-multicast-address downstream flooding policy according the identification
           3.4 if ipv4-multicast-address downstream flooding policy is discard, will add ipv4-prefix 224.0.0.0/24 to the flooding-policies-profile
           3.5 remove the forwarder and flooding-policy-profile identification node
        4. modify the ntp&rip-multicast-address downstream flooding policy
    -->

    <xsl:template match="/*         /*[name()='forwarding' and namespace-uri() = 'urn:bbf:yang:bbf-l2-forwarding']         /*[name() ='forwarders']         /*[name() = 'forwarder' and child::*[ name()='ports'] and child::*[ name()='flooding-policies']]         ">
        <xsl:variable name="currentFwd" select="./*[name() = 'name']"/>
        <xsl:copy>
            <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
<!--
                search all multicast vpn
            -->
           <xsl:for-each select="/*[name() = 'config']                /*[name() = 'multicast' and namespace-uri() = 'urn:bbf:yang:bbf-mgmd']                /*[name() = 'mgmd']                /*[name() = 'multicast-vpn']                ">
               <!--
                   search all multicast-network-interface in the vpn
               -->
               <xsl:for-each select="./*[name() = 'multicast-network-interface']">
                  <xsl:variable name="network_vsi" select="./*[name() = 'single-uplink-interface-data']/*[name() = 'vlan-sub-interface']"/>
                  <xsl:if test="/*[name() = 'config']                       /*[name() = 'forwarding']                       /*[name() = 'forwarders']                       /*[name() = 'forwarder' and child::*[name() = 'name' and text()=$currentFwd]]                       /*[name() = 'ports']                       /*[name() = 'port' and child::*[name()='sub-interface' and text()=$network_vsi]]                       ">
                  <network-vsi-refered-by-igmp-channel/>
                  </xsl:if>
               </xsl:for-each>
        </xsl:for-each>
       </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
