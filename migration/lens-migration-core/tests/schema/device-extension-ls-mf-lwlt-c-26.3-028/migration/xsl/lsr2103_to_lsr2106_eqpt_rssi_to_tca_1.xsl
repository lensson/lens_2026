<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cfgNs="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:hwNs="urn:ietf:params:xml:ns:yang:ietf-hardware" xmlns:rssiNs="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-hardware-extension" version="1.0">
  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" indent="yes"/>

  <!-- default rule -->
  <xsl:template match="*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!--remove false values of tca-monitoring-enabled -->
  <xsl:template match="*[name() = 'tca-monitoring-enabled']">
    <xsl:choose>
       <xsl:when test="namespace-uri() = ('urn:ietf:params:xml:ns:yang:ietf-hardware' or 'http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-hardware-extension')                  and parent::*[name() = 'component']                  and ancestor::*[name() = 'hardware']                  and text() = 'false'        ">
        <xsl:variable name="val_class" select="preceding-sibling::*[name() = 'class']"/>
        <xsl:choose>
          <xsl:when test="               $val_class = 'bbf-hwt:transceiver'           ">
          </xsl:when>
        <xsl:otherwise>
          <xsl:copy>
            <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
        </xsl:otherwise>
    </xsl:choose>

      </xsl:when>

      <xsl:otherwise>
        <xsl:copy>
          <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
      </xsl:otherwise>

    </xsl:choose>
  </xsl:template>
  <!--update <tca-monitoring-enabled> according to tranceiver-link rssi values-->
  <xsl:template match="*[name() = 'component']">
    <xsl:choose>
      <xsl:when test="namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-hardware'                  and parent::*[name() = 'hardware']       ">
        <!--rssi configs supported only on transceiver-link-gpon and transceiver-link-ngpon-->
        <xsl:variable name="ns" select="namespace-uri()"/>
        <xsl:variable name="val_name" select="child::*[name() = 'name']"/>
        <xsl:variable name="val_class" select="child::*[name() = 'class']"/>
         <!-- few transceivers supports dual-gpon with parent-rel-pos 1 and 2 respectively-->
        <xsl:variable name="val_link_name_gpon1" select="/cfgNs:config/hwNs:hardware/hwNs:component/hwNs:parent[text()=$val_name]/preceding-sibling::*[name()='class' and (text()='nokia-hwi:transceiver-link-gpon')]/following-sibling::*[name()='parent-rel-pos' and (text()='1')]/../child::*[name()='name']"/>
        <xsl:variable name="val_link_name_gpon2" select="/cfgNs:config/hwNs:hardware/hwNs:component/hwNs:parent[text()=$val_name]/preceding-sibling::*[name()='class' and (text()='nokia-hwi:transceiver-link-gpon')]/following-sibling::*[name()='parent-rel-pos' and (text()='2')]/../child::*[name()='name']"/>
        <xsl:variable name="val_link_name_ngpon" select="/cfgNs:config/hwNs:hardware/hwNs:component/hwNs:parent[text()=$val_name]/preceding-sibling::*[name()='class' and (text()='nokia-hwi:transceiver-link-ngpon')]/../child::*[name()='name']"/>
        <xsl:variable name="val_link_class" select="/cfgNs:config/hwNs:hardware/hwNs:component/child::*[name()='parent' and text()=$val_name]/../child::*[name()='class']"/>

        <xsl:variable name="val_rssi_value_link_gpon1" select="/cfgNs:config/hwNs:hardware/hwNs:component/child::*[name()='name' and text()=$val_link_name_gpon1]/../child::*[name()='rssi-monitoring-enabled']"/>
        <xsl:variable name="val_rssi_value_link_gpon2" select="/cfgNs:config/hwNs:hardware/hwNs:component/child::*[name()='name' and text()=$val_link_name_gpon2]/../child::*[name()='rssi-monitoring-enabled']"/>
        <xsl:variable name="val_rssi_value_link_ngpon" select="/cfgNs:config/hwNs:hardware/hwNs:component/child::*[name()='name' and text()=$val_link_name_ngpon]/../child::*[name()='rssi-monitoring-enabled']"/>
        <xsl:variable name="val_tca_value" select="/cfgNs:config/hwNs:hardware/hwNs:component/child::*[name()='name' and text()=$val_name]/../child::*[name()='tca-monitoring-enabled']"/> 

        <xsl:variable name="final_rssi_value" select="($val_rssi_value_link_gpon1='true') or ($val_rssi_value_link_gpon2='true') or ($val_rssi_value_link_ngpon='true')"/>


       <xsl:choose>

          <xsl:when test="               $val_class = 'bbf-hwt:transceiver'               and (($val_link_class = 'nokia-hwi:transceiver-link-gpon') or ($val_link_class = 'nokia-hwi:transceiver-link-ngpon'))               and (not(($val_tca_value = 'true')))               and ($final_rssi_value = 'true')                         ">
              <xsl:copy>
              <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
                <xsl:element name="tca-monitoring-enabled" namespace="{'http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-hardware-extension'}">
                <xsl:value-of select="$final_rssi_value"/>
              </xsl:element>
            </xsl:copy>
          </xsl:when>

        <xsl:otherwise>
          <xsl:copy>
            <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
        </xsl:otherwise>
    </xsl:choose>

      </xsl:when>

      <xsl:otherwise>
        <xsl:copy>
          <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
      </xsl:otherwise>

    </xsl:choose>
  </xsl:template>



