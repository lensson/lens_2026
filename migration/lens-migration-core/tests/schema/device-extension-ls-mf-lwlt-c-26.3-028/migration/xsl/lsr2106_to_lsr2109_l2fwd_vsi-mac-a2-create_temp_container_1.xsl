<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:bbf-l2-fwd="urn:bbf:yang:bbf-l2-forwarding" xmlns:ietf-interfaces="urn:ietf:params:xml:ns:yang:ietf-interfaces" xmlns:port-temp-nms="urn:params:port:temp" version="1.0">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
<xsl:strip-space elements="*"/>

<!-- default rule -->

<xsl:template match="node()|@*">
    <xsl:copy>
        <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
</xsl:template>
	
<!-- Creating a new container with static-mac based on forwarder interface in contains -->

<xsl:template match="/tailf:config/ietf-interfaces:interfaces/ietf-interfaces:interface">
   <xsl:copy>
       <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
<static-mac-address-list xmlns="urn:ief:address:list">
          <xsl:variable name="portname" select="ietf-interfaces:name"/>
	       <xsl:for-each select="//tailf:config/bbf-l2-fwd:forwarding/bbf-l2-fwd:forwarding-databases/bbf-l2-fwd:forwarding-database/bbf-l2-fwd:static-mac-address">
		      <xsl:if test="bbf-l2-fwd:static-forwarder-port-ref/port-temp-nms:port-temp = $portname">
			  <stat-mac>
              <mac-address><xsl:value-of select="bbf-l2-fwd:mac-address"/></mac-address>
			  <fdb-name><xsl:value-of select="../bbf-l2-fwd:name"/></fdb-name>
			  </stat-mac>
			  </xsl:if>
           </xsl:for-each>
	  </static-mac-address-list>
   </xsl:copy>
 </xsl:template>
</xsl:stylesheet>
