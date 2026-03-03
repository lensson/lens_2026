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

    <xsl:template match="*[name() = 'policy'          and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies-mounted'         and parent::*[name() = 'policies']         and ancestor::*[name() = 'onu']     ]">
        <xsl:variable name="var_name" select="child::*[name() = 'name']"/>
        <xsl:variable name="var_new" select="../../qosNs:policies-new/qosNs:policy/child::*[name() = 'name' and text()=$var_name]"/>
        <xsl:choose>
            <xsl:when test="$var_new">
      </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[name() = 'policy-profile'         and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies-mounted'         and parent::*[name() = 'qos-policy-profiles']         and ancestor::*[name() = 'onu']     ]">
        <xsl:variable name="var_name" select="child::*[name() = 'name']"/>
        <xsl:variable name="var_new" select="../../qosNs:qos-policy-profiles-new/qosNs:policy-profile/child::*[name() = 'name' and text()=$var_name]"/>
        <xsl:choose>
            <xsl:when test="$var_new">
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
