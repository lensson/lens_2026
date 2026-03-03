<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0"
                xmlns:onuNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount"
                xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted"
                xmlns:ipNs="urn:ietf:params:xml:ns:yang:ietf-ip-mounted"
                xmlns:ipAugNs="urn:ietf:params:xml:ns:yang:nokia-ip-aug-mounted"
>

    <xsl:template match="/tailf:config/onuNs:onus/onuNs:onu/onuNs:root/ifNs:interfaces/ifNs:interface/ipNs:ipv4/ipAugNs:ip-address-acquisition-method">
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
      </xsl:copy>

      <xsl:variable name="origin" select="ipAugNs:origin"/>
      <xsl:if test="$origin = 'dhcp'">
        <xsl:element name="dhcp" namespace="urn:ietf:params:xml:ns:yang:nokia-ip-aug-mounted"/>
      </xsl:if>
    </xsl:template>

</xsl:stylesheet>
