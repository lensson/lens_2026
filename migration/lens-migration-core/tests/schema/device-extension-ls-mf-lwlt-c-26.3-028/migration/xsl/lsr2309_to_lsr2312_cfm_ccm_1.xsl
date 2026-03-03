<?xml version="1.0" ?>

<xsl:stylesheet version="1.0"
     xmlns:cfgns="urn:ietf:params:xml:ns:netconf:base:1.0"
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
     xmlns:cfmns="urn:ieee:std:802.1Q:yang:ieee802-dot1q-cfm"
     xmlns:ltmns="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-ieee802-dot1q-cfm-linktrace-aug"
    >

<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
<xsl:strip-space elements="*"/>
<xsl:param name="ccmLtmPrioNewNs" select="'http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-ieee802-dot1q-cfm-aug'"/>

<!-- change new namespace : nokia-ieee802-dot1q-cfm-linktrace-aug -> nokia-sdan-ieee802-dot1q-cfm-aug -->
<xsl:template match="/cfgns:config/cfmns:cfm/cfmns:maintenance-group/cfmns:mep/ltmns:ccm-ltm-inner-tag-priority">
   <xsl:element name="{name()}" namespace="{$ccmLtmPrioNewNs}">
     <xsl:apply-templates select="@* | node()"/>
   </xsl:element>
</xsl:template>

</xsl:stylesheet>
