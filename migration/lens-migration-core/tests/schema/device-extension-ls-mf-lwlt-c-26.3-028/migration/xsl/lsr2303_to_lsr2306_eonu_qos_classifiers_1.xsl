<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cfgNs="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:onu="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount" xmlns:bbf-qos-cls-mounted="urn:bbf:yang:bbf-qos-classifiers-mounted" xmlns:bbf-qos-plc-mounted="urn:bbf:yang:bbf-qos-policing-mounted" xmlns:if-mounted="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted" xmlns:bbf-subif-mounted="urn:bbf:yang:bbf-sub-interfaces-mounted" xmlns:bbf-subif-tag-mounted="urn:bbf:yang:bbf-sub-interface-tagging-mounted" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>


<!-- update pbit-marking-list index value to 0 -->
<xsl:template match="/cfgNs:config/onu:onus/onu:onu/onu:root/bbf-qos-cls-mounted:classifiers/bbf-qos-cls-mounted:classifier-entry/bbf-qos-cls-mounted:match-criteria/bbf-qos-plc-mounted:pbit-marking-list/bbf-qos-plc-mounted:index">
    <xsl:if test="text() != 0">
        <xsl:element name="{local-name()}" namespace="urn:bbf:yang:bbf-qos-policing-mounted">0</xsl:element>
    </xsl:if>
    <xsl:if test="text() = 0">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
    </xsl:if>
</xsl:template>

<xsl:template match="/cfgNs:config/onu:onus/onu:onu/onu:root/bbf-qos-cls-mounted:classifiers/bbf-qos-cls-mounted:classifier-entry/bbf-qos-cls-mounted:classifier-action-entry-cfg/bbf-qos-cls-mounted:pbit-marking-cfg/bbf-qos-cls-mounted:pbit-marking-list/bbf-qos-cls-mounted:index">
    <xsl:if test="text() != 0">
        <xsl:element name="{local-name()}" namespace="urn:bbf:yang:bbf-qos-classifiers-mounted">0</xsl:element>
    </xsl:if>
    <xsl:if test="text() = 0">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
    </xsl:if>
</xsl:template>

<!-- remove classifiers match-criteria tag with index value 1 -->
<xsl:template match="/cfgNs:config/onu:onus/onu:onu/onu:root/bbf-qos-cls-mounted:classifiers/bbf-qos-cls-mounted:classifier-entry/bbf-qos-cls-mounted:match-criteria/bbf-qos-cls-mounted:tag[bbf-qos-cls-mounted:index[text() = 1]]"/>

<!-- remove egress-rewrite push-tag when pop-tags value 0 -->
<xsl:template match="/cfgNs:config/onu:onus/onu:onu/onu:root/if-mounted:interfaces/if-mounted:interface/bbf-subif-mounted:inline-frame-processing/bbf-subif-mounted:egress-rewrite/bbf-subif-tag-mounted:push-tag[../bbf-subif-tag-mounted:pop-tags[text() = 0]]"/>

</xsl:stylesheet>
