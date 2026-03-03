<?xml version="1.0" ?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0">

<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
<xsl:strip-space elements="*"/>

<!-- default rule -->
<xsl:template match="node()|@*">
    <xsl:copy>
        <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
</xsl:template>

<xsl:template match="*[local-name() = 'multicast-distribution-set' and namespace-uri() = 'urn:bbf:yang:bbf-xpon']"/>

</xsl:stylesheet>
