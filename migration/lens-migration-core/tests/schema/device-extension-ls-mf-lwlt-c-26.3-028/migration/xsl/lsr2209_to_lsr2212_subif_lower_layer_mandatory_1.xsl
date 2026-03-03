<?xml version="1.0" ?>
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
        the subif-lower-layer of VSI can't be empty
    -->
    <!--
        When NET VSI has no subif-lower-layer:BP_Eth, auto complate the configuration.
        Otherwise, add an invalide element.
    -->
    <xsl:template match="/*
        /*[name()='interfaces' and namespace-uri()='urn:ietf:params:xml:ns:yang:ietf-interfaces']
        /*[name()='interface' and ./*[name()='type' and text()='bbfift:vlan-sub-interface']
                              and not(./*[name()='subif-lower-layer']/*[name()='interface'])
                              and not(./*[name()='interface-usage']/*[name()='interface-usage'])]
        /*[name()='name']
        ">
            <xsl:copy>
                <xsl:copy-of select="@*"/>
                <xsl:apply-templates/>
            </xsl:copy>
            <xsl:choose>
                <xsl:when test="not(../*[name()='vector-profile'])">
                    <wrong-configuration-detected> vlan sub-interface has no subif-lower-layer </wrong-configuration-detected>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="profile-name" select="../*[name()='vector-profile']"/>
                    <xsl:choose>
                        <xsl:when test="/*/*[name()='vsi-vector-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-vlan-sub-interface-vector']
                                        /*[name()='vsi-vector-profile' and ./*[name()='name' and text()=$profile-name]]
                                        /*[name()='interface-usage']/*[name()='interface-usage' and text()='network-port']
                                       ">
                            <subif-lower-layer xmlns="urn:bbf:yang:bbf-sub-interfaces">
                                <interface>BP_Eth</interface>
                            </subif-lower-layer>
                        </xsl:when>
                        <xsl:otherwise>
                            <wrong-configuration-detected> vlan sub-interface has no subif-lower-layer </wrong-configuration-detected>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
    </xsl:template>

    <xsl:template match="/*
        /*[name()='interfaces' and namespace-uri()='urn:ietf:params:xml:ns:yang:ietf-interfaces']
        /*[name()='interface' and ./*[name()='type' and text()='bbfift:vlan-sub-interface']
                              and not(./*[name()='subif-lower-layer']/*[name()='interface'])]
        /*[name()='interface-usage' and namespace-uri() = 'urn:bbf:yang:bbf-interface-usage']
        ">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
        <xsl:choose>
            <xsl:when test="./*[name()='interface-usage' and text()='network-port']">
                <subif-lower-layer xmlns="urn:bbf:yang:bbf-sub-interfaces">
                    <interface>BP_Eth</interface>
                </subif-lower-layer>
            </xsl:when>
            <xsl:otherwise>
                <wrong-configuration-detected> vlan sub-interface has no subif-lower-layer </wrong-configuration-detected>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="/*
        /*[name()='interfaces' and namespace-uri()='urn:ietf:params:xml:ns:yang:ietf-interfaces']
        /*[name()='interface' and ./*[name()='type' and text()='bbfift:vlan-sub-interface']]
        /*[name()='subif-lower-layer' and namespace-uri() = 'urn:bbf:yang:bbf-sub-interfaces']
        ">
        <xsl:if test="./*[name()='interface']">
          <xsl:copy>
              <xsl:copy-of select="@*"/>
              <xsl:apply-templates/>
          </xsl:copy>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>

