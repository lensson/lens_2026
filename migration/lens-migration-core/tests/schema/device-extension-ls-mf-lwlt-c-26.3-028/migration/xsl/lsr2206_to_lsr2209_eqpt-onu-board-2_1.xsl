<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:onusNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount" xmlns:hardwareNs="urn:ietf:params:xml:ns:yang:ietf-hardware-mounted" xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted" xmlns:nokia-hwi="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-hardware-identities" version="1.0">

    <xsl:variable name="var_hardwareNs">urn:ietf:params:xml:ns:yang:ietf-hardware-mounted</xsl:variable>
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>
    <!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
   
    <xsl:template match="*[name() = 'namexxutempethernetCsmacd' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-hardware-mounted'     and parent::*[name() = 'hardware'] and ancestor::*[name() = 'root'] and ancestor::*[name() = 'onu']  and ancestor::*[name() = 'onus']      ]"> 
        <xsl:variable name="current" select="child::*[name() = 'namexxutemp1']"/>   
        <xsl:if test="hardwareNs:namexxutemp1[not(.=preceding-sibling::hardwareNs:namexxutemp1)]">
                <xsl:element name="namexxutempethernetCsmacd" namespace="{$var_hardwareNs}">
                    <xsl:value-of select="$current"/>
                 </xsl:element>
        </xsl:if>
    </xsl:template>



    <xsl:template match="*[name() = 'namexxutempvoipvoice' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-hardware-mounted'     and parent::*[name() = 'hardware'] and ancestor::*[name() = 'root'] and ancestor::*[name() = 'onu']  and ancestor::*[name() = 'onus']      ]"> 
        <xsl:variable name="current" select="child::*[name() = 'namexxutemp1']"/>   
        <xsl:if test="hardwareNs:namexxutemp1[not(.=preceding-sibling::hardwareNs:namexxutemp1)]">
                <xsl:element name="namexxutempvoipvoice" namespace="{$var_hardwareNs}">
                    <xsl:value-of select="$current"/>
                 </xsl:element>
        </xsl:if>
    </xsl:template>




    <xsl:template match="*[name() = 'tempethernetCsmacd' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-hardware-mounted'         and parent::*[name() = 'hardware'] and ancestor::*[name() = 'root'] and ancestor::*[name() = 'onu']  and ancestor::*[name() = 'onus']          ]"> 
        <xsl:if test="not (preceding-sibling::hardwareNs:tempethernetCsmacd/text() = current()/text())">
            <xsl:copy>
                <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
        </xsl:if>
    </xsl:template>



    
</xsl:stylesheet>
