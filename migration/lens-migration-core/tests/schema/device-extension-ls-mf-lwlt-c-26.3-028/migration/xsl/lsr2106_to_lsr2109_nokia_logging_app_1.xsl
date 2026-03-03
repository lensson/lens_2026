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

<!--  Modify the loggers configuration for certmanager_hwa and certmanager_logic -->
  <xsl:template match="/tailf:config/nokiaLog:loggers/nokiaLog:enable-logging-for/nokiaLog:modules/nokiaLog:mod-name">
     <xsl:choose><!-- choose 1-->
         <xsl:when test="text()='libcertmgr_syslog'">
            <mod-name xmlns="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-logging-app">libcertmanager</mod-name>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy>
               <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
         </xsl:otherwise>
     </xsl:choose><!-- /choose 1-->
  </xsl:template>

  <!--  Modify the applications configuration for certmanager_hwa and certmanager_logic -->
  <xsl:template match="/tailf:config/nokiaLog:applications/nokiaLog:enable-logging-for/nokiaLog:modules/nokiaLog:mod-name">
     <xsl:choose><!-- choose 1-->
         <xsl:when test="text()='libcertmanager'">
          <mod-name xmlns="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-logging-app">libcertmgr</mod-name>
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
