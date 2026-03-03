<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0"
                xmlns:onuNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount"
                xmlns:voipNs="urn:bbf:yang:bbf-sip-voip-mounted"
>

    <xsl:variable name="mediaDscpMark" select="/tailf:config/onuNs:onus/onuNs:onu/onuNs:root/voipNs:sip-signaling/voipNs:voip-service-gateways/voipNs:voip-service-gateway/voipNs:sip-dscp-mark"/>

    <xsl:template match="/tailf:config/onuNs:onus/onuNs:onu/onuNs:root/voipNs:media-forwarders/voipNs:media-forwarder/voipNs:media-x-connect">
      <xsl:copy>
        <xsl:copy-of select="@*"/>

        <xsl:for-each select="current()/node()">
          <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
          </xsl:copy>
        </xsl:for-each>

        <xsl:if test="$mediaDscpMark != ''">
          <xsl:element name="media-dscp-mark" namespace="urn:bbf:yang:bbf-sip-voip-mounted">
            <xsl:value-of select="$mediaDscpMark"/>
          </xsl:element>
        </xsl:if>
      </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
