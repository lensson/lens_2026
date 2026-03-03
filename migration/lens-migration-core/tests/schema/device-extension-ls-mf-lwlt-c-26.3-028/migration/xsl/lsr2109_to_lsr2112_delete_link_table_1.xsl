<?xml version="1.0" ?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <!-- default rule -->
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>

    <!-- Delete link-table -->
    <xsl:template match="*[contains(name(),'link-table')
        and namespace-uri() = 'urn:bbf:yang:bbf-link-table-body'
        ]">
    </xsl:template>

</xsl:stylesheet>

