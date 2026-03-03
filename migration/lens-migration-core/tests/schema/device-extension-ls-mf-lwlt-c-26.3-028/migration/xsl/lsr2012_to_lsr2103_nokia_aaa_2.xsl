<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:newns="http://tail-f.com/ns/aaa/1.1" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
 
 <xsl:param name="nokiaAAANS" select="'http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-aaa'"/>


<!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>


<!--  Add the new-password-at-login configuration for all users in the /nokia-aaa:users -->
  <xsl:template match="*[name() = 'login']">
     <xsl:choose>
         <xsl:when test="namespace-uri() = $nokiaAAANS and ./preceding-sibling::*[name()='name' and text()!='techsupport']">
          <xsl:copy>
            <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
              <xsl:element name="new-password-at-login" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-aaa">true</xsl:element>
          </xsl:copy>
         </xsl:when>

         <xsl:when test="./preceding-sibling::*[name()='name' and text()='techsupport']">
          <xsl:copy>
            <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
              <xsl:element name="new-password-at-login" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-aaa">false</xsl:element>
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