<xsl:param name="profileNamespace" select="'http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-hardware-profiles'"/>
<xsl:param name="hwProfileNamespace" select="'http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-hardware-extension'"/>

<!-- change 'tca-profile' to 'transceiver-link-tca-profile'-->
    <xsl:template match="*[name()='tca-profile']">
        <xsl:choose>
            <xsl:when test="namespace-uri() = $profileNamespace                       and     parent::*[name() = 'tca-profiles']">
                <xsl:element name="transceiver-link-tca-profile" namespace="{$profileNamespace}">
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:element>
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

<!-- change 'rssi-threshold-low-alarm' to 'rx-power-threshold-low-alarm'-->
    <xsl:template match="*[name()='rssi-threshold-low-alarm']">
        <xsl:choose>
            <xsl:when test="namespace-uri() = $profileNamespace                       and     ancestor::*[name() = 'tca-profiles']                       ">
                <xsl:element name="rx-power-threshold-low-alarm" namespace="{$profileNamespace}">
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:element>
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

<!-- change 'rssi-threshold-low-warning' to 'rx-power-threshold-low-warning'-->
    <xsl:template match="*[name()='rssi-threshold-low-warning']">
        <xsl:choose>
            <xsl:when test="namespace-uri() = $profileNamespace                       and     ancestor::*[name() = 'tca-profiles']                       ">
                <xsl:element name="rx-power-threshold-low-warning" namespace="{$profileNamespace}">
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:element>
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


<!-- change 'rssi-threshold-high-warning' to 'rx-power-threshold-high-warning'-->
    <xsl:template match="*[name()='rssi-threshold-high-warning']">
        <xsl:choose>
            <xsl:when test="namespace-uri() = $profileNamespace                       and     ancestor::*[name() = 'tca-profiles']                       ">
                <xsl:element name="rx-power-threshold-high-warning" namespace="{$profileNamespace}">
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:element>
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

<!-- change 'rssi-threshold-high-alarm' to 'rx-power-threshold-high-alarm'-->
    <xsl:template match="*[name()='rssi-threshold-high-alarm']">
        <xsl:choose>
            <xsl:when test="namespace-uri() = $profileNamespace                       and     ancestor::*[name() = 'tca-profiles']                       ">
                <xsl:element name="rx-power-threshold-high-alarm" namespace="{$profileNamespace}">
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:element>
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

<!-- change 'hw/profile' to 'hw/tca-transceiver-link-profile'-->
    <xsl:template match="*[name()='profile']">
        <xsl:choose>
            <xsl:when test="namespace-uri() = $hwProfileNamespace                       and parent::*[name() = 'component']">
                <xsl:element name="tca-transceiver-link-profile" namespace="{$hwProfileNamespace}">
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:element>
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

<!-- change 'hw/ext:profile' to 'hw/ext:tca-transceiver-link-profile'-->
    <xsl:template match="*[name()='nokia-hw-ext:profile']">
        <xsl:choose>
            <xsl:when test="namespace-uri() = $hwProfileNamespace                       and parent::*[name() = 'component']                       ">
                <xsl:element name="nokia-hw-ext:tca-transceiver-link-profile" namespace="{$hwProfileNamespace}">
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:element>
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

<!-- remove 'rssi-monitoring-enabled' from hw/transceiver-link-->
    <xsl:template match="*[name()='rssi-monitoring-enabled' or name()='nokia-hw-ext:rssi-monitoring-enabled']">
        <xsl:choose>
            <xsl:when test="namespace-uri() = $hwProfileNamespace                       and parent::*[name() = 'component']                       and ancestor::*[name() = 'hardware']                       ">
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
