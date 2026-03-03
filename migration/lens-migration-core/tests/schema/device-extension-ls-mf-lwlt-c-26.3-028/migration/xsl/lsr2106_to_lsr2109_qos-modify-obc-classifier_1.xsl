<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:param name="classifierNameSpace" select="'urn:bbf:yang:bbf-qos-classifiers'"/>

    <!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>


    <!-- add filter-operation to obcRateLimitCla classifier-entry-->
    <xsl:template match="*[name() = 'name' and text() = 'obcRateLimitCla'         and parent::*[name() = 'classifier-entry']         and ancestor::*[name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']         ]">

        <xsl:variable name="filter-operation-exist" select="../child::*[name()='filter-operation']"/>
        <xsl:choose>
            <xsl:when test="$filter-operation-exist">
                <xsl:copy>
                   <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
                    <xsl:apply-templates/>
                </xsl:copy>
                <xsl:element name="filter-operation" namespace="{$classifierNameSpace}">match-all-filter</xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
