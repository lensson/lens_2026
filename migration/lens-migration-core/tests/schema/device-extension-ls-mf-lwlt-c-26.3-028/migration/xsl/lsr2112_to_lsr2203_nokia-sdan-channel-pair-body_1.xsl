<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:oldns="urn:broadband-forum-org:yang:bbf-xponinfra-augment-nodes"
                              xmlns:newns="urn:broadband-forum-org:yang:nokia-sdan-channel-pair-body">

    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
        <xsl:copy-of select="@*"/> 
        <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <!-- change namespace recursively -->
    <xsl:param name="sourceNamespace" select="'urn:broadband-forum-org:yang:bbf-xponinfra-augment-nodes'" />
    <xsl:param name="targetNamespace" select="'urn:broadband-forum-org:yang:nokia-sdan-channel-pair-body'" />
    <xsl:template match="node() | @*" name="xponinfraAug:ultra-low-latency-mode"  xmlns:xponinfraAug="urn:broadband-forum-org:yang:bbf-xponinfra-augment-nodes">
        <xsl:copy>
        <xsl:apply-templates select="node() | @*" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*">
        <xsl:choose>
            <xsl:when test="namespace-uri() = $sourceNamespace
                            and ./parent::*[name() = 'channel-pair'] 
                            and (name() = 'xponinfraAug:ultra-low-latency-mode'
                                or name() = 'ultra-low-latency-mode') ">
                <xsl:element name="nokia-sdan-channel-pair-body:ultra-low-latency-mode" namespace="{$targetNamespace}">
                    <xsl:apply-templates select="node() | @*"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="xponinfraAug:ultra-low-latency-mode" xmlns:xponinfraAug="urn:broadband-forum-org:yang:bbf-xponinfra-augment-nodes"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
