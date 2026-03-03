<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:onusNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount" xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted" xmlns:qosNs="urn:bbf:yang:bbf-qos-policies-mounted" version="1.0">
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


    <xsl:template match="*[name() = 'ingress-qos-policy-profile'          and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies-mounted'         and parent::*[name() = 'interface']         and ancestor::*[name() = 'onu']     ]">
        <xsl:variable name="var_itf_name" select="../child::*[name() = 'name']"/>
        <xsl:variable name="var_type" select="../child::*[name() = 'mig_tmp_type']"/>
        <xsl:choose>
            <xsl:when test="$var_type">
                <xsl:variable name="ns" select="namespace-uri()"/>
                <xsl:variable name="value" select="text()"/>
                <xsl:element name="ingress-qos-policy-profile" namespace="{$ns}">
                    <xsl:value-of select="$var_itf_name"/>
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


    <xsl:template match="*[name() = 'pbit-from-tag-index'          and namespace-uri() = 'urn:bbf:yang:bbf-sub-interface-tagging-mounted'         and ancestor::*[name() = 'interface']         and ancestor::*[name() = 'onu']     ]">
        <xsl:variable name="var_type" select="../../../../../../../child::*[name() = 'mig_tmp_type']"/>
        <xsl:choose>
            <xsl:when test="$var_type">
                <xsl:element name="pbit-marking-index" namespace="urn:bbf:yang:bbf-qos-policies-sub-interfaces-mounted">0</xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[name() = 'write-pbit'          and namespace-uri() = 'urn:bbf:yang:bbf-sub-interface-tagging-mounted'         and ancestor::*[name() = 'interface']         and ancestor::*[name() = 'onu']     ]">
        <xsl:variable name="var_type" select="../../../../../../../child::*[name() = 'mig_tmp_type']"/>
        <xsl:choose>
            <xsl:when test="$var_type">
                <xsl:element name="pbit-marking-index" namespace="urn:bbf:yang:bbf-qos-policies-sub-interfaces-mounted">0</xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="*[name() = 'write-pbit-0'          and namespace-uri() = 'urn:bbf:yang:bbf-sub-interface-tagging-mounted'         and ancestor::*[name() = 'interface']         and ancestor::*[name() = 'onu']     ]">
        <xsl:variable name="var_type" select="../../../../../../../child::*[name() = 'mig_tmp_type']"/>
        <xsl:choose>
            <xsl:when test="$var_type">
                <xsl:element name="pbit-marking-index" namespace="urn:bbf:yang:bbf-qos-policies-sub-interfaces-mounted">0</xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="*[name() = 'mig_tmp_type'                      and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted'                     and parent::*[name() = 'interface']                     and ancestor::*[name() = 'onu']                 ]">
    </xsl:template>

    <xsl:template match="*[name() = 'mig_count_policy_list'          and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted'         and parent::*[name() = 'interface']         and ancestor::*[name() = 'onu']     ]">
    </xsl:template>

    <xsl:template match="*[name() = 'mig_tmp_untagged-write-pbit'          and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted'         and parent::*[name() = 'interface']         and ancestor::*[name() = 'onu']     ]">
    </xsl:template>

    <xsl:template match="*[name() = 'mig_tmp_tagged-write-pbit'          and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted'         and parent::*[name() = 'interface']         and ancestor::*[name() = 'onu']     ]">
    </xsl:template>

</xsl:stylesheet>
