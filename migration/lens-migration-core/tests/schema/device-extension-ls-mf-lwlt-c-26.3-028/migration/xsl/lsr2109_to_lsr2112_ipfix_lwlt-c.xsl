<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:newns="http://tail-f.com/ns/aaa/1.1" version="1.0">
   <xsl:strip-space elements="*"/>
   <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
   <xsl:param name="ipfix_ns" select="'urn:ietf:params:xml:ns:yang:ietf-ipfix-psamp'"/>

   <!-- default rule -->
   <xsl:template match="*">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>

   <xsl:template match="*[name()='maxFlows' or                           name()='activeTimeout' or                           name()='idleTimeout' or                           name()='ieId' or                           name()='ieLength' or                           name()='isFlowKey' or                           name()='ifIndex' or                           name()='ifName' or                           name()='sendBufferSize' or                           name()='rateLimit' or                           name()='localCertificationAuthorityDN' or                           name()='localSubjectDN' or                           name()='localSubjectFQDN' or                           name()='remoteCertificationAuthorityDN' or                           name()='remoteSubjectDN' or                           name()='remoteSubjectFQDN' or                           name()='sourceIPAddress' or                           name()='options' or                           name()='exportingProcess' or                           name()='destination' and descendant::*[name()='sctpExporter']]">
        <xsl:choose>
            <xsl:when test="namespace-uri() = $ipfix_ns and ./ancestor::*[name()='cache']">
            </xsl:when>
            <xsl:when test="namespace-uri() = $ipfix_ns and ./ancestor::*[name()='exportingProcess']">
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
        ieEnterpriseNumber, exportMode, ipfixVersion

        2109: IPFIX uses hard-coded values internally to formulate and export its packets.
        Those leaves now have default values in 2112 and they cannot be modified by the operator.
        IPFIX does not handle those leaves when they are configured, but uses the same values internally to formulate
        its exported packets.
        That is why we need to handle those leaves in migration case from 2109 to 2112, to make sure that the operator
        has not misconfigured anything that would render IPFIX operation and configuration inconsistent.
    -->

    <xsl:template match="*[name()='ieEnterpriseNumber']">
        <xsl:choose>
            <xsl:when test="namespace-uri() = $ipfix_ns and ./ancestor::*[name()='cache']">
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
                    <xsl:text>3729</xsl:text>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[name()='ipfixVersion']">
        <xsl:choose>
            <xsl:when test="namespace-uri() = $ipfix_ns and ./ancestor::*[name()='tcpExporter']">
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
                    <xsl:text>10</xsl:text>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[name()='exportMode']">
        <xsl:choose>
            <xsl:when test="namespace-uri() = $ipfix_ns and ./ancestor::*[name()='exportingProcess']">
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
                    <xsl:text>ipfix:fallback</xsl:text>
                </xsl:copy>
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
