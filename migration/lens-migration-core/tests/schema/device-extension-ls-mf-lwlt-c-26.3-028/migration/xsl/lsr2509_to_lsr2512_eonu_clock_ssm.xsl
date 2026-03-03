<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0"
                xmlns:onuNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount"
                xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted"
                xmlns:ssmNs="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-conf-clock-frequency-mounted"
                xmlns:ifNsFromMounted="urn:ietf:params:xml:ns:yang:ietf-interfaces-frommounted"
                xmlns:ssmNsFromMounted="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-conf-clock-frequency-frommounted"
>
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<!-- 
1.add root.synce.admin-state: 
   If "ssm-out-profile-ref" is configured, admin-state will be set to lock/unlock
       lock: no "ssm-out-enable == true" in any uni interface. 
       unlock: ssm-out-enable is true in at least one uni interfaces.
   If no ssm-out-profile-ref is configured and no ssm-out-enable is true.
       admin-state will not be added.
2.add root.synce.ESMC-vlan-id:
   If no ssm-out-enable is true and ssm-out-profile-ref is configured in at least one uni interfaces, 
      ESMC-vlan-id will be set to the first ssm-out-profile-ref.ssm-out-vlan-id.
   If ssm-out-enable is true and ssm-out-profile-ref is configured in at least one uni interfaces,
      ESMC-vlan-id will be set to ssm-out-profile-ref.ssm-out-vlan-id which is configured in the first uni interface in which ssm-out-enable is true.
-->    

    <xsl:template match="/tailf:config/onuNs:onus/onuNs:onu/onuNs:root">
        <xsl:copy>
            <xsl:variable name="sshEnableCount" select="count(ifNs:interfaces/ifNs:interface[ifNs:type='ianaift-mounted:ethernetCsmacd']/ssmNs:ssm-out[ssmNs:ssm-out-enable = 'true'])"/>
            <xsl:variable name="sshProfileCount" select="count(ifNs:interfaces/ifNs:interface[ifNs:type='ianaift-mounted:ethernetCsmacd']/ssmNs:ssm-out-profile-ref)"/>

            <xsl:choose>
                <xsl:when test = "$sshProfileCount &gt;= 1">
		    <xsl:choose>
		        <xsl:when test = "$sshEnableCount &gt;= 1">
		            <xsl:variable name="ssm_out_profile_name" select="ifNs:interfaces/ifNs:interface[ifNs:type='ianaift-mounted:ethernetCsmacd' and descendant::*[name() = 'ssm-out-enable' and text() = 'true']]/ssmNs:ssm-out-profile-ref"/>
                            <xsl:variable name="vlan_id" select="ssmNs:clock-ssm-out-vlan-profiles/ssmNs:clock-ssm-out-vlan-profile[ssmNs:name = $ssm_out_profile_name]/ssmNs:ssm-out-vlan-id"/>
                            <xsl:element name="synce-ssm" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-conf-clock-frequency-mounted">
                                <xsl:element name="admin-state" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-conf-clock-frequency-mounted"><xsl:text>unlock</xsl:text></xsl:element>
                                <xsl:element name="ESMC-vlan-id" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-conf-clock-frequency-mounted"><xsl:value-of select="$vlan_id"/></xsl:element>
                            </xsl:element>
		        </xsl:when>
                        <xsl:otherwise>
		            <xsl:variable name="ssm_out_profile_name" select="ifNs:interfaces/ifNs:interface[ifNs:type='ianaift-mounted:ethernetCsmacd']/*[name()='ssm-out-profile-ref']"/>
                            <xsl:variable name="vlan_id" select="ssmNs:clock-ssm-out-vlan-profiles/ssmNs:clock-ssm-out-vlan-profile[ssmNs:name = $ssm_out_profile_name]/ssmNs:ssm-out-vlan-id"/>
                            <xsl:element name="synce-ssm" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-conf-clock-frequency-mounted">
                                <xsl:element name="admin-state" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-conf-clock-frequency-mounted"><xsl:text>lock</xsl:text></xsl:element>
                                <xsl:element name="ESMC-vlan-id" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-conf-clock-frequency-mounted"><xsl:value-of select="$vlan_id"/></xsl:element>
                            </xsl:element>
			</xsl:otherwise>
                    </xsl:choose>    
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test = "$sshEnableCount &gt;= 1">
		        <xsl:element name="synce-ssm" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-conf-clock-frequency-mounted">
		            <xsl:element name="admin-state" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-conf-clock-frequency-mounted"><xsl:text>unlock</xsl:text></xsl:element>
			</xsl:element>
		    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>

        <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>	

   <!--
1.remove interfaces.interface.ssm-out if interfaces.interface.ssm-out.ssm-out-enable is false
2.remove root.clock-ssm-out-vlan-profiles
3.remove interface.ssm-out-profile-ref
   -->
    <xsl:template match="/tailf:config/onuNs:onus/onuNs:onu/onuNs:root/ifNs:interfaces/ifNs:interface[ifNs:type='ianaift-mounted:ethernetCsmacd']/ssmNs:ssm-out-profile-ref"/>
    <xsl:template match="/tailf:config/onuNs:onus/onuNs:onu/onuNs:root/ssmNs:clock-ssm-out-vlan-profiles"/>
    <xsl:template match="/tailf:config/onuNs:onus/onuNs:onu/onuNs:root/ifNs:interfaces/ifNs:interface/ssmNs:ssm-out[ssmNs:ssm-out-enable = 'false']/ssmNs:ssm-out-enable"/>
    <xsl:template match="/tailf:config/onuNs:onus/onuNs:onu/onuNs:root/ifNs:interfaces/ifNs:interface[ssmNs:ssm-out/ssmNs:ssm-out-enable = 'false']/ssmNs:ssm-out"/>

    <xsl:template match="/tailf:config/onuNs:onus/onuNs:onu/onuNs:fromroot/ifNsFromMounted:interfaces/ifNsFromMounted:interface[ifNsFromMounted:type='ianaift-frommounted:ethernetCsmacd']/ssmNsFromMounted:ssm-out-profile-ref"/>
    <xsl:template match="/tailf:config/onuNs:onus/onuNs:onu/onuNs:fromroot/ifNsFromMounted:interfaces/ifNsFromMounted:interface/ssmNsFromMounted:ssm-out/ssmNsFromMounted:ssm-out-enable"/>
    <xsl:template match="/tailf:config/onuNs:onus/onuNs:onu/onuNs:fromroot/ifNsFromMounted:interfaces/ifNsFromMounted:interface/ssmNsFromMounted:ssm-out"/>


</xsl:stylesheet>


