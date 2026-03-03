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
        mark forwarder which include nni vsi
    -->

    <xsl:template match="/*
        /*[name()='forwarding' and namespace-uri() = 'urn:bbf:yang:bbf-l2-forwarding']
        /*[name() ='forwarders']
        /*[name() = 'forwarder']
        ">

        <xsl:variable name="currentFwd" select="./*[name() = 'name']"/>
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
            <xsl:for-each select="./*[name() = 'ports']/*[name() = 'port']">
                <xsl:variable name="vsi" select="./*[name() = 'sub-interface']"/>
                <xsl:if test="/*
                  /*[name() = 'interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces' ]
                  /*[name() = 'interface' and ./*[name() = 'interface-usage']/*[name() = 'interface-usage' and text() = 'inherit'] and ./*[name() = 'type' and text() = 'bbfift:vlan-sub-interface']]
                  /*[name() = 'name' and text()=$vsi]
                  ">
                  <forwarder-include-nni-vsi/>
              </xsl:if>
        </xsl:for-each>
       </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
