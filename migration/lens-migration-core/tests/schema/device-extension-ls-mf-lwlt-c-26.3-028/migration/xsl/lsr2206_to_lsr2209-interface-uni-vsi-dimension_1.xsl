<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
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
        uni per olt-v-enet dimension:8
    -->

    <!--
       add invalid element if uni vis number reach the dimension
       match the user-port olt-v-enet element
    -->
    <xsl:template match="/*
        /*[name() = 'interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']
        /*[name() = 'interface' and ./*[name() = 'type' and text()='bbf-xponift:olt-v-enet']
                                and not(./*[name() = 'interface-usage']/*[name() = 'interface-usage' and text() = 'subtended-node-port'])]
        ">
        <xsl:copy>
            <xsl:variable name="olt-v-enet-name" select="./*[name() = 'name']"/>
            <xsl:if test="count(/*
                /*[name()='interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']
                /*[name() ='interface' and ./*[name() = 'type' and text() = 'bbfift:vlan-sub-interface']
                                       and ./*[name() = 'subif-lower-layer']/*[name() = 'interface' and text() = $olt-v-enet-name]])
                &gt;8
                ">
                <wrong-configuration-detected>Max Uni vsi per olt-v-enet reached - Migration is not successful</wrong-configuration-detected>
            </xsl:if>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
