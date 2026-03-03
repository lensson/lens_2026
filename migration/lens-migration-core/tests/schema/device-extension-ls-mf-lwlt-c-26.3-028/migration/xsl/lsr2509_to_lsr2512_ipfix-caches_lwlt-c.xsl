<?xml version="1.0" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:ipfix="urn:ietf:params:xml:ns:yang:ietf-ipfix-psamp" 
                              xmlns:nokia-ipfix="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-ipfix">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    <xsl:param name="ipfix_ns" select="'urn:ietf:params:xml:ns:yang:ietf-ipfix-psamp'" />











   <!-- xsl rule to update heartbeat-interval of on-change changes to multiples of 3600sec or 0sec  -->
   <xsl:template match="ipfix:ipfix/ipfix:cache/ipfix:permanentCache/nokia-ipfix:on-change/nokia-ipfix:heartbeat-interval[text() mod 3600!=0]">
    <xsl:variable name="tobeCorrected">
         <xsl:text>true</xsl:text>
    </xsl:variable>

     <xsl:choose>
       <xsl:when test="contains($tobeCorrected,'true')">
           <xsl:element name="heartbeat-interval" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-ipfix">0</xsl:element>
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