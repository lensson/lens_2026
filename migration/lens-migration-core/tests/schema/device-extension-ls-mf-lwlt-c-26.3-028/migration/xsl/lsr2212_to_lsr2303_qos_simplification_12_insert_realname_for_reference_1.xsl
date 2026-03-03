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
  
  <!-- Insert policy realName for policy-profile -->
  <xsl:template match="*[     local-name() = 'policy-list'     and parent::*[local-name() = 'policy-profile']     and ancestor::*[local-name() = 'qos-policy-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']   ]">
    <xsl:variable name="curPolicySec" select="current()"/>
    <xsl:variable name="policyName">
      <xsl:value-of select="$curPolicySec/child::*[local-name() = 'name']"/>
    </xsl:variable>

    <xsl:variable name="policySec" select="//*[       local-name() = 'policy'       and parent::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']       and child::*[local-name() = 'name'] = $policyName     ]"/>
    <xsl:variable name="realNameOfPolicy">
      <xsl:value-of select="$policySec/child::*[local-name() = 'realName']"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="boolean($realNameOfPolicy) and string-length(normalize-space($realNameOfPolicy))&gt;0">
        <xsl:copy>
          <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
<xsl:element name="policyRealName" namespace="urn:bbf:yang:bbf-qos-policies">
            <xsl:value-of select="$realNameOfPolicy"/>
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

  <!-- Insert classifier realName for policy -->
  <xsl:template match="*[     local-name() = 'classifiers'     and parent::*[local-name() = 'policy']     and ancestor::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']   ]">
    <xsl:variable name="curClassifierSec" select="current()"/>
    <xsl:variable name="classifierName">
      <xsl:value-of select="$curClassifierSec/child::*[local-name() = 'name']"/>
    </xsl:variable>

    <xsl:variable name="classifierSec" select="//*[       local-name() = 'classifier-entry'       and parent::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']       and child::*[local-name() = 'name'] = $classifierName     ]"/>
    <xsl:variable name="realNameOfClassifier">
      <xsl:value-of select="$classifierSec/child::*[local-name() = 'realName']"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="boolean($realNameOfClassifier) and string-length(normalize-space($realNameOfClassifier))&gt;0">
        <xsl:copy>
          <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
<xsl:element name="classifierRealName" namespace="urn:bbf:yang:bbf-qos-policies">
            <xsl:value-of select="$realNameOfClassifier"/>
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

</xsl:stylesheet>
