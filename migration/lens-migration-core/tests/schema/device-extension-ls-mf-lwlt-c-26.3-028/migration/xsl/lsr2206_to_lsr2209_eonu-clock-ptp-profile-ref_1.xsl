<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0"
                xmlns:onuNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount"
                xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted"
                xmlns:ptpNs="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-conf-clock-ptp-mounted"
>
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

<!-- default rule -->
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

   
   <!--
       check if profile-ref be configured when ptp-port enabled.
   -->

  <xsl:template match="*[name() = 'ptp-port'
        and parent::*[name() = 'interface' and ./*[name() = 'type' and text() = 'ianaift-mounted:ethernetCsmacd']]
        and ancestor::*[name() = 'interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted']
        and ancestor::*[name() = 'onus']
    ]">

    <xsl:variable name="ptp_port_enable" select="ptpNs:enable"/>
    <xsl:variable name="ptp_prpfile_ref_8275" select="../ptpNs:ptp-port/*[contains(name(), 'profile-ref-8275dot1')]"/>
    <xsl:variable name="ptp_prpfile_ref_ccsa" select=" ../ptpNs:ptp-port/*[contains(name(), 'profile-ref-ccsa')]"/>
    <xsl:copy>
      <xsl:if test="(($ptp_port_enable = 'true') and not (($ptp_prpfile_ref_ccsa != '') or ($ptp_prpfile_ref_8275 != '')))">
        <wrong-configuration-detected>profile-ref must be configured when ptp-port enabled - Migration is not successful</wrong-configuration-detected>
      </xsl:if>
     <xsl:copy-of select="@*"/>
       <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>



