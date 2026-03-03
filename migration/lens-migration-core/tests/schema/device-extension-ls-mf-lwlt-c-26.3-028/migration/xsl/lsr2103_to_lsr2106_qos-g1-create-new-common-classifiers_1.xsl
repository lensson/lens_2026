<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:onusNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount" xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted" xmlns:qosNs="urn:bbf:yang:bbf-qos-policies-mounted" xmlns:bbfinf="urn:bbf:yang:bbf-sub-interfaces-mounted" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>
    <!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="*[name() = 'root']">
        <xsl:choose>
            <xsl:when test="namespace-uri() = 'urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount'                   and parent::*[name() = 'onu']             ">
                <xsl:variable name="nsroot" select="'urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount'"/>
                <xsl:element name="root" namespace="{$nsroot}">
                    <xsl:apply-templates select="node()|@*"/>
                    <xsl:variable name="ns" select="'urn:bbf:yang:bbf-qos-classifiers-mounted'"/>
                    <xsl:element name="classifiers-new" namespace="{$ns}">
                        <xsl:call-template name="pbit2tc_pbit">
                            <xsl:with-param name="count" select="0"/>
                        </xsl:call-template>
                        <xsl:call-template name="pbit_marking_tag_pbit">
                            <xsl:with-param name="count" select="0"/>
                        </xsl:call-template>
                        <xsl:call-template name="pbit_marking_untag_write_pbit">
                            <xsl:with-param name="count" select="0"/>
                        </xsl:call-template>
                        <xsl:call-template name="pbit_marking_copy_pbit">
                            <xsl:with-param name="count" select="0"/>
                        </xsl:call-template>
                    </xsl:element>
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
    <xsl:template name="pbit2tc_pbit">
        <xsl:param name="count" select="1"/>
        <xsl:if test="$count &lt; 64">
            <xsl:variable name="ns" select="'urn:bbf:yang:bbf-qos-classifiers-mounted'"/>
            <xsl:variable name="nsp" select="'urn:bbf:yang:bbf-qos-policing-mounted'"/>
            <xsl:element name="classifier-entry" namespace="{$ns}">
                <xsl:element name="name" namespace="{$ns}">pbit2tc_pbit<xsl:value-of select="floor($count div 8)"/>_to_tc<xsl:value-of select="$count mod 8"/></xsl:element>
                <xsl:element name="filter-operation" namespace="{$ns}">match-all-filter</xsl:element>
                <xsl:element name="match-criteria" namespace="{$ns}">
                    <xsl:element name="pbit-marking-list" namespace="{$nsp}">
                        <xsl:element name="index" namespace="{$nsp}">0</xsl:element>
                        <xsl:element name="pbit-value" namespace="{$nsp}">
                            <xsl:value-of select="floor($count div 8)"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="classifier-action-entry-cfg" namespace="{$ns}">
                    <xsl:element name="action-type" namespace="{$ns}">scheduling-traffic-class</xsl:element>
                    <xsl:element name="scheduling-traffic-class" namespace="{$ns}">
                        <xsl:value-of select="$count mod 8"/>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <xsl:call-template name="pbit2tc_pbit">
                <xsl:with-param name="count" select="$count + 1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="pbit_marking_tag_pbit">
        <xsl:param name="count" select="1"/>
        <xsl:if test="$count &lt; 64">
            <xsl:variable name="ns" select="'urn:bbf:yang:bbf-qos-classifiers-mounted'"/>
            <xsl:element name="classifier-entry" namespace="{$ns}">
                <xsl:element name="name" namespace="{$ns}">pbit_marking_tag_pbit<xsl:value-of select="floor($count div 8)"/>_write_pbit<xsl:value-of select="$count mod 8"/></xsl:element>
                <xsl:element name="filter-operation" namespace="{$ns}">match-all-filter</xsl:element>
                <xsl:element name="match-criteria" namespace="{$ns}">
                    <xsl:element name="tag" namespace="{$ns}">
                        <xsl:element name="index" namespace="{$ns}">0</xsl:element>
                        <xsl:element name="in-pbit-list" namespace="{$ns}">
                            <xsl:value-of select="floor($count div 8)"/>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="dscp-range" namespace="{$ns}">any</xsl:element>
                </xsl:element>
                <xsl:element name="classifier-action-entry-cfg" namespace="{$ns}">
                    <xsl:element name="action-type" namespace="{$ns}">pbit-marking</xsl:element>
                    <xsl:element name="pbit-marking-cfg" namespace="{$ns}">
                        <xsl:element name="pbit-marking-list" namespace="{$ns}">
                            <xsl:element name="index" namespace="{$ns}">0</xsl:element>
                            <xsl:element name="pbit-value" namespace="{$ns}">
                                <xsl:value-of select="$count mod 8"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <xsl:call-template name="pbit_marking_tag_pbit">
                <xsl:with-param name="count" select="$count + 1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="pbit_marking_untag_write_pbit">
        <xsl:param name="count" select="1"/>
        <xsl:if test="$count &lt; 8">
            <xsl:variable name="ns" select="'urn:bbf:yang:bbf-qos-classifiers-mounted'"/>
            <xsl:element name="classifier-entry" namespace="{$ns}">
                <xsl:element name="name" namespace="{$ns}">pbit_marking_untag_write_pbit<xsl:value-of select="$count"/></xsl:element>
                <xsl:element name="filter-operation" namespace="{$ns}">match-all-filter</xsl:element>
                <xsl:element name="match-criteria" namespace="{$ns}">
                    <xsl:element name="untagged" namespace="{$ns}"/>
                </xsl:element>
                <xsl:element name="classifier-action-entry-cfg" namespace="{$ns}">
                    <xsl:element name="action-type" namespace="{$ns}">pbit-marking</xsl:element>
                    <xsl:element name="pbit-marking-cfg" namespace="{$ns}">
                        <xsl:element name="pbit-marking-list" namespace="{$ns}">
                            <xsl:element name="index" namespace="{$ns}">0</xsl:element>
                            <xsl:element name="pbit-value" namespace="{$ns}">
                                <xsl:value-of select="$count"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <xsl:call-template name="pbit_marking_untag_write_pbit">
                <xsl:with-param name="count" select="$count + 1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="pbit_marking_copy_pbit">
        <xsl:param name="count" select="1"/>
        <xsl:if test="$count &lt; 8">
            <xsl:variable name="ns" select="'urn:bbf:yang:bbf-qos-classifiers-mounted'"/>
            <xsl:element name="classifier-entry" namespace="{$ns}">
                <xsl:element name="name" namespace="{$ns}">pbit_marking_copy_pbit<xsl:value-of select="$count"/></xsl:element>
                <xsl:element name="filter-operation" namespace="{$ns}">match-all-filter</xsl:element>
                <xsl:element name="match-criteria" namespace="{$ns}">
                    <xsl:element name="tag" namespace="{$ns}">
                        <xsl:element name="index" namespace="{$ns}">0</xsl:element>
                        <xsl:element name="in-pbit-list" namespace="{$ns}">
                            <xsl:value-of select="$count"/>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="dscp-range" namespace="{$ns}">any</xsl:element>
                </xsl:element>
                <xsl:element name="classifier-action-entry-cfg" namespace="{$ns}">
                    <xsl:element name="action-type" namespace="{$ns}">pbit-marking</xsl:element>
                    <xsl:element name="pbit-marking-cfg" namespace="{$ns}">
                        <xsl:element name="pbit-marking-list" namespace="{$ns}">
                            <xsl:element name="index" namespace="{$ns}">0</xsl:element>
                            <xsl:element name="pbit-value" namespace="{$ns}">
                                <xsl:value-of select="$count"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <xsl:call-template name="pbit_marking_copy_pbit">
                <xsl:with-param name="count" select="$count + 1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
