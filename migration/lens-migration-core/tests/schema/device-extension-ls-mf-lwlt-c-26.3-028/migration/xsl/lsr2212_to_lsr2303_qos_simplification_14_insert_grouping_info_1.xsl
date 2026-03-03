<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:bbf-qos-filt="urn:bbf:yang:bbf-qos-filters" xmlns:bbf-qos-enhfilt="urn:bbf:yang:bbf-qos-enhanced-filters" xmlns:bbf-qos-pol="urn:bbf:yang:bbf-qos-policies" xmlns:bbf-qos-cls="urn:bbf:yang:bbf-qos-classifiers" xmlns:bbf-qos-plc="urn:bbf:yang:bbf-qos-policing" xmlns:nokia-qos-filt="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-qos-filters-ext" xmlns:nokia-sdan-qos-policing-extension="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension" xmlns:nokia-qos-cls-ext="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-classifier-extension" xmlns="" version="1.0">

  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" indent="yes"/>

  <!-- default rule -->
  <xsl:template match="*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!-- update source max for policing profile -->
  <xsl:template match="*[     local-name() = 'policing-profile'     and parent::*[local-name() = 'policing-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policing']   ]">
    <xsl:variable name="curSourceName">
      <xsl:value-of select="bbf-qos-plc:sourceName"/>
    </xsl:variable>
    <xsl:variable name="curRealName">
      <xsl:value-of select="bbf-qos-plc:realName"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="boolean($curSourceName) and string-length(normalize-space($curSourceName))&gt;0 and boolean($curRealName) and string-length(normalize-space($curRealName))&gt;0">
        <xsl:copy>
          <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
<!-- sourceMax-->
          <xsl:variable name="policingSec" select="//*[               local-name() = 'policing-profile'               and child::*[local-name() = 'sourceName' and text() = $curSourceName]               and parent::*[local-name() = 'policing-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policing']           ]"/>
          <xsl:variable name="maxNumber">
            <xsl:for-each select="$policingSec/bbf-qos-plc:counter">
              <xsl:sort select="." order="descending"/>
              <xsl:if test="position()=1">
                <xsl:value-of select="."/>
              </xsl:if>
            </xsl:for-each>
          </xsl:variable>
          <xsl:element name="sourceMax" namespace="urn:bbf:yang:bbf-qos-policing">
            <xsl:value-of select="$maxNumber"/>
          </xsl:element>

          <!-- firstNameInGroup-->
          <xsl:variable name="firstNameInGroup">
            <xsl:for-each select="//*[             local-name() = 'policing-profile'             and child::*[local-name() = 'realName' and text() = $curRealName]             and parent::*[local-name() = 'policing-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policing']           ]">
              <xsl:sort select="bbf-qos-plc:name" order="descending"/>
              <xsl:if test="position()=1">
                <xsl:value-of select="bbf-qos-plc:name"/>
              </xsl:if>
            </xsl:for-each>
          </xsl:variable>
          <xsl:element name="firstNameInGroup" namespace="urn:bbf:yang:bbf-qos-policing">
            <xsl:value-of select="$firstNameInGroup"/>
          </xsl:element>

          <!-- sourceFinalName-->
          <xsl:variable name="sourceFinalName">
            <xsl:for-each select="//*[             local-name() = 'policing-profile'             and child::*[local-name() = 'counter' and text() = $maxNumber]             and child::*[local-name() = 'sourceName' and text() = $curSourceName]             and parent::*[local-name() = 'policing-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policing']           ]">
              <xsl:sort select="bbf-qos-plc:name" order="descending"/>
              <xsl:if test="position()=1">
                <xsl:value-of select="bbf-qos-plc:name"/>
              </xsl:if>
            </xsl:for-each>
          </xsl:variable>
          <xsl:element name="sourceFinalName" namespace="urn:bbf:yang:bbf-qos-policing">
            <xsl:value-of select="$sourceFinalName"/>
          </xsl:element>

          <!-- finalName-->
          <xsl:choose>
            <xsl:when test="$firstNameInGroup != $sourceFinalName">
              <xsl:element name="finalName" namespace="urn:bbf:yang:bbf-qos-policing">
                <xsl:value-of select="$firstNameInGroup"/>
              </xsl:element>
              <xsl:variable name="isExistSameProfile" select="//*[                   local-name() = 'policing-profile'                   and child::*[local-name() = 'name' and text() = $firstNameInGroup]                   and parent::*[local-name() = 'policing-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policing']               ]"/>
              <xsl:if test="(boolean($isExistSameProfile) and string-length(normalize-space($isExistSameProfile))&gt;0) and not(boolean($curSourceName) and string-length(normalize-space($curSourceName))&gt;0)">
                <wrong-configuration-detected>There is a conflict with the old policing profile name(<xsl:value-of select="$firstNameInGroup"/>).</wrong-configuration-detected>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:element name="finalName" namespace="urn:bbf:yang:bbf-qos-policing">
                <xsl:value-of select="$curSourceName"/>
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
  
  <!-- update source max for classifier profile -->
  <xsl:template match="*[     local-name() = 'classifier-entry'     and parent::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']   ]">
    <xsl:variable name="curSourceName">
      <xsl:value-of select="bbf-qos-cls:sourceName"/>
    </xsl:variable>
    <xsl:variable name="curRealName">
      <xsl:value-of select="bbf-qos-cls:realName"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="boolean($curSourceName) and string-length(normalize-space($curSourceName))&gt;0 and boolean($curRealName) and string-length(normalize-space($curRealName))&gt;0">
        <xsl:copy>
          <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
