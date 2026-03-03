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
        <xsl:variable name="ns" select="namespace-uri()"/>
        <xsl:variable name="var_old_name" select="child::*[name() = 'name']"/>
        <xsl:variable name="var_name0" select="child::*[name() = 'name0']"/>
        <xsl:variable name="var_first_policy_name" select="child::*[name() = 'policy-list'][1]/child::*[name() = 'name']"/>
        <xsl:variable name="var_first_policy" select="../../qosNs:policies-new/qosNs:policy/child::*[name() = 'name' and text()=$var_first_policy_name]/.."/>
        <xsl:variable name="var_untagged_pbit" select="$var_first_policy/child::*[name() = 'untagged_pbit']"/>
        <xsl:variable name="var_untagged_dcsp" select="$var_first_policy/child::*[name() = 'untagged_dcsp']"/>
        <xsl:variable name="var_tagged_copy" select="$var_first_policy/child::*[name() = 'tagged_copy']"/>
        <xsl:variable name="var_tagged_pbit" select="$var_first_policy/child::*[name() = 'tagged_pbit']"/>
        <xsl:element name="policy-profile" namespace="{$ns}">
            <xsl:element name="old_name_pol_pbit" namespace="{$ns}"><xsl:value-of select="$var_old_name"/>_pbit</xsl:element>
            <xsl:element name="old_name_pol_tc" namespace="{$ns}"><xsl:value-of select="$var_old_name"/>_tc</xsl:element>
            <xsl:element name="old_name_vsi" namespace="{$ns}">
                <xsl:value-of select="$var_old_name"/>
            </xsl:element>
            <xsl:element name="name0" namespace="{$ns}">
                <xsl:value-of select="$var_name0"/>
            </xsl:element>

            <xsl:if test="$var_untagged_pbit">
                <xsl:element name="name" namespace="{$ns}"><xsl:value-of select="$var_name0"/>_pbit<xsl:value-of select="$var_untagged_pbit"/></xsl:element>
                <xsl:element name="policy-list" namespace="{$ns}">
                    <xsl:element name="name" namespace="{$ns}"><xsl:value-of select="$var_name0"/>_pbit<xsl:value-of select="$var_untagged_pbit"/></xsl:element>
                </xsl:element>
            </xsl:if>

            <xsl:if test="$var_tagged_pbit">
<xsl:if test="not (number($var_untagged_pbit) = number($var_tagged_pbit))">
                <xsl:element name="name" namespace="{$ns}"><xsl:value-of select="$var_name0"/>_pbit<xsl:value-of select="$var_tagged_pbit"/></xsl:element>
                <xsl:element name="policy-list" namespace="{$ns}">
                    <xsl:element name="name" namespace="{$ns}"><xsl:value-of select="$var_name0"/>_pbit<xsl:value-of select="$var_tagged_pbit"/></xsl:element>
                </xsl:element>
 </xsl:if>
            </xsl:if>

            <xsl:if test="not ($var_untagged_pbit or $var_tagged_pbit)">
                <xsl:element name="name" namespace="{$ns}">
                    <xsl:value-of select="$var_name0"/>
                </xsl:element>
                <xsl:element name="policy-list" namespace="{$ns}">
                    <xsl:element name="name" namespace="{$ns}">
                        <xsl:value-of select="$var_name0"/>
                    </xsl:element>
                </xsl:element>
            </xsl:if>

            <xsl:element name="policy-list" namespace="{$ns}">
                <xsl:element name="name" namespace="{$ns}"><xsl:value-of select="$var_name0"/>_tc</xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
