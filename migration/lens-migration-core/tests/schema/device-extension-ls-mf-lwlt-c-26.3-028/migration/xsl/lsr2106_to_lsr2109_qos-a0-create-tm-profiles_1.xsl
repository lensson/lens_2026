<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

    <!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*[name() = 'interfaces'     and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces'     ]">
        <xsl:choose>
            <xsl:when test="preceding-sibling::*[name() = 'tm-profiles'][namespace-uri() = 'urn:bbf:yang:bbf-qos-traffic-mngt'] or following-sibling::*[name() = 'tm-profiles'][namespace-uri() = 'urn:bbf:yang:bbf-qos-traffic-mngt']">
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
                <xsl:element name="tm-profiles" namespace="urn:bbf:yang:bbf-qos-traffic-mngt"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
