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
         >>3.2 add a child node to identify the flooding-policy-profile refered by a forwarder which identifed
           3.3 modify the ipv4-multicast-address downstream flooding policy according the identification
           3.4 if ipv4-multicast-address downstream flooding policy is discard, will add ipv4-prefix 224.0.0.0/24 to the flooding-policies-profile
           3.5 remove the forwarder and flooding-policy-profile identification node
        4. modify the ntp&rip-multicast-address downstream flooding policy
    -->
    <xsl:template match="/*         /*[name()='forwarding' and namespace-uri() = 'urn:bbf:yang:bbf-l2-forwarding']         /*[name() ='flooding-policies-profiles']         /*[name() = 'flooding-policies-profile' and child::*[ descendant::*[text()='network-port'] and descendant::*[name()='ipv4-multicast-address'] ]]         ">
        <xsl:variable name="profile-name" select="./*[name() = 'name']"/>

        <xsl:copy>
           <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
<xsl:if test="/*[name() = 'config']                 /*[name() = 'forwarding']                 /*[name() = 'forwarders']                 /*[name() = 'forwarder' and child::*[name() = 'network-vsi-refered-by-igmp-channel'] and descendant::*[name() = 'flooding-policies-profile' and text()=$profile-name]]                 ">
                <current-profile-be-marked/>
            </xsl:if>
       </xsl:copy>

    </xsl:template>

</xsl:stylesheet>
