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
<xsl:for-each select="/*[local-name() = 'config']                 /*[local-name() = 'frame-processing-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-frame-processing-profile']                 /*[local-name() = 'frame-processing-profile']                 ">
                <xsl:variable name="frame_profile_name" select="./*[local-name() = 'name']"/>
                <xsl:variable name="fpp_match_criteria" select="./*[local-name() = 'match-criteria']"/>

                <!--
                    frame processing profile have dual tag:
                    1. tag 0
                    2. tag 1
                -->
                <xsl:if test="$fpp_match_criteria/*[local-name() = 'tag']/*[local-name() = 'index' and text() = '0']                     and $fpp_match_criteria/*[local-name() = 'tag']/*[local-name() = 'index' and text() = '1']">
                    <marked-dual-tag-fpp-profile><xsl:value-of select="$frame_profile_name"/></marked-dual-tag-fpp-profile>
                </xsl:if>
            </xsl:for-each>
            <xsl:apply-templates/>
</xsl:copy>
    </xsl:template>

</xsl:stylesheet>
