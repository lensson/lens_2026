<?xml version='1.0' encoding='utf-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
xmlns:map="http://www.w3.org/2005/xpath-functions/map"
xmlns:cfgNs="urn:ietf:params:xml:ns:netconf:base:1.0"
xmlns:if="urn:ietf:params:xml:ns:yang:ietf-interfaces"
>

    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:variable name="interface_map" select="map:merge(for $d in /cfgNs:config/if:interfaces/if:interface return map{$d/if:name : $d})" />

    <xsl:include href="lsr2403_to_lsr2406_ipfix-caches_lwlt-c.xsl" />
    <xsl:include href="lsr2403_to_lsr2406_ipfix_lwlt-c.xsl" />
    <xsl:include href="lsr2403_to_lsr2406_nacm_1.xsl" />
    <xsl:include href="lsr2403_to_lsr2406_ct_statistics_1.xsl" />
    <xsl:include href="lsr2403_to_lsr2406_remove_unsecure_algorithms_1.xsl" />
    <xsl:include href="lsr2403_to_lsr2406_multicast_interface_to_host_per_cp_cg_dimension_1.xsl" />
    <xsl:include href="lsr2403_to_lsr2406_qos_pbit_dei_configuring_improvement_1.xsl" />
    <xsl:include href="lsr2403_to_lsr2406_xpon_aes_1.xsl" />
    <xsl:include href="lsr2403_to_lsr2406_rmtDbg_xgemport_1.xsl" />

</xsl:stylesheet>
