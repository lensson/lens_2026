<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:xgemtc="urn:bbf:yang:bbf-xpongemtcont">

  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" indent="yes"/>

  
  <!-- Remove the xpongemtcont gemport configuration if there is any 64504 or 64505 exists-->
  <xsl:template match="//xgemtc:xpongemtcont/xgemtc:gemports/xgemtc:gemport[xgemtc:gemport-id = 64504 or xgemtc:gemport-id = 64505 ]"/>

</xsl:stylesheet>

