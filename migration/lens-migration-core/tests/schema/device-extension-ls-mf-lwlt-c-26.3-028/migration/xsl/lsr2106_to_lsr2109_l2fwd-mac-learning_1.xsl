<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces" xmlns:bbfl2fwdNs="urn:bbf:yang:bbf-l2-forwarding" xmlns:bbfifusgNs="urn:bbf:yang:bbf-interface-usage" version="1.0">                                          
                                                                          
    <xsl:strip-space elements="*"/>                                       
    <xsl:output method="xml" indent="yes"/>                               
    <xsl:param name="targetNS" select="'urn:bbf:yang:bbf-l2-forwarding'"/>
                            
    <!-- default rule -->             
    <xsl:template match="*">          
        <xsl:copy>                    
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>                                               
    </xsl:template>                                               
                                                                  
    <!-- change mac-learning-failure-action forward to discard -->
    <xsl:template match="*[name() = 'mac-learning-failure-action'         and namespace-uri() = 'urn:bbf:yang:bbf-l2-forwarding'         and parent::*[name() = 'mac-learning']                                          ]">                                                                                                
        <xsl:choose>
            <xsl:when test="(../../ifNs:type = 'bbfift:vlan-sub-interface') and                                                                       (../../bbfifusgNs:interface-usage/bbfifusgNs:interface-usage = 'user-port') and                                          ((../bbfl2fwdNs:mac-learning-enable = 'true')                               or (not(boolean(../bbfl2fwdNs:mac-learning-enable))))">
            <xsl:element name="mac-learning-failure-action" namespace="{$targetNS}">discard</xsl:element>
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
