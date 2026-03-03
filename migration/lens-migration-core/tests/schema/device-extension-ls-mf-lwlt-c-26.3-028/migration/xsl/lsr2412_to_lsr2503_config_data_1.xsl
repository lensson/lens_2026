<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0"
                xmlns:onuNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount"
                xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted"
                xmlns:voipNs="urn:bbf:yang:bbf-sip-voip-mounted"
                xmlns:ipNs="urn:ietf:params:xml:ns:yang:ietf-ip-mounted"
                xmlns:rtNs="urn:ietf:params:xml:ns:yang:ietf-routing-mounted"
                xmlns:v4urNs="urn:ietf:params:xml:ns:yang:ietf-ipv4-unicast-routing-mounted"
                xmlns:ipAugNs="urn:ietf:params:xml:ns:yang:nokia-ip-aug-mounted"
>

  <xsl:template match="/tailf:config/onuNs:onus/onuNs:onu/onuNs:root/ifNs:interfaces/ifNs:interface/ipNs:ipv4/ipNs:mtu"/>
  <xsl:template match="/tailf:config/onuNs:onus/onuNs:onu/onuNs:root/ifNs:interfaces/ifNs:interface/ipNs:ipv4/ipNs:neighbor"/>
  <xsl:template match="/tailf:config/onuNs:onus/onuNs:onu/onuNs:root/ifNs:interfaces/ifNs:interface/ipNs:ipv6"/>

  <xsl:template match="/tailf:config/onuNs:onus/onuNs:onu/onuNs:root/ifNs:interfaces/ifNs:interface/ipAugNs:tag-ip-intf"/>

  <xsl:template match="/tailf:config/onuNs:onus/onuNs:onu/onuNs:root/voipNs:sip-signaling/voipNs:voip-service-providers/voipNs:sip-vsp-bad-digitmap"/>
  <xsl:template match="/tailf:config/onuNs:onus/onuNs:onu/onuNs:root/voipNs:sip-signaling/voipNs:voip-service-providers/voipNs:sip-vsp-notification"/>

  <xsl:template match="/tailf:config/onuNs:onus/onuNs:onu/onuNs:root/rtNs:routing/rtNs:control-plane-protocols/rtNs:control-plane-protocol/rtNs:description"/>
  <xsl:template match="/tailf:config/onuNs:onus/onuNs:onu/onuNs:root/rtNs:routing/rtNs:control-plane-protocols/rtNs:control-plane-protocol/rtNs:static-routes/v4urNs:ipv4/v4urNs:route/v4urNs:description"/>

</xsl:stylesheet>
