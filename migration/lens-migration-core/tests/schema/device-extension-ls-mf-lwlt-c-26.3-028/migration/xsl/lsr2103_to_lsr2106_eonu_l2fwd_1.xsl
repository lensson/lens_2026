<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:onusNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount" xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted" xmlns:bbfiftNs="urn:bbf:yang:bbf-if-type-mounted" version="1.0">

    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

    <!-- default rule -->
    <xsl:template match="*">
	<xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
   
    <!-- change vsi enabled false to true -->
    <xsl:template match="*[contains(name(),'enabled')   and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted'         and parent::*[contains(name(),'interface')]  and ancestor::*[contains(name(),'onu')]      ]">
        <xsl:choose>
            <xsl:when test="../ifNs:type = 'bbfift-mounted:vlan-sub-interface'">
	        <xsl:element name="{name()}" namespace="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted">true</xsl:element>	
	    </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>    
    </xsl:template>
 
   <!--delete 'ethernet-frame-type' and 'any-protocol' and 'any-frame'-->
    <xsl:template match="*[contains(name(),'ethernet-frame-type')        and namespace-uri() = 'urn:bbf:yang:bbf-sub-interface-tagging-mounted'        and ancestor::*[contains(name(),'interface')]        and ancestor::*[contains(name(),'onu')]      ]">
    </xsl:template>

    <xsl:template match="*[contains(name(),'any-protocol')        and namespace-uri() = 'urn:bbf:yang:bbf-sub-interface-tagging-mounted'        and ancestor::*[contains(name(),'interface')]        and ancestor::*[contains(name(),'onu')]      ]">
    </xsl:template>

    <xsl:template match="*[contains(name(),'any-frame')        and namespace-uri() = 'urn:bbf:yang:bbf-sub-interface-tagging-mounted'        and ancestor::*[contains(name(),'interface')]        and ancestor::*[contains(name(),'onu')]      ]">
    </xsl:template>

</xsl:stylesheet>
