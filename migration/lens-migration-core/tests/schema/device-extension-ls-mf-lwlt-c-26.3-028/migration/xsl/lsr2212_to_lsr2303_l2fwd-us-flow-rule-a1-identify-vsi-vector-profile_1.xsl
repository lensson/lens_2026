<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

    <!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="/*[local-name() = 'config']/*[local-name() = 'us-flow-rule-temp']">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
<xsl:for-each select="/*[local-name() = 'config']                 /*[local-name() = 'vsi-vector-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-vlan-sub-interface-vector']                 /*[local-name() = 'vsi-vector-profile']                 ">
                <xsl:variable name="vsi_profile_name" select="./*[local-name() = 'name']"/>
                <xsl:variable name="frame_profile_name" select="./*[local-name() = 'frame-processing-profile-ref']"/>
                <xsl:variable name="tag_0_id" select="./*[local-name() = 'tag-0']/*[local-name() = 'vlan-id']"/>
                <xsl:variable name="tag_1_id" select="./*[local-name() = 'tag-1']/*[local-name() = 'vlan-id']"/>
                <xsl:variable name="fpp" select="/*[local-name() = 'config']                     /*[local-name() = 'frame-processing-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-frame-processing-profile']                     /*[local-name() = 'frame-processing-profile' and ./*[local-name() = 'name' and text() = $frame_profile_name]]"/>
                <xsl:variable name="fpp_match_criteria" select="$fpp/*[local-name() = 'match-criteria']"/>
                <xsl:variable name="fpp_ing_rewrite" select="$fpp/*[local-name() = 'ingress-rewrite']"/>
                <xsl:variable name="fpp_eg_rewrite" select="$fpp/*[local-name() = 'egress-rewrite']"/>
                <!-- match vlan type and vlan id -->
                <xsl:variable name="match_outer_tag" select="$fpp_match_criteria/*[local-name() = 'tag']                     /*[local-name() = 'index' and text() = '0']/.."/>
                <xsl:variable name="match_outer_type" select="$match_outer_tag/*[local-name() = 'tag-type']"/>
                <xsl:variable name="match_outer_id" select="$match_outer_tag/*[local-name() = 'vlan-id']"/>
                <xsl:variable name="match_inner_tag" select="$fpp_match_criteria/*[local-name() = 'tag']                     /*[local-name() = 'index' and text() = '1']/.."/>
                <xsl:variable name="match_inner_type" select="$match_inner_tag/*[local-name() = 'tag-type']"/>
                <xsl:variable name="match_inner_id" select="$match_inner_tag/*[local-name() = 'vlan-id']"/>
                <!-- push vlan type and vlan id -->
                <xsl:variable name="push_outer_tag" select="$fpp_eg_rewrite/*[local-name() = 'push-tag']                     /*[local-name() = 'index' and text() = '0']/.."/>
                <xsl:variable name="push_outer_type" select="$push_outer_tag/*[local-name() = 'tag-type']"/>
                <xsl:variable name="push_outer_id" select="$push_outer_tag/*[local-name() = 'vlan-id']"/>
                <xsl:variable name="push_inner_tag" select="$fpp_eg_rewrite/*[local-name() = 'push-tag']                     /*[local-name() = 'index' and text() = '1']/.."/>
                <xsl:variable name="push_inner_type" select="$push_inner_tag/*[local-name() = 'tag-type']"/>
                <xsl:variable name="push_inner_id" select="$push_inner_tag/*[local-name() = 'vlan-id']"/>

                <!--
                    vsi vector profile has frame processing profile and the fpp meet any of below scenarios:
                    1. matches untagged
                    2. ingress pop-tags is more than 0
                -->
                <xsl:if test="$frame_profile_name and ($fpp_match_criteria/*[local-name() = 'untagged']                     or $fpp_ing_rewrite/*[local-name() = 'pop-tags' and text() &gt;0])">
                    <marked-pop-vsi-profile><xsl:value-of select="$vsi_profile_name"/></marked-pop-vsi-profile>
                </xsl:if>

                <!--
                    vsi vector profile has frame processing profile and the fpp can't meet all below requirements:
                    1. eg push outer tag is same as ing match outer tag
                    2. don't have eg push inner tag and ing match inner tag or eg push inner tag is same as ing match inner tag
                -->
                <xsl:if test="$frame_profile_name                     and not (($push_outer_type = $match_outer_type or $push_outer_type = 'tag-type-from-match')                     and ($push_outer_id = $match_outer_id or $push_outer_id = $tag_0_id or $push_outer_id = 'vlan-id-from-match')                     and ((not ($match_inner_tag) and not ($push_inner_tag))                     or (($push_inner_type = $match_inner_type or $push_inner_type = 'tag-type-from-match')                     and ($push_inner_id = $match_inner_id or $push_inner_id = $tag_1_id or $push_inner_id = 'vlan-id-from-match'))))">
                    <marked-push-vsi-profile><xsl:value-of select="$vsi_profile_name"/></marked-push-vsi-profile>
                </xsl:if>
            </xsl:for-each>
            <xsl:apply-templates/>
</xsl:copy>
    </xsl:template>

</xsl:stylesheet>
