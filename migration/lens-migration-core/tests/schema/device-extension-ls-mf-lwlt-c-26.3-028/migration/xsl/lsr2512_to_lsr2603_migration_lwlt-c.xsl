<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!-- Identity transform -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:include href="lsr2512_to_lsr2603_ipfix-caches_lwlt-c.xsl"/>
    <xsl:include href="lsr2512_to_lsr2603_nacm_1.xsl"/>
    <xsl:include href="lsr2512_to_lsr2603_end-entity-certificate-renew-policy_1.xsl"/>

  <xsl:include href="lsr2512_to_lsr2603_confd8_unsecure_algorithms.xsl"/>
  <xsl:include href="lsr2512_to_lsr2603_new_defaults_confd_dyncfg_init.xsl"/>
  <xsl:include href="lsr2512_to_lsr2603_xpon_mc_gemport_1.xsl"/>
  <xsl:include href="lsr2512_to_lsr2603_eonu_clock_ptp.xsl"/>
</xsl:stylesheet>
