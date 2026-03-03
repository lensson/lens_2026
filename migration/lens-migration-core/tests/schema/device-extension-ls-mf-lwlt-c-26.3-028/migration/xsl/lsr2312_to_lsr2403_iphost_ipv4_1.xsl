<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0"
                xmlns:onuNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount"
                xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted"
                xmlns:ipNs="urn:ietf:params:xml:ns:yang:ietf-ip-mounted"
                xmlns:ipAugNs="urn:ietf:params:xml:ns:yang:nokia-ip-aug-mounted"
                xmlns:onusTempNs="http://www.nokia.com/Fixed-Networks/BBA/yang/onus-from-template"
>
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <!--delete 'ipv4'-->
    <xsl:template match="/tailf:config/onuNs:onus/onuNs:onu/onuNs:root/ifNs:interfaces/ifNs:interface[ifNs:type!='ianaift-mounted:ipForward']/ipNs:ipv4/ipAugNs:ip-address-acquisition-method">
    </xsl:template>

    <xsl:template match="/tailf:config/onuNs:onus/onuNs:onu/onusTempNs:template-parameters/onusTempNs:interfaces/onusTempNs:interface/onusTempNs:ipv4">
      <xsl:variable name="interfaceName" select="../onusTempNs:template-ref"/>
      <xsl:variable name="onuName" select="../../../onusTempNs:template-ref"/>
      <xsl:variable name="ifType" select="/tailf:config/onuNs:onus/onuNs:onu[onuNs:name = $onuName]/onuNs:root/ifNs:interfaces/ifNs:interface[ifNs:name = $interfaceName]/ifNs:type"/>
      <xsl:choose>
        <xsl:when test="$ifType != 'ianaift-mounted:ipForward'"/>
        <xsl:otherwise>
          <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
          </xsl:copy>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
