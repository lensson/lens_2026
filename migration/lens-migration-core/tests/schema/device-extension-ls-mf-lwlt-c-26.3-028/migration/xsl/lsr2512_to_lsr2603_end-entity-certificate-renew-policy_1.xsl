<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:estc="urn:ietf:params:xml:ns:yang:nokia-sdan-est-client">

    <!-- Template for 'end-entity-certificate-renew-policy' -->
    <xsl:template match="estc:end-entity-certificate-renew-policy">
        <!-- Check if 'after-issue' is not '0' -->
        <xsl:if test="not(estc:after-issue = '0')">
            <!-- If not '0', copy the entire node as is. Else it is not copied, aka removed. -->
	    <xsl:copy>
                <xsl:copy-of select="@*"/>
                <xsl:apply-templates/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
