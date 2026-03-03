<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:cfgNs="urn:ietf:params:xml:ns:netconf:base:1.0"
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
       add a warning message under root element
    -->
    <xsl:template match="/">
        <xsl:copy>
            <xsl:if test="/*
                /*[local-name()='interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']
                /*[local-name() ='interface' and ./*[local-name() = 'type' and (text() = 'bbf-xponift:olt-v-enet' or text() = 'ianaift:ethernetCsmacd' or text() = 'ianaift:ieee8023adLag')]]
                /*[local-name() = 'mac-learning']
                /*[local-name() = 'max-number-mac-addresses' and text() != '4294967295']
                ">
                <xsl:comment>xslt warning: the max mac number configured on VSI lower-layer interface will be changed to 4294967295, operator need check whether it is expected. </xsl:comment>
            </xsl:if>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
