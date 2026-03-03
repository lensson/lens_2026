<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cfgNs="urn:ietf:params:xml:ns:netconf:base:1.0" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

    <!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <!--
        identify and mark all admin-down network VSI
    -->
    <xsl:template match="/*         /*[local-name() = 'interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']         /*[local-name() = 'interface' and child::*[local-name() = 'type' and text() = 'bbfift:vlan-sub-interface']]         /*[local-name() = 'enabled' and text() = 'false']         ">
        <xsl:variable name="currentVSI" select="../*[local-name() = 'name']"/>
        <xsl:variable name="lowerItf" select="../*[local-name() = 'subif-lower-layer']/*[local-name() = 'interface']"/>
        <xsl:variable name="usage" select="../*[local-name() = 'interface-usage']/*[local-name() = 'interface-usage']"/>
        <xsl:variable name="vectorProfile" select="../*[local-name() = 'vector-profile']"/>
        
        <xsl:copy>
            <xsl:copy-of select="@*"/>
<xsl:choose>                
                <xsl:when test="$usage='network-port'">
                    <xsl:text>changed-to-true</xsl:text>
                </xsl:when>
                <xsl:when test="$usage='inherit'">
                    <xsl:variable name="lowerUsage" select="/*                         /*[local-name() = 'interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']                         /*[local-name() = 'interface' and child::*[local-name() = 'name' and text() = $lowerItf]]                         /*[local-name() = 'interface-usage']/*[local-name() = 'interface-usage']"/>
                    <xsl:choose>                
                        <xsl:when test="$lowerUsage='network-port'">
                            <xsl:text>changed-to-true</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates/>
</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$usage">
                    <xsl:apply-templates/>
</xsl:when>
                <xsl:when test="$vectorProfile">
                    <xsl:variable name="vectorUsage" select="/*                         /*[local-name() = 'vsi-vector-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-vlan-sub-interface-vector']                         /*[local-name() = 'vsi-vector-profile' and child::*[local-name() = 'name' and text() = $vectorProfile]]                         /*[local-name() = 'interface-usage']/*[local-name() = 'interface-usage']"/>
                    <xsl:choose>                
                        <xsl:when test="$vectorUsage='network-port'">
                            <xsl:text>changed-to-true</xsl:text>
                        </xsl:when>
                        <xsl:when test="$vectorUsage='inherit'">
                            <xsl:variable name="lowerUsage" select="/*                                 /*[local-name() = 'interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']                                 /*[local-name() = 'interface' and child::*[local-name() = 'name' and text() = $lowerItf]]                                 /*[local-name() = 'interface-usage']/*[local-name() = 'interface-usage']"/>
                            <xsl:choose>                
                                <xsl:when test="$lowerUsage='network-port'">
                                    <xsl:text>changed-to-true</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:apply-templates/>
</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates/>
</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
</xsl:otherwise>
            </xsl:choose>
       </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
