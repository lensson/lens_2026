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

    <xsl:template match="/*         /*[name()='forwarding' and namespace-uri() = 'urn:bbf:yang:bbf-l2-forwarding']         /*[name() ='mac-learning-control-profiles']         /*[name() = 'mac-learning-control-profile']         /*[name() = 'mac-learning-rule' and child::*[name()='receiving-interface-usage' and text()='user-port']]         /*[name() = 'mac-can-not-move-to']         ">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
        <!--
            if mac-learning-rule not include <mac-can-not-move-to>subtended-node-port</mac-can-not-move-to>
            <mac-can-not-move-to>subtended-node-port</mac-can-not-move-to> will be added as mac-learning-rule child element
        -->
        <xsl:if test="not(../child::*[name()='mac-can-not-move-to' and text()='subtended-node-port'])">
            <xsl:element name="mac-can-not-move-to" namespace="{$forwardingNameSpace}">subtended-node-port</xsl:element>
        </xsl:if>
    </xsl:template>


    <xsl:template match="/*         /*[name()='forwarding' and namespace-uri() = 'urn:bbf:yang:bbf-l2-forwarding']         /*[name() ='mac-learning-control-profiles']         /*[name() = 'mac-learning-control-profile']         /*[name() = 'mac-learning-rule' and child::*[name()='receiving-interface-usage' and text()='user-port']]         ">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>

        <!--
            if mac-learning-control-profile not include mac-learning-rule child element which include receiving-interface-usage is subtended-node-port
            mac-learning-rule element that include receiving-interface-usage is subtended-node-port child element will be added
        -->
        <xsl:if test="not(../*[name()='mac-learning-rule']/*[name()='receiving-interface-usage' and text()='subtended-node-port'] )">
             <xsl:element name="mac-learning-rule" namespace="{$forwardingNameSpace}">
                 <xsl:element name="receiving-interface-usage" namespace="{$forwardingNameSpace}">subtended-node-port</xsl:element>
                 <xsl:element name="mac-can-not-move-to" namespace="{$forwardingNameSpace}">user-port</xsl:element>
                 <xsl:element name="mac-can-not-move-to" namespace="{$forwardingNameSpace}">subtended-node-port</xsl:element>
             </xsl:element>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
