<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:newns="http://tail-f.com/ns/aaa/1.1" version="1.0">
   <xsl:strip-space elements="*"/>
   <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
   <xsl:param name="netconf_ns" select="'urn:ietf:params:xml:ns:yang:ietf-netconf-server'"/>

   <!-- default rule -->
   <xsl:template match="*">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>

   <!-- Remove not supported leafs -->
   <xsl:template match="*[name()='keep-alives']">
      <xsl:choose>
         <xsl:when test="namespace-uri() = $netconf_ns and ./ancestor::*[name()='tls']">
         </xsl:when>
         <xsl:when test="namespace-uri() = $netconf_ns and ./ancestor::*[name()='connection-type']">
         </xsl:when>
         <xsl:when test="namespace-uri() = $netconf_ns and ./ancestor::*[name()='netconf-server']">
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
