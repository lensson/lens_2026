<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

    <!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>


    <!-- Delete unsupported nodes under /bbf-l2-fwd:forwarding/bbf-l2-fwd:forwarders/bbf-l2-fwd:forwarder/bbf-l2-fwd:flooding-policies/bbf-l2-fwd:flooding-policy-type/bbf-l2-fwd:forwarder-specific -->
    <xsl:template match="*[         local-name() = 'flooding-policy'         and namespace-uri() = 'urn:bbf:yang:bbf-l2-forwarding'         and parent::*[name() = 'flooding-policies']         and ancestor::*[name() = 'forwarder']         and ancestor::*[name() = 'forwarding']     ]">
    </xsl:template>    

    <!-- Delete unsupported nodes under /bbf-l2-fwd:forwarding/bbf-l2-fwd:forwarding-databases/bbf-l2-fwd:forwarding-database/bbf-l2-fwd:static-mac-address -->
    <xsl:template match="*[         namespace-uri() = 'urn:bbf:yang:bbf-l2-forwarding'         and parent::*[name() = 'static-mac-address']         and ancestor::*[name() = 'forwarding-database']     ]">
        <xsl:choose>
            <xsl:when test="             local-name() = 'forwarder-port-ref'             or local-name() = 'forwarder-port-group-ref'             ">
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>  
    </xsl:template>

    <!-- Delete unsupported nodes under /if:interfaces/if:interface/bbf-subif:frame-processing/bbf-subif:inline-frame-processing/bbf-subif:inline-frame-processing/bbf-subif:ingress-rule/bbf-subif:rule/bbf-subif:flexible-match/bbf-subif-tag:match-criteria -->    
    <xsl:template match="*[         namespace-uri() = 'urn:bbf:yang:bbf-sub-interface-tagging'         and parent::*[name() = 'match-criteria']         and ancestor::*[name() = 'inline-frame-processing' and namespace-uri() = 'urn:bbf:yang:bbf-sub-interfaces']         and ancestor::*[name() = 'interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']     ]">
        <xsl:choose>
            <xsl:when test="             local-name() = 'any-frame'             or local-name() = 'any-multicast-mac-address'             or local-name() = 'unicast-address'             or local-name() = 'broadcast-address'             or local-name() = 'cfm-multicast-address'             or local-name() = 'ipv4-multicast-address'             or local-name() = 'ipv6-multicast-address'             or local-name() = 'mac-address-value'             or local-name() = 'mac-address-mask'             or local-name() = 'any-multicast-ipv4-address'             or local-name() = 'all-hosts-multicast-address'             or local-name() = 'rip-multicast-address'             or local-name() = 'ntp-multicast-address'             or local-name() = 'ipv4-prefix'             or local-name() = 'any-multicast-ipv6-address'             or local-name() = 'all-nodes-multicast-ipv6-address'             or local-name() = 'rip-multicast-ipv6-address'             or local-name() = 'ntp-multicast-ipv6-address'             or local-name() = 'ipv6-prefix'             or local-name() = 'match-all'             or local-name() = 'ethernet-frame-type'             or local-name() = 'any-protocol'             or local-name() = 'protocol'             ">
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>        
    </xsl:template>


    <!-- Delete unsupported nodes under /if:interfaces/if:interface/bbf-subif:frame-processing/bbf-subif:inline-frame-processing/bbf-subif:inline-frame-processing/bbf-subif:ingress-rule/bbf-subif:rule/bbf-subif:flexible-match/bbf-subif-tag:exclude-criteria -->
    <xsl:template match="*[         local-name() = 'exclude-criteria'         and namespace-uri() = 'urn:bbf:yang:bbf-sub-interface-tagging'         and parent::*[name() = 'flexible-match' and namespace-uri() = 'urn:bbf:yang:bbf-sub-interfaces']         and ancestor::*[name() = 'inline-frame-processing' and namespace-uri() = 'urn:bbf:yang:bbf-sub-interfaces']         and ancestor::*[name() = 'interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']     ]">
    </xsl:template>


    <!-- Delete unsupported nodes under /if:interfaces/if:interface/bbf-subif:frame-processing/bbf-subif:inline-frame-processing/bbf-subif:inline-frame-processing/bbf-subif:ingress-rule/bbf-subif:rule/bbf-subif:ingress-rewrite -->
    <xsl:template match="*[         local-name() = 'push-tag'         and namespace-uri() = 'urn:bbf:yang:bbf-sub-interface-tagging'         and parent::*[name() = 'ingress-rewrite' and namespace-uri() = 'urn:bbf:yang:bbf-sub-interfaces']         and ancestor::*[name() = 'inline-frame-processing' and namespace-uri() = 'urn:bbf:yang:bbf-sub-interfaces']         and ancestor::*[name() = 'interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']     ]">
    </xsl:template>



    <!-- Delete unsupported nodes under /if:interfaces/if:interface/bbf-subif:frame-processing/bbf-subif:inline-frame-processing/bbf-subif:inline-frame-processing/bbf-subif:egress-rewrite -->
    <xsl:template match="*[         namespace-uri() = 'urn:bbf:yang:bbf-sub-interface-tagging'         and parent::*[name() = 'dot1q-tag']         and ancestor::*[name() = 'egress-rewrite' and namespace-uri() = 'urn:bbf:yang:bbf-sub-interfaces']         and ancestor::*[name() = 'inline-frame-processing' and namespace-uri() = 'urn:bbf:yang:bbf-sub-interfaces']         and ancestor::*[name() = 'interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']     ]">
        <xsl:choose>
            <xsl:when test="                 local-name() = 'vlan-id-from-tag-index-or-discard'             ">
            </xsl:when>

            <xsl:when test="                 local-name() = 'write-pbit-0'                 or local-name() = 'write-pbit'             ">
                <xsl:if test="                 not(parent::*[name()='dot1q-tag']/descendant::*[name()='pbit-from-tag-index'])                 and not(parent::*[name()='dot1q-tag']/descendant::*[name()='pbit-marking-index'])                 ">
                    <xsl:element name="pbit-marking-index" namespace="urn:bbf:yang:bbf-qos-policies-sub-interfaces">
                        <xsl:value-of select="ancestor::*[name()='push-tag']/descendant::*[name()='index']"/>
                    </xsl:element>
                </xsl:if>
            </xsl:when>

            <xsl:when test="                 local-name() = 'write-dei-0'                 or local-name() = 'write-dei-1'             ">
                <xsl:if test="                 not(parent::*[name()='dot1q-tag']/descendant::*[name()='dei-from-tag-index'])                 and not(parent::*[name()='dot1q-tag']/descendant::*[name()='dei-marking-index'])                 ">
                    <xsl:element name="dei-marking-index" namespace="urn:bbf:yang:bbf-qos-policies-sub-interfaces">
                        <xsl:value-of select="ancestor::*[name()='push-tag']/descendant::*[name()='index']"/>
                    </xsl:element>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[         namespace-uri() = 'urn:bbf:yang:bbf-frame-processing-profile'         and parent::*[name() = 'match-criteria']         and ancestor::*[name() = 'frame-processing-profiles']     ]">
        <xsl:choose>
            <xsl:when test="                 local-name() = 'any-frame'                 or local-name='any-multicast-mac-address'                 or local-name() = 'unicast-address'                 or local-name() = 'broadcast-address'                 or local-name() = 'cfm-multicast-address'                 or local-name() = 'ipv4-multicast-address'                 or local-name() = 'ipv6-multicast-address'                 or local-name() = 'mac-address-value'                 or local-name() = 'mac-address-mask'                 or local-name() = 'any-multicast-ipv4-address'                 or local-name() = 'all-hosts-multicast-address'                 or local-name() = 'rip-multicast-address'                 or local-name() = 'ntp-multicast-address'                 or local-name() = 'ipv4-prefix'                 or local-name() = 'any-multicast-ipv6-address'                 or local-name() = 'all-nodes-multicast-ipv6-address'                 or local-name() = 'rip-multicast-ipv6-address'                 or local-name() = 'ntp-multicast-ipv6-address'                 or local-name() = 'ipv6-prefix'                 or local-name() = 'ethernet-frame-type'                 or local-name() = 'any-protocol'                 or local-name() = 'protocol'                 ">
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>  
    </xsl:template>
    
    <xsl:template match="*[         namespace-uri() = 'urn:bbf:yang:bbf-frame-processing-profile'         and parent::*[name() = 'push-tag']         and ancestor::*[name() = 'egress-rewrite']         and ancestor::*[name() = 'frame-processing-profiles']     ]">
        <xsl:choose>
            <xsl:when test="                 local-name() = 'write-pbit-0'                 or local-name() = 'pbit-from-tag-index'                 or local-name() = 'write-pbit'             ">
                <xsl:if test="                     not(parent::*[name()='push-tag']/descendant::*[name()='pbit-marking-index'])                 ">
                    <xsl:element name="pbit-marking-index" namespace="urn:bbf:yang:bbf-qos-classifiers">
                        <xsl:value-of select="parent::*[name()='push-tag']/descendant::*[name()='index']"/>
                    </xsl:element>
                </xsl:if>
            </xsl:when>
            <xsl:when test="                 local-name() = 'dei-from-tag-index'                 or local-name() = 'write-dei-1'             ">
                <xsl:if test="                     not(parent::*[name()='push-tag']/descendant::*[name()='write-dei-0'])                     and not(parent::*[name()='push-tag']/descendant::*[name()='dei-marking-index'])                 ">
                    <xsl:element name="dei-marking-index" namespace="urn:bbf:yang:bbf-qos-classifiers">
                        <xsl:value-of select="parent::*[name()='push-tag']/descendant::*[name()='index']"/>
                    </xsl:element>
                </xsl:if>
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
