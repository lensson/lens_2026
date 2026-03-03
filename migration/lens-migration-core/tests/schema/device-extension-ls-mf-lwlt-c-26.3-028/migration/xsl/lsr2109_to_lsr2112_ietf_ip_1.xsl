<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
   <xsl:strip-space elements="*"/>
   <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
   <xsl:param name="ietf_ip" select="'urn:ietf:params:xml:ns:yang:ietf-ip'"/>

   <!-- default rule -->
   <xsl:template match="*">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>

   <!-- Remove not supported leafs -->
   <xsl:template match="*[name()='forwarding' or name()='mtu' or name()='neighbor']">
      <xsl:choose>
         <xsl:when test="namespace-uri() = $ietf_ip and ./ancestor::*[name()='ipv4']">
         </xsl:when>
         <xsl:when test="namespace-uri() = $ietf_ip and ./ancestor::*[name()='ipv6']">
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy>
               <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="*[name()='autoconf' or name()='dup-addr-detect-transmits']">
      <xsl:choose>
         <xsl:when test="namespace-uri() = $ietf_ip and ./ancestor::*[name()='ipv6']">
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
