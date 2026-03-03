<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:newns="http://tail-f.com/ns/webui" version="1.0">

    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

<xsl:param name="webui-ns" select="'http://tail-f.com/ns/webui'"/>

<!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

  <!-- Remove the tailf-webui module from configuration -->
  <xsl:template match="*[name() = 'webui']">
     <xsl:choose><!-- choose 1-->
         <xsl:when test="namespace-uri() = $webui-ns and ./parent::*[name()='config']">
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy>
               <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
         </xsl:otherwise>
     </xsl:choose><!-- /choose 1-->
  </xsl:template>

</xsl:stylesheet>
