<?xml version="1.0" ?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0"
xmlns:bbf-l2-fwd="urn:bbf:yang:bbf-l2-forwarding">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
<xsl:strip-space elements="*"/>

<!-- default rule -->

<xsl:template match="node()|@*">
	<xsl:copy>
	<xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
</xsl:template>

<!-- add a temporary node with port interface based on forwarder and name -->

<xsl:template match="bbf-l2-fwd:static-forwarder-port-ref/bbf-l2-fwd:port">
	<xsl:copy-of select="."/>
		<xsl:variable name="FwdName" select="../bbf-l2-fwd:forwarder" />
	    <xsl:variable name="portname" select="." />
		<xsl:for-each select="//tailf:config/bbf-l2-fwd:forwarding/bbf-l2-fwd:forwarders/bbf-l2-fwd:forwarder/bbf-l2-fwd:ports/bbf-l2-fwd:port">
		      <xsl:if test= "(../../bbf-l2-fwd:name = $FwdName) and (bbf-l2-fwd:name = $portname)">
				<port-temp xmlns="urn:params:port:temp"><xsl:value-of select="bbf-l2-fwd:sub-interface"/></port-temp>
			  </xsl:if>
           </xsl:for-each>
</xsl:template>
</xsl:stylesheet>
