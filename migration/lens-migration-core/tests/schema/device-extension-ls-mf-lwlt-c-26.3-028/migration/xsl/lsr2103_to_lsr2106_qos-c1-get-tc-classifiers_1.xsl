<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:onusNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount"
    xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted"
    xmlns:qosNs="urn:bbf:yang:bbf-qos-policies-mounted"
    xmlns:clsNs="urn:bbf:yang:bbf-qos-classifiers-mounted"
>
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="var_onusNs">urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount</xsl:variable>
    <xsl:variable name="var_ifNs">urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted</xsl:variable>
    <xsl:variable name="var_qosNs">urn:bbf:yang:bbf-qos-policies-mounted</xsl:variable>
    <xsl:variable name="var_clsNs">urn:bbf:yang:bbf-qos-classifiers-mounted</xsl:variable>
    <!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*[name() = 'policy-profile'
        and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies-mounted'
        and parent::*[name() = 'qos-policy-profiles-new']
    ]">
        <xsl:variable name="var_onu_name" select="ancestor::*[name() = 'onu']/child::*[name() = 'name']"/>
        <xsl:variable name="var_police_count" select="child::*[name() = 'mig_tmp_police_count']"/>
        <xsl:variable name="var_count">
            <xsl:value-of select="$var_police_count"/>
        </xsl:variable>
        <!--
    <xsl:variable name="var_policy_name1" select="child::*[name() = 'policy-list'][1]/child::*[name() = 'name']"/>
    <xsl:variable name="var_policy_name2" select="child::*[name() = 'policy-list'][2]/child::*[name() = 'name']"/>
-->
        <xsl:variable name="var_policy_name" select="child::*[name() = 'policy-list'][position()=$var_count]/child::*[name() = 'name']"/>
        <!--
					<xsl:choose>
						<xsl:when test="1=$var_police_count">
    <xsl:variable name="var_policy_name" select="child::*[name() = 'policy-list'][1]/child::*[name() = 'name']"/>
						</xsl:when>
						<xsl:otherwise>
    <xsl:variable name="var_policy_name" select="child::*[name() = 'policy-list'][2]/child::*[name() = 'name']"/>
						</xsl:otherwise>
					</xsl:choose>
-->
        <xsl:element name="policy-profile" namespace="{$var_qosNs}">
            <xsl:copy-of select="child::*"/>
            <!--
<xsl:element name="aa" namespace="{$var_qosNs}"><xsl:value-of select="$var_onu_name"/></xsl:element>
<xsl:element name="var_policy_name" namespace="{$var_qosNs}"><xsl:value-of select="$var_policy_name"/></xsl:element>
<xsl:element name="var_police_count" namespace="{$var_qosNs}"><xsl:value-of select="$var_police_count"/></xsl:element>
<xsl:element name="var_policy_name1" namespace="{$var_qosNs}"><xsl:value-of select="$var_policy_name1"/></xsl:element>
<xsl:element name="var_policy_name2" namespace="{$var_qosNs}"><xsl:value-of select="$var_policy_name2"/></xsl:element>
-->
            <xsl:for-each select="../../qosNs:policies/qosNs:policy/child::*[name() = 'name' and text()=$var_policy_name]">
                <xsl:element name="mig_tmp_classifiers" namespace="{$var_qosNs}">
                    <xsl:for-each select="../qosNs:classifiers/qosNs:name">
                        <xsl:variable name="var_classifier_name" select="."/>
                        <xsl:variable name="var_pbit_list" select="../../../../clsNs:classifiers/clsNs:classifier-entry/child::*[name() = 'name' and text()=$var_classifier_name]/../descendant::*[name() = 'in-pbit-list']"/>
                        <xsl:variable name="var_tc" select="../../../../clsNs:classifiers/clsNs:classifier-entry/child::*[name() = 'name' and text()=$var_classifier_name]/../descendant::*[name() = 'scheduling-traffic-class']"/>
                        <xsl:element name="soure_classifier" namespace="{$var_qosNs}">
                            <xsl:element name="name" namespace="{$var_qosNs}">
                                <xsl:value-of select="$var_classifier_name"/>
                            </xsl:element>
                            <!--
					<xsl:element name="pbit_list" namespace="{$var_qosNs}"><xsl:value-of select="$var_pbit_list"/></xsl:element>
-->
                            <xsl:choose>
                                <xsl:when test="1=string-length($var_pbit_list)">
                                    <xsl:element name="pbit-value" namespace="{$var_qosNs}">
                                        <xsl:value-of select="$var_pbit_list"/>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:element name="pbit-value" namespace="{$var_qosNs}"><xsl:value-of select="$var_pbit_list"/>,</xsl:element>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:element name="tc" namespace="{$var_qosNs}">
                                <xsl:value-of select="$var_tc"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
