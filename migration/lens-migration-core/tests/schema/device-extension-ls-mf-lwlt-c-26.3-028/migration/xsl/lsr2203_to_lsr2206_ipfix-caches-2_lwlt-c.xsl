<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ipfix="urn:ietf:params:xml:ns:yang:ietf-ipfix-psamp" version="1.0">
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


   <!-- xsl rule to update export-interval of PM history XPATHs to 900sec  -->
   <xsl:template match="*[name()='exportInterval' and text()!='900' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-ipfix-psamp']">
    <xsl:variable name="ispm">
     <xsl:for-each select="../ipfix:cacheLayout/ipfix:cacheField">
       <xsl:if test="contains(./child::*[name()='ieName'],'intervals-15min')">
         <xsl:text>true</xsl:text>
       </xsl:if>
     </xsl:for-each>
    </xsl:variable>

     <xsl:choose>
       <xsl:when test="contains($ispm,'true')">
           <xsl:element name="exportInterval" namespace="urn:ietf:params:xml:ns:yang:ietf-ipfix-psamp">900</xsl:element>
       </xsl:when>
       <xsl:otherwise>
          <xsl:copy>
             <xsl:copy-of select="@*"/>
             <xsl:apply-templates/>
          </xsl:copy>
       </xsl:otherwise>
     </xsl:choose>
   </xsl:template>


   <!-- xsl rule to remove cache elements without cachefield  -->
   <xsl:template match="*[name()='cache' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-ipfix-psamp']" name="removecache">
     <xsl:choose>
       <xsl:when test="count(./ipfix:permanentCache/ipfix:cacheLayout/child::*[name()='cacheField']) = 0">
       </xsl:when>
       <xsl:otherwise>
          <xsl:copy>
             <xsl:copy-of select="@*"/>
             <xsl:apply-templates/>
          </xsl:copy>
       </xsl:otherwise>
     </xsl:choose>
   </xsl:template>


   <!-- xsl rule to remove cache elements without cachefield  -->
   <xsl:template name="ipfix" match="*[name()='ipfix' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-ipfix-psamp' ]">
     <xsl:choose>
       <xsl:when test="not(./child::*[name()='cache']) and not(./child::*[name()='randomize-data-collection']) and not(./child::*[name()='ipfix-exporting-enable']) and not(./child::*[name()='exportingProcess'])">
       </xsl:when>
       <xsl:when test="(./child::*[name()='cache']) and not(./child::*[name()='randomize-data-collection']) and not(./child::*[name()='ipfix-exporting-enable']) and not(./child::*[name()='exportingProcess'])">
         <xsl:choose>
          <xsl:when test="count(./ipfix:cache/ipfix:permanentCache/ipfix:cacheLayout/child::*[name()='cacheField']) = 0">
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy>
              <xsl:copy-of select="@*"/>
              <xsl:apply-templates/>
            </xsl:copy>
          </xsl:otherwise>
         </xsl:choose>
       </xsl:when>
       <xsl:otherwise>
          <xsl:copy>
             <xsl:copy-of select="@*"/>
             <xsl:apply-templates/>
          </xsl:copy>
       </xsl:otherwise>
     </xsl:choose>
   </xsl:template>

   <!-- xsl rule to remove isFlowKey, ieLength and/or ieId leafs if configured under cacheField  -->
   <xsl:template match="*[name()='isFlowKey' or name()='ieLength' or name()='ieId']">
        <xsl:choose>
            <xsl:when test="namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-ipfix-psamp' and ./ancestor::*[name()='cacheField']">
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
