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
<xsl:for-each select="/*[local-name() = 'config']                 /*[local-name() ='interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']                 /*[local-name() ='interface' and ./*[local-name()='type' and text()='bbfift:vlan-sub-interface']                 and not(./*[local-name() = 'name' and text() = 'sinband'])]                 ">
                <xsl:variable name="vsi_name" select="./*[local-name() = 'name']"/>
                <xsl:variable name="itf_usage" select="./*[local-name() = 'interface-usage']/*[local-name() = 'interface-usage']"/>
                <xsl:variable name="inline" select="./*[local-name() = 'inline-frame-processing']"/>
                <xsl:variable name="frame_profile_name" select="./*[local-name() = 'frame-processing-profile-ref']"/>
                <xsl:variable name="vsi_profile_name" select="./*[local-name() = 'vector-profile']"/>
                <xsl:variable name="tag_0_id" select="./*[local-name() = 'tag-0']/*[local-name() = 'vlan-id']"/>
                <xsl:variable name="tag_1_id" select="./*[local-name() = 'tag-1']/*[local-name() = 'vlan-id']"/>
                <!-- inline-frame-processiong -->
                <xsl:variable name="il_match_criteria" select="$inline/*[local-name() = 'ingress-rule']                     /*[local-name() = 'rule']/*[local-name() = 'flexible-match']/*[local-name() = 'match-criteria']"/>
                <xsl:variable name="il_ing_rewrite" select="$inline/*[local-name() = 'ingress-rule']                     /*[local-name() = 'rule']/*[local-name() = 'ingress-rewrite']"/>
                <xsl:variable name="il_eg_rewrite" select="$inline/*[local-name() = 'egress-rewrite']"/>
                <!-- inline match vlan type and vlan id -->
                <xsl:variable name="il_match_outer_tag" select="$il_match_criteria/*[local-name() = 'tag']                     /*[local-name() = 'index' and text() = '0']/../*[local-name() = 'dot1q-tag']"/>
                <xsl:variable name="il_match_outer_type" select="$il_match_outer_tag/*[local-name() = 'tag-type']"/>
                <xsl:variable name="il_match_outer_id" select="$il_match_outer_tag/*[local-name() = 'vlan-id']"/>
                <xsl:variable name="il_match_inner_tag" select="$il_match_criteria/*[local-name() = 'tag']                     /*[local-name() = 'index' and text() = '1']/../*[local-name() = 'dot1q-tag']"/>
                <xsl:variable name="il_match_inner_type" select="$il_match_inner_tag/*[local-name() = 'tag-type']"/>
                <xsl:variable name="il_match_inner_id" select="$il_match_inner_tag/*[local-name() = 'vlan-id']"/>
                <!-- inline push vlan type and vlan id -->
                <xsl:variable name="il_push_outer_tag" select="$il_eg_rewrite/*[local-name() = 'push-tag']                     /*[local-name() = 'index' and text() = '0']/../*[local-name() = 'dot1q-tag']"/>
                <xsl:variable name="il_push_outer_type" select="$il_push_outer_tag/*[local-name() = 'tag-type']"/>
                <xsl:variable name="il_push_outer_id" select="$il_push_outer_tag/*[local-name() = 'vlan-id']"/>
                <xsl:variable name="il_push_inner_tag" select="$il_eg_rewrite/*[local-name() = 'push-tag']                     /*[local-name() = 'index' and text() = '1']/../*[local-name() = 'dot1q-tag']"/>
                <xsl:variable name="il_push_inner_type" select="$il_push_inner_tag/*[local-name() = 'tag-type']"/>
                <xsl:variable name="il_push_inner_id" select="$il_push_inner_tag/*[local-name() = 'vlan-id']"/>
                <!-- frame-processing-profile-ref -->
                <xsl:variable name="fpp" select="/*[local-name() = 'config']                     /*[local-name() = 'frame-processing-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-frame-processing-profile']                     /*[local-name() = 'frame-processing-profile' and ./*[local-name() = 'name' and text() = $frame_profile_name]]"/>
                <xsl:variable name="fpp_match_criteria" select="$fpp/*[local-name() = 'match-criteria']"/>
                <xsl:variable name="fpp_ing_rewrite" select="$fpp/*[local-name() = 'ingress-rewrite']"/>
                <xsl:variable name="fpp_eg_rewrite" select="$fpp/*[local-name() = 'egress-rewrite']"/>
                <!-- fp match vlan type and vlan id -->
                <xsl:variable name="fpp_match_outer_tag" select="$fpp_match_criteria/*[local-name() = 'tag']                     /*[local-name() = 'index' and text() = '0']/.."/>
                <xsl:variable name="fpp_match_outer_type" select="$fpp_match_outer_tag/*[local-name() = 'tag-type']"/>
                <xsl:variable name="fpp_match_outer_id" select="$fpp_match_outer_tag/*[local-name() = 'vlan-id']"/>
                <xsl:variable name="fpp_match_inner_tag" select="$fpp_match_criteria/*[local-name() = 'tag']                     /*[local-name() = 'index' and text() = '1']/.."/>
                <xsl:variable name="fpp_match_inner_type" select="$fpp_match_inner_tag/*[local-name() = 'tag-type']"/>
                <xsl:variable name="fpp_match_inner_id" select="$fpp_match_inner_tag/*[local-name() = 'vlan-id']"/>
                <!-- fp push vlan type and vlan id -->
                <xsl:variable name="fpp_push_outer_tag" select="$fpp_eg_rewrite/*[local-name() = 'push-tag']                     /*[local-name() = 'index' and text() = '0']/.."/>
                <xsl:variable name="fpp_push_outer_type" select="$fpp_push_outer_tag/*[local-name() = 'tag-type']"/>
                <xsl:variable name="fpp_push_outer_id" select="$fpp_push_outer_tag/*[local-name() = 'vlan-id']"/>
                <xsl:variable name="fpp_push_inner_tag" select="$fpp_eg_rewrite/*[local-name() = 'push-tag']                     /*[local-name() = 'index' and text() = '1']/.."/>
                <xsl:variable name="fpp_push_inner_type" select="$fpp_push_inner_tag/*[local-name() = 'tag-type']"/>
                <xsl:variable name="fpp_push_inner_id" select="$fpp_push_inner_tag/*[local-name() = 'vlan-id']"/>

                <!--
                    vsi is not network-port and meet any of below requirement:
                    1. has vsi-vector-profile and this profile is marked before
                    2. has frame-processing-profile-ref and the fpp match untagged or its ingress pop-tags is more than 0
                    3. inline-frame-processing match untagged or its ingress pop-tags is more than 0
                -->
                <xsl:if test="not ($itf_usage = 'network-port' or ($vsi_profile_name and /*[local-name() = 'config']                     /*[local-name() = 'vsi-vector-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-vlan-sub-interface-vector']                     /*[local-name() = 'vsi-vector-profile' and ./*[local-name() = 'name' and text() = $vsi_profile_name]]                     /*[local-name() = 'interface-usage']/*[local-name() = 'interface-usage' and text() = 'network-port']))                      and (($vsi_profile_name and /*[local-name() = 'config']/*[local-name() = 'us-flow-rule-temp']                     /*[local-name() = 'marked-pop-vsi-profile' and text() = $vsi_profile_name])                      or ($frame_profile_name and ($fpp_match_criteria/*[local-name() = 'untagged']                     or $fpp_ing_rewrite/*[local-name() = 'pop-tags' and text() &gt;0]))                      or ($inline and ($il_match_criteria/*[local-name() = 'untagged']                     or $il_ing_rewrite/*[local-name() = 'pop-tags' and text() &gt;0])))                     ">
                    <marked-user-vsi><xsl:value-of select="$vsi_name"/></marked-user-vsi>
                </xsl:if>

                <!--
                    vsi is network-port and meet any of below requirement:
                    1. doesn't have vsi-vector-profile or frame-processing-profile-ref or inline
                    2. has vsi-vector-profile and this profile is marked before
                    3. has frame-processing-profile-ref but this profile's eg pop-tags are not same as ing match tags
                    4. has inline-frame-processing but eg push tags are not same as ing match tags
                -->
                <xsl:if test="($itf_usage = 'network-port' or ($vsi_profile_name and /*[local-name() = 'config']                     /*[local-name() = 'vsi-vector-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-vlan-sub-interface-vector']                     /*[local-name() = 'vsi-vector-profile' and ./*[local-name() = 'name' and text() = $vsi_profile_name]]                     /*[local-name() = 'interface-usage']/*[local-name() = 'interface-usage' and text() = 'network-port']))                      and (not ($vsi_profile_name or $frame_profile_name or $inline)                      or ($vsi_profile_name and /*[local-name() = 'config']/*[local-name() = 'us-flow-rule-temp']                     /*[local-name() = 'marked-push-vsi-profile' and text() = $vsi_profile_name])                      or ($frame_profile_name and not (($fpp_push_outer_type = $fpp_match_outer_type or $fpp_push_outer_type = 'tag-type-from-match')                     and ($fpp_push_outer_id = $fpp_match_outer_id or $fpp_push_outer_id = $tag_0_id or $fpp_push_outer_id = 'vlan-id-from-match')                     and ((not ($fpp_match_inner_tag) and not ($fpp_push_inner_tag))                     or (($fpp_push_inner_type = $fpp_match_inner_type or $fpp_push_inner_type = 'tag-type-from-match')                     and ($fpp_push_inner_id = $fpp_match_inner_id or $fpp_push_inner_id = $tag_1_id or $fpp_push_inner_id = 'vlan-id-from-match')))))                      or ($inline and not ($il_push_outer_type = $il_match_outer_type                     and $il_push_outer_id = $il_match_outer_id                     and ((not ($il_match_inner_tag) and not ($il_push_inner_tag))                     or ($il_push_inner_type = $il_match_inner_type                     and $il_push_inner_id = $il_match_inner_id)))))                     ">
                    <marked-net-vsi><xsl:value-of select="$vsi_name"/></marked-net-vsi>
                </xsl:if>

            </xsl:for-each>
            <xsl:apply-templates/>
</xsl:copy>
    </xsl:template>

</xsl:stylesheet>
