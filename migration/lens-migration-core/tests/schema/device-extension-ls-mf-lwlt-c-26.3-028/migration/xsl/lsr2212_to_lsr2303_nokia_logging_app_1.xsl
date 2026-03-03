<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:nokiaLog="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-logging-app" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

  <!-- Remove  the libcertmanager module from all apps in loggers configuration -->
  <xsl:template match="/tailf:config/nokiaLog:loggers/nokiaLog:enable-logging-for/nokiaLog:modules">
     <xsl:choose><!-- choose 1-->
         <xsl:when test="./nokiaLog:mod-name/text()='libcertmanager'">
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
