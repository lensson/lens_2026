<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:onusNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount" xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted" xmlns:qosNs="urn:bbf:yang:bbf-qos-policies-mounted" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>
    <!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*[name() = 'policy-profile'          and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies-mounted'          and parent::*[name() = 'qos-policy-profiles']          and ancestor::*[name() = 'onu']     ]">
        <xsl:variable name="var_name" select="child::*[name() = 'name']"/>
        <xsl:variable name="var_vsi" select="../../ifNs:interfaces/ifNs:interface/child::*[name()='ingress-qos-policy-profile' and text()=$var_name]"/>
        <xsl:choose>
            <xsl:when test="not ($var_vsi)">
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
