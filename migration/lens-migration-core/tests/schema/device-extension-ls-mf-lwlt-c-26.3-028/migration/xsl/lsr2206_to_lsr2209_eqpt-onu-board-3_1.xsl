<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:hardwareNs="urn:ietf:params:xml:ns:yang:ietf-hardware-mounted"
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
             

          <xsl:variable name="var_uniport_namexxu" select="../../hardwareNs:hardware/hardwareNs:namexxutempethernetCsmacd"/>           
          <!--xsl:element name="name111111" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_uniport_namexxu"/></xsl:element-->
          <xsl:variable name="var_port_parent" select="./child::*[name() = 'class' and text()= 'bbf-hwt:transceiver-link']/../child::*[name() = 'parent' and text()=$var_uniport_namexxu]"/>
          <!--xsl:element name="name22222222" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_port_parent"/></xsl:element-->
          <xsl:variable name="var_port_name" select="./child::*[name() = 'class' and text()= 'bbf-hwt:transceiver-link']/../child::*[name() = 'name']"/>  


                   
          <xsl:choose>
            <xsl:when test="''!=$var_port_parent">
             <xsl:variable name="var_uniport_tempethernetCsmacd_count" select=" count(../../hardwareNs:hardware/hardwareNs:tempethernetCsmacd)"/> 
             <!--xsl:element name="name333333333333" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_uniport_tempethernetCsmacd_count"/></xsl:element-->
                               
            <xsl:variable name="var_port_parent_link_pos" select="./child::*[name() = 'class' and text()= 'bbf-hwt:transceiver-link']/../child::*[name() = 'parent-rel-pos']"/>
            <!--xsl:element name="name222222220000000" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_port_parent_link_pos"/></xsl:element-->
            <xsl:variable name="var_uniport_pos_board" select="../../hardwareNs:hardware/hardwareNs:component/child::*[name() = 'class' and text()= 'bbf-hwt:board']/../child::*[name() ='name' and text()= $var_port_parent]/../child::*[name()='parent-rel-pos']"/>
            <!--xsl:element name="name222222221111111" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_uniport_pos_board"/></xsl:element-->
            <xsl:variable name="var_uniport_pos_board_parent" select="../../hardwareNs:hardware/hardwareNs:component/child::*[name() = 'class' and text()= 'bbf-hwt:board']/../child::*[name() ='name' and text()= $var_port_parent]/../child::*[name()='parent']"/>

             <!--  11 is xgsonu  -->
             <xsl:if test=" $var_uniport_tempethernetCsmacd_count = 1 and $var_uniport_pos_board != 11">  

                   <xsl:element name="component" namespace="{$var_hardwareNs}">
                     <xsl:element name="name" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_port_name"/></xsl:element> 
                     <class xmlns:bbf-hwt="urn:bbf:yang:bbf-hardware-types" xmlns="urn:ietf:params:xml:ns:yang:ietf-hardware-mounted">bbf-hwt:rj45</class>
                    <xsl:element name="parent" namespace="{$var_hardwareNs}"> <xsl:value-of select="$var_uniport_pos_board_parent"/>  </xsl:element>
                    <xsl:element name="parent-rel-pos" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_port_parent_link_pos"/></xsl:element>
                    <xsl:element name="admin-state" namespace="{$var_hardwareNs}">unlocked</xsl:element>
                     <xsl:element name="omci-identifier-helper" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-hardware-extension-mounted">
                          <xsl:element name="virtual-board-number" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-hardware-extension-mounted"><xsl:value-of select="$var_uniport_pos_board"/></xsl:element>
                     </xsl:element>
                  </xsl:element> 

             </xsl:if>

      
            <xsl:if test=" $var_uniport_tempethernetCsmacd_count = 2 ">  

             <xsl:variable name="var_first_uniport_pos_board_num1" select="../../hardwareNs:hardware/hardwareNs:tempethernetCsmacd[1]"/>
             <!--xsl:element name="name44444444444444" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_first_uniport_pos_board_num1"/></xsl:element-->
             <xsl:variable name="var_first_uniport_pos_board_num2" select="../../hardwareNs:hardware/hardwareNs:tempethernetCsmacd[2]"/>
             <!--xsl:element name="name5555555555555" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_first_uniport_pos_board_num2"/></xsl:element-->

             <xsl:choose>
                   <xsl:when test="($var_first_uniport_pos_board_num1 = $var_uniport_pos_board)  and ($var_first_uniport_pos_board_num1 &lt; $var_first_uniport_pos_board_num2)">

                    <xsl:element name="component" namespace="{$var_hardwareNs}">
                          <xsl:element name="name" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_port_name"/></xsl:element> 
                          <class xmlns:nokia-hwi="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-hardware-identities" xmlns="urn:ietf:params:xml:ns:yang:ietf-hardware-mounted">nokia-hwi:rj45-1G</class>
                          <xsl:element name="parent" namespace="{$var_hardwareNs}"> <xsl:value-of select="$var_uniport_pos_board_parent"/>  </xsl:element>
                          <xsl:element name="parent-rel-pos" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_port_parent_link_pos"/></xsl:element>
                          <xsl:element name="admin-state" namespace="{$var_hardwareNs}">unlocked</xsl:element>
                     </xsl:element> 

                    </xsl:when>
                     <xsl:otherwise>
                     
                       <xsl:element name="component" namespace="{$var_hardwareNs}">
                          <xsl:element name="name" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_port_name"/></xsl:element> 
                          <class xmlns:nokia-hwi="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-hardware-identities" xmlns="urn:ietf:params:xml:ns:yang:ietf-hardware-mounted">nokia-hwi:rj45-10G</class>
                          <xsl:element name="parent" namespace="{$var_hardwareNs}"> <xsl:value-of select="$var_uniport_pos_board_parent"/>  </xsl:element>
                          <xsl:element name="parent-rel-pos" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_port_parent_link_pos"/></xsl:element>
                          <xsl:element name="admin-state" namespace="{$var_hardwareNs}">unlocked</xsl:element>
                      </xsl:element>
                      
                   </xsl:otherwise>
             </xsl:choose>

             </xsl:if>
          
            </xsl:when>

            <xsl:otherwise>
            </xsl:otherwise>

        </xsl:choose>


        <xsl:variable name="var_uniport_namexxuvoice" select="../../hardwareNs:hardware/hardwareNs:namexxutempvoipvoice"/>
        <xsl:variable name="var_port_parent_voice" select="./child::*[name() = 'class' and text()= 'bbf-hwt:transceiver-link']/../child::*[name() = 'parent' and text()=$var_uniport_namexxuvoice]"/>

          <xsl:choose>
          <xsl:when test="''!=$var_port_parent_voice">
            
            
            <xsl:variable name="var_voip_port_parent_link_pos" select="./child::*[name() = 'class' and text()= 'bbf-hwt:transceiver-link']/../child::*[name() = 'parent-rel-pos']"/>   
            <!--xsl:element name="name22222222333333" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_voip_port_parent_link_pos"/></xsl:element-->
            <xsl:variable name="var_voip_uniport_pos_board" select="../../hardwareNs:hardware/hardwareNs:component/child::*[name() = 'class' and text()= 'bbf-hwt:board']/../child::*[name() ='name' and text()= $var_port_parent_voice]/../child::*[name()='parent-rel-pos']"/>
            <!--xsl:element name="name22222222444444" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_voip_uniport_pos_board"/></xsl:element-->
            <xsl:variable name="var_voip_uniport_board_parent" select="../../hardwareNs:hardware/hardwareNs:component/child::*[name() = 'class' and text()= 'bbf-hwt:board']/../child::*[name() ='name' and text()= $var_port_parent_voice]/../child::*[name()='parent']"/>
          
                 <xsl:element name="component" namespace="{$var_hardwareNs}">
                    <xsl:element name="name" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_port_name"/></xsl:element> 
                    <class xmlns:nokia-hwi="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-hardware-identities" xmlns="urn:ietf:params:xml:ns:yang:ietf-hardware-mounted">nokia-hwi:rj11</class>
                    <xsl:element name="parent" namespace="{$var_hardwareNs}"> <xsl:value-of select="$var_voip_uniport_board_parent"/>  </xsl:element>
                    <xsl:element name="parent-rel-pos" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_voip_port_parent_link_pos"/></xsl:element>
                    <xsl:element name="admin-state" namespace="{$var_hardwareNs}">unlocked</xsl:element>
                     <xsl:element name="omci-identifier-helper" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-hardware-extension-mounted">
                        <xsl:element name="virtual-board-number" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-hardware-extension-mounted"><xsl:value-of select="$var_voip_uniport_pos_board"/></xsl:element>
                     </xsl:element>
                </xsl:element>
                     
            </xsl:when>

            <xsl:otherwise>
            </xsl:otherwise>

        </xsl:choose>


     
     <xsl:copy-of select="."/>
     <!-- xsl:copy>
       <xsl:apply-templates select="@* | node()"/>
    </xsl:copy-->

    </xsl:template>


</xsl:stylesheet>
