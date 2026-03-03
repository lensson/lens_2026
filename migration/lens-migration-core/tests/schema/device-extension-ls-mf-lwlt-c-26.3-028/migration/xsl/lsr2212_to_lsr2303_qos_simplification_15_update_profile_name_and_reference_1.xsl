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

  <!--update name  for policing profile-->
  <xsl:template match="*[
    local-name() = 'name'
    and parent::*[local-name() = 'policing-profile']
    and ancestor::*[local-name() = 'policing-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policing']
  ]">
    <xsl:variable name="curFinalName">
      <xsl:value-of select="../child::*[local-name() = 'finalName']"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="boolean($curFinalName) and string-length(normalize-space($curFinalName))>0">
        <xsl:element name="name" namespace="urn:bbf:yang:bbf-qos-policing">
          <xsl:value-of select="$curFinalName"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- update name  for classifier profile -->
  <xsl:template match="*[
    local-name() = 'name'
    and parent::*[local-name() = 'classifier-entry']
    and ancestor::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']
  ]">
    <xsl:variable name="curFinalName">
      <xsl:value-of select="../child::*[local-name() = 'finalName']"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="boolean($curFinalName) and string-length(normalize-space($curFinalName))>0">
        <xsl:element name="name" namespace="urn:bbf:yang:bbf-qos-classifiers">
          <xsl:value-of select="$curFinalName"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- update name for policy profile -->
  <xsl:template match="*[
    local-name() = 'name'
    and parent::*[local-name() = 'policy']
    and ancestor::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']
  ]">
    <xsl:variable name="curFinalName">
      <xsl:value-of select="../child::*[local-name() = 'finalName']"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="boolean($curFinalName) and string-length(normalize-space($curFinalName))>0">
        <xsl:element name="name" namespace="urn:bbf:yang:bbf-qos-policies">
          <xsl:value-of select="$curFinalName"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- update policing profile reference in classifier -->
  <xsl:template match="*[
    local-name() = 'policing-profile'
    and parent::*[local-name() = 'policing' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policing']
    and ancestor::*[local-name() = 'classifier-action-entry-cfg']
    and ancestor::*[local-name() = 'classifier-entry']
    and ancestor::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']
  ]">
    <xsl:variable name="curPolicingRealName">
      <xsl:value-of select="../../../child::*[local-name() = 'policingRealName']"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="boolean($curPolicingRealName) and string-length(normalize-space($curPolicingRealName))>0">
        <xsl:variable name="policingSec" select="//*[
          local-name() = 'policing-profile'
          and child::*[local-name() = 'realName' and text() = $curPolicingRealName]
          and parent::*[local-name() = 'policing-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policing']
        ]"/>

        <xsl:variable name="policingFinalName">
          <xsl:value-of select="$policingSec/bbf-qos-plc:finalName"/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="boolean($policingFinalName) and string-length(normalize-space($policingFinalName))>0">
            <xsl:element name="policing-profile" namespace="urn:bbf:yang:bbf-qos-policing">
              <xsl:value-of select="$policingFinalName"/>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="."/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- update classifier profile reference in policy -->
  <xsl:template match="*[
    local-name() = 'name'
    and parent::*[local-name() = 'classifiers']
    and ancestor::*[local-name() = 'policy' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']
    and ancestor::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']
  ]">
    <xsl:variable name="curClassifierRealName">
      <xsl:value-of select="../bbf-qos-pol:classifierRealName"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="boolean($curClassifierRealName) and string-length(normalize-space($curClassifierRealName))>0">
        <xsl:variable name="classifierSec" select="//*[
          local-name() = 'classifier-entry'
          and child::*[local-name() = 'realName' and text() = $curClassifierRealName]
          and parent::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']
        ]"/>

        <xsl:variable name="classifierFinalName">
          <xsl:value-of select="$classifierSec/bbf-qos-cls:finalName"/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="boolean($classifierFinalName) and string-length(normalize-space($classifierFinalName))>0">
            <xsl:element name="name" namespace="urn:bbf:yang:bbf-qos-policies">
              <xsl:value-of select="$classifierFinalName"/>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="."/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- update policy profile reference in qos-policy profile -->
  <xsl:template match="*[
    local-name() = 'name'
    and parent::*[local-name() = 'policy-list']
    and ancestor::*[local-name() = 'policy-profile']
    and ancestor::*[local-name() = 'qos-policy-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']
  ]">
    <xsl:variable name="curPolicyRealName">
      <xsl:value-of select="../bbf-qos-pol:policyRealName"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="boolean($curPolicyRealName) and string-length(normalize-space($curPolicyRealName))>0">
        <xsl:variable name="policySec" select="//*[
          local-name() = 'policy'
          and child::*[local-name() = 'realName' and text() = $curPolicyRealName]
          and parent::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']
        ]"/>

        <xsl:variable name="policyFinalName">
          <xsl:value-of select="$policySec/bbf-qos-pol:finalName"/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="boolean($policyFinalName) and string-length(normalize-space($policyFinalName))>0">
            <xsl:element name="name" namespace="urn:bbf:yang:bbf-qos-policies">
              <xsl:value-of select="$policyFinalName"/>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="."/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
