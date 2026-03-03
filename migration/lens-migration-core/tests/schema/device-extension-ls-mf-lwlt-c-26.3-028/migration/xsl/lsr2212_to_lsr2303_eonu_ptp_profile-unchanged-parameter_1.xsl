<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:onuNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount" xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

<!-- default rule -->
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>



<!-- g8275profile set master-only to default value false -->
    <xsl:template match="*[name() = 'master-only'         and parent::*[name() = 'ptp-g8275dot1-port-profile']         and ancestor::*[name() = 'ptp-g8275dot1-profiles' and namespace-uri() = 'http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-conf-clock-ptp-mounted']         and ancestor::*[name() = 'onus']     ]">
        <xsl:choose>
            <xsl:when test="text() != 'true'">
	        <xsl:element name="{name()}" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-conf-clock-ptp-mounted">true</xsl:element>	
	    </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>    
    </xsl:template>
	
 <!-- ccsaprofile set master-only to default value false -->
    <xsl:template match="*[name() = 'master-only'         and parent::*[name() = 'ptp-ccsa-port-profile']         and ancestor::*[name() = 'ptp-ccsa-profiles' and namespace-uri() = 'http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-conf-clock-ptp-mounted']         and ancestor::*[name() = 'onus']     ]">
        <xsl:choose>
            <xsl:when test="text() != 'true'">
	        <xsl:element name="{name()}" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-conf-clock-ptp-mounted">true</xsl:element>	
	    </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>    
    </xsl:template>
	
   <!--delete 'ssm-in'-->
    <xsl:template match="*[name() = 'ssm-in'         and parent::*[name() = 'interface' and ./*[name() = 'type' and text() = 'ianaift-mounted:ethernetCsmacd']]         and ancestor::*[name() = 'interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted']         and ancestor::*[name() = 'onus']     ]">
    </xsl:template>
    
</xsl:stylesheet>
