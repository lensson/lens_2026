<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:newns="http://tail-f.com/ns/aaa/1.1" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

 <xsl:param name="nacmNS" select="'urn:ietf:params:xml:ns:yang:ietf-netconf-acm'"/>

<!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

<!-- Add the vcli-group  -->
   <xsl:template match="*[name() = 'groups']">
     <xsl:choose>
       <xsl:when test="namespace-uri() = $nacmNS">
	      <xsl:copy>
              <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
              <xsl:element name="group" namespace="urn:ietf:params:xml:ns:yang:ietf-netconf-acm">
                <xsl:element name="name" namespace="urn:ietf:params:xml:ns:yang:ietf-netconf-acm">vcli-group</xsl:element>
                <xsl:element name="user-name" namespace="urn:ietf:params:xml:ns:yang:ietf-netconf-acm">cli_user</xsl:element>
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
