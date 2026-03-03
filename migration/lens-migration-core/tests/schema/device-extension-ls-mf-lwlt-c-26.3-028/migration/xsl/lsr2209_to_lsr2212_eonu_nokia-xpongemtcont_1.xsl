<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted" xmlns:onu="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount" xmlns:bbf-xpongemtcont="urn:bbf:yang:bbf-xpongemtcont-mounted" xmlns:bbf-xpongemtcont-qos="urn:bbf:yang:bbf-xpongemtcont-qos-mounted" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

<!-- default rule -->
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>


   <!--
       check if t-cont or interface is removed in gemport.
   -->
    <xsl:template match="*[local-name() = 'gemport'          and parent::*[local-name() = 'gemports']         and ancestor::*[local-name() = 'xpongemtcont' and namespace-uri() = 'urn:bbf:yang:bbf-xpongemtcont-mounted']         and ancestor::*[local-name() = 'onus' and namespace-uri() = 'urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount']     ]">
     <xsl:variable name="tcont_name" select="*[local-name() = 'tcont-ref']"/>
     <xsl:variable name="interface_name" select="*[local-name() = 'interface']"/>
    
     <xsl:choose>
       <xsl:when test="not(../../bbf-xpongemtcont:tconts/bbf-xpongemtcont:tcont/bbf-xpongemtcont:name[text()=$tcont_name])">
       </xsl:when>
       <xsl:when test="not(../../../ifNs:interfaces/ifNs:interface/ifNs:name[text()=$interface_name])">
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
