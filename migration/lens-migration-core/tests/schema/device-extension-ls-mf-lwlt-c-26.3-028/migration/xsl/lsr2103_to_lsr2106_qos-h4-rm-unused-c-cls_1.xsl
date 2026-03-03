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

    <xsl:template match="*[name() = 'classifier-entry'         and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers-mounted'         and parent::*[name() = 'classifiers']         and ancestor::*[name() = 'onu']     ]">
        <xsl:variable name="var_name" select="child::*[name() = 'name']"/>
        <xsl:variable name="var_policy" select="../../qosNs:policies/qosNs:policy/qosNs:classifiers/child::*[name()='name' and text()=$var_name]"/>
        <xsl:choose>
            <xsl:when test="not ($var_policy)">
          </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[((name() = 'write-pbit') or (name() = 'write-pbit-0'))         and namespace-uri() = 'urn:bbf:yang:bbf-sub-interface-tagging-mounted'         and ancestor::*[name() = 'ingress-rewrite']         and ancestor::*[name() = 'interface']         and ancestor::*[name() = 'onu']     ]">
        <xsl:variable name="ns" select="namespace-uri()"/>
        <xsl:element name="pbit-from-tag-index" namespace="{$ns}">0</xsl:element>
    </xsl:template>

</xsl:stylesheet>
