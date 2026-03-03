<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:onuNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount" xmlns:bbf-xpongemtcont="urn:bbf:yang:bbf-xpongemtcont-mounted" xmlns:bbf-xpongemtcont-qos="urn:bbf:yang:bbf-xpongemtcont-qos-mounted" xmlns:bbf-qos-tm="urn:bbf:yang:bbf-qos-traffic-mngt-mounted" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

<!-- default rule -->
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

<!--
       check if local-queue-id under tcont tm root queue is included in tm-profiles.
-->       
    <xsl:template match="*[local-name() = 'queue'          and parent::*[local-name() = 'tm-root' and namespace-uri() = 'urn:bbf:yang:bbf-xpongemtcont-qos-mounted']         and ancestor::*[local-name() = 'tcont']         and ancestor::*[local-name() = 'tconts']         and ancestor::*[local-name() = 'xpongemtcont' and namespace-uri() = 'urn:bbf:yang:bbf-xpongemtcont-mounted']         and ancestor::*[local-name() = 'onus' and namespace-uri() = 'urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount']     ]">
     <xsl:choose>
       <xsl:when test="not(./child::*[local-name()='queue_id_valid'])">
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
