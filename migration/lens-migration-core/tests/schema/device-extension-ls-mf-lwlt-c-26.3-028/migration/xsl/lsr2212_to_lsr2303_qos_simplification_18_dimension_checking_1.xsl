<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cfgNs="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:bbf-qos-filt="urn:bbf:yang:bbf-qos-filters" xmlns:bbf-qos-enhfilt="urn:bbf:yang:bbf-qos-enhanced-filters" xmlns:bbf-qos-pol="urn:bbf:yang:bbf-qos-policies" xmlns:bbf-qos-cls="urn:bbf:yang:bbf-qos-classifiers" xmlns:bbf-qos-plc="urn:bbf:yang:bbf-qos-policing" xmlns:nokia-qos-filt="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-qos-filters-ext" xmlns:nokia-sdan-qos-policing-extension="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension" xmlns="" version="1.0">

  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" indent="yes"/>

  <xsl:variable name="POLICY_DIMENSION" select="512"/>
  <xsl:variable name="CLASSIFIER_DIMENSION" select="2048"/>
  <xsl:variable name="FILTER_DIMENSION" select="512"/>
  <xsl:variable name="POLICING_DIMENSION" select="512"/>
  <xsl:variable name="POLICING_PREHANDLING_DIMENSION" select="512"/>
  <xsl:variable name="POLICING_ACTION_DIMENSION" select="512"/>

  <!-- default rule -->
  <xsl:template match="*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!--calculate number of policy profile-->
  <xsl:template match="//cfgNs:config/bbf-qos-pol:policies">
    <xsl:variable name="numberOfPolicy" select="count(//*[         local-name() = 'policy'         and parent::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']     ])"/>
    <xsl:if test="string-length(normalize-space($numberOfPolicy))&gt;0 and $numberOfPolicy&gt;$POLICY_DIMENSION">
      <wrong-configuration-detected>The policy number exceeds the maximum value of 512.</wrong-configuration-detected>
    </xsl:if>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
  </xsl:template>

  <!--calculate number of classifier profile-->
  <xsl:template match="//cfgNs:config/bbf-qos-cls:classifiers">
    <xsl:variable name="numberOfClassifier" select="count(//*[         local-name() = 'classifier-entry'         and parent::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']     ])"/>
    <xsl:if test="string-length(normalize-space($numberOfClassifier))&gt;0 and $numberOfClassifier&gt;$CLASSIFIER_DIMENSION">
      <wrong-configuration-detected>The classifier number exceeds the maximum value of 2048.</wrong-configuration-detected>
    </xsl:if>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
  </xsl:template>
  
  <!--calculate number of filter profile-->
  <xsl:template match="//cfgNs:config/bbf-qos-filt:filters">
    <xsl:variable name="numberOfEnhanceFilter" select="count(//*[         local-name() = 'enhanced-filter'         and parent::*[local-name() = 'filters' and namespace-uri() = 'urn:bbf:yang:bbf-qos-filters']     ])"/>

    <xsl:if test="string-length(normalize-space($numberOfEnhanceFilter))&gt;0 and $numberOfEnhanceFilter&gt;$FILTER_DIMENSION">
      <wrong-configuration-detected>The enhanceFilter number exceeds the maximum value of 512.</wrong-configuration-detected>
    </xsl:if>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
  </xsl:template>
  
  <!--calculate number of policing profile-->
  <xsl:template match="//cfgNs:config/bbf-qos-plc:policing-profiles">
    <xsl:variable name="numberOfPolicing" select="count(//*[         local-name() = 'policing-profile'         and parent::*[local-name() = 'policing-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policing']     ])"/>

    <xsl:if test="string-length(normalize-space($numberOfPolicing))&gt;0 and $numberOfPolicing&gt;$POLICING_DIMENSION">
      <wrong-configuration-detected>The policing number exceeds the maximum value of 512.</wrong-configuration-detected>
    </xsl:if>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
  </xsl:template>
  
  <!--calculate number of policing-pre-handling-profiles profile-->
  <xsl:template match="//cfgNs:config/nokia-sdan-qos-policing-extension:policing-pre-handling-profiles">
    <xsl:variable name="numberOfPolicingPreHandlingProfile" select="count(//*[         local-name() = 'pre-handling-profile'         and parent::*[local-name() = 'policing-pre-handling-profiles' and namespace-uri() = 'http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension']     ])"/>

    <xsl:if test="string-length(normalize-space($numberOfPolicingPreHandlingProfile))&gt;0 and $numberOfPolicingPreHandlingProfile&gt;$POLICING_PREHANDLING_DIMENSION">
      <wrong-configuration-detected>The policing PreHandling profile number exceeds the maximum value of 512.</wrong-configuration-detected>
    </xsl:if>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
  </xsl:template>
 
  <!--calculate number of policing-action-profiles profile-->
  <xsl:template match="//cfgNs:config/nokia-sdan-qos-policing-extension:policing-action-profiles">
    <xsl:variable name="numberOfPolicingActionProfile" select="count(//*[         local-name() = 'action-profile'         and parent::*[local-name() = 'policing-action-profiles' and namespace-uri() = 'http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension']     ])"/>
    <xsl:if test="string-length(normalize-space($numberOfPolicingActionProfile))&gt;0 and $numberOfPolicingActionProfile&gt;$POLICING_ACTION_DIMENSION">
      <wrong-configuration-detected>The policing action profile number exceeds the maximum value of 512.</wrong-configuration-detected>
    </xsl:if>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
  </xsl:template>

</xsl:stylesheet>
