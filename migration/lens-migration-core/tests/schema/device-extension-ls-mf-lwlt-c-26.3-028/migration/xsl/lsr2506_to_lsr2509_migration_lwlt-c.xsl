<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!-- Identity transform -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:include href="lsr2506_to_lsr2509_dot1x_dyn_auth_1.xsl"/>
    <xsl:include href="lsr2506_to_lsr2509_ipfix-caches_lwlt-c.xsl"/>
    <xsl:include href="lsr2506_to_lsr2509_nacm_1.xsl"/>
    <xsl:include href="lsr2506_to_lsr2509_qos_delete_unused_yang.xsl"/>

</xsl:stylesheet>
