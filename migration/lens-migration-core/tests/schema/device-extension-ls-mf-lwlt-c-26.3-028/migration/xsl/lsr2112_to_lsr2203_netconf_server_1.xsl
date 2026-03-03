<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:newns="http://tail-f.com/ns/aaa/1.1" version="1.0">
   <xsl:strip-space elements="*"/>
   <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
   <xsl:param name="netconf_ns" select="'urn:ietf:params:xml:ns:yang:ietf-netconf-server'"/>

   <!-- default rule -->
   <xsl:template match="*">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>


<!-- Match 'netconf-server' and if '/netconf-server/call-home' is not available, create the same-->
<xsl:template match="*[name() = 'config' and namespace-uri() = namespace-uri(/*)]">
   <xsl:choose>
     <xsl:when test="not(child::*[name()= 'netconf-server'])">
       <xsl:copy>
         <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
            <xsl:element name="netconf-server" namespace="urn:ietf:params:xml:ns:yang:ietf-netconf-server">
              <xsl:element name="call-home" namespace="urn:ietf:params:xml:ns:yang:ietf-netconf-server">
              </xsl:element>
            </xsl:element>
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
