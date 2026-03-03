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

	<xsl:template match="/*[local-name() = 'config']                 /*[local-name() ='interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']                 /*[local-name() ='interface' and ./*[local-name()='type' and text()='bbfift:vlan-sub-interface']]                 ">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
<xsl:variable name="vsi_name" select="./*[local-name() = 'name']"/>
            <xsl:variable name="itf_usage" select="./*[local-name() = 'interface-usage']/*[local-name() = 'interface-usage']"/>
            <xsl:variable name="inline" select="./*[local-name() = 'inline-frame-processing']"/>
            <xsl:variable name="frame_profile_name" select="./*[local-name() = 'frame-processing-profile-ref']"/>
            <xsl:variable name="vsi_profile_name" select="./*[local-name() = 'vector-profile']"/>

            <!--
                vsi is user-port and meet any of below requirement:
                1. only has vsi-vector-profile and this profile is marked before
                2. has frame-processing-profile-ref and the fpp profile is marked before
            -->
            <xsl:if test="($itf_usage = 'user-port' or $itf_usage = 'inherit' or ($vsi_profile_name and /*[local-name() = 'config']                 /*[local-name() = 'vsi-vector-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-vlan-sub-interface-vector']                 /*[local-name() = 'vsi-vector-profile' and ./*[local-name() = 'name' and text() = $vsi_profile_name]]                 /*[local-name() = 'interface-usage']/*[local-name() = 'interface-usage' and text() = 'user-port']) or                  ($vsi_profile_name and /*[local-name() = 'config']                 /*[local-name() = 'vsi-vector-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-vlan-sub-interface-vector']                 /*[local-name() = 'vsi-vector-profile' and ./*[local-name() = 'name' and text() = $vsi_profile_name]]                 /*[local-name() = 'interface-usage']/*[local-name() = 'interface-usage' and text() = 'subtended-node-port']))                  and (($vsi_profile_name and /*[local-name() = 'config']/*[local-name() = 'dual-tag-rule-temp']                 /*[local-name() = 'marked-dual-tag-vec-profile' and text() = $vsi_profile_name]                 and not($inline) and not($frame_profile_name))                  or ($frame_profile_name and /*[local-name() = 'config']/*[local-name() = 'dual-tag-rule-temp']                 /*[local-name() = 'marked-dual-tag-fpp-profile' and text() = $frame_profile_name]))                 ">
                <wrong-configuration-detected>When user vsi <xsl:value-of select="$vsi_name"/> attach dual tag, must be rejected configuration.</wrong-configuration-detected>
            </xsl:if>
            <xsl:apply-templates/>
</xsl:copy>
    </xsl:template>

</xsl:stylesheet>
