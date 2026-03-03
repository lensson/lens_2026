<?xml version='1.0' encoding='utf-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:include href="lsr2309_to_lsr2312_ipfix-caches_lwlt-c.xsl" />
    <xsl:include href="lsr2309_to_lsr2312_nacm_1.xsl" />
    <xsl:include href="lsr2309_to_lsr2312_multicast_interface_to_host_dimension_1.xsl" />
    <xsl:include href="lsr2309_to_lsr2312_confd_dyncfg_1.xsl" />
    <xsl:include href="lsr2309_to_lsr2312_xpon_auth_1.xsl" />
    <xsl:include href="lsr2309_to_lsr2312_ipfix_validator_lwlt-c.xsl" />
    <xsl:include href="lsr2309_to_lsr2312_cfm_ccm_1.xsl" />

</xsl:stylesheet>