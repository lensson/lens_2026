<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">	
   <xsl:strip-space elements="*"/>
   <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
   <xsl:param name="ietf_routing" select="'urn:ietf:params:xml:ns:yang:ietf-routing'"/>
   <xsl:param name="ietf_v4_routing" select="'urn:ietf:params:xml:ns:yang:ietf-ipv4-unicast-routing'"/>
   <xsl:param name="ietf_v6_routing" select="'urn:ietf:params:xml:ns:yang:ietf-ipv6-unicast-routing'"/>

   <!-- default rule -->
   <xsl:template match="*">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>

   <!-- Remove not supported leafs -->
   <xsl:template match="*[name()='ribs']">
      <xsl:choose>
         <xsl:when test="namespace-uri() = $ietf_routing and ./ancestor::*[name()='routing']">
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy>
               <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="*[name()='outgoing-interface']">
      <xsl:choose>
         <xsl:when test="namespace-uri() = $ietf_v4_routing and ./ancestor::*[name()='next-hop']">
         </xsl:when>
         <xsl:when test="namespace-uri() = $ietf_v6_routing and ./ancestor::*[name()='next-hop']">
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy>
               <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="*[name()='ipv6-router-advertisements']">
      <xsl:choose>
         <xsl:when test="namespace-uri() = $ietf_v6_routing and ./ancestor::*[name()='ipv6']">
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
