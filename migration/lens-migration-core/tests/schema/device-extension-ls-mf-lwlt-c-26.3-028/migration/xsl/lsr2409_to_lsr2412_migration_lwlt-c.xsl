<?xml version='1.0' encoding='utf-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:include href="lsr2409_to_lsr2412_ipfix-caches_lwlt-c.xsl" />
    <xsl:include href="lsr2409_to_lsr2412_nacm_1.xsl" />
    <xsl:include href="lsr2409_to_lsr2412_nokia_licensing_1.xsl" />

    <xsl:include href="lsr2409_to_lsr2412_netconf_server_fingerprints_1.xsl" />
</xsl:stylesheet>