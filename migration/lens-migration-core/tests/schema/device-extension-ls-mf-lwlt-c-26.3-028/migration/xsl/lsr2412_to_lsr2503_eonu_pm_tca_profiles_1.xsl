<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:onu="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount"
                xmlns:if-mounted="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted"
                xmlns:bbf-if-pm-mounted="urn:bbf:yang:bbf-interfaces-performance-management-mounted" version="1.0">


    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <xsl:template match="onu:onus/onu:onu/onu:root/if-mounted:interfaces/if-mounted:interface[if-mounted:type = 'bbf-xponift-mounted:onu-v-enet']/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:enable">
    <xsl:choose>
        <xsl:when test="text() = 'true'">
            <enable xmlns="urn:bbf:yang:bbf-interfaces-performance-management-mounted">false</enable>
        </xsl:when>
        <xsl:otherwise>
            <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
            </xsl:copy>
        </xsl:otherwise>
    </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
