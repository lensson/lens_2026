<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:cfgNs="urn:ietf:params:xml:ns:netconf:base:1.0"
    xmlns:xpon="urn:bbf:yang:bbf-xpon"
    xmlns:if="urn:ietf:params:xml:ns:yang:ietf-interfaces"
    xmlns:profNs="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-ber-tca-profiles"
    xmlns:xponaug="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-if-xpon-aug"
    >

  <xsl:template name="choose-closet-onu-distance">
      <xsl:param name="var"/>
      <xsl:param name="ponType"/>
      <xsl:if test="$ponType = 'xgs'">
          <xsl:choose>
              <xsl:when test="$var &lt;= 10">
                  <xsl:value-of select="string('0')"/>
              </xsl:when>
              <xsl:when test="($var &gt; 10) and ($var &lt;= 30)">
                  <xsl:value-of select="string('20')"/>
              </xsl:when>
              <xsl:when test="$var &gt; 30">
                  <xsl:value-of select="string('40')"/>
              </xsl:when>
          </xsl:choose>
      </xsl:if>
      <xsl:if test="$ponType != 'xgs'">
          <xsl:choose>
              <xsl:when test="$var &lt;= 10">
                  <xsl:value-of select="string('0')"/>
              </xsl:when>
              <xsl:when test="$var &gt; 10">
                  <xsl:value-of select="string('20')"/>
              </xsl:when>
          </xsl:choose>
      </xsl:if>
  </xsl:template>

  <!-- Rule 3: 1. For XGSPON case, the closet-onu-distance can only be 0, 20 or 40.
               2. For 25GPON and 50GPON, the closet-onu-distance can only be 0 or 20.
               3. For 25GPON and 50GPON, the maximum-differential-xpon-distance can only be 20. <-->
  <!--Handle nodes added by a1 script. -->
  <xsl:template match="/cfgNs:config/if:interfaces/if:interface/xpon:channel-partition/xpon:closest-onu-distance">
      <xsl:variable name="cp_name">
          <xsl:value-of select="../../if:name"/>
      </xsl:variable>
      <xsl:variable name="closestDistance">
          <xsl:value-of select="."/>
      </xsl:variable>
      <xsl:variable name="pon_type">
          <xsl:value-of select="../../../if:interface/xpon:channel-pair/
          xpon:channel-partition-ref[text()=$cp_name]/../xpon:channel-pair-type"/>
      </xsl:variable>
      <!--xsl:message>
          channel-partition name is <xsl:value-of select="$cp_name"/>
          closest-onu-distance is <xsl:value-of select="$closestDistance"/>
          pon_type is <xsl:value-of select="$pon_type"/>
      </xsl:message-->

      <xsl:if test="$pon_type='bbf-xpon-types:xgs'">
          <xsl:element name="closest-onu-distance" namespace="urn:bbf:yang:bbf-xpon">
              <xsl:call-template name="choose-closet-onu-distance">
                  <xsl:with-param name="var"><xsl:value-of select="$closestDistance"/></xsl:with-param>
                  <xsl:with-param name="ponType">xgs</xsl:with-param>
              </xsl:call-template>
          </xsl:element>
      </xsl:if>

      <xsl:if test="$pon_type='nokia-sdan-xpon-types:twentyfivegs' or $pon_type='nokia-sdan-hspon-types:hs-pon'">
          <!--xsl:message>
              For 25GPON and 50GPON, the closet-onu-distance can only be 0 or 20.
          </xsl:message-->
          <xsl:element name="closest-onu-distance" namespace="urn:bbf:yang:bbf-xpon">
              <xsl:call-template name="choose-closet-onu-distance">
                  <xsl:with-param name="var"><xsl:value-of select="$closestDistance"/></xsl:with-param>
                  <xsl:with-param name="ponType">notxgs</xsl:with-param>
              </xsl:call-template>
          </xsl:element>
      </xsl:if>

      <xsl:if test="not ($pon_type='bbf-xpon-types:xgs' or $pon_type='nokia-sdan-xpon-types:twentyfivegs' or $pon_type='nokia-sdan-hspon-types:hs-pon')">
          <xsl:copy>
              <xsl:copy-of select="@*"/>
              <xsl:apply-templates/>
          </xsl:copy>
      </xsl:if>
  </xsl:template>

  <xsl:template match="/cfgNs:config/if:interfaces/if:interface/xpon:channel-partition/xpon:maximum-differential-xpon-distance">
      <xsl:variable name="maxDiffDistance">
          <xsl:value-of select="."/>
      </xsl:variable>
      <xsl:variable name="cp_name">
          <xsl:value-of select="../../if:name"/>
      </xsl:variable>
      <xsl:variable name="pon_type">
          <xsl:value-of select="../../../if:interface/xpon:channel-pair/
          xpon:channel-partition-ref[text()=$cp_name]/../xpon:channel-pair-type"/>
      </xsl:variable>
      <!--xsl:message>
          channel-partition name is <xsl:value-of select="$cp_name"/>
          maximum-differential-xpon-distance is <xsl:value-of select="$maxDiffDistance"/>
          pon_type is <xsl:value-of select="$pon_type"/>
      </xsl:message-->

      <xsl:if test="$pon_type='nokia-sdan-xpon-types:twentyfivegs' or $pon_type='nokia-sdan-hspon-types:hs-pon'">
          <xsl:element name="maximum-differential-xpon-distance" namespace="urn:bbf:yang:bbf-xpon">20</xsl:element>
          <!--xsl:message>
              For 25GPON or 50GPON case, the maximum-differential-xpon-distance can only be 20.
          </xsl:message-->
      </xsl:if>
      <xsl:if test="not ($pon_type='nokia-sdan-xpon-types:twentyfivegs' or $pon_type='nokia-sdan-hspon-types:hs-pon')">
          <xsl:copy>
              <xsl:copy-of select="@*"/>
              <xsl:apply-templates/>
          </xsl:copy>
      </xsl:if>
  </xsl:template>

  <!-- Rule 9: For GPON case, range of leaf "sd-threshold" should be "4 .. 9". <-->
  <xsl:template match="/cfgNs:config/profNs:ber-tca-profiles/profNs:ber-tca-profile/profNs:sd-threshold">
      <xsl:variable name="sd"><xsl:value-of select="."/></xsl:variable>
      <xsl:variable name="profFile"><xsl:value-of select="../profNs:name"/></xsl:variable>
      <xsl:variable name="profName"><xsl:value-of select="../../../if:interfaces/if:interface/xpon:channel-pair/xponaug:ber-tca-profile[text()=$profFile]"/></xsl:variable>
      <xsl:variable name="chType"><xsl:value-of select="../../../if:interfaces/if:interface/xpon:channel-pair/xpon:channel-pair-type/../xponaug:ber-tca-profile[text()=$profFile]/../xpon:channel-pair-type[text()='bbf-xpon-types:gpon']"/></xsl:variable>
      <!--xsl:message>
          sd is : <xsl:value-of select="$sd"/>
          profFile is : <xsl:value-of select="$profFile"/>
          profName : <xsl:value-of select="$profName"/>
          chType   : <xsl:value-of select="$chType"/>
      </xsl:message-->
      <xsl:if test="$profName=$profFile and $chType='bbf-xpon-types:gpon' and $sd &lt; 4">
          <xsl:element name='sd-threshold' namespace='http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-ber-tca-profiles'>4</xsl:element>
      </xsl:if>
      <xsl:if test="$profName=$profFile and $chType='bbf-xpon-types:gpon' and $sd &gt; 9">
          <xsl:element name='sd-threshold' namespace='http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-ber-tca-profiles'>9</xsl:element>
      </xsl:if>
      <xsl:if test="$profName!=$profFile or $chType!='bbf-xpon-types:gpon' or ($sd &lt;= 9 and $sd &gt;= 4)">
          <xsl:element name='sd-threshold' namespace='http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-ber-tca-profiles'><xsl:value-of select="$sd"/></xsl:element>
      </xsl:if>
  </xsl:template>
</xsl:stylesheet>
