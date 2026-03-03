<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ipfix="urn:ietf:params:xml:ns:yang:ietf-ipfix-psamp"
                xmlns:newns="http://tail-f.com/ns/aaa/1.1"
                version="1.0">
   <xsl:strip-space elements="*"/>
   <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

   <!-- default rule -->
<!--
   <xsl:template match="*">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>
-->
<!--
   <xsl:variable name="exp">
       <xsl:value-of select="//*[ local-name() = 'name' and parent::*[local-name() = 'exportingProcess'] ]"/>
   </xsl:variable>

   <xsl:template match="//ipfix:ipfix/ipfix:cache">
      <xsl:choose>
        <xsl:when test="./ipfix:exportingProcess">
            <xsl:copy>
                <xsl:copy-of select="@*"/>
                <xsl:apply-templates/>
            </xsl:copy>
        </xsl:when>
        <xsl:otherwise>
            <xsl:copy>
                <xsl:copy-of select="@*"/>
                <xsl:apply-templates/>
                <xsl:if test="string-length($exp) > 0">
                    <exportingProcess xmlns="urn:ietf:params:xml:ns:yang:ietf-ipfix-psamp">
                        <xsl:value-of select="$exp"/>
                    </exportingProcess>
                </xsl:if>
            </xsl:copy>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:template>
-->
</xsl:stylesheet>
