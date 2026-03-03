<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:ldraif="urn:bbf:yang:bbf-ldra">
<xsl:strip-space elements="*"/>
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
<!-- default rule -->
<xsl:template match="node()|@*">
<xsl:copy>
<xsl:apply-templates select = "node()|@*"/>
</xsl:copy>
</xsl:template>
<!-- delete usage -->

<xsl:template match="ldraif:*[name() = 'option' and text()='subscriber-id' and parent::*[name() = 'options'] and ancestor::*[name() = 'dhcpv6-ldra-profile']] "/>
<xsl:template match="ldraif:*[name() = 'option' and text()='enterprise-number' and parent::*[name() = 'options'] and ancestor::*[name() = 'dhcpv6-ldra-profile']] "/>
</xsl:stylesheet>
