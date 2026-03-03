<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:bbf-qos-filt="urn:bbf:yang:bbf-qos-filters" xmlns:bbf-qos-enhfilt="urn:bbf:yang:bbf-qos-enhanced-filters" xmlns:bbf-qos-pol="urn:bbf:yang:bbf-qos-policies" xmlns:bbf-qos-cls="urn:bbf:yang:bbf-qos-classifiers" xmlns:bbf-qos-plc="urn:bbf:yang:bbf-qos-policing" xmlns:nokia-qos-filt="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-qos-filters-ext" xmlns:nokia-sdan-qos-policing-extension="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension" xmlns:nokia-qos-cls-ext="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-classifier-extension" xmlns="" version="1.0">

  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>

  <!-- default rule -->
  <xsl:template match="*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  
  <!-- Insert realName for policy -->
  <xsl:template match="*[     local-name() = 'policy'     and parent::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']   ]">
    <xsl:variable name="curPolicySec" select="current()"/>
    <xsl:variable name="sourceName">
      <xsl:value-of select="$curPolicySec/child::*[local-name() = 'sourceName']"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="boolean($sourceName) and string-length(normalize-space($sourceName))&gt;0">
        <xsl:copy>
          <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
<xsl:variable name="realPolicyName">
            <xsl:call-template name="generateRealPolicyName">
              <xsl:with-param name="policySourceName" select="$sourceName"/>
              <xsl:with-param name="policySec" select="$curPolicySec"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:element name="realName" namespace="urn:bbf:yang:bbf-qos-policies">
            <xsl:value-of select="$realPolicyName"/>
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
  </xsl:template>

  <xsl:template name="generateRealPolicyName">
    <xsl:param name="policySourceName"/>
    <xsl:param name="policySec"/>
    <xsl:variable name="policyRealName">
      <xsl:for-each select="$policySec/child::*[local-name() = 'classifiers']">
        <xsl:variable name="curClassifier" select="current()"/>
        <xsl:variable name="curClassifierName">
          <xsl:value-of select="$curClassifier/child::*[local-name() = 'name']"/>
        </xsl:variable>
      
        <xsl:variable name="classifierSec" select="//*[           local-name() = 'classifier-entry'           and parent::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']           and child::*[local-name() = 'name'] = $curClassifierName         ]"/>

        <xsl:variable name="classifierRealName">
          <xsl:value-of select="$classifierSec/child::*[local-name() = 'realName']"/>
        </xsl:variable>

        <xsl:choose>
          <xsl:when test="position() != 1">
            <xsl:choose>
              <xsl:when test="boolean($classifierRealName) and string-length(normalize-space($classifierRealName))&gt;0">
                <xsl:value-of select="concat(policyRealName,$classifierRealName)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat(policyRealName,$curClassifierName)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="boolean($classifierRealName) and string-length(normalize-space($classifierRealName))&gt;0">
                <xsl:value-of select="concat($policySourceName,$classifierRealName)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat($policySourceName,$curClassifierName)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:variable>

    <xsl:value-of select="$policyRealName"/>
  </xsl:template>

</xsl:stylesheet>
