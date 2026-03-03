<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:param name="forwardingNameSpace" select="'urn:bbf:yang:bbf-l2-forwarding'"/>

    <!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <!--
        1. remove all ipv4-prefix flooding policy
      >>2. add subtend-node-port to all downstream flooding policy out-interface-usages except ipv4-multicast-address
        3. modify ipv4-multicast-address dowanstream flooding policy
           3.1 add a child node to identify the forwarder which include a flooding-policy-profile(include ipv4-multicast-address downstream policy) and network vsi(refered by a igmp channel)
           3.2 add a child node to identify the flooding-policy-profile refered by a forwarder which identifed
           3.3 modify the ipv4-multicast-address downstream flooding policy according the identification
           3.4 if ipv4-multicast-address downstream flooding policy is discard, will add ipv4-prefix 224.0.0.0/24 to the flooding-policies-profile
           3.5 remove the forwarder and flooding-policy-profile identification node
        4. modify the ntp&rip-multicast-address downstream flooding policy
    -->

    <!--
    pre condition:
       1. downstream flooding policy
       2. destination not ipv4-multicast-address

    scenatio 1: if dsicard and <out-interface-usages> are both not exist
    expected behavior: element
        <out-interface-usages>
           <interface-usages>subtended-node-port</interface-usages>
        </out-interface-usages>
        will be added as flooding policy child element

    scenario 2: if discard exist
    expected behavior: element
        <out-interface-usages>
           <interface-usages>subtended-node-port</interface-usages>
        </out-interface-usages>
        will be added as flooding policy child element

    scenatio 3: if <out-interface-usages> child element exist
    expected behavior:  element
           <interface-usages>subtended-node-port</interface-usages>
        will be added as out-interface-usages child element

    -->

    <!-- interface-usages variable-->
    <xsl:variable name="add_interface-usages">
        <xsl:element name="interface-usages" namespace="{$forwardingNameSpace}">subtended-node-port</xsl:element>
    </xsl:variable>

    <!-- out-interface-usages variable which include subtended-node-port in interface usage-->
    <xsl:variable name="add_out-interface-usages">
        <xsl:element name="out-interface-usages" namespace="{$forwardingNameSpace}">
            <xsl:copy-of select="$add_interface-usages"/>
        </xsl:element>
    </xsl:variable>

   <!--
       scenatio 1: if dsicard and <out-interface-usages> are both not exist
       expected behavior: element
           <out-interface-usages>
              <interface-usages>subtended-node-port</interface-usages>
           </out-interface-usages>
           will be added as flooding policy child element
   -->
    <xsl:template match="/*         /*[name()='forwarding' and namespace-uri() = 'urn:bbf:yang:bbf-l2-forwarding']         /*[name() ='flooding-policies-profiles']         /*[name() = 'flooding-policies-profile']         /*[name() = 'flooding-policy' and ./*[name()='in-interface-usages']/*[name()='interface-usages' and text() = 'network-port']         ]">

        <xsl:variable name="discard-outiterfaces-not-exist" select="not(./*[name()='destination-address']/*[name() = 'ipv4-multicast-address'])             and not(./*[name() = 'out-interface-usages']) and not(./*[name()='discard'])"/>

        <xsl:choose>
            <xsl:when test="$discard-outiterfaces-not-exist">
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
                    <xsl:copy-of select="$add_out-interface-usages"/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
        scenario 2: if discard exist
        expected behavior: element
            <out-interface-usages>
               <interface-usages>subtended-node-port</interface-usages>
            </out-interface-usages>
            will be added as flooding policy child element
    -->
    <xsl:template match="/*         /*[name()='forwarding' and namespace-uri() = 'urn:bbf:yang:bbf-l2-forwarding']         /*[name() ='flooding-policies-profiles']         /*[name() = 'flooding-policies-profile']         /*[name() = 'flooding-policy' and ./*[name()='in-interface-usages']/*[name()='interface-usages' and text() = 'network-port']]         /*[name() = 'discard']         ">

        <xsl:variable name="destiantion-match" select="not(../*[name()='destination-address']/*[name()='ipv4-multicast-address'])"/>

        <xsl:choose>
            <xsl:when test="$destiantion-match">
                <xsl:copy-of select="$add_out-interface-usages"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
        scenatio 3: if <out-interface-usages> child element exist
        expected behavior:  element
            <interface-usages>subtended-node-port</interface-usages>
            will be added as out-interface-usages child element
    -->
    <xsl:template match="/*         /*[name()='forwarding' and namespace-uri() = 'urn:bbf:yang:bbf-l2-forwarding']         /*[name() ='flooding-policies-profiles']         /*[name() = 'flooding-policies-profile']         /*[name() = 'flooding-policy' and ./*[name()='in-interface-usages']/*[name()='interface-usages' and text() = 'network-port']]         /*[name() = 'out-interface-usages']         ">

        <xsl:variable name="destiantion-match" select="not(../*[name()='destination-address']/*[name()='ipv4-multicast-address'])"/>

        <xsl:choose>
            <xsl:when test="$destiantion-match">
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
                    <xsl:copy-of select="$add_interface-usages"/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
