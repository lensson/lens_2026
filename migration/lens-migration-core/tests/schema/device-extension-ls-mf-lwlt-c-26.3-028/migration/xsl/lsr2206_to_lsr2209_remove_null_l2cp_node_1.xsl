<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

    <!-- default rule  -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

   <!--
       delete null l2cp node
   -->
    <xsl:template match="/*
                         /*[name()='interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']
                         /*[name() ='interface' and ./*[name() = 'type' and text() = 'bbfift:vlan-sub-interface']]
                         /*[name() = 'l2cp']
                         ">
        <xsl:choose>
            <xsl:when test="not (./*[name() ='l2cp-address-service'])">
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
