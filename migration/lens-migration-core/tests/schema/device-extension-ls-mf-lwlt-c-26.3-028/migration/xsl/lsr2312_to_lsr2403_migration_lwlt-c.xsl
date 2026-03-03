<?xml version='1.0' encoding='utf-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:include href="lsr2312_to_lsr2403_ipfix-caches_lwlt-c.xsl" />
    <xsl:include href="lsr2312_to_lsr2403_nacm_1.xsl" />
    <xsl:include href="lsr2312_to_lsr2403_algorithm_protection_1.xsl" />
    <xsl:include href="lsr2312_to_lsr2403_default_confd_dyncfg_init_1.xsl" />
    <xsl:include href="lsr2312_to_lsr2403_iphost_ipv4_1.xsl" />

</xsl:stylesheet>