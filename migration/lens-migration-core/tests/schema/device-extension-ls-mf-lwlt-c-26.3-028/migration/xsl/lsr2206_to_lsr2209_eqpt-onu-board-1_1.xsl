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
    and parent::*[name() = 'hardware'] and ancestor::*[name() = 'root'] and ancestor::*[name() = 'onu'] 
    and child::*[name() = 'class' and text()= 'bbf-hwt:transceiver-link']
    ]">

          <xsl:variable name="var_uni_port_name" select="./child::*[name() = 'class' and text()= 'bbf-hwt:transceiver-link']/../child::*[name() = 'name']"/>

          <xsl:variable name="var_port_parent" select="./child::*[name() = 'class' and text()= 'bbf-hwt:transceiver-link']/../child::*[name() = 'parent']"/>
          <!--xsl:element name="name22222222" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_port_parent"/></xsl:element-->
          <xsl:variable name="var_board_number" select="../../hardwareNs:hardware/hardwareNs:component/child::*[name() = 'class' and text()= 'bbf-hwt:board']/../child::*[name() ='name' and text()= $var_port_parent]/../child::*[name()='parent-rel-pos']"/>
          <xsl:variable name="var_uniport_name" select="../../hardwareNs:hardware/hardwareNs:component/child::*[name() = 'class' and text()= 'bbf-hwt:board']/../child::*[name() ='name' and text()= $var_port_parent]"/>

          <xsl:variable name="var_uniport_ethernetCsmacd" select="../../ifNs:interfaces/ifNs:interface/child::*[name() = 'type' and text()= 'ianaift-mounted:ethernetCsmacd']/../child::*[name() = 'bbf-if-port-ref-mounted:port-layer-if' or name()='port-layer-if']"/>
          
          <xsl:variable name="var_uniport_voip_voice" select="../../ifNs:interfaces/ifNs:interface/child::*[name() = 'type' and text()= 'ianaift-mounted:voiceFXS']/../child::*[name() = 'bbf-if-port-ref-mounted:port-layer-if'  or name() = 'port-layer-if']"/>
          <xsl:variable name="var_uniport_phys_voip_voice" select="../../ifNs:interfaces/ifNs:interface/child::*[name() = 'type' and text()= 'ianaift-mounted:voiceFXS']/../child::*[name() = 'phys-voice-itf']/child::*[name() = 'bbf-if-port-ref-mounted:port-layer-if'  or name() = 'port-layer-if']"/>
           <!--xsl:element name="name22222222" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_port_parent"/></xsl:element-->
          
          <xsl:variable name="var_uniport_ethernetCsmacd_parent" select="./child::*[name() = 'name' and text()= $var_uniport_ethernetCsmacd]/../child::*[name() = 'parent']"/>
          
          <xsl:variable name="var_uniport_voip_voice_parent" select="./child::*[name() = 'name' and text()= $var_uniport_voip_voice]/../child::*[name() = 'parent']"/>    
          <xsl:variable name="var_uniport_voip_voice_parent_phys" select="./child::*[name() = 'name' and text()= $var_uniport_phys_voip_voice]/../child::*[name() = 'parent']"/> 
          <!--xsl:element name="name22222222" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_port_parent"/></xsl:element-->
    
        <xsl:choose>
            <xsl:when test=" $var_uniport_name and string($var_port_parent)=string($var_uniport_ethernetCsmacd_parent)">
            <xsl:element name="namexxutempethernetCsmacd" namespace="{$var_hardwareNs}">
                  <xsl:element name="namexxutemp1" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_port_parent"/></xsl:element>
            </xsl:element>

            <xsl:element name="tempethernetCsmacd"  namespace="{$var_hardwareNs}"><xsl:value-of select="$var_board_number"/></xsl:element>
            </xsl:when>

                       <xsl:otherwise>
                       </xsl:otherwise>

        </xsl:choose>


         <xsl:choose>
          <xsl:when test="''!=string($var_uniport_phys_voip_voice)">

             <xsl:if test=" $var_uniport_name and string($var_port_parent)=string($var_uniport_voip_voice_parent_phys)">  
                    <xsl:element name="namexxutempvoipvoice" namespace="{$var_hardwareNs}">
                          <xsl:element name="namexxutemp1" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_port_parent"/></xsl:element>
                    </xsl:element>
             </xsl:if>

          </xsl:when>
          <xsl:otherwise>
          
                    <xsl:if test=" $var_uniport_name and string($var_port_parent)=string($var_uniport_voip_voice_parent)">
                        <xsl:element name="namexxutempvoipvoice" namespace="{$var_hardwareNs}">
                           <xsl:element name="namexxutemp1" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_port_parent"/></xsl:element>
                        </xsl:element>
                   </xsl:if>

          </xsl:otherwise>
        </xsl:choose>

            
     <xsl:copy-of select="."/>

    </xsl:template>
</xsl:stylesheet>