<!-- sourceMax-->
          <xsl:variable name="classifierSec" select="//*[               local-name() = 'classifier-entry'               and child::*[local-name() = 'sourceName' and text() = $curSourceName]               and parent::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']           ]"/>
          <xsl:variable name="maxNumber">
            <xsl:for-each select="$classifierSec/bbf-qos-cls:counter">
              <xsl:sort select="." order="descending"/>
              <xsl:if test="position()=1">
                <xsl:value-of select="."/>
              </xsl:if>
            </xsl:for-each>
          </xsl:variable>
          <xsl:element name="sourceMax" namespace="urn:bbf:yang:bbf-qos-classifiers">
            <xsl:value-of select="$maxNumber"/>
          </xsl:element>

          <!-- firstNameInGroup-->
          <xsl:variable name="firstNameInGroup">
            <xsl:for-each select="//*[               local-name() = 'classifier-entry'               and parent::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']               and child::*[local-name() = 'realName' and text() = $curRealName]]">
              <xsl:sort select="bbf-qos-cls:name" order="descending"/>
              <xsl:if test="position()=1">
                <xsl:value-of select="bbf-qos-cls:name"/>
              </xsl:if>
            </xsl:for-each>
          </xsl:variable>
          <xsl:element name="firstNameInGroup" namespace="urn:bbf:yang:bbf-qos-classifiers">
            <xsl:value-of select="$firstNameInGroup"/>
          </xsl:element>

          <!-- sourceFinalName-->
          <xsl:variable name="sourceFinalName">
            <xsl:for-each select="//*[               local-name() = 'classifier-entry'               and child::*[local-name() = 'counter' and text() = $maxNumber]               and child::*[local-name() = 'sourceName' and text() = $curSourceName]               and parent::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']             ]">
              <xsl:sort select="bbf-qos-cls:name" order="descending"/>
              <xsl:if test="position()=1">
                <xsl:value-of select="bbf-qos-cls:name"/>
              </xsl:if>
            </xsl:for-each>
          </xsl:variable>
          <xsl:element name="sourceFinalName" namespace="urn:bbf:yang:bbf-qos-classifiers">
            <xsl:value-of select="$sourceFinalName"/>
          </xsl:element>

          <!-- finalName-->
          <xsl:choose>
            <xsl:when test="$firstNameInGroup != $sourceFinalName">
              <xsl:element name="finalName" namespace="urn:bbf:yang:bbf-qos-classifiers">
                <xsl:value-of select="$firstNameInGroup"/>
              </xsl:element>
              <xsl:variable name="isExistSameProfile" select="//*[                   local-name() = 'classifier-entry'                   and child::*[local-name() = 'name' and text() = $firstNameInGroup]                   and parent::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']               ]"/>
              <xsl:if test="(boolean($isExistSameProfile) and string-length(normalize-space($isExistSameProfile))&gt;0) and not(boolean($curSourceName) and string-length(normalize-space($curSourceName))&gt;0)">
                <wrong-configuration-detected>There is a conflict with the old classifier profile name(<xsl:value-of select="$firstNameInGroup"/>).</wrong-configuration-detected>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:element name="finalName" namespace="urn:bbf:yang:bbf-qos-classifiers">
                <xsl:value-of select="$curSourceName"/>
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
  
  <!-- update source max for policy profile -->
  <xsl:template match="*[     local-name() = 'policy'     and parent::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']   ]">
    <xsl:variable name="curSourceName">
      <xsl:value-of select="bbf-qos-pol:sourceName"/>
    </xsl:variable>
    <xsl:variable name="curRealName">
      <xsl:value-of select="bbf-qos-pol:realName"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="boolean($curSourceName) and string-length(normalize-space($curSourceName))&gt;0 and boolean($curRealName) and string-length(normalize-space($curRealName))&gt;0">
        <xsl:copy>
          <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
