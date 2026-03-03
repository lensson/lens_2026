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


<xsl:template match="*[(local-name() = 'additional-bw-eligibility-indicator' or local-name() = 'weight' or local-name() = 'priority') and namespace-uri() = 'urn:bbf:yang:bbf-xpongemtcont']"/>

<xsl:template match="*[local-name() = 'ictp' and namespace-uri() = 'urn:bbf:yang:bbf-xpon']"/>

<xsl:template match="*[local-name() = 'notifiable-onu-presence-states' and namespace-uri() = 'urn:bbf:yang:bbf-xpon-onu-state']"/>

</xsl:stylesheet>
