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

	<xsl:template match="/*[local-name() = 'config']/*[local-name() = 'dual-tag-rule-temp']">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
<xsl:for-each select="/*[local-name() = 'config']                 /*[local-name() = 'vsi-vector-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-vlan-sub-interface-vector']                 /*[local-name() = 'vsi-vector-profile']                 ">
                <xsl:variable name="vsi_profile_name" select="./*[local-name() = 'name']"/>
                <xsl:variable name="frame_profile_name" select="./*[local-name() = 'frame-processing-profile-ref']"/>

                <!--
                    vsi vector profile has frame processing profile and this profile is marked before
                -->
                <xsl:if test="$frame_profile_name and /*[local-name() = 'config']/*[local-name() = 'dual-tag-rule-temp']                     /*[local-name() = 'marked-dual-tag-fpp-profile' and text() = $frame_profile_name]">	
                    <marked-dual-tag-vec-profile><xsl:value-of select="$vsi_profile_name"/></marked-dual-tag-vec-profile>
                </xsl:if>

            </xsl:for-each>
            <xsl:apply-templates/>
</xsl:copy>
    </xsl:template>

</xsl:stylesheet>
