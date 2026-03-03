<?xml version='1.0' encoding='utf-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:include href="lsr2412_to_lsr2503_ipfix-caches_lwlt-c.xsl" />
    <xsl:include href="lsr2412_to_lsr2503_nacm_1.xsl" />
    <xsl:include href="lsr2412_to_lsr2503_remove_techsupport_user_2.xsl" />
    <xsl:include href="lsr2412_to_lsr2503_bbf_fiber_rogue_nodes_1.xsl" />
    <xsl:include href="lsr2412_to_lsr2503_config_data_1.xsl" />
    <xsl:include href="lsr2412_to_lsr2503_eonu_pm_tca_profiles_1.xsl" />
    <xsl:include href="lsr2412_to_lsr2503_remove_unsupported_xpaths_2.xsl" />
    <xsl:include href="lsr2412_to_lsr2503_remove_nokia_mgntvlan_termination_interfaces_1.xsl" />
    <xsl:include href="lsr2412_to_lsr2503_eonu_multicast_network_vsi_auto-instantiate_1.xsl" />

</xsl:stylesheet>