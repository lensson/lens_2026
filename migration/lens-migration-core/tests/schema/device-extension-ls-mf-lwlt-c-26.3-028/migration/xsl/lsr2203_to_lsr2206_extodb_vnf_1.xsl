<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:vnf="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-virtual-network-function" version="1.0">
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

  <!-- Add  virtual-network-functions -->
 <xsl:variable name="add_virtual-network-functions">
   <xsl:element name="virtual-network-functions" namespace="{$targetVNF}">
   <xsl:element name="virtual-network-function" namespace="{$targetVNF}">
       <xsl:element name="name" namespace="{$targetVNF}">dsc</xsl:element>
       <xsl:element name="address" namespace="{$targetVNF}">169.254.1.253</xsl:element>
    </xsl:element>
   </xsl:element>
 </xsl:variable>

  <!-- Add  virtual-network-function -->
 <xsl:variable name="add_virtual-network-function">
   <xsl:element name="virtual-network-function" namespace="{$targetVNF}">
       <xsl:element name="name" namespace="{$targetVNF}">dsc</xsl:element>
       <xsl:element name="address" namespace="{$targetVNF}">169.254.1.253</xsl:element>
    </xsl:element>
 </xsl:variable>

 <!-- when virtual-network-function exist, create an entry when entry with name=dsc is not there-->
  <xsl:template match="vnf:*[name() = 'virtual-network-functions' and parent::*[name() = 'config'] ]">
   <xsl:variable name="vnf-exist" select="child::*[name()='virtual-network-function'] and descendant::*[name()='name' and text()='dsc']"/>
    <xsl:choose>
      <xsl:when test="$vnf-exist">
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
                </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
              <xsl:copy>
                  <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
                  <xsl:copy-of select="$add_virtual-network-function"/>
              </xsl:copy>          
      </xsl:otherwise>
     </xsl:choose>
  </xsl:template>

  <!-- when virtual-network-functions does not exist, create it-->
  <xsl:template match="*[name() = 'config']">
    <xsl:choose> 
       <xsl:when test="(./child::vnf:*[name()='virtual-network-functions'])">
          <xsl:copy> 
          <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
       </xsl:when>
       <xsl:otherwise>
         <xsl:copy> 
         <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
<xsl:copy-of select="$add_virtual-network-functions"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
      
</xsl:stylesheet>
