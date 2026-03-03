<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:cfgNs="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:bbfXpon="urn:bbf:yang:bbf-xpon" xmlns:bbfGem="urn:bbf:yang:bbf-xpongemtcont" xmlns:bbfIfPortRef="urn:bbf:yang:bbf-interface-port-reference" xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces" version="1.0" exclude-result-prefixes="bbfGem bbfIfPortRef bbfXpon cfgNs ifNs">

<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
<xsl:strip-space elements="*"/>

<!-- default rule -->
<xsl:template match="node()|@*">
    <xsl:copy>
        <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
</xsl:template>


<xsl:template match="*/child::*[(local-name() = 'hardware' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-hardware')]">
    <xsl:copy>
        <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
    <xsl:variable name="tcontCfg" select="../*[local-name()='tconts-config' and namespace-uri() = 'urn:bbf:yang:bbf-xpongemtcont']/*"/>
    <xsl:variable name="gemCfg" select="../*[local-name()='gemports-config' and namespace-uri() = 'urn:bbf:yang:bbf-xpongemtcont']/*"/>
    <xsl:variable name="trafficProf" select="../*[local-name()='traffic-descriptor-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-xpongemtcont']/*"/>
    <xsl:variable name="ictpCfg" select="../*[local-name()='ictp-config' and namespace-uri()='urn:bbf:yang:bbf-xpon']/*"/>
    <xsl:variable name="multiGemCfg" select="../*[local-name()='multicast-gemports-config' and namespace-uri()='urn:bbf:yang:bbf-xpon']/*"/>
    <xsl:variable name="multiDistSetCfg" select="../*[local-name()='multicast-distribution-set-config' and namespace-uri()='urn:bbf:yang:bbf-xpon']/*"/>
    <xsl:variable name="wavelengthProfCfg" select="../*[local-name()='wavelength-profiles' and namespace-uri()='urn:bbf:yang:bbf-xpon']/*"/>

    <xsl:if test="$ictpCfg != '' or $multiGemCfg != '' or $multiDistSetCfg != '' or $wavelengthProfCfg != ''">
    <xsl:element name="xpon" namespace="urn:bbf:yang:bbf-xpon">
        <xsl:if test="$wavelengthProfCfg != ''">
            <xsl:element name="wavelength-profiles" namespace="urn:bbf:yang:bbf-xpon">
                <xsl:copy-of select="$wavelengthProfCfg"/>
            </xsl:element>
        </xsl:if>
        <xsl:if test="$ictpCfg != ''">
            <xsl:element name="ictp" namespace="urn:bbf:yang:bbf-xpon">
                <xsl:copy-of select="$ictpCfg"/>
            </xsl:element>
        </xsl:if>
        <xsl:if test="$multiGemCfg != ''">
            <xsl:element name="multicast-gemports" namespace="urn:bbf:yang:bbf-xpon">
                <xsl:copy-of select="$multiGemCfg"/>
            </xsl:element>
        </xsl:if>
        <xsl:if test="$multiDistSetCfg != ''">
            <xsl:element name="multicast-distribution-set" namespace="urn:bbf:yang:bbf-xpon">
                <xsl:copy-of select="$multiDistSetCfg"/>
            </xsl:element>
        </xsl:if>
    </xsl:element>
    </xsl:if>

    <xsl:if test="$gemCfg != '' or $tcontCfg != '' or $trafficProf != ''">
    <xsl:element name="xpongemtcont" namespace="urn:bbf:yang:bbf-xpongemtcont">
        <xsl:if test="$trafficProf != ''">
            <xsl:element name="traffic-descriptor-profiles" namespace="urn:bbf:yang:bbf-xpongemtcont">
                <xsl:copy-of select="$trafficProf"/>
            </xsl:element>
        </xsl:if>
        <xsl:if test="$tcontCfg != ''">
            <xsl:element name="tconts" namespace="urn:bbf:yang:bbf-xpongemtcont">
                <xsl:copy-of select="$tcontCfg"/>
            </xsl:element>
        </xsl:if>
        <xsl:if test="$gemCfg != ''">
            <xsl:element name="gemports" namespace="urn:bbf:yang:bbf-xpongemtcont">
                <xsl:copy-of select="$gemCfg"/>
            </xsl:element>
        </xsl:if>
    </xsl:element>
    </xsl:if>
</xsl:template>

</xsl:stylesheet>
