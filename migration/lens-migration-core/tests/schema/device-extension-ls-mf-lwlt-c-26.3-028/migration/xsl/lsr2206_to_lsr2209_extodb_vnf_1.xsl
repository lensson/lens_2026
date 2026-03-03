<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    <xsl:param name="targetVNF" select="'http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-virtual-network-function'"/>


<!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>


  <xsl:template match="*[name() = 'virtual-network-function']"> 
   <xsl:variable name="dsc-exist" select="*[name()='name' and text()='dsc']"/>
    <xsl:choose>
      <xsl:when test="$dsc-exist">
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
