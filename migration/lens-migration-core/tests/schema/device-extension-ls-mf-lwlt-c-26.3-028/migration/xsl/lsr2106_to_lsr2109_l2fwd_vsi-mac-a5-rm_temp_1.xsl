<?xml version="1.0" ?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0"
xmlns:bbf-l2-fwd="urn:bbf:yang:bbf-l2-forwarding"
xmlns:ietf-interfaces="urn:ietf:params:xml:ns:yang:ietf-interfaces"
xmlns:address-list ="urn:ief:address:list"
xmlns:port-temp-nms="urn:params:port:temp">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
<xsl:strip-space elements="*"/>
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
<xsl:strip-space elements="*"/>

<!-- default rule -->

<xsl:template match="node()|@*">
	<xsl:copy>
	<xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
</xsl:template>

<!-- Remove the temporary container created in interface in step1 -->

<xsl:template match="tailf:config/ietf-interfaces:interfaces/ietf-interfaces:interface/address-list:static-mac-address-list">
</xsl:template>

<xsl:template match="tailf:config/bbf-l2-fwd:forwarding/bbf-l2-fwd:forwarding-databases/bbf-l2-fwd:forwarding-database/bbf-l2-fwd:static-mac-address/bbf-l2-fwd:static-forwarder-port-ref/port-temp-nms:port-temp">
</xsl:template>

</xsl:stylesheet>
