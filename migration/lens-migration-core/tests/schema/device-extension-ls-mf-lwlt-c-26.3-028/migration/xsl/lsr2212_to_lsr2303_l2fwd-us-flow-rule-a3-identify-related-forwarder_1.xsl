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

    <xsl:template match="/*[local-name() = 'config']         /*[local-name() = 'forwarding' and namespace-uri() = 'urn:bbf:yang:bbf-l2-forwarding']         /*[local-name() = 'forwarders']         /*[local-name() = 'forwarder']         ">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
<xsl:for-each select="./*[local-name() = 'ports']/*[local-name() = 'port']">
                <xsl:variable name="refered_vsi" select="./*[local-name()='sub-interface']"/>
                <xsl:if test="/*[local-name() = 'config']/*[local-name() = 'us-flow-rule-temp']                     /*[local-name() = 'marked-net-vsi' and text() = $refered_vsi]">
                    <marked-by-net-vsi><xsl:value-of select="$refered_vsi"/></marked-by-net-vsi>
                </xsl:if>
            </xsl:for-each>
       </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
