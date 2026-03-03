<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cfgNs="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:mgmdNs="urn:bbf:yang:bbf-mgmd" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

	<xsl:variable name="cfg_mgmd" select="/cfgNs:config/mgmdNs:multicast/mgmdNs:mgmd"/>
	
<!-- 
    multicast-interface-to-host dimension:8192
    add invalid element if multicast-interface-to-host number reach the dimension
-->

	<xsl:template match="/cfgNs:config/mgmdNs:multicast/mgmdNs:mgmd">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
<xsl:if test="count($cfg_mgmd/mgmdNs:multicast-vpn/mgmdNs:multicast-interface-to-host)                  &gt;8192                 ">
            <wrong-configuration-detected>Multicast host exceed max dimension value 8K.</wrong-configuration-detected>
            </xsl:if>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
