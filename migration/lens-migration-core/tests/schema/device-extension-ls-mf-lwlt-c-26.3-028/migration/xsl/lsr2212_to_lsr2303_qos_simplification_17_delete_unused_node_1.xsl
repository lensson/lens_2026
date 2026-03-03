<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:bbf-qos-filt="urn:bbf:yang:bbf-qos-filters"
                xmlns:bbf-qos-enhfilt="urn:bbf:yang:bbf-qos-enhanced-filters"
                xmlns:bbf-qos-pol="urn:bbf:yang:bbf-qos-policies"
                xmlns:bbf-qos-cls="urn:bbf:yang:bbf-qos-classifiers"
                xmlns:bbf-qos-plc="urn:bbf:yang:bbf-qos-policing"
                xmlns:nokia-qos-filt="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-qos-filters-ext"
                xmlns:nokia-sdan-qos-policing-extension="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension"
                xmlns:nokia-qos-cls-ext="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-classifier-extension"
                xmlns=""
                version="1.0">

  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" indent="yes"/>

  <!-- default rule -->
  <xsl:template match="*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!--delete unused node for policing-->
  <xsl:template match="*[
    local-name() = 'sourceName'
    and parent::*[local-name() = 'policing-profile']
    and ancestor::*[local-name() = 'policing-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policing']
  ]"/>
  <xsl:template match="*[
    local-name() = 'realName'
    and parent::*[local-name() = 'policing-profile']
    and ancestor::*[local-name() = 'policing-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policing']
  ]"/>
  <xsl:template match="*[
    local-name() = 'counter'
    and parent::*[local-name() = 'policing-profile']
    and ancestor::*[local-name() = 'policing-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policing']
  ]"/>
  <xsl:template match="*[
    local-name() = 'sourceMax'
    and parent::*[local-name() = 'policing-profile']
    and ancestor::*[local-name() = 'policing-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policing']
  ]"/>
  <xsl:template match="*[
    local-name() = 'firstNameInGroup'
    and parent::*[local-name() = 'policing-profile']
    and ancestor::*[local-name() = 'policing-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policing']
  ]"/>
  <xsl:template match="*[
    local-name() = 'sourceFinalName'
    and parent::*[local-name() = 'policing-profile']
    and ancestor::*[local-name() = 'policing-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policing']
  ]"/>
  <xsl:template match="*[
    local-name() = 'finalName'
    and parent::*[local-name() = 'policing-profile']
    and ancestor::*[local-name() = 'policing-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policing']
  ]"/>

  <!--delete unused node for classifier-->
  <xsl:template match="*[
    local-name() = 'sourceName'
    and parent::*[local-name() = 'classifier-entry']
    and ancestor::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']
  ]"/>
  <xsl:template match="*[
    local-name() = 'realName'
    and parent::*[local-name() = 'classifier-entry']
    and ancestor::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']
  ]"/>
  <xsl:template match="*[
    local-name() = 'policingRealName'
    and parent::*[local-name() = 'classifier-entry']
    and ancestor::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']
  ]"/>
  <xsl:template match="*[
    local-name() = 'counter'
    and parent::*[local-name() = 'classifier-entry']
    and ancestor::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']
  ]"/>
  <xsl:template match="*[
    local-name() = 'sourceMax'
    and parent::*[local-name() = 'classifier-entry']
    and ancestor::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']
  ]"/>
  <xsl:template match="*[
    local-name() = 'firstNameInGroup'
    and parent::*[local-name() = 'classifier-entry']
    and ancestor::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']
  ]"/>
  <xsl:template match="*[
    local-name() = 'sourceFinalName'
    and parent::*[local-name() = 'classifier-entry']
    and ancestor::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']
  ]"/>
  <xsl:template match="*[
    local-name() = 'finalName'
    and parent::*[local-name() = 'classifier-entry']
    and ancestor::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']
  ]"/>
  
  <!--delete unused node for policy-->
  <xsl:template match="*[
    local-name() = 'sourceName'
    and parent::*[local-name() = 'policy']
    and ancestor::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']
  ]"/>
  <xsl:template match="*[
    local-name() = 'realName'
    and parent::*[local-name() = 'policy']
    and ancestor::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']
  ]"/>
  <xsl:template match="*[
    local-name() = 'counter'
    and parent::*[local-name() = 'policy']
    and ancestor::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']
  ]"/>
  <xsl:template match="*[
    local-name() = 'sourceMax'
    and parent::*[local-name() = 'policy']
    and ancestor::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']
  ]"/>
  <xsl:template match="*[
    local-name() = 'firstNameInGroup'
    and parent::*[local-name() = 'policy']
    and ancestor::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']
  ]"/>
  <xsl:template match="*[
    local-name() = 'sourceFinalName'
    and parent::*[local-name() = 'policy']
    and ancestor::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']
  ]"/>
  <xsl:template match="*[
    local-name() = 'finalName'
    and parent::*[local-name() = 'policy']
    and ancestor::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']
  ]"/>

  <xsl:template match="*[
    local-name() = 'classifierRealName'
    and parent::*[local-name() = 'classifiers']
    and ancestor::*[local-name() = 'policy']
    and ancestor::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']
  ]"/>
  
  <!--delete unused node for qos-policy-profile-->
  <xsl:template match="*[
    local-name() = 'sourceName'
    and parent::*[local-name() = 'policy-list']
    and ancestor::*[local-name() = 'policy-profile']
    and ancestor::*[local-name() = 'qos-policy-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']
  ]"/>
  <xsl:template match="*[
    local-name() = 'policyRealName'
    and parent::*[local-name() = 'policy-list']
    and ancestor::*[local-name() = 'policy-profile']
    and ancestor::*[local-name() = 'qos-policy-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']
  ]"/>

  <!-- clean duplicates element for policy, classifier, enhance filter. -->
  <xsl:key name="PolicyProfile" match="bbf-qos-pol:policy" use="bbf-qos-pol:name"/>
  <xsl:template match="bbf-qos-pol:policies/bbf-qos-pol:policy[not(generate-id() = generate-id(key('PolicyProfile', bbf-qos-pol:name)[1]))]"/>

  <xsl:key name="ClassifierProfile" match="bbf-qos-cls:classifier-entry" use="bbf-qos-cls:name"/>
  <xsl:template match="bbf-qos-cls:classifiers/bbf-qos-cls:classifier-entry[not(generate-id() = generate-id(key('ClassifierProfile', bbf-qos-cls:name)[1]))]"/>

  <xsl:key name="PolicingProfile" match="bbf-qos-plc:policing-profile" use="bbf-qos-plc:name"/>
  <xsl:template match="bbf-qos-plc:policing-profiles/bbf-qos-plc:policing-profile[not(generate-id() = generate-id(key('PolicingProfile', bbf-qos-plc:name)[1]))]"/>

</xsl:stylesheet>
