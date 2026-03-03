<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:param name="forwardingNameSpace" select="'urn:bbf:yang:bbf-l2-forwarding'"/>

    <!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="/*         /*[name()='forwarding' and namespace-uri() = 'urn:bbf:yang:bbf-l2-forwarding']         /*[name() ='split-horizon-profiles']         /*[name() = 'split-horizon-profile']         /*[name() = 'split-horizon' and child::*[name()='in-interface-usage' and text()='user-port']]         /*[name() = 'out-interface-usage']         ">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>

        <!--
            if split-horizon not include <out-interface-usage>subtended-node-port</out-interface-usage> element
            <out-interface-usage>subtended-node-port</out-interface-usage> will be added as split-horizon child element
        -->
        <xsl:if test="not(../child::*[name()='out-interface-usage' and text()='subtended-node-port'])">
            <xsl:element name="out-interface-usage" namespace="{$forwardingNameSpace}">subtended-node-port</xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template match="/*         /*[name()='forwarding' and namespace-uri() = 'urn:bbf:yang:bbf-l2-forwarding']         /*[name() ='split-horizon-profiles']         /*[name() = 'split-horizon-profile']         /*[name() = 'split-horizon' and child::*[name()='in-interface-usage' and text()='user-port']]         ">
        <xsl:variable name="split-hosrzen-exist" select="../*[name()='split-horizon']/*[name()='in-interface-usage' and text()='subtended-node-port'] "/>
        <xsl:copy>
           <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>

       <!--
           if split-horizon-profile not include split-horizon child element which include <it-interface-usage>subtended-node-port</in-interface-usage> child element
           the split-horizon element will be added as the split-horizon-profile child element
        -->
       <xsl:if test="not(../*[name()='split-horizon']/*[name()='in-interface-usage' and text()='subtended-node-port'])">
           <xsl:element name="split-horizon" namespace="{$forwardingNameSpace}">
               <xsl:element name="in-interface-usage" namespace="{$forwardingNameSpace}">subtended-node-port</xsl:element>
               <xsl:element name="out-interface-usage" namespace="{$forwardingNameSpace}">user-port</xsl:element>
               <xsl:element name="out-interface-usage" namespace="{$forwardingNameSpace}">subtended-node-port</xsl:element>
           </xsl:element>
     </xsl:if>

    </xsl:template>
</xsl:stylesheet>
