<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:if="urn:ietf:params:xml:ns:yang:ietf-interfaces"
                xmlns:nokia-itfstat="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-interfaces-statistics">

  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" indent="yes"/>
   <xsl:variable name="defaultValue" select="'best-effort'"/>

   <xsl:template match="//if:interfaces/if:interface[normalize-space(if:type)='bbf-xponift:channel-termination']/nokia-itfstat:statistics/nokia-itfstat:enable[text()='false']">
        <xsl:copy>
           <xsl:copy-of select="@*"/>
           <xsl:value-of select="$defaultValue"/>
        </xsl:copy>
   </xsl:template>

</xsl:stylesheet>
