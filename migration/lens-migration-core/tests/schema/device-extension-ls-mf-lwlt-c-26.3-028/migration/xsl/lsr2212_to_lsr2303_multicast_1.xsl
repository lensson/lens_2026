<?xml version="1.0" ?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ipspoofns="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-mgmd-ipspoof"
    xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <!-- Identity transform -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Remove unsupported multicast-interface-to-host leaves under bbf-mgmd -->
    <xsl:template match="*[(name() = 'multicast-rate-limit' or
                            name() = 'multicast-rate-limit-exceed-action') and
                            namespace-uri() = 'urn:bbf:yang:bbf-mgmd']">
        <xsl:choose>
            <xsl:when test="parent::*[name() = 'multicast-interface-to-host']">
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Remove unsupported multicast-interface-to-host leaves under nokia-mgmd-ipspoof -->
    <xsl:template match="ipspoofns:vlan-sub-interface-ref-for-ipspoof">
    </xsl:template>

    <!-- Remove unsupported multicast-channel leaves under bbf-mgmd -->
    <xsl:template match="*[(name() = 'interface-to-host') and
                        namespace-uri() = 'urn:bbf:yang:bbf-mgmd']">
        <xsl:choose>
            <xsl:when test="parent::*[name() = 'multicast-channel']">
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

