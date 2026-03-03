<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0"
                xmlns:onuNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount"
                xmlns:bbf-xpongemtcont="urn:bbf:yang:bbf-xpongemtcont-mounted"
                xmlns:bbf-xpongemtcont-qos="urn:bbf:yang:bbf-xpongemtcont-qos-mounted"
                xmlns:bbf-qos-traffic-mngt="urn:bbf:yang:bbf-qos-traffic-mngt-mounted"
>
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
   <xsl:template match="*[local-name() = 'queue' 
        and parent::*[local-name() = 'tm-root' and namespace-uri() = 'urn:bbf:yang:bbf-xpongemtcont-qos-mounted']
        and ancestor::*[local-name() = 'tcont']
        and ancestor::*[local-name() = 'tconts']
        and ancestor::*[local-name() = 'xpongemtcont' and namespace-uri() = 'urn:bbf:yang:bbf-xpongemtcont-mounted']
        and ancestor::*[local-name() = 'onus' and namespace-uri() = 'urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount']
   ]">
	<xsl:variable name="tcont-name" select="../../bbf-xpongemtcont:name"/>
	<xsl:variable name="tc-id-2-queue-mapping-profile-name" select="../bbf-xpongemtcont-qos:tc-id-2-queue-id-mapping-profile-name"/>
	<xsl:variable name="local-queue-id" select="./bbf-xpongemtcont-qos:local-queue-id"/>
	
    <xsl:copy>   
    	<xsl:for-each select="../../../../../bbf-qos-traffic-mngt:tm-profiles/bbf-qos-traffic-mngt:tc-id-2-queue-id-mapping-profile[bbf-qos-traffic-mngt:name = $tc-id-2-queue-mapping-profile-name]/bbf-qos-traffic-mngt:mapping-entry">
    		<xsl:variable name="tm-profile-queue-id" select="child::*[local-name() = 'local-queue-id']"/>
      		<xsl:if test="$tm-profile-queue-id = $local-queue-id">
      			<xsl:element name="queue_id_valid" namespace="urn:bbf:yang:bbf-xpongemtcont-qos-mounted">
      				<xsl:text>true</xsl:text>
      			</xsl:element>
      		</xsl:if>
     	</xsl:for-each>
     	<xsl:copy-of select="@*"/>
       		<xsl:apply-templates/>
    	</xsl:copy>
  </xsl:template>

</xsl:stylesheet>

