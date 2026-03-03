<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:newns="http://tail-f.com/ns/aaa/1.1" version="1.0">
   <xsl:strip-space elements="*"/>
   <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
   <xsl:param name="syslogNS" select="'urn:ietf:params:xml:ns:yang:ietf-syslog'"/>

<!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

<!--  Restriction of the allowed facilities -->
    <xsl:template match="*[name()= 'facility-list']">
        <xsl:choose>
            <xsl:when test="namespace-uri() = $syslogNS and ./child::*[name()= 'facility' and (text()= 'kern' or text()= 'mail' or text()= 'daemon' or text()= 'auth' or text()= 'lpr' or text()= 'news' or text()= 'uucp' or text()= 'cron' or text()= 'authpriv' or text()= 'audit' or text()= 'console' or text()= 'cron2' or text()= 'local0' or text()= 'local1' or text()= 'local2' or text()= 'local3' or text()= 'local4' or text()= 'local5' or text()= 'local6' or text()= 'local7')]">
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
