<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:onusNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount" xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted" xmlns:nokia-hwi="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-hardware-identities" version="1.0">

    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>
    <!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="*[name() = 'disable-upon-ponlos' and parent::*[name() = 'interface'] and ancestor::*[name() = 'interfaces'] and ancestor::*[name() = 'root'] and ancestor::*[name() = 'onu'] and ancestor::*[name() = 'onus']       ]">
      
      <xsl:variable name="var_interface_type_onu-v-vrefpoint" select="../../ifNs:interface/child::*[name() = 'type' and text()= 'bbf-xponift-mounted:onu-v-vrefpoint']"/> 
      <!--xsl:element name="interface_type_onu-v-vrefpoint" namespace="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted"><xsl:value-of select="$var_interface_type_onu-v-vrefpoint"/></xsl:element-->

        <xsl:choose>
           <xsl:when test="'bbf-xponift-mounted:onu-v-vrefpoint'=$var_interface_type_onu-v-vrefpoint">
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
