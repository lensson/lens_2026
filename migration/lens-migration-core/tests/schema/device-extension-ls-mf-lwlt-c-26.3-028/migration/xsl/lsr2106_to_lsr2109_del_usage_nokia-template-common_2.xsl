<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:inf="urn:ietf:params:xml:ns:yang:ietf-interfaces">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
<!-- delete usage -->
   <xsl:template match="*[name() = 'usage' and parent::*[name() = 'interface'] and ancestor::*[name() = 'interfaces']] "/>
   <xsl:template match="*[name() = 'template-common:usage' and parent::*[name() = 'interface'] and ancestor::*[name() = 'interfaces']] "/>
</xsl:stylesheet>
