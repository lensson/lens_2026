<?xml version="1.0" ?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0"
xmlns:bbfmgmd="urn:bbf:yang:bbf-mgmd"
xmlns:bbf-l2-fwd="urn:bbf:yang:bbf-l2-forwarding">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
<xsl:strip-space elements="*"/>

<!-- default rule -->

<xsl:template match="node()|@*">
    <xsl:copy>
        <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
 </xsl:template>


<!--multicast-interface-to-host must be reference to a unique user side vsi per system-->

<xsl:key name="vsi-mc-host" match="bbfmgmd:multicast-interface-to-host" use="bbfmgmd:vlan-sub-interface"/>

<xsl:template match=
"/tailf:config/bbfmgmd:multicast/bbfmgmd:mgmd/bbfmgmd:multicast-vpn/bbfmgmd:multicast-interface-to-host[not(generate-id() = generate-id(key('vsi-mc-host',bbfmgmd:vlan-sub-interface)[1]))]"/>

<!-- multicast-interface-to-host must be referenced by forwarder port -->

<xsl:key name="fwder-port" match="bbf-l2-fwd:port" use="bbf-l2-fwd:sub-interface"/>

<xsl:template match="/tailf:config/bbfmgmd:multicast/bbfmgmd:mgmd/bbfmgmd:multicast-vpn/bbfmgmd:multicast-interface-to-host[not(key('fwder-port',bbfmgmd:vlan-sub-interface))]"/>

<!-- multicast-snoop-transparent profile to be removed-->

<xsl:template match="bbfmgmd:multicast-snoop-transparent-profile">
</xsl:template>

<!-- multicast-snoop-with-proxy-reporting-profile to be removed -->

<xsl:template match="bbfmgmd:multicast-snoop-with-proxy-reporting-profile">
</xsl:template>

<!-- unsolicited-report-interval and robustness removed from interface-to-router-data -->

<xsl:template match="*[name() = 'unsolicited-report-interval' or name() = 'robustness']">
    <xsl:choose>
            <xsl:when test="parent::*[name() = 'interface-to-router-data']"> 
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
             
