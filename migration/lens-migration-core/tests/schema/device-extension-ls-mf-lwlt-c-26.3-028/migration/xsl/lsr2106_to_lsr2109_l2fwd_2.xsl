<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tailf="http://tail-f.com/ns/config/1.0" xmlns:bbf-l2-fwd="urn:bbf:yang:bbf-l2-forwarding" xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces" xmlns:ifUsageNs="urn:bbf:yang:bbf-interface-usage" xmlns:fdbnsp="urn:bbf:yang:bbf-l2-forwarding" version="1.0">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
<xsl:strip-space elements="*"/>

<!-- default rule -->

<xsl:template match="node()|@*">
    <xsl:copy>
       <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
</xsl:template>

<!-- discard-frame is removed from config -->

<xsl:template match="bbf-l2-fwd:discard-frame">
</xsl:template>

  <xsl:template match="/">
     <xsl:choose>
        <xsl:when test="(count(/tailf:config/ifNs:interfaces/ifNs:interface[ifUsageNs:interface-usage/ifUsageNs:interface-usage='user-port']) &lt;= 8192) and (count(/tailf:config/ifNs:interfaces/ifNs:interface[ifUsageNs:interface-usage/ifUsageNs:interface-usage='network-port']) &lt;= 8257) ">
            <xsl:copy>
                <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
        </xsl:when>
        <xsl:otherwise>
            <xsl:comment>Error-log: Max vsi reached - Migration is not successful</xsl:comment>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:otherwise>
     </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
