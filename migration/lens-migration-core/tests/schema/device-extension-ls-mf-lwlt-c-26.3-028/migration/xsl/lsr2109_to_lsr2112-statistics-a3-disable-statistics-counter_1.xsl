<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:cfgNs="urn:ietf:params:xml:ns:netconf:base:1.0"
    xmlns:multicastNs="urn:bbf:yang:bbf-mgmd"
    >
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

    <!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <!--
       change the all interfaces statistics from all-available to best-effort if total statistice exceed the hardware resource
    -->
    <xsl:template match="/*
        /*[name()='interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']
        /*[name() ='interface' and ./*[name() = 'type' and text() = 'bbfift:vlan-sub-interface']]
        /*[name() = 'statistics']
        /*[name() = 'enable']
        /text()
        ">

        <xsl:choose>
            <xsl:when test="(/*
                /*[name()='interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']
                /*[name() = 'statistics-exceed-the-hardware-resource'])
                and (. = 'all-available')">
                <xsl:text>best-effort</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="." />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
       disable ipv4 security statistics if total statistice exceed the hardware resource
    -->
    <xsl:template match="/*
        /*[name()='interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']
        /*[name() ='ipv4-security-statistics']
        ">
        <xsl:choose>
            <xsl:when test="/*
                /*[name()='interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']
                /*[name() = 'statistics-exceed-the-hardware-resource']">
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
       disable ipv6 security statistics if total statistice exceed the hardware resource
    -->
    <xsl:template match="/*
        /*[name()='interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']
        /*[name() ='ipv6-security-statistics']
        ">
        <xsl:choose>
            <xsl:when test="/*
                /*[name()='interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']
                /*[name() = 'statistics-exceed-the-hardware-resource']">
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
       add an warning message under root element
    -->
    <xsl:template match="/">
        <xsl:copy>
            <xsl:if test="/*
                /*[name()='interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']
                /*[name() = 'statistics-exceed-the-hardware-resource']
                ">
                <xsl:comment>xslt warning: total statistics counter has exceed the dimension, will disable all statistics func, operator need re-open statistics func after new release upgraded </xsl:comment>
            </xsl:if>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
