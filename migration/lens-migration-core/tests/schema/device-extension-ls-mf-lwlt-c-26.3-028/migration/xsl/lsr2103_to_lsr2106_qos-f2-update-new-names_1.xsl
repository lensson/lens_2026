<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:onusNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount" xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted" xmlns:qosNs="urn:bbf:yang:bbf-qos-policies-mounted" xmlns:clsNs="urn:bbf:yang:bbf-qos-classifiers-mounted" version="1.0">
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

    <xsl:template match="*[name() = 'name'          and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies-mounted'         and parent::*[name() = 'policy']         and ancestor::*[name() = 'policies-new']     ]">
        <xsl:variable name="ns" select="namespace-uri()"/>
        <xsl:variable name="var_old_name" select="."/>
        <xsl:variable name="var_profile1" select="../../../qosNs:qos-policy-profiles-new/qosNs:policy-profile/child::*[name() = 'old_name_pol_pbit' and text()=$var_old_name]"/>
        <xsl:variable name="var_profile2" select="../../../qosNs:qos-policy-profiles-new/qosNs:policy-profile/child::*[name() = 'old_name_pol_tc' and text()=$var_old_name]"/>
        <xsl:variable name="var_new_name1" select="$var_profile1/../child::*[name() = 'name']"/>
        <xsl:variable name="var_new_name2" select="$var_profile2/../child::*[name() = 'name0']"/>
        <!--
        <xsl:element name="var_old_name" namespace="{$ns}"><xsl:value-of select="$var_old_name"/></xsl:element>
        <xsl:element name="var_new_name" namespace="{$ns}"><xsl:value-of select="$var_new_name"/></xsl:element>
-->
        <xsl:if test="$var_new_name1">
            <xsl:element name="name" namespace="{$ns}">
                <xsl:value-of select="$var_new_name1"/>
            </xsl:element>
        </xsl:if>
        <xsl:if test="$var_new_name2">
            <xsl:element name="name" namespace="{$ns}"><xsl:value-of select="$var_new_name2"/>_tc</xsl:element>
        </xsl:if>
        <xsl:if test="not ($var_new_name1 or $var_new_name2)">
            <xsl:copy>
                <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
        </xsl:if>
    </xsl:template>


    <xsl:template match="*[name() = 'ingress-qos-policy-profile'          and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies-mounted'         and parent::*[name() = 'interface']         and ancestor::*[name() = 'onu']     ]">
        <xsl:variable name="ns" select="namespace-uri()"/>
        <xsl:variable name="var_old_name" select="."/>
        <xsl:variable name="var_profile" select="../../../qosNs:qos-policy-profiles-new/qosNs:policy-profile/child::*[name() = 'old_name_vsi' and text()=$var_old_name]"/>
        <xsl:variable name="var_new_name" select="$var_profile/../child::*[name() = 'name']"/>
        <!--
        <xsl:element name="var_old_name" namespace="{$ns}"><xsl:value-of select="$var_old_name"/></xsl:element>
        <xsl:element name="var_new_name" namespace="{$ns}"><xsl:value-of select="$var_new_name"/></xsl:element>
-->
        <xsl:choose>
            <xsl:when test="$var_new_name">
                <xsl:element name="ingress-qos-policy-profile" namespace="{$ns}">
                    <xsl:value-of select="$var_new_name"/>
                </xsl:element>
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
