<?xml version='1.0' encoding='utf-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:strip-space elements="*" />
    <xsl:output encoding="UTF-8" indent="yes" method="xml" />

    <xsl:include href="lsr2406_to_lsr2409_ipfix-caches_lwlt-c.xsl" />
    <xsl:include href="lsr2406_to_lsr2409_nacm_1.xsl" />
    <xsl:include href="lsr2406_to_lsr2409_l2fwd_pop_push_1.xsl" />
    <xsl:include href="lsr2406_to_lsr2409_keystore_1.xsl" />
    <xsl:include href="lsr2406_to_lsr2409_dscp_1.xsl" />
    <xsl:include href="lsr2406_to_lsr2409_dhcp_1.xsl" />

</xsl:stylesheet>