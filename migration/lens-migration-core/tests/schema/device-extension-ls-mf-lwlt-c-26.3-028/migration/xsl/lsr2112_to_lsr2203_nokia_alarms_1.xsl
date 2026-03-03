<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0"
                              xmlns:bbfalarms="urn:bbf:yang:bbf-alarm-management" >
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

  <!-- Remove  the local_alarm module from alarm_logic_app in applications configuration -->
  <xsl:template match="/tailf:config/bbfalarms:alarms">
     <xsl:choose><!-- choose 1-->
         <xsl:when test="./*">
         </xsl:when>
     </xsl:choose><!-- /choose 1-->
  </xsl:template>


</xsl:stylesheet>
