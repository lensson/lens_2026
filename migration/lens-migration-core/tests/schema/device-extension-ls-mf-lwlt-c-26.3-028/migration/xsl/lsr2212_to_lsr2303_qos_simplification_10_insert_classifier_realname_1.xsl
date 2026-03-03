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
  
  <!-- delete policy-list which is not exist in policy. -->
  <xsl:template match="*[     local-name() = 'policy-list'     and parent::*[local-name() = 'policy-profile']     and ancestor::*[local-name() = 'qos-policy-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']   ]">
    <xsl:variable name="curPolicyName">
      <xsl:value-of select="bbf-qos-pol:name"/>
    </xsl:variable>
    <xsl:variable name="policySec" select="//*[         local-name() = 'policy'         and child::*[local-name() = 'name' and text() = $curPolicyName]         and parent::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']     ]"/>

    <xsl:choose>
      <xsl:when test="boolean($policySec) and string-length(normalize-space($policySec))&gt;0">
        <xsl:copy>
          <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- clean duplicates element for enhance filter. -->
  <xsl:key name="EnhanceFilterProfile" match="bbf-qos-enhfilt:enhanced-filter" use="bbf-qos-enhfilt:name"/>
  <xsl:template match="bbf-qos-filt:filters/bbf-qos-enhfilt:enhanced-filter[not(generate-id() = generate-id(key('EnhanceFilterProfile', bbf-qos-enhfilt:name)[1]))]"/>

  <!-- Insert realName for classifier -->
  <xsl:template match="*[     local-name() = 'classifier-entry'     and parent::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']   ]">
    <xsl:variable name="curClassifier" select="current()"/>
    <xsl:variable name="sourceName">
      <xsl:value-of select="$curClassifier/bbf-qos-cls:sourceName"/>
    </xsl:variable>
    <xsl:variable name="refPolicingName">
      <xsl:value-of select="$curClassifier/bbf-qos-cls:classifier-action-entry-cfg/bbf-qos-plc:policing/bbf-qos-plc:policing-profile"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="boolean($sourceName) and string-length(normalize-space($sourceName))&gt;0 and boolean($refPolicingName) and string-length(normalize-space($refPolicingName))&gt;0">
        <xsl:copy>
          <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
<xsl:variable name="policingSec" select="//*[             local-name() = 'policing-profile'             and parent::*[local-name() = 'policing-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policing']             and child::*[local-name() = 'name' and text() = $refPolicingName]           ]"/>

          <xsl:variable name="realNameOfPolicing">
            <xsl:value-of select="$policingSec/bbf-qos-plc:realName"/>
          </xsl:variable>
          <xsl:variable name="realClassifierName">
            <xsl:call-template name="generateRealClassifierName">
              <xsl:with-param name="realPolicingName" select="$realNameOfPolicing"/>
              <xsl:with-param name="classifierName" select="$sourceName"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:element name="realName" namespace="urn:bbf:yang:bbf-qos-classifiers">
            <xsl:value-of select="$realClassifierName"/>
          </xsl:element>
          <xsl:choose>
            <xsl:when test="boolean($realNameOfPolicing) and string-length(normalize-space($realNameOfPolicing))&gt;0">
              <xsl:element name="policingRealName" namespace="urn:bbf:yang:bbf-qos-classifiers">
                <xsl:value-of select="$realNameOfPolicing"/>
              </xsl:element>
            </xsl:when>
            <xsl:otherwise>
              <xsl:element name="policingRealName" namespace="urn:bbf:yang:bbf-qos-classifiers">
                <xsl:value-of select="$refPolicingName"/>
              </xsl:element>
            </xsl:otherwise>
          </xsl:choose>

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

  <xsl:template name="generateRealClassifierName">
    <xsl:param name="realPolicingName"/>
    <xsl:param name="classifierName"/>
    <xsl:value-of select="concat($classifierName,$realPolicingName)"/>
  </xsl:template>

</xsl:stylesheet>
