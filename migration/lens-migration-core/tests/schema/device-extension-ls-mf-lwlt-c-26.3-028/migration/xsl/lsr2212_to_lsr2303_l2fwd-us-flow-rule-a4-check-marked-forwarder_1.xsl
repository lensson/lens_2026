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

    <xsl:template match="/*[local-name() = 'config']         /*[local-name() = 'forwarding' and namespace-uri() = 'urn:bbf:yang:bbf-l2-forwarding']         /*[local-name() = 'forwarders']         /*[local-name() = 'forwarder' and ./*[local-name() = 'marked-by-net-vsi']]         ">
        <xsl:variable name="net_vsi" select="./*[local-name()='marked-by-net-vsi']"/>
        <xsl:copy>
            <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
<xsl:for-each select="./*[local-name() = 'ports']/*[local-name() = 'port']">
                <xsl:variable name="refered_vsi" select="./*[local-name()='sub-interface']"/>
                <xsl:if test="/*[local-name() = 'config']/*[local-name() = 'us-flow-rule-temp']                     /*[local-name() = 'marked-user-vsi' and text() = $refered_vsi]">
                    <wrong-configuration-detected>When vsi <xsl:value-of select="$refered_vsi"/> pops tag, vsi <xsl:value-of select="$net_vsi"/> must pushes tags which are same as its ingress match tags.</wrong-configuration-detected>
                </xsl:if>
            </xsl:for-each>
       </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
