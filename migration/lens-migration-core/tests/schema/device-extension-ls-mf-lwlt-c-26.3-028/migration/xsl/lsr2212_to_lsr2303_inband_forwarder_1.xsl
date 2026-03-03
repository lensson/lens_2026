<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
   <xsl:strip-space elements="*"/>
   <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
   <xsl:param name="bbf-l2-forwarding" select="'urn:bbf:yang:bbf-l2-forwarding'"/>

   <!-- default rule -->
   <xsl:template match="*">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>

   <xsl:template match="*[name()='forwarder']">
      <xsl:choose>
         <xsl:when test="namespace-uri() = $bbf-l2-forwarding and ./child::*[name()='name' and text()='inband-forwarder']">
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
