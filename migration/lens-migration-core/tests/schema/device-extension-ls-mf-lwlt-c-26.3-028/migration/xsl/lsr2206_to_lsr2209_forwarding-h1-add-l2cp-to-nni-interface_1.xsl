<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:param name="interfacesNs" select="'urn:ietf:params:xml:ns:yang:ietf-interfaces'" />

    <!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <!--
        add l2cp to subtended-node-port vsi
    -->

    <!--
    scenatio 1: if not configuration l2cp on subtended-node-port
    expected behavior:  below element will be added to this nni vsi
        <l2cp xmlns="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-l2cp">
            <l2cp-address-service>l2cp-pass-00-02to0f-10-2x</l2cp-address-service>
        </l2cp>

    scenario 2: if l2cp block on subtended-node-port
    expected behavior: will change block-l2cp to pass.
        <l2cp xmlns="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-l2cp">
            <l2cp-address-service>block-l2cp</l2cp-address-service>
        </l2cp>
        will changed to
        <l2cp xmlns="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-l2cp">
            <l2cp-address-service>l2cp-pass-00-02to0f-10-2x</l2cp-address-service>
        </l2cp>
    -->

   <!--
    scenatio 1: if not configuration l2cp on subtended-node-port
    expected behavior:  below element will be added to this nni vsi
        <l2cp xmlns="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-l2cp">
            <l2cp-address-service>l2cp-pass-00-02to0f-10-2x</l2cp-address-service>
        </l2cp>
   -->
    <xsl:template match="/*
        /*[name()='interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']
        /*[name() ='interface' and ./*[name() = 'interface-usage']/*[name() = 'interface-usage' and text() = 'inherit'] and ./*[name() = 'type' and text() = 'bbfift:vlan-sub-interface']]
        /*[name() = 'type']
        ">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>

        <xsl:if test="not(../*[name()='l2cp'])">
            <xsl:element name= "l2cp" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-l2cp">
                <xsl:element name="l2cp-address-service" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-l2cp">l2cp-pass-00-02to0f-10-2x</xsl:element>
            </xsl:element>
        </xsl:if>

    </xsl:template>

    <!--
        scenatio 2: if l2cp block on subtended-node-port
        expected behavior: change block-l2cp to pass
            <l2cp xmlns="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-l2cp">
                <l2cp-address-service>l2cp-pass-00-02to0f-10-2x</l2cp-address-service>
            </l2cp>
    -->

    <xsl:template match="/*
        /*[name()='interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']
        /*[name() ='interface' and ./*[name() = 'interface-usage']/*[name() = 'interface-usage' and text() = 'inherit'] and ./*[name() = 'type' and text() = 'bbfift:vlan-sub-interface']]
        /*[name() = 'l2cp']
        /*[name() = 'l2cp-address-service']
        /text()
        ">
        <xsl:choose>
            <xsl:when test=". = 'block-l2cp'">
                <xsl:text>l2cp-pass-00-02to0f-10-2x</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="." />
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

</xsl:stylesheet>
