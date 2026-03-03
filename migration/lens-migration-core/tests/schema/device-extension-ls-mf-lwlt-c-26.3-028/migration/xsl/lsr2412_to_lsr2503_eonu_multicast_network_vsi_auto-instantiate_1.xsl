<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0"
                xmlns:onuNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount"
                xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted"
                xmlns:mgmd="urn:bbf:yang:bbf-mgmd-mounted"
                xmlns:onus-template="http://www.nokia.com/Fixed-Networks/BBA/yang/onus-from-template">

    <xsl:template match="/tailf:config/onuNs:onus/onuNs:onu/onuNs:root/ifNs:interfaces/ifNs:interface/onus-template:auto-instantiate">
        <xsl:variable name="ifName" select="../ifNs:name"/>
        <xsl:choose>
            <xsl:when test="count(ancestor::onuNs:root/mgmd:multicast/mgmd:mgmd/mgmd:multicast-vpn/mgmd:multicast-network-interface[mgmd:single-uplink-interface-data/mgmd:vlan-sub-interface = $ifName]) > 0">
              <xsl:copy>
                  <xsl:copy-of select="@*"/>
                  <xsl:value-of select="'false'"/>
              </xsl:copy>
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
