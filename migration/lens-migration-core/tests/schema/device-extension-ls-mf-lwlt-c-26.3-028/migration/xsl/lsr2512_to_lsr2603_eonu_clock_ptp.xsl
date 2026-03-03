<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0"
                xmlns:onuNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount"
                xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted"
                xmlns:ptpNs="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-conf-clock-ptp-mounted"
                xmlns:ifNsFromMounted="urn:ietf:params:xml:ns:yang:ietf-interfaces-frommounted"
                xmlns:ptpNsFromMounted="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-conf-clock-ptp-frommounted"
>
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<!-- 
1.add root.ptp.admin-state: 
   If "profile-ref-8275dot1 or profile-ref-ccsa" is configured, admin-state will be set to lock/unlock
       lock: no "ptp-port.enable == true" in any uni interface. 
       unlock: ptp-port.enable is true in at least one uni interfaces.
   If no profile-ref-8275dot1 or profile-ref-ccsa is configured and no ptp-port.enable is true.
       admin-state will not be added.
-->    

    <xsl:template match="/tailf:config/onuNs:onus/onuNs:onu/onuNs:root">
        <xsl:copy>
            <xsl:variable name="ptpEnableCount" select="count(ifNs:interfaces/ifNs:interface[ifNs:type='ianaift-mounted:ethernetCsmacd']/ptpNs:ptp-port[ptpNs:enable = 'true'])"/>
            <xsl:variable name="ProfileCount8275" select="count(ifNs:interfaces/ifNs:interface[ifNs:type='ianaift-mounted:ethernetCsmacd']/ptpNs:ptp-port/ptpNs:profile-ref-8275dot1)"/>
            <xsl:variable name="ProfileCountccsa" select="count(ifNs:interfaces/ifNs:interface[ifNs:type='ianaift-mounted:ethernetCsmacd']/ptpNs:ptp-port/ptpNs:profile-ref-ccsa)"/>
        

            <xsl:choose>
                <xsl:when test = "$ProfileCount8275 &gt;= 1 or $ProfileCountccsa &gt;= 1">

                    <!-- select a valid interface has either 8275 or ccsa-->
                    <xsl:variable name="validInterface" select=" 
                        ifNs:interfaces/ifNs:interface[
                            ifNs:type='ianaift-mounted:ethernetCsmacd' and 
                            (
                                ptpNs:ptp-port/ptpNs:profile-ref-8275dot1 or 
                                ptpNs:ptp-port/ptpNs:profile-ref-ccsa
                            )
                        ][1]/ifNs:name"/>

                    <xsl:variable name="is8275existed" select="count(ifNs:interfaces/ifNs:interface[
                            ifNs:type='ianaift-mounted:ethernetCsmacd' and ifNs:name = $validInterface]/ptpNs:ptp-port/ptpNs:profile-ref-8275dot1)"/>
                    <xsl:variable name="isccsaexisted" select="count(ifNs:interfaces/ifNs:interface[
                            ifNs:type='ianaift-mounted:ethernetCsmacd' and ifNs:name = $validInterface]/ptpNs:ptp-port/ptpNs:profile-ref-ccsa)"/>

                    <xsl:element name="ptp" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-conf-clock-ptp-mounted">
                    <xsl:choose>
                        <xsl:when test = "$ptpEnableCount &gt;= 1">
                            <xsl:element name="admin-state" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-conf-clock-ptp-mounted"><xsl:text>unlock</xsl:text></xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:element name="admin-state" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-conf-clock-ptp-mounted"><xsl:text>lock</xsl:text></xsl:element>
                    </xsl:otherwise>
                    </xsl:choose>
                        <xsl:element name="profile-ref" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-conf-clock-ptp-mounted">
                            <xsl:choose>
                                <xsl:when test = "$is8275existed &gt;= 1">
                                    <xsl:element name="profile-ref-8275dot1" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-conf-clock-ptp-mounted"><xsl:value-of select="ifNs:interfaces/ifNs:interface[ifNs:type='ianaift-mounted:ethernetCsmacd' and ifNs:name = $validInterface]/ptpNs:ptp-port/ptpNs:profile-ref-8275dot1/text()"/></xsl:element>
                                </xsl:when>
                                <xsl:when test = "$isccsaexisted &gt;= 1">
                                    <xsl:element name="profile-ref-ccsa" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-conf-clock-ptp-mounted"><xsl:value-of select="ifNs:interfaces/ifNs:interface[ifNs:type='ianaift-mounted:ethernetCsmacd' and ifNs:name = $validInterface]/ptpNs:ptp-port/ptpNs:profile-ref-ccsa/text()"/></xsl:element>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:element>
                    </xsl:element>
                </xsl:when>
            </xsl:choose>

            <xsl:copy-of select="@*"/>
                <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>      

   <!--
3.1.remove interface.ptp-port.profile-ref-8275dot1
3.2.remove interface.ptp-port.profile-ref-ccsa
   -->
    <xsl:template match="/tailf:config/onuNs:onus/onuNs:onu/onuNs:root/ifNs:interfaces/ifNs:interface[ifNs:type='ianaift-mounted:ethernetCsmacd']/ptpNs:ptp-port/ptpNs:profile-ref-8275dot1"/>
    <xsl:template match="/tailf:config/onuNs:onus/onuNs:onu/onuNs:root/ifNs:interfaces/ifNs:interface[ifNs:type='ianaift-mounted:ethernetCsmacd']/ptpNs:ptp-port/ptpNs:profile-ref-ccsa"/>

    <xsl:template match="/tailf:config/onuNs:onus/onuNs:onu/onuNs:fromroot/ifNsFromMounted:interfaces/ifNsFromMounted:interface[ifNsFromMounted:type='ianaift-frommounted:ethernetCsmacd']/ptpNsFromMounted:ptp-port/ptpNsFromMounted:profile-ref-8275dot1"/>
    <xsl:template match="/tailf:config/onuNs:onus/onuNs:onu/onuNs:fromroot/ifNsFromMounted:interfaces/ifNsFromMounted:interface[ifNsFromMounted:type='ianaift-frommounted:ethernetCsmacd']/ptpNsFromMounted:ptp-port/ptpNsFromMounted:profile-ref-ccsa"/>
    <xsl:template match="/tailf:config/onuNs:onus/onuNs:onu/onuNs:fromroot/ifNsFromMounted:interfaces/ifNsFromMounted:interface[ifNsFromMounted:type='ianaift-frommounted:ethernetCsmacd']/ptpNsFromMounted:ptp-port[not(ptpNsFromMounted:enable)]"/>

</xsl:stylesheet>


