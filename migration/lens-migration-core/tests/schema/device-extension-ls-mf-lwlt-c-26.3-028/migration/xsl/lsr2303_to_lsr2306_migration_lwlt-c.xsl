<?xml version='1.0' encoding='utf-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:include href="lsr2303_to_lsr2306_ipfix-caches_lwlt-c.xsl" />
    <xsl:include href="lsr2303_to_lsr2306_nacm_1.xsl" />
    <xsl:include href="lsr2303_to_lsr2306_l2fwd-dual-tag-rule-a0-temp-node_1.xsl" />
    <xsl:include href="lsr2303_to_lsr2306_eonu-clock-ssm-incidental-gemport_1.xsl" />
    <xsl:include href="lsr2303_to_lsr2306_xpon_others_1.xsl" />
    <xsl:include href="lsr2303_to_lsr2306_xpon_rangeValidation_1.xsl" />
    <xsl:include href="lsr2303_to_lsr2306_xpon_merged_1.xsl" />
    <xsl:include href="lsr2303_to_lsr2306_eonu_qos_classifiers_1.xsl" />
    <xsl:include href="lsr2303_to_lsr2306_eonu_cpu_1.xsl" />
    <xsl:include href="lsr2303_to_lsr2306_eonu_removeBoard_cpu_1.xsl" />
    <xsl:include href="lsr2303_to_lsr2306_eonu_remove_unsupported_1.xsl" />
    <xsl:include href="lsr2303_to_lsr2306_aaa_1.xsl" />
    <xsl:include href="lsr2303_to_lsr2306_l2fwd-frame-processing-profile-without-match-criteria_1.xsl" />
    <xsl:include href="lsr2303_to_lsr2306_l2fwd-vlan-sub-interface-without-match-criteria_1.xsl" />

</xsl:stylesheet>