<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:onusNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount"
    xmlns:hardwareNs="urn:ietf:params:xml:ns:yang:ietf-hardware-mounted"
    xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted" 
    xmlns:nokia-hwi="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-hardware-identities" 
>

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
    

    <xsl:template match="*[name() = 'component' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-hardware-mounted'
    and parent::*[name() = 'hardware'] and ancestor::*[name() = 'root'] and ancestor::*[name() = 'onu'] and    ancestor::*[name() = 'onus'] 
    and child::*[name() = 'class' and text()= 'bbf-hwt:transceiver-link']
    ]">              
 
        <xsl:variable name="var_uniport_namexxu_eth" select="../../hardwareNs:hardware/hardwareNs:namexxutempethernetCsmacd"/> 
        <xsl:variable name="var_uniport_parent" select="child::*[name() = 'parent' and text()=$var_uniport_namexxu_eth]"/>
        <xsl:variable name="var_uniport_tempethernetCsmacd_value_a" select="../../hardwareNs:hardware/hardwareNs:tempethernetCsmacd"/> 
        <xsl:variable name="var_uniport_tempethernetCsmacd_count_a" select=" count(../../hardwareNs:hardware/hardwareNs:tempethernetCsmacd)"/> 

        <xsl:choose>
           <xsl:when test="''!=$var_uniport_parent and $var_uniport_tempethernetCsmacd_value_a !=11 and $var_uniport_tempethernetCsmacd_count_a &lt; 3">
          </xsl:when>
          <xsl:otherwise>
          
           <!-- xsl:copy>
             <xsl:apply-templates select="@* | node()"/>
           </xsl:copy -->
           <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose> 
    
    </xsl:template>

    <xsl:template match="*[name() = 'component' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-hardware-mounted'
    and parent::*[name() = 'hardware'] and ancestor::*[name() = 'root'] and ancestor::*[name() = 'onu'] and ancestor::*[name() = 'onus']
    and child::*[name() = 'class' and text()= 'bbf-hwt:board']    
    ]">
    
        <xsl:variable name="var_uniport_namexxu" select="../../hardwareNs:hardware/hardwareNs:namexxutempethernetCsmacd"/> 
        <!--xsl:element name="name22222222000000" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_uniport_namexxu"/></xsl:element-->
       
        <xsl:variable name="var_uniport_name" select="child::*[name() = 'name' and  text()= $var_uniport_namexxu]"/>
         <!--xsl:element name="name22222222-1111111" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_uniport_name"/></xsl:element-->

        <xsl:variable name="var_uniport_tempethernetCsmacd_value" select="../../hardwareNs:hardware/hardwareNs:tempethernetCsmacd"/> 
        <xsl:variable name="var_uniport_tempethernetCsmacd_count" select=" count(../../hardwareNs:hardware/hardwareNs:tempethernetCsmacd)"/> 


        <xsl:choose>
           <xsl:when test="''!=$var_uniport_name and $var_uniport_tempethernetCsmacd_value !=11 and $var_uniport_tempethernetCsmacd_count &lt; 3">
          </xsl:when>
          <xsl:otherwise>
                             <!-- xsl:copy>
                             <xsl:apply-templates select="@* | node()"/>
                            </xsl:copy -->
                            <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
