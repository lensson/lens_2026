<?xml version="1.0" ?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0"
xmlns:bbf-l2-fwd="urn:bbf:yang:bbf-l2-forwarding"
xmlns:ietf-interfaces="urn:ietf:params:xml:ns:yang:ietf-interfaces"
xmlns:address-list ="urn:ief:address:list">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
<xsl:strip-space elements="*"/>
<!-- default rule -->

<xsl:template match="node()|@*">
    <xsl:copy>
        <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
</xsl:template>

	
<!-- remove the mac-address more than max mac limit per VSI -->
<xsl:template match="/tailf:config/ietf-interfaces:interfaces/ietf-interfaces:interface/address-list:static-mac-address-list/address-list:stat-mac[position() &gt; ../../bbf-l2-fwd:mac-learning/bbf-l2-fwd:max-number-mac-addresses]"/>

</xsl:stylesheet>
