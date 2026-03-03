<?xml version='1.0' encoding='utf-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:include href="lsr2503_to_lsr2506_ipfix-caches_lwlt-c.xsl" />
    <xsl:include href="lsr2503_to_lsr2506_nacm_1.xsl" />
    <xsl:include href="lsr2503_to_lsr2506_default_confd_dyncfg_init_1.xsl" />

</xsl:stylesheet>