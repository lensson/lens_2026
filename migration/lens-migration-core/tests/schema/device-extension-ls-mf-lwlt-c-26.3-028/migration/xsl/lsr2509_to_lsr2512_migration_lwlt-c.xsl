<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!-- Identity transform -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:include href="lsr2509_to_lsr2512_ipfix-caches_lwlt-c.xsl"/>
    <xsl:include href="lsr2509_to_lsr2512_nacm_1.xsl"/>
    <xsl:include href="lsr2509_to_lsr2512_eonu_veip_vsi_auto-instantiate_1.xsl"/>
    <xsl:include href="lsr2509_to_lsr2512_eonu_clock_ssm.xsl"/>

</xsl:stylesheet>
