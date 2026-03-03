<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:cfgNs="urn:ietf:params:xml:ns:netconf:base:1.0"
    xmlns:onusNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount"
    xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted"
    xmlns:qosNs="urn:bbf:yang:bbf-qos-policies-mounted"
>
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="var_onusNs">urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount</xsl:variable>
    <xsl:variable name="var_ifNs">urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted</xsl:variable>
    <xsl:variable name="var_qosNs">urn:bbf:yang:bbf-qos-policies-mounted</xsl:variable>
    <!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>


    <xsl:template match="*[name() = 'root' 
        and namespace-uri() = 'urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount'
        and parent::*[name() = 'onu']
    ]">
        <xsl:variable name="var_onu_name" select="ancestor::*[name() = 'onu']/child::*[name() = 'name']"/>
        <!--
/child::*[name()='ingress-qos-policy-profile' and text()=$var_name]/../descendant::*[name()='untagged']"
/cfgNs:config/onusNs:onus/onusNs:onu/child::*[name()='name' and text()=$var_onu_name]/../onusNs:root/qosNs:qos-policy-profiles-new/qosNs:policy-profile/qosNs:name
	-->
        <xsl:element name="root" namespace="{$var_onusNs}">
            <xsl:element name="qos-policy-profiles-new" namespace="{$var_qosNs}">
                <xsl:for-each select="../onusNs:root/ifNs:interfaces/ifNs:interface">
                    <xsl:variable name="var_itf_name" select="child::*[name() = 'name']"/>
                    <xsl:variable name="var_profile_name" select="child::*[name() = 'ingress-qos-policy-profile']"/>
                    <xsl:variable name="var_type" select="child::*[name() = 'mig_tmp_type']"/>
                    <xsl:variable name="var_police_count" select="child::*[name() = 'mig_count_policy_list']"/>
                    <xsl:variable name="var_pbit_untagged" select="child::*[name() = 'mig_tmp_untagged-write-pbit']"/>
                    <xsl:variable name="var_pbit_tagged" select="child::*[name() = 'mig_tmp_tagged-write-pbit']"/>
                    <xsl:if test="$var_type">
                        <xsl:variable name="var_old" select="/cfgNs:config/onusNs:onus/onusNs:onu/child::*[name()='name' and text()=$var_onu_name]/../onusNs:root/qosNs:qos-policy-profiles/qosNs:policy-profile/child::*[name()='name' and text()=$var_profile_name]/../child::*"/>
                        <xsl:element name="policy-profile" namespace="{$var_qosNs}">
                            <xsl:element name="mig_tmp_name" namespace="{$var_qosNs}">
                                <xsl:value-of select="$var_itf_name"/>
                            </xsl:element>
                            <xsl:element name="mig_tmp_type" namespace="{$var_qosNs}">
                                <xsl:value-of select="$var_type"/>
                            </xsl:element>
                            <xsl:element name="mig_tmp_police_count" namespace="{$var_qosNs}">
                                <xsl:value-of select="$var_police_count"/>
                            </xsl:element>
                            <xsl:element name="mig_tmp_pbit_untagged" namespace="{$var_qosNs}">
                                <xsl:value-of select="$var_pbit_untagged"/>
                            </xsl:element>
                            <xsl:element name="mig_tmp_pbit_tagged" namespace="{$var_qosNs}">
                                <xsl:value-of select="$var_pbit_tagged"/>
                            </xsl:element>
                            <xsl:copy-of select="$var_old"/>
                        </xsl:element>
                    </xsl:if>
                </xsl:for-each>
            </xsl:element>
            <xsl:copy-of select="child::*"/>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
