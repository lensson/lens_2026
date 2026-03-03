<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:onuNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount" xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted" xmlns:aniNs="urn:bbf:yang:bbf-xponani-mounted" xmlns:ssmNs="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-conf-clock-frequency-mounted" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

     <!--
       check if incidental gemport created when ssm-out enabled.
   -->

    <xsl:template match="/tailf:config/onuNs:onus/onuNs:onu/onuNs:root/ifNs:interfaces/ifNs:interface[ifNs:type='ianaift-mounted:ethernetCsmacd']/ssmNs:ssm-out/ssmNs:ssm-out-enable">

        <xsl:variable name="gemportCount" select="count(../../../ifNs:interface/aniNs:ani/aniNs:multicast-gemport/child::*[name()='is-broadcast' and text() = 'true'])"/>

        <xsl:choose>
            <xsl:when test="text() = 'true' and ($gemportCount != 1)">
                <xsl:element name="{name()}" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-conf-clock-frequency-mounted">false</xsl:element>
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
