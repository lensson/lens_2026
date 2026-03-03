<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    
    xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces"
>
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:variable name="var_ifNs">urn:ietf:params:xml:ns:yang:ietf-interfaces</xsl:variable>
    <xsl:variable name="var_fwdNs">urn:bbf:yang:bbf-l2-forwarding</xsl:variable>
    <xsl:variable name="var_itfUsageNs">urn:bbf:yang:bbf-interface-usage</xsl:variable>
    <xsl:variable name="var_l2term">urn:bbf:yang:bbf-l2-terminations</xsl:variable>
    <!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="*[name() = 'interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']">
        <xsl:element name="interfaces" namespace="{$var_ifNs}">
        <xsl:for-each select="ifNs:interface">
            <xsl:element name="interface" namespace="{$var_ifNs}">
            <xsl:variable name="var_type" select="child::*[name() = 'type' and text() = 'nokia-l2-ti:l2-termination-interface']"/> 
            <xsl:choose>
            <xsl:when test="$var_type">
                <xsl:element name="name" namespace="{$var_ifNs}">
                    <xsl:value-of select="child::*[name() = 'name']"/>
                </xsl:element>
                <type xmlns:bbfift="urn:bbf:yang:bbf-if-type" xmlns="urn:ietf:params:xml:ns:yang:ietf-interfaces">bbfift:l2-termination</type>
                <xsl:variable name="var_itfUsage" select="child::*/child::*[name() = 'interface-usage']"/> 
                <xsl:if test="$var_itfUsage">
                    <xsl:element name="interface-usage" namespace="{$var_itfUsageNs}">
                        <xsl:element name="interface-usage" namespace="{$var_itfUsageNs}">
                            <xsl:value-of select="$var_itfUsage"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="child::*[name() = 'l2-termination-interface']">
                    <xsl:element name="l2-termination" namespace="{$var_l2term}">
                    <xsl:if test="child::*[name() = 'l2-termination-interface']/child::*[name() = 'termination-port-receive']">
                        <xsl:element name="ingress-rewrite" namespace="{$var_l2term}">
                            <xsl:element name="pop-tags" namespace="{$var_l2term}">
                                <xsl:value-of select="child::*/child::*[name() = 'termination-port-receive']/child::*[name() = 'pop-tags']"/>
                            </xsl:element>                       
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="child::*[name() = 'l2-termination-interface']/child::*[name() = 'termination-port-transmit']">
                        <xsl:element name="egress-rewrite" namespace="{$var_l2term}">
                            <xsl:element name="push-tag" namespace="{$var_l2term}">
                                <xsl:element name="index" namespace="{$var_l2term}">0</xsl:element>
                                <tag-type xmlns:bbf-dot1qt="urn:bbf:yang:bbf-dot1q-types" xmlns="urn:bbf:yang:bbf-l2-terminations">
                                    <xsl:value-of select="child::*/child::*[name() = 'termination-port-transmit']/child::*[name() = 'push-tag']/child::*[name() = 'index' and text() = '0']/following-sibling::*[name() = 'dot1q-tag']/child::*[name() = 'tag-type']"/>
                                </tag-type>
                                <xsl:element name="vlan-id" namespace="{$var_l2term}">
                                    <xsl:value-of select="child::*/child::*[name() = 'termination-port-transmit']/child::*[name() = 'push-tag']/child::*[name() = 'index' and text() = '0']/following-sibling::*[name() = 'dot1q-tag']/child::*[name() = 'vlan-id']"/>
                                </xsl:element>
                                <xsl:element name="pbit" namespace="{$var_l2term}">0</xsl:element>
                            </xsl:element>
                            <xsl:if test="child::*/child::*[name() = 'termination-port-transmit']/child::*[name() = 'push-tag']/child::*[name() = 'index' and text() = '1']">
                                <xsl:element name="push-tag" namespace="{$var_l2term}">
                                    <xsl:element name="index" namespace="{$var_l2term}">1</xsl:element>
                                    <tag-type xmlns:bbf-dot1qt="urn:bbf:yang:bbf-dot1q-types" xmlns="urn:bbf:yang:bbf-l2-terminations">
                                        <xsl:value-of select="child::*/child::*[name() = 'termination-port-transmit']/child::*[name() = 'push-tag']/child::*[name() = 'index' and text() = '1']/following-sibling::*[name() = 'dot1q-tag']/child::*[name() = 'tag-type']"/>
                                    </tag-type>
                                    <xsl:element name="vlan-id" namespace="{$var_l2term}">
                                        <xsl:value-of select="child::*/child::*[name() = 'termination-port-transmit']/child::*[name() = 'push-tag']/child::*[name() = 'index' and text() = '1']/following-sibling::*[name() = 'dot1q-tag']/child::*[name() = 'vlan-id']"/>
                                    </xsl:element>
                                    <xsl:element name="pbit" namespace="{$var_l2term}">0</xsl:element>
                                </xsl:element>
                            </xsl:if>
                        </xsl:element>
                    </xsl:if>
                    </xsl:element>
                </xsl:if>
                <xsl:copy-of select="child::*[name() = 'object-index']"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="child::*"/>
            </xsl:otherwise>
            </xsl:choose>
            </xsl:element>
        </xsl:for-each>
        <xsl:copy-of select="child::*[not(name() = 'interface')]"/>  
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="*[local-name() = 'l2-termination-interface' and parent::*[name() = 'port']]">
        <xsl:element name="sub-interface" namespace="{$var_fwdNs}">
             <xsl:apply-templates select="node()|@*"/>
        </xsl:element>
    </xsl:template>
    

</xsl:stylesheet>

