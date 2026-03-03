<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:onuNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount" xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted" xmlns:onuSubItf="urn:bbf:yang:bbf-sub-interfaces-mounted" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

<!-- default rule -->
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

   
<!--
    check if subif-lower-layer interface and ingress-qos-policy-profile is configured in vlan-sub-interface.
-->
  <xsl:template match="*[local-name() = 'interface' and ./*[local-name() = 'type' and text() = 'bbfift-mounted:vlan-sub-interface']         and parent::*[local-name() = 'interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted']         and ancestor::*[local-name() = 'onus' and namespace-uri() = 'urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount']   ]">
  <xsl:choose>
       <xsl:when test="not(./onuSubItf:subif-lower-layer/onuSubItf:interface)">
       </xsl:when>
       <xsl:when test="not(child::*[contains(local-name(),'ingress-qos-policy-profile')])">
        	<xsl:variable name="vlan-sub-itf-name" select="./*[local-name() = 'name']"/> 
      		<xsl:variable name="subitf-name" select="./onuSubItf:subif-lower-layer/onuSubItf:interface"/>
      		<xsl:variable name="subitf-type" select="../ifNs:interface[ifNs:name = $subitf-name]/ifNs:type"/>
      		<xsl:if test="not(contains($subitf-type, 'ethernetCsmacd') or contains($subitf-type,'onu-v-vrefpoint'))"> 
      			<xsl:copy>
             		<xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
			</xsl:if>
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
