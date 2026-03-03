<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:confdNS="http://tail-f.com/ns/confd_dyncfg/1.0" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

  <!-- Overwrite maxAttributeValueLength=1024 with 4096-->  
  <xsl:template match="confdNS:parserLimits/confdNS:maxAttributeValueLength[text()='1024']">
          <xsl:element name="maxAttributeValueLength" namespace="http://tail-f.com/ns/confd_dyncfg/1.0">4096</xsl:element>
  </xsl:template> 
 
</xsl:stylesheet>