<!-- sourceMax-->
          <xsl:variable name="policySec" select="//*[               local-name() = 'policy'               and child::*[local-name() = 'sourceName' and text() = $curSourceName]               and parent::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']           ]"/>
          <xsl:variable name="maxNumber">
            <xsl:for-each select="$policySec/bbf-qos-pol:counter">
              <xsl:sort select="." order="descending"/>
              <xsl:if test="position()=1">
                <xsl:value-of select="."/>
              </xsl:if>
            </xsl:for-each>
          </xsl:variable>
          <xsl:element name="sourceMax" namespace="urn:bbf:yang:bbf-qos-policies">
            <xsl:value-of select="$maxNumber"/>
          </xsl:element>

          <!-- firstNameInGroup-->
          <xsl:variable name="firstNameInGroup">
            <xsl:for-each select="//*[               local-name() = 'policy'               and parent::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']               and child::*[local-name() = 'realName' and text() = $curRealName]]">
              <xsl:sort select="bbf-qos-pol:name" order="descending"/>
              <xsl:if test="position()=1">
                <xsl:value-of select="bbf-qos-pol:name"/>
              </xsl:if>
            </xsl:for-each>
          </xsl:variable>
          <xsl:element name="firstNameInGroup" namespace="urn:bbf:yang:bbf-qos-policies">
            <xsl:value-of select="$firstNameInGroup"/>
          </xsl:element>

          <!-- sourceFinalName-->
          <xsl:variable name="sourceFinalName">
            <xsl:for-each select="//*[               local-name() = 'policy'               and child::*[local-name() = 'counter' and text() = $maxNumber]               and child::*[local-name() = 'sourceName' and text() = $curSourceName]               and parent::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']               ]">
              <xsl:sort select="bbf-qos-pol:name" order="descending"/>
              <xsl:if test="position()=1">
                <xsl:value-of select="bbf-qos-pol:name"/>
              </xsl:if>
            </xsl:for-each>
          </xsl:variable>
          <xsl:element name="sourceFinalName" namespace="urn:bbf:yang:bbf-qos-policies">
            <xsl:value-of select="$sourceFinalName"/>
          </xsl:element>

          <!-- finalName-->
          <xsl:choose>
            <xsl:when test="$firstNameInGroup != $sourceFinalName">
              <xsl:element name="finalName" namespace="urn:bbf:yang:bbf-qos-policies">
                <xsl:value-of select="$firstNameInGroup"/>
              </xsl:element>
              <xsl:variable name="isExistSameProfile" select="//*[                   local-name() = 'policy'                   and child::*[local-name() = 'name' and text() = $firstNameInGroup]                   and parent::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']               ]"/>
              <xsl:if test="(boolean($isExistSameProfile) and string-length(normalize-space($isExistSameProfile))&gt;0) and not(boolean($curSourceName) and string-length(normalize-space($curSourceName))&gt;0)">
                <wrong-configuration-detected>There is a conflict with the old policy profile name(<xsl:value-of select="$firstNameInGroup"/>).</wrong-configuration-detected>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:element name="finalName" namespace="urn:bbf:yang:bbf-qos-policies">
                <xsl:value-of select="$curSourceName"/>
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

</xsl:stylesheet>
