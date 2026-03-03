<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cfgNs="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:itfs="urn:ietf:params:xml:ns:yang:ietf-interfaces" xmlns:vsi="urn:bbf:yang:bbf-sub-interfaces" xmlns:vsi-tag="urn:bbf:yang:bbf-sub-interface-tagging" xmlns:fpp="urn:bbf:yang:bbf-frame-processing-profile" xmlns:vsi-vector="urn:bbf:yang:bbf-vlan-sub-interface-vector" xmlns:vsi-vector-fpp="urn:bbf:yang:bbf-vlan-sub-interface-vector-fpp" version="1.0">
  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" indent="yes"/>

  <!-- default rule -->
  <xsl:template match="*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!--Handle VSIs that have an untagged rule. -->
  <xsl:template match="/cfgNs:config/itfs:interfaces/itfs:interface[itfs:type = 'bbfift:vlan-sub-interface']">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
      <xsl:variable name="untagged">
        <xsl:call-template name="has_vsi_untagged"/>
      </xsl:variable>
      <xsl:if test="$untagged != '' ">
        <!--xsl:message><xsl:value-of select="itfs:name"/> untagged from <xsl:value-of select="$untagged"/></xsl:message-->
        <untagged-rule-on-subif-lower-layer>
          <via>
            <xsl:value-of select="$untagged"/>
          </via>
          <lower-layer>
            <xsl:value-of select="vsi:subif-lower-layer/vsi:interface"/>
          </lower-layer>
        </untagged-rule-on-subif-lower-layer>
      </xsl:if>
    </xsl:copy>
  </xsl:template>

  <!-- Return string if node has untagged rule, whether inline or in frame-processing-profile or vector-profile. -->
  <xsl:template name="has_vsi_untagged">
    <xsl:choose>
      <xsl:when test="vsi:inline-frame-processing">
        <xsl:if test="vsi:inline-frame-processing/vsi:ingress-rule/vsi:rule/vsi:flexible-match/vsi-tag:match-criteria/vsi-tag:untagged">
          <xsl:text>inline</xsl:text>
        </xsl:if>
      </xsl:when>
      <xsl:when test="fpp:frame-processing-profile-ref">
        <xsl:call-template name="has_fpp_untagged"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- Not inline frame processing or frame-processing-profile, so try vector-profile, which has lowest priority. -->
        <xsl:if test="vsi-vector:vector-profile">
          <xsl:call-template name="has_vector_untagged"/>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Return profile's name if node has a reference to a frame-processing-profile with untagged rule. -->
  <xsl:template name="has_fpp_untagged">
    <xsl:variable name="fppref">
      <xsl:value-of select="fpp:frame-processing-profile-ref"/>
    </xsl:variable>
    <xsl:if test="/cfgNs:config/fpp:frame-processing-profiles/fpp:frame-processing-profile[fpp:name = $fppref]/fpp:match-criteria/fpp:untagged">
      <xsl:value-of select="$fppref"/>
    </xsl:if>
  </xsl:template>

  <!-- Return profile's name if node has a reference to a vector-profile with untagged rule. -->
  <xsl:template name="has_vector_untagged">
    <xsl:variable name="vector-profile-ref">
      <xsl:value-of select="vsi-vector:vector-profile"/>
    </xsl:variable>
    <xsl:variable name="fppref">
      <xsl:value-of select="/cfgNs:config/vsi-vector:vsi-vector-profiles/vsi-vector:vsi-vector-profile[vsi-vector:name = $vector-profile-ref]/vsi-vector-fpp:frame-processing-profile-ref"/>
    </xsl:variable>
    <xsl:if test="/cfgNs:config/fpp:frame-processing-profiles/fpp:frame-processing-profile[fpp:name = $fppref]/fpp:match-criteria/fpp:untagged">
      <xsl:value-of select="$vector-profile-ref"/>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
