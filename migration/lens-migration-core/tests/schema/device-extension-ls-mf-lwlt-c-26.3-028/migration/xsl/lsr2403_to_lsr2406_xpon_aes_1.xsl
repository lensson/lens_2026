<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
xmlns:cfgNs="urn:ietf:params:xml:ns:netconf:base:1.0"
xmlns:if="urn:ietf:params:xml:ns:yang:ietf-interfaces"
xmlns:xpon="urn:bbf:yang:bbf-xpon"
xmlns:xponvani="urn:bbf:yang:bbf-xponvani"
xmlns:xpongemtcont="urn:bbf:yang:bbf-xpongemtcont"
xmlns:bbf-subif="urn:bbf:yang:bbf-sub-interfaces"
>


  <!-- Rule 1: For 25GPON case, the management-gemport-aes-indicator can only be false.-->
  <xsl:template match="/cfgNs:config/if:interfaces/if:interface/xponvani:v-ani/xponvani:management-gemport-aes-indicator[.='true']">
      <xsl:variable name="cp_name">
          <xsl:value-of select="../xponvani:preferred-channel-pair"/>
      </xsl:variable>
      <xsl:variable name="pon_type">
          <xsl:value-of select="$interface_map($cp_name)/xpon:channel-pair/xpon:channel-pair-type"/>
      </xsl:variable>
      <!--xsl:message>
          channel-pair is <xsl:value-of select="$cp_name"/>
          pon_type is <xsl:value-of select="$pon_type"/>
      </xsl:message-->

      <xsl:if test="$pon_type='nokia-sdan-xpon-types:twentyfivegs'">
          <xsl:element name='{local-name()}' namespace="{namespace-uri()}">
              <xsl:text>false</xsl:text> 
          </xsl:element>
      </xsl:if>
      <xsl:if test="not ($pon_type='nokia-sdan-xpon-types:twentyfivegs')">
          <xsl:copy>
              <xsl:copy-of select="@*"/>
              <xsl:apply-templates/>
          </xsl:copy>
      </xsl:if>
  </xsl:template>


  <!-- Rule 2: For 25GPON case, the upstream-aes-indicator can only be false.-->
  <xsl:template name="for-upstream-aes">
    <xsl:param name="venet_name"/>
    <xsl:variable name="vani_name">
          <xsl:value-of select="$interface_map($venet_name)/xponvani:olt-v-enet/xponvani:lower-layer-interface"/>
      </xsl:variable>
      <xsl:variable name="cp_name">
          <xsl:value-of select="$interface_map($vani_name)/xponvani:v-ani/xponvani:preferred-channel-pair"/>
      </xsl:variable>
      <xsl:variable name="pon_type">
          <xsl:value-of select="$interface_map($cp_name)/xpon:channel-pair/xpon:channel-pair-type"/>
      </xsl:variable>
      <!--xsl:message>
          olt-v-enet is <xsl:value-of select="$venet_name"/>
          v-ani is <xsl:value-of select="$vani_name"/>
          channel-pair is <xsl:value-of select="$cp_name"/>
          pon_type is <xsl:value-of select="$pon_type"/>
      </xsl:message-->

      <xsl:if test="$pon_type='nokia-sdan-xpon-types:twentyfivegs'">
          <xsl:element name='{local-name()}' namespace="{namespace-uri()}">
              <xsl:text>false</xsl:text> 
          </xsl:element>
      </xsl:if>
      <xsl:if test="not ($pon_type='nokia-sdan-xpon-types:twentyfivegs')">
          <xsl:copy>
              <xsl:copy-of select="@*"/>
              <xsl:apply-templates/>
          </xsl:copy>
      </xsl:if>
  </xsl:template>


  <xsl:template match="/cfgNs:config/xpongemtcont:xpongemtcont/xpongemtcont:gemports/xpongemtcont:gemport/xpongemtcont:upstream-aes-indicator[.='true']">
      <xsl:variable name="interface_name">
          <xsl:value-of select="../xpongemtcont:interface"/>
      </xsl:variable>
      <xsl:variable name="interface_type">
          <xsl:value-of select="$interface_map($interface_name)/if:type"/>
      </xsl:variable>
      <!--xsl:message>
          interface_name is <xsl:value-of select="$interface_name"/>
          interface_type is <xsl:value-of select="$interface_type"/> 
      </xsl:message-->

      <xsl:if test="$interface_type='bbf-xponift:olt-v-enet'">
        <xsl:call-template name="for-upstream-aes">
            <xsl:with-param name="venet_name">
                <xsl:value-of select="$interface_name"/>
            </xsl:with-param>
        </xsl:call-template>
      </xsl:if>

      <xsl:if test="$interface_type='bbfift:vlan-sub-interface'">
        <xsl:call-template name="for-upstream-aes">
	<xsl:with-param name="venet_name">
            <xsl:value-of select="$interface_map($interface_name)/bbf-subif:subif-lower-layer/bbf-subif:interface"/>
            </xsl:with-param>
        </xsl:call-template>
      </xsl:if>
  </xsl:template> 

</xsl:stylesheet>
