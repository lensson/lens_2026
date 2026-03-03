<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:bbfmgmd="urn:bbf:yang:bbf-mgmd" xmlns:bbf-l2-fwd="urn:bbf:yang:bbf-l2-forwarding" version="1.0">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
<xsl:strip-space elements="*"/>

<!-- default rule -->

<xsl:template match="node()|@*">
    <xsl:copy>
        <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
</xsl:template>

<!-- multicast-network-interface must be reference to a unique network side vsi per system-->

<xsl:key name="vsi-mc-net" match="bbfmgmd:single-uplink-interface-data" use="bbfmgmd:vlan-sub-interface"/>

<xsl:template match="/tailf:config/bbfmgmd:multicast/bbfmgmd:mgmd/bbfmgmd:multicast-vpn/bbfmgmd:multicast-network-interface">
<xsl:choose>
    <xsl:when test="generate-id(bbfmgmd:single-uplink-interface-data) = generate-id(key('vsi-mc-net',.//bbfmgmd:vlan-sub-interface)[1])">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
     </xsl:when>
    <xsl:otherwise>
        <wrong-configuration-detected>VSI used in below Network Interface is already used - Migration is not Succesful</wrong-configuration-detected>
            <xsl:copy>
                <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
    </xsl:otherwise>
</xsl:choose>
</xsl:template>
</xsl:stylesheet>
