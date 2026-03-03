<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cfgNs="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:onusNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount" xmlns:hardwareNs="urn:ietf:params:xml:ns:yang:ietf-hardware-mounted" xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted" xmlns:harewareExtNs="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-hardware-extension-mounted" xmlns:ethNs="urn:ieee:params:xml:ns:yang:ethernet-mounted" xmlns:itfRefNs="urn:bbf:yang:bbf-interface-port-reference-mounted" version="1.0" exclude-result-prefixes="cfgNs onusNs hardwareNs ifNs harewareExtNs ethNs">


    <xsl:variable name="var_hardwareNs">urn:ietf:params:xml:ns:yang:ietf-hardware-mounted</xsl:variable>
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

     <!--  remove speed for FNMS-154327 StarHub issue  -->
    <xsl:template match="//onusNs:onus/onusNs:onu/onusNs:root/ifNs:interfaces/ifNs:interface[ifNs:type='ianaift-mounted:ethernetCsmacd']/ethNs:ethernet/ethNs:auto-negotiation/ethNs:speed">
    <xsl:variable name="var_itf_port" select="../../../child::*[name()='bbf-if-port-ref-mounted:port-layer-if' or name()='port-layer-if']"/> 
	<!--xsl:element name="name111111" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_itf_port"/></xsl:element-->
	<xsl:variable name="var_port_name" select="../../../../../hardwareNs:hardware/hardwareNs:component/child::*[name() = 'class' and text()= 'bbf-hwt:transceiver-link']/../child::*[name() ='name' and text()= $var_itf_port]"/>
        <!--xsl:element name="name222222" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_itf_port"/></xsl:element-->	
	<xsl:choose>
	<xsl:when test=" $var_port_name and string($var_port_name)=string($var_itf_port)">
	  <xsl:variable name="var_board_id" select="../../../../../hardwareNs:hardware/hardwareNs:component/child::*[name() = 'class' and text()= 'bbf-hwt:board']/../child::*[name()='parent-rel-pos']"/>
	  <xsl:variable name="var_board_count" select=" count(../../../../../hardwareNs:hardware/hardwareNs:component[hardwareNs:class = 'bbf-hwt:board'])"/>
          <xsl:if test=" $var_board_count = 1 and $var_board_id = 11">
	      <xsl:copy-of select="."/>
	  </xsl:if>
	 </xsl:when>
	     <xsl:otherwise>
	         <xsl:copy-of select="."/>
	     </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="//onusNs:onus/onusNs:onu/onusNs:root/hardwareNs:hardware/hardwareNs:component[hardwareNs:class = 'bbf-hwt:transceiver-link']">
          <xsl:variable name="var_uniport_name" select="./child::*[name() = 'class' and text()= 'bbf-hwt:transceiver-link']/../child::*[name() = 'name']"/>
          <xsl:variable name="var_port_parent" select="./child::*[name() = 'class' and text()= 'bbf-hwt:transceiver-link']/../child::*[name() = 'parent']"/>
          <xsl:variable name="var_board_number" select="../../hardwareNs:hardware/hardwareNs:component/child::*[name() = 'class' and text()= 'bbf-hwt:board']/../child::*[name() ='name' and text()= $var_port_parent]/../child::*[name()='parent-rel-pos']"/>
          <xsl:variable name="var_board_name" select="../../hardwareNs:hardware/hardwareNs:component/child::*[name() = 'class' and text()= 'bbf-hwt:board']/../child::*[name() ='name' and text()= $var_port_parent]"/>
          <xsl:variable name="var_itf_ethernetCsmacd" select="../../ifNs:interfaces/ifNs:interface/child::*[name() = 'type' and text()= 'ianaift-mounted:ethernetCsmacd']/../child::*[name() = 'bbf-if-port-ref-mounted:port-layer-if' or name()='port-layer-if']"/>
          <xsl:variable name="var_itf_ethernetCsmacd_parent" select="./child::*[name() = 'name' and text()= $var_itf_ethernetCsmacd]/../child::*[name() = 'parent']"/>
          <xsl:choose>
           <xsl:when test=" $var_uniport_name and string($var_port_parent)=string($var_itf_ethernetCsmacd_parent)">
             <xsl:variable name="var_uniport_count" select=" count(../../hardwareNs:hardware/hardwareNs:component[hardwareNs:class = 'bbf-hwt:board'])"/> 
             <xsl:variable name="var_uniport_pos_board" select="../../hardwareNs:hardware/hardwareNs:component/child::*[name() = 'class' and text()= 'bbf-hwt:board']/../child::*[name() ='name' and text()= $var_port_parent]/../child::*[name()='parent-rel-pos']"/>
             <xsl:variable name="var_port_parent_link_pos" select="./child::*[name() = 'class' and text()= 'bbf-hwt:transceiver-link']/../child::*[name() = 'parent-rel-pos']"/>
             <xsl:variable name="var_uniport_pos_board_parent" select="../../hardwareNs:hardware/hardwareNs:component/child::*[name() = 'class' and text()= 'bbf-hwt:board']/../child::*[name() ='name' and text()= $var_port_parent]/../child::*[name()='parent']"/>
	     <!--  11 is 25G ONU  -->
	     <xsl:if test=" $var_uniport_count = 1 and $var_uniport_pos_board = 11">
                    <xsl:element name="component" namespace="{$var_hardwareNs}">
		    <xsl:choose>
		       <xsl:when test="starts-with($var_uniport_name,'UNI_')">
                         <xsl:variable name="uni_port_name" select="substring($var_uniport_name, 5)"/>
			 <xsl:variable name="uni_cage_name" select="concat('CAGE_',$uni_port_name)"/>
		         <xsl:element name="name" namespace="{$var_hardwareNs}"><xsl:value-of select="$uni_cage_name"/></xsl:element>
		       </xsl:when>
		       <xsl:otherwise>
		         <xsl:variable name="uni_cage_name" select="concat('CAGE_',$var_uniport_name)"/>
		         <xsl:element name="name" namespace="{$var_hardwareNs}"><xsl:value-of select="$uni_cage_name"/></xsl:element>
		       </xsl:otherwise>
	            </xsl:choose>

		    <class xmlns:nokia-hwi="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-hardware-identities" xmlns="urn:ietf:params:xml:ns:yang:ietf-hardware-mounted">nokia-hwi:cage-uni</class>
                    <xsl:element name="parent" namespace="{$var_hardwareNs}"> <xsl:value-of select="$var_uniport_pos_board_parent"/>  </xsl:element>
                    <xsl:element name="parent-rel-pos" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_port_parent_link_pos"/></xsl:element>
                    </xsl:element>


		    <xsl:element name="component" namespace="{$var_hardwareNs}">
		    <xsl:choose>
		          <xsl:when test="starts-with($var_uniport_name,'UNI_')">
		            <xsl:variable name="uni_port_name" select="substring($var_uniport_name, 5)"/>
			    <xsl:variable name="uni_cage_name" select="concat('CAGE_',$uni_port_name)"/>
			    <xsl:variable name="uni_transceiver_name" select="concat('SFP_',$uni_port_name)"/>
			    <xsl:element name="name" namespace="{$var_hardwareNs}"><xsl:value-of select="$uni_transceiver_name"/></xsl:element>
			    <xsl:element name="parent" namespace="{$var_hardwareNs}"><xsl:value-of select="$uni_cage_name"/></xsl:element>
			  </xsl:when>
		          <xsl:otherwise>
		              <xsl:variable name="uni_cage_name" select="concat('CAGE_',$var_uniport_name)"/>
			      <xsl:variable name="uni_transceiver_name" select="concat('SFP_',$var_uniport_name)"/>
			      <xsl:element name="name" namespace="{$var_hardwareNs}"><xsl:value-of select="$uni_transceiver_name"/></xsl:element>
			      <xsl:element name="parent" namespace="{$var_hardwareNs}"><xsl:value-of select="$uni_cage_name"/></xsl:element>
			  </xsl:otherwise>
	            </xsl:choose>
                    <class xmlns:bbf-hwt="urn:bbf:yang:bbf-hardware-types" xmlns="urn:ietf:params:xml:ns:yang:ietf-hardware-mounted">bbf-hwt:transceiver</class>
                    <xsl:element name="parent-rel-pos" namespace="{$var_hardwareNs}">0</xsl:element>
                    </xsl:element>

              </xsl:if>
           </xsl:when>
        </xsl:choose>
        <xsl:copy>
          <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
        </xsl:copy>
      </xsl:template>

      <xsl:template match="//hardwareNs:component[hardwareNs:class = 'bbf-hwt:transceiver-link']/hardwareNs:parent">
            <xsl:variable name="var_uniport_name" select="../child::*[name() = 'class' and text()= 'bbf-hwt:transceiver-link']/../child::*[name() = 'name']"/>
            <xsl:variable name="var_port_parent" select="text()"/>
            <!--xsl:element name="name111111" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_uniport_name"/></xsl:element-->

            <xsl:variable name="var_itf_veip" select="../../../ifNs:interfaces/ifNs:interface/child::*[name() = 'type' and text()= 'bbf-xponift-mounted:onu-v-vrefpoint']/../child::*[name() = 'bbf-if-port-ref-mounted:port-layer-if'  or name() = 'port-layer-if']"/>
            <xsl:variable name="var_itf_veip_name" select="../child::*[name() = 'name' and text()= $var_itf_veip]/../child::*[name() = 'name']"/>


            <xsl:variable name="var_itf_voip" select="../../../ifNs:interfaces/ifNs:interface/child::*[name() = 'type' and text()= 'ianaift-mounted:voiceFXS']/../child::*[name() = 'bbf-if-port-ref-mounted:port-layer-if'  or name() = 'port-layer-if']"/>
            <xsl:variable name="var_itf_voip_name" select="../child::*[name() = 'name' and text()= $var_itf_voip]/../child::*[name() = 'name']"/>

	    <xsl:variable name="var_itf_voip_voice" select="../../../ifNs:interfaces/ifNs:interface/child::*[name() = 'type' and text()= 'ianaift-mounted:voiceFXS']/../child::*[name() = 'phys-voice-itf']/child::*[name() = 'bbf-if-port-ref-mounted:port-layer-if'  or name() = 'port-layer-if']"/>

           <xsl:variable name="var_itf_voip_voice_name" select="../child::*[name() = 'name' and text()= $var_itf_voip_voice]/../child::*[name() = 'name']"/>

            <!--xsl:element name="name22222" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_itf_voip"/></xsl:element-->
            
            <xsl:variable name="var_itf_eth" select="../../../ifNs:interfaces/ifNs:interface/child::*[name() = 'type' and text()= 'ianaift-mounted:ethernetCsmacd']/../child::*[name() = 'bbf-if-port-ref-mounted:port-layer-if'  or name() = 'port-layer-if']"/>
            <xsl:variable name="var_itf_eth_name" select="../child::*[name() = 'name' and text()= $var_itf_eth]/../child::*[name() = 'name']"/>
            <xsl:variable name="var_board_parent" select="../../../hardwareNs:hardware/hardwareNs:component/child::*[name() = 'class' and text()= 'bbf-hwt:board']/../child::*[name() ='name' and text()= $var_port_parent]/../child::*[name()='parent']"/>
          <xsl:choose>
	  <xsl:when test="string($var_uniport_name)=string($var_itf_veip_name)">
               <xsl:element name="parent" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_board_parent"/></xsl:element>
             </xsl:when>
         
             <xsl:when test="string($var_uniport_name)=string($var_itf_voip_name) or string($var_uniport_name)=string($var_itf_voip_voice_name)">
               <xsl:element name="parent" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_board_parent"/></xsl:element>
             </xsl:when>
         
             <xsl:when test="string($var_uniport_name)=string($var_itf_eth_name)">
              <xsl:variable name="var_board_count" select=" count(../../../hardwareNs:hardware/hardwareNs:component[hardwareNs:class = 'bbf-hwt:board'])"/>
	      <xsl:variable name="var_veip_count" select=" count(../../../ifNs:interfaces/ifNs:interface[ifNs:type='bbf-xponift-mounted:onu-v-vrefpoint'])"/>
	      <xsl:variable name="var_voip_count" select=" count(../../../ifNs:interfaces/ifNs:interface[ifNs:type='ianaift-mounted:voiceFXS'])"/>
	      <xsl:variable name="var_rj11_count" select=" count(../../../hardwareNs:hardware/hardwareNs:component[hardwareNs:class = 'nokia-hwi:rj11'])"/>
	      <xsl:variable name="voip_board_count">
	        <xsl:choose>
	          <xsl:when test="($var_voip_count = $var_rj11_count)">
		       <xsl:value-of select="0"/>
	          </xsl:when>
		  <xsl:when test="$var_rj11_count >= 1 and $var_voip_count = 0">
		       <xsl:value-of select="0"/>     
		  </xsl:when>
		  <xsl:when test="$var_rj11_count = 0 and $var_voip_count >= 1">
		       <xsl:value-of select="1"/>     
		  </xsl:when>
                  <xsl:otherwise>
		       <xsl:value-of select="0"/>
		  </xsl:otherwise>
	        </xsl:choose>
	       </xsl:variable>
	       <xsl:variable name="veip_board_count">
	          <xsl:choose>
		    <xsl:when test= "($var_veip_count >= 1)">
	               <xsl:value-of select="1"/>
	            </xsl:when>
                    <xsl:otherwise>
		       <xsl:value-of select="0"/>
		    </xsl:otherwise>
		  </xsl:choose>
	       </xsl:variable>
	       <xsl:variable name="eth_board_count" select="$var_board_count - $veip_board_count - $voip_board_count"/>
              <xsl:variable name="var_uniport_pos_board" select="../../../hardwareNs:hardware/hardwareNs:component/child::*[name() = 'class' and text()= 'bbf-hwt:board']/../child::*[name() ='name' and text()= $var_port_parent]/../child::*[name()='parent-rel-pos']"/>
	      <xsl:if test=" $eth_board_count = 1 and $var_uniport_pos_board = 11">
                <xsl:choose>
		   <xsl:when test="starts-with($var_uniport_name,'UNI_')">
		       <xsl:variable name="uni_port_name" select="substring($var_uniport_name, 5)"/>
		       <xsl:variable name="uni_transceiver_name" select="concat('SFP_',$uni_port_name)"/>
		       <xsl:element name="parent" namespace="{$var_hardwareNs}"><xsl:value-of select="$uni_transceiver_name"/></xsl:element>    
		   </xsl:when>
		   <xsl:otherwise>
		       <xsl:variable name="uni_transceiver_name" select="concat('SFP_',$var_uniport_name)"/>
		       <xsl:element name="parent" namespace="{$var_hardwareNs}"><xsl:value-of select="$uni_transceiver_name"/></xsl:element>    
		   </xsl:otherwise>
    	      </xsl:choose>
              </xsl:if>
	      <xsl:if test="($eth_board_count &gt; 1) or ($eth_board_count = 1 and $var_uniport_pos_board != 11)">
                <xsl:element name="parent" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_board_parent"/></xsl:element>
              </xsl:if>
             </xsl:when>
            <xsl:otherwise>
              <xsl:copy-of select="."/>
            </xsl:otherwise>
         </xsl:choose>
     </xsl:template>

       
     <xsl:template match="//onusNs:onus/onusNs:onu/onusNs:root/hardwareNs:hardware/hardwareNs:component/hardwareNs:class[text() = 'bbf-hwt:transceiver-link']">   
            <xsl:variable name="var_uniport_name" select="../child::*[name() = 'class' and text()= 'bbf-hwt:transceiver-link']/../child::*[name() = 'name']"/>
        
            <xsl:variable name="var_itf_veip" select="../../../ifNs:interfaces/ifNs:interface/child::*[name() = 'type' and text()= 'bbf-xponift-mounted:onu-v-vrefpoint']/../child::*[name() = 'bbf-if-port-ref-mounted:port-layer-if'  or name() = 'port-layer-if']"/>
            <xsl:variable name="var_itf_veip_name" select="../child::*[name() = 'name' and text()= $var_itf_veip]/../child::*[name() = 'name']"/>                  
           
            <xsl:variable name="var_itf_voip" select="../../../ifNs:interfaces/ifNs:interface/child::*[name() = 'type' and text()= 'ianaift-mounted:voiceFXS']/../child::*[name() = 'bbf-if-port-ref-mounted:port-layer-if'  or name() = 'port-layer-if']"/>
	    <xsl:variable name="var_itf_voip_voice" select="../../../ifNs:interfaces/ifNs:interface/child::*[name() = 'type' and text()= 'ianaift-mounted:voiceFXS']/../child::*[name() = 'phys-voice-itf']/child::*[name() = 'bbf-if-port-ref-mounted:port-layer-if'  or name() = 'port-layer-if']"/>

	    <xsl:variable name="var_itf_voip_name" select="../child::*[name() = 'name' and text()= $var_itf_voip]/../child::*[name() = 'name']"/>
            <xsl:variable name="var_itf_voip_voice_name" select="../child::*[name() = 'name' and text()= $var_itf_voip_voice]/../child::*[name() = 'name']"/>
	    

            <xsl:variable name="var_itf_ethernetCsmacd" select="../../../ifNs:interfaces/ifNs:interface/child::*[name() = 'type' and text()= 'ianaift-mounted:ethernetCsmacd']/../child::*[name() = 'bbf-if-port-ref-mounted:port-layer-if' or name()='port-layer-if']"/>
            <xsl:variable name="var_itf_eth_name" select="../child::*[name() = 'name' and text()= $var_itf_ethernetCsmacd]/../child::*[name() = 'name']"/> 
           
            <xsl:variable name="var_port_parent" select="../child::*[name() = 'parent']"/>
           
      <xsl:choose>
           <xsl:when test="string($var_uniport_name)=string($var_itf_veip_name)">
             <!--xsl:element name="name33333" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_itf_veip_name"/></xsl:element-->
             <class xmlns:nokia-hwi="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-hardware-identities" xmlns="urn:ietf:params:xml:ns:yang:ietf-hardware-mounted">nokia-hwi:virtual-port</class>
           </xsl:when>

           <xsl:when test="string($var_uniport_name)=string($var_itf_voip_name) or string($var_uniport_name)=string($var_itf_voip_voice_name)">
             <!--xsl:element name="name33333" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_itf_veip_name"/></xsl:element-->
             <class xmlns:nokia-hwi="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-hardware-identities" xmlns="urn:ietf:params:xml:ns:yang:ietf-hardware-mounted">nokia-hwi:rj11</class>
           </xsl:when>

           <xsl:when test="string($var_uniport_name)=string($var_itf_eth_name)">
              <xsl:variable name="var_board_count" select=" count(../../../hardwareNs:hardware/hardwareNs:component[hardwareNs:class = 'bbf-hwt:board'])"/>
	      <xsl:variable name="var_veip_count" select=" count(../../../ifNs:interfaces/ifNs:interface[ifNs:type='bbf-xponift-mounted:onu-v-vrefpoint'])"/>
	      <xsl:variable name="var_voip_count" select=" count(../../../ifNs:interfaces/ifNs:interface[ifNs:type='ianaift-mounted:voiceFXS'])"/>
	      <xsl:variable name="var_rj11_count" select=" count(../../../hardwareNs:hardware/hardwareNs:component[hardwareNs:class = 'nokia-hwi:rj11'])"/>
	      <xsl:variable name="voip_board_count">
	        <xsl:choose>
	          <xsl:when test="($var_voip_count = $var_rj11_count)">
		       <xsl:value-of select="0"/>
	          </xsl:when>
		  <xsl:when test="$var_rj11_count >= 1 and $var_voip_count = 0">
		       <xsl:value-of select="0"/>     
		  </xsl:when>
		  <xsl:when test="$var_rj11_count = 0 and $var_voip_count >= 1">
		       <xsl:value-of select="1"/>     
		  </xsl:when>
                  <xsl:otherwise>
		       <xsl:value-of select="0"/>
		  </xsl:otherwise>
	        </xsl:choose>
	       </xsl:variable>
	       <xsl:variable name="veip_board_count">
	          <xsl:choose>
		    <xsl:when test= "($var_veip_count >= 1)">
	               <xsl:value-of select="1"/>
	            </xsl:when>
                    <xsl:otherwise>
		       <xsl:value-of select="0"/>
		    </xsl:otherwise>
		  </xsl:choose>
	       </xsl:variable>
	      <xsl:variable name="eth_board_count" select="$var_board_count - $veip_board_count - $voip_board_count"/>
              <xsl:variable name="var_uniport_pos_board" select="../../../hardwareNs:hardware/hardwareNs:component/child::*[name() = 'class' and text()= 'bbf-hwt:board']/../child::*[name() ='name' and text()= $var_port_parent]/../child::*[name()='parent-rel-pos']"/>
              <xsl:variable name="var_port_id" select="../child::*[name() = 'parent-rel-pos']"/>
              <xsl:variable name="var_uni_pos_board" select="../../../hardwareNs:hardware/hardwareNs:component/child::*[name() = 'class' and text()= 'bbf-hwt:board']/../child::*[name() ='name' and text()= $var_port_parent]/../child::*[name()='parent-rel-pos']"/>
	      <xsl:if test=" $eth_board_count = 1 and $var_uniport_pos_board != 11">
	      <class xmlns:bbf-hwt="urn:bbf:yang:bbf-hardware-types" xmlns="urn:ietf:params:xml:ns:yang:ietf-hardware-mounted">bbf-hwt:rj45</class>
	      <xsl:element name="omci-identifier-helper" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-hardware-extension-mounted">
	        <xsl:element name="virtual-board-number" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-hardware-extension-mounted"><xsl:value-of select="$var_uni_pos_board"/></xsl:element>
	      </xsl:element>
	      </xsl:if>
	      <xsl:if test=" $eth_board_count &gt; 1 ">
                    <class xmlns:bbf-hwt="urn:bbf:yang:bbf-hardware-types" xmlns="urn:ietf:params:xml:ns:yang:ietf-hardware-mounted">bbf-hwt:rj45</class>
                    <xsl:element name="omci-identifier-helper" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-hardware-extension-mounted">
                    <xsl:element name="virtual-board-number" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-hardware-extension-mounted"><xsl:value-of select="$var_uni_pos_board"/></xsl:element>
                    <xsl:element name="port-id" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-hardware-extension-mounted"><xsl:value-of select="$var_port_id"/></xsl:element>
                    </xsl:element>
              </xsl:if>
              
              <xsl:if test=" $eth_board_count = 1 and $var_uniport_pos_board = 11">
                    <xsl:copy-of select="."/>              
              </xsl:if>
           </xsl:when>
            
          <xsl:otherwise>           
             <xsl:copy-of select="."/>        
          </xsl:otherwise>

     </xsl:choose>          
    </xsl:template>

  
   
  <xsl:template match="//hardwareNs:component[hardwareNs:class = 'bbf-hwt:transceiver-link']/hardwareNs:parent-rel-pos">
       <xsl:variable name="var_uniport_name" select="../child::*[name() = 'class' and text()= 'bbf-hwt:transceiver-link']/../child::*[name() = 'name']"/>
       <xsl:variable name="var_itf_eth" select="../../../ifNs:interfaces/ifNs:interface/child::*[name() = 'type' and text()= 'ianaift-mounted:ethernetCsmacd']/../child::*[name() = 'bbf-if-port-ref-mounted:port-layer-if'  or name() = 'port-layer-if']"/>
       <xsl:variable name="var_itf_eth_name" select="../child::*[name() = 'name' and text()= $var_itf_eth]/../child::*[name() = 'name']"/>
       <xsl:choose>
         <xsl:when test="string($var_uniport_name)=string($var_itf_eth_name)">
              <xsl:variable name="var_board_count" select=" count(../../../hardwareNs:hardware/hardwareNs:component[hardwareNs:class = 'bbf-hwt:board'])"/>
	      <xsl:variable name="var_veip_count" select=" count(../../../ifNs:interfaces/ifNs:interface[ifNs:type='bbf-xponift-mounted:onu-v-vrefpoint'])"/>
	      <xsl:variable name="var_voip_count" select=" count(../../../ifNs:interfaces/ifNs:interface[ifNs:type='ianaift-mounted:voiceFXS'])"/>
	      <xsl:variable name="var_rj11_count" select=" count(../../../hardwareNs:hardware/hardwareNs:component[hardwareNs:class = 'nokia-hwi:rj11'])"/>
	      <xsl:variable name="voip_board_count">
	        <xsl:choose>
	          <xsl:when test="($var_voip_count = $var_rj11_count)">
		       <xsl:value-of select="0"/>
	          </xsl:when>
		  <xsl:when test="$var_rj11_count >= 1 and $var_voip_count = 0">
		       <xsl:value-of select="0"/>     
		  </xsl:when>
		  <xsl:when test="$var_rj11_count = 0 and $var_voip_count >= 1">
		       <xsl:value-of select="1"/>     
		  </xsl:when>
                  <xsl:otherwise>
		       <xsl:value-of select="0"/>
		  </xsl:otherwise>
	        </xsl:choose>
	       </xsl:variable>
	       <xsl:variable name="veip_board_count">
	          <xsl:choose>
		    <xsl:when test= "($var_veip_count >= 1)">
	               <xsl:value-of select="1"/>
	            </xsl:when>
                    <xsl:otherwise>
		       <xsl:value-of select="0"/>
		    </xsl:otherwise>
		  </xsl:choose>
	       </xsl:variable>
	   <xsl:variable name="eth_board_count" select="$var_board_count - $veip_board_count - $voip_board_count"/>
	   <xsl:if test=" $eth_board_count &gt; 1 ">   
           </xsl:if>
           <xsl:variable name="var_port_parent" select="../child::*[name() = 'parent']"/>
           
           <xsl:variable name="var_uniport_pos_board" select="../../../hardwareNs:hardware/hardwareNs:component/child::*[name() = 'class' and text()= 'bbf-hwt:board']/../child::*[name() ='name' and text()= $var_port_parent]/../child::*[name()='parent-rel-pos']"/>
           <xsl:if test=" $eth_board_count = 1 and $var_uniport_pos_board = 11">
               <xsl:element name="parent-rel-pos" namespace="{$var_hardwareNs}">1</xsl:element>
	   </xsl:if>
           <xsl:if test=" $eth_board_count = 1 and $var_uniport_pos_board != 11">
	       <xsl:copy-of select="."/>
           </xsl:if>
         </xsl:when>
           <xsl:otherwise>
              <xsl:copy-of select="."/>
           </xsl:otherwise>
      </xsl:choose>
  </xsl:template>
 
  <xsl:template match="//hardwareNs:component[hardwareNs:class = 'bbf-hwt:rj45']/hardwareNs:class">
        <xsl:variable name="var_port_parent" select="../child::*[name() = 'parent']"/>
        <!--xsl:element name="name1111" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_port_parent"/></xsl:element-->
        <xsl:variable name="var_parent_class" select="../../../hardwareNs:hardware/hardwareNs:component/child::*[name() = 'name' and text() = $var_port_parent]/../child::*[name() ='class']"/>
        <xsl:choose>
           <xsl:when test="$var_parent_class = 'bbf-hwt:board'">
             <xsl:variable name="var_board_id" select="../../../hardwareNs:hardware/hardwareNs:component/child::*[name() = 'class' and text()= 'bbf-hwt:board']/../child::*[name() ='name' and text()= $var_port_parent]/../child::*[name()='parent-rel-pos']"/>
             <xsl:variable name="var_port_id" select="../child::*[name() = 'parent-rel-pos']"/>
             <xsl:element name="omci-identifier-helper" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-hardware-extension-mounted">
             <xsl:element name="virtual-board-number" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-hardware-extension-mounted"><xsl:value-of select="$var_board_id"/></xsl:element>
             <xsl:element name="port-id" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-hardware-extension-mounted"><xsl:value-of select="$var_port_id"/></xsl:element>
             </xsl:element>
           </xsl:when>
                   <xsl:otherwise>
                   </xsl:otherwise>
        </xsl:choose>
     <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="//hardwareNs:component[hardwareNs:class = 'bbf-hwt:rj45']/hardwareNs:parent">
           <xsl:variable name="var_port_parent" select="text()"/>
           <xsl:variable name="var_parent_class" select="../../../hardwareNs:hardware/hardwareNs:component/child::*[name() = 'name' and text() = $var_port_parent]/../child::*[name() ='class']"/>
           <!--xsl:element name="name111111" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_parent_class"/></xsl:element-->
        <xsl:choose>
           <xsl:when test="$var_parent_class = 'bbf-hwt:board'">
              <xsl:variable name="var_board_parent" select="../../../hardwareNs:hardware/hardwareNs:component/child::*[name() = 'class' and text()= 'bbf-hwt:board']/../child::*[name() ='name' and text()= $var_port_parent]/../child::*[name()='parent']"/>
              <xsl:element name="parent" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_board_parent"/></xsl:element>
           </xsl:when>
           <xsl:otherwise>
              <xsl:copy-of select="."/>
           </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="//hardwareNs:component[hardwareNs:class = 'bbf-hwt:rj45']/hardwareNs:parent-rel-pos">
           <xsl:variable name="var_port_parent" select="../child::*[name() = 'parent']"/>
           <xsl:variable name="var_parent_class" select="../../../hardwareNs:hardware/hardwareNs:component/child::*[name() = 'name' and text() = $var_port_parent]/../child::*[name() ='class']"/>
           <!--xsl:element name="name222222" namespace="{$var_hardwareNs}"><xsl:value-of select="$var_parent_class"/></xsl:element-->
       <xsl:choose>
           <xsl:when test="$var_parent_class = 'bbf-hwt:board'">
           </xsl:when>
           <xsl:otherwise>
              <xsl:copy-of select="."/>
           </xsl:otherwise>
       </xsl:choose>
    </xsl:template>

    <xsl:template match="//hardwareNs:component[hardwareNs:class = 'bbf-hwt:board']">
    </xsl:template>

</xsl:stylesheet>
