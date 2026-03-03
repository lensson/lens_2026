<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:qosefNs="urn:bbf:yang:bbf-qos-enhanced-filters" xmlns:nqfeNs="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-qos-filters-ext" xmlns:bqpolNs="urn:bbf:yang:bbf-qos-policies" xmlns:bqplcNs="urn:bbf:yang:bbf-qos-policing" version="1.0">

    <xsl:variable name="var_qosefNs">urn:bbf:yang:bbf-qos-enhanced-filters</xsl:variable>
    <xsl:variable name="var_nqfeNs">http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-qos-filters-ext</xsl:variable>
    <xsl:variable name="var_bqpolNs">urn:bbf:yang:bbf-qos-policies</xsl:variable>
    <xsl:variable name="var_bqplcNs">urn:bbf:yang:bbf-qos-policing</xsl:variable>

    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

    <!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*[local-name() = 'ip-common'         and namespace-uri() = 'urn:bbf:yang:bbf-qos-enhanced-filters'         and parent::*[name() = 'filter']         and ancestor::*[name() = 'enhanced-filter']     ]">
        <xsl:variable name="ipv4_node" select="preceding-sibling::*[local-name() = 'ipv4'][namespace-uri() = $var_qosefNs] or following-sibling::*[local-name() = 'ipv4'][namespace-uri() = $var_qosefNs]"/>
        <xsl:variable name="ipv6_node" select="preceding-sibling::*[local-name() = 'ipv6'][namespace-uri() = $var_qosefNs] or following-sibling::*[local-name() = 'ipv6'][namespace-uri() = $var_qosefNs]"/>
        <xsl:variable name="no_ip_filter" select="not ($ipv4_node or $ipv6_node)"/>
        <xsl:choose>
            <xsl:when test="$no_ip_filter">
                <xsl:element name="ipv4" namespace="{$var_qosefNs}">
                    <xsl:element name="source-ipv4-network" namespace="{$var_qosefNs}">0.0.0.0/0</xsl:element>
                </xsl:element>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[         local-name() = 'policy-list'         and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies'         and parent::*[name() = 'policy-profile']     ]">
        <xsl:variable name="child_name" select="child::*[name() = 'name']"/>
        <xsl:variable name="names_need_delete" select="$child_name = 'copyOuterTagDei'             or $child_name = 'copyInnerTagPbit'             or $child_name = 'copyInnerTagDei'         "/>
        <xsl:variable name="defaultCopyPbitDeiToMetadata_node" select="preceding-sibling::*[local-name() = 'name'][text() = 'defaultCopyPbitDeiToMetadata'] or following-sibling::*[local-name() = 'name'][text() = 'defaultCopyPbitDeiToMetadata']"/>
        <xsl:choose>
            <xsl:when test="$names_need_delete and $defaultCopyPbitDeiToMetadata_node">
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[         local-name() = 'unmetered'         and namespace-uri() = 'http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-qos-filters-ext'         and parent::*[name() = 'match-criteria']     ]">
        <xsl:variable name="protocol_igmp_node" select="preceding-sibling::*[local-name() = 'protocol'][text() = 'igmp'] or following-sibling::*[local-name() = 'protocol'][text() = 'igmp']"/>
        <xsl:variable name="flow_color_node" select="preceding-sibling::*[local-name() = 'flow-color'][namespace-uri()= $var_bqplcNs] or following-sibling::*[local-name()= 'flow-color'][namespace-uri()= $var_bqplcNs]"/>
        <xsl:choose>
            <xsl:when test="$protocol_igmp_node or $flow_color_node">
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>        
    </xsl:template>


    <xsl:template match="*[         local-name() = 'filter-operation'         and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers'         and parent::*[name() = 'classifier-entry']         and ancestor::*[name() = 'classifiers']     ]">

        <xsl:variable name="not_has_rate_limit_frames_action" select="not(preceding-sibling::*[local-name() = 'classifier-action-entry-cfg'][child::*[name() = 'rate-limit-frames']] or following-sibling::*[local-name() = 'classifier-action-entry-cfg'][child::*[name() = 'rate-limit-frames']])"/>

        <xsl:choose>
            <xsl:when test="$not_has_rate_limit_frames_action">
                <xsl:element name="filter-operation" namespace="urn:bbf:yang:bbf-qos-classifiers">match-all-filter</xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="*[         local-name() = 'scope'         and namespace-uri() = 'urn:bbf:yang:bbf-qos-policing'         and parent::*[name() = 'policing-profile']         and ancestor::*[name() = 'policing-profiles']     ]">
        <xsl:variable name="name_equals_ccl_policing" select="preceding-sibling::*[local-name() = 'name'][text() = 'ccl-policing'] or following-sibling::*[local-name() = 'name'][text() = 'ccl-policing']"/>
        <xsl:choose>
            <xsl:when test="$name_equals_ccl_policing">
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="*[         local-name() = 'policy-list'         and child::*[name() = 'name'][text() = 'pbitx_to_TCx']         and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies'         and parent::*[name() = 'policy-profile']         and ancestor::*[name() = 'qos-policy-profiles']     ]">
        <xsl:variable name="policy_profile_match_hsi" select="preceding-sibling::*[local-name() = 'name'][text() = 'US_HSI'] or following-sibling::*[local-name() = 'name'][text() = 'US_HSI']"/>
        <xsl:variable name="policy_profile_match_rgw" select="preceding-sibling::*[local-name() = 'name'][text() = 'US_RGW-MGMT'] or following-sibling::*[local-name() = 'name'][text() = 'US_RGW-MGMT']"/>
        <xsl:variable name="policy_profile_match_voip" select="preceding-sibling::*[local-name() = 'name'][text() = 'US_VOIP'] or following-sibling::*[local-name() = 'name'][text() = 'US_VOIP']"/>
        <xsl:variable name="policy_profile_match_vod" select="preceding-sibling::*[local-name() = 'name'][text() = 'US_VOD'] or following-sibling::*[local-name() = 'name'][text() = 'US_VOD']"/>
        <xsl:variable name="policy_profile_match_iptv" select="preceding-sibling::*[local-name() = 'name'][text() = 'US_INGRESS_IPTV'] or following-sibling::*[local-name() = 'name'][text() = 'US_INGRESS_IPTV']"/>
        <xsl:choose>
            <xsl:when test="$policy_profile_match_hsi or $policy_profile_match_rgw or $policy_profile_match_voip or $policy_profile_match_vod or $policy_profile_match_iptv">
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
