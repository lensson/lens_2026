<?xml version='1.0' encoding='utf-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:include href="lsr2306_to_lsr2309_ipfix-caches_lwlt-c.xsl" />
    <xsl:include href="lsr2306_to_lsr2309_dot1x_2.xsl" />
    <xsl:include href="lsr2306_to_lsr2309_nacm_1.xsl" />
    <xsl:include href="lsr2306_to_lsr2309_netconf_server_1.xsl" />
    <xsl:include href="lsr2306_to_lsr2309_eonu_pm_tca_profiles_1.xsl" />
    <xsl:include href="lsr2306_to_lsr2309_eonu_gemport_id_1.xsl" />
    <xsl:include href="lsr2306_to_lsr2309_eqpt-onu-board_1.xsl" />
    <xsl:include href="lsr2306_to_lsr2309_xpon_merged_1.xsl" />
    <xsl:include href="lsr2306_to_lsr2309_xpon_others_1.xsl" />
    <xsl:include href="lsr2306_to_lsr2309_confd_dyncfg_init_1.xsl" />

</xsl:stylesheet>