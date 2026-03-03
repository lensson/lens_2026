<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0"
                xmlns:onu="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount"
                xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted"
                xmlns:bbf-xpongemtcont="urn:bbf:yang:bbf-xpongemtcont-mounted"
                xmlns:bbf-xpongemtcont-qos="urn:bbf:yang:bbf-xpongemtcont-qos-mounted"
                xmlns:bbf-qos-traffic-mngt="urn:bbf:yang:bbf-qos-traffic-mngt-mounted"

                                  
>
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

<!-- default rule -->
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>


<!-- remove unsupported nodes -->
<xsl:template match="//onu:onus/onu:onu/onu:root/bbf-xpongemtcont:xpongemtcont/bbf-xpongemtcont:traffic-descriptor-profiles"/>
<xsl:template match="//onu:onus/onu:onu/onu:root/ifNs:interfaces/ifNs:interface/bbf-qos-traffic-mngt:tm-root"/>
<xsl:template match="//onu:onus/onu:onu/onu:root/bbf-xpongemtcont:xpongemtcont/bbf-xpongemtcont:tconts/bbf-xpongemtcont:tcont/bbf-xpongemtcont-qos:tm-root/bbf-xpongemtcont-qos:queue/bbf-xpongemtcont-qos:queue_id_valid"/>
<xsl:template match="//onu:onus/onu:onu/onu:root/bbf-xpongemtcont:xpongemtcont/bbf-xpongemtcont:gemports/bbf-xpongemtcont:gemport[not(bbf-xpongemtcont:tcont-ref)]"/>
<xsl:template match="//onu:onus/onu:onu/onu:root/bbf-xpongemtcont:xpongemtcont/bbf-xpongemtcont:gemports/bbf-xpongemtcont:gemport[not(bbf-xpongemtcont:interface)]"/>

<xsl:template match="//onu:onus/onu:onu/onu:root/bbf-xpongemtcont:xpongemtcont/bbf-xpongemtcont:tconts/bbf-xpongemtcont:tcont[not(bbf-xpongemtcont:interface-reference)]"/>
<xsl:template match="//onu:onus/onu:onu/onu:root/bbf-xpongemtcont:xpongemtcont/bbf-xpongemtcont:tconts/bbf-xpongemtcont:tcont[not(bbf-xpongemtcont-qos:tm-root/bbf-xpongemtcont-qos:queue)]"/>


</xsl:stylesheet>

