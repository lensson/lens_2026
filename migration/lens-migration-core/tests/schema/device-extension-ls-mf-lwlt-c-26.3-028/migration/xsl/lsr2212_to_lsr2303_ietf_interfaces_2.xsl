<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
   <xsl:strip-space elements="*"/>
   <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
   <xsl:param name="ietf_interfaces" select="'urn:ietf:params:xml:ns:yang:ietf-interfaces'"/>

   <!-- default rule -->
   <xsl:template match="*">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>

   <xsl:template match="*[name()='interface']">
      <xsl:choose>
         <xsl:when test="namespace-uri() = $ietf_interfaces and ./child::*[name()='name' and text()='inband']">
         </xsl:when>
         <xsl:when test="namespace-uri() = $ietf_interfaces and ./child::*[name()='name' and text()='inband-l2term']">
         </xsl:when>
         <xsl:when test="namespace-uri() = $ietf_interfaces and ./child::*[name()='name' and text()='sinband']">
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
