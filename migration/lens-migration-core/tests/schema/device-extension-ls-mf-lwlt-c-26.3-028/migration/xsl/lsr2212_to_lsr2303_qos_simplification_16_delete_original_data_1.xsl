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

  <!--delete old data if new data has generated.-->
  <xsl:template match="*[     local-name() = 'policing-profile'     and parent::*[local-name() = 'policing-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policing']   ]">
    <xsl:variable name="curName">
      <xsl:value-of select="./bbf-qos-plc:name"/>
    </xsl:variable>
    <xsl:variable name="curRealName">
      <xsl:value-of select="./bbf-qos-plc:realName"/>
    </xsl:variable>
    <xsl:variable name="isExistSameProfile" select="//*[         local-name() = 'policing-profile'         and child::*[local-name() = 'finalName' and text() = $curName]         and parent::*[local-name() = 'policing-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policing']     ]"/>

    <xsl:variable name="curFinalName">
      <xsl:value-of select="./bbf-qos-plc:finalName"/>
    </xsl:variable>
    <xsl:variable name="hasConflict" select="//*[         local-name() = 'policing-profile'         and child::*[local-name() = 'finalName' and text() = $curFinalName]         and child::*[local-name() = 'realName' and text() != $curRealName]         and parent::*[local-name() = 'policing-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policing']     ]"/>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
<xsl:if test="boolean($hasConflict) and string-length(normalize-space($hasConflict))&gt;0">
        <wrong-configuration-detected>There is a conflict with the policing profile name(<xsl:value-of select="$curFinalName"/>).</wrong-configuration-detected>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="(boolean($isExistSameProfile) and string-length(normalize-space($isExistSameProfile))&gt;0) and not(boolean($curRealName) and string-length(normalize-space($curRealName))&gt;0)">
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
</xsl:otherwise>
      </xsl:choose>
	</xsl:copy>
  </xsl:template>

  <!--delete old data if new data has generated.-->
  <xsl:template match="*[     local-name() = 'classifier-entry'     and parent::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']   ]">
    <xsl:variable name="curName">
      <xsl:value-of select="./bbf-qos-cls:name"/>
    </xsl:variable>
    <xsl:variable name="curRealName">
      <xsl:value-of select="./bbf-qos-cls:realName"/>
    </xsl:variable>
    <xsl:variable name="isExistSameProfile" select="//*[         local-name() = 'classifier-entry'         and child::*[local-name() = 'finalName' and text() = $curName]         and parent::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']     ]"/>

    <xsl:variable name="curFinalName">
      <xsl:value-of select="./bbf-qos-cls:finalName"/>
    </xsl:variable>
    <xsl:variable name="hasConflict" select="//*[         local-name() = 'classifier-entry'         and child::*[local-name() = 'finalName' and text() = $curFinalName]         and child::*[local-name() = 'realName' and text() != $curRealName]         and parent::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']     ]"/>

    <xsl:copy>
      <xsl:copy-of select="@*"/>
<xsl:if test="boolean($hasConflict) and string-length(normalize-space($hasConflict))&gt;0">
        <wrong-configuration-detected>There is a conflict with the classifier profile name(<xsl:value-of select="$curFinalName"/>).</wrong-configuration-detected>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="(boolean($isExistSameProfile) and string-length(normalize-space($isExistSameProfile))&gt;0) and not(boolean($curRealName) and string-length(normalize-space($curRealName))&gt;0)">
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
</xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>
  
  <!--delete old data if new data has generated.-->
  <xsl:template match="*[     local-name() = 'policy'     and parent::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']   ]">
    <xsl:variable name="curName">
      <xsl:value-of select="./bbf-qos-pol:name"/>
    </xsl:variable>
    <xsl:variable name="curRealName">
      <xsl:value-of select="./bbf-qos-pol:realName"/>
    </xsl:variable>
    <xsl:variable name="isExistSameProfile" select="//*[         local-name() = 'policy'         and child::*[local-name() = 'finalName' and text() = $curName]         and parent::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']     ]"/>

    <xsl:variable name="curFinalName">
      <xsl:value-of select="./bbf-qos-pol:finalName"/>
    </xsl:variable>
    <xsl:variable name="hasConflict" select="//*[         local-name() = 'policy'         and child::*[local-name() = 'finalName' and text() = $curFinalName]         and child::*[local-name() = 'realName' and text() != $curRealName]         and parent::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']     ]"/>

    <xsl:copy>
      <xsl:copy-of select="@*"/>
<xsl:if test="boolean($hasConflict) and string-length(normalize-space($hasConflict))&gt;0">
        <wrong-configuration-detected>There is a conflict with the policy profile name(<xsl:value-of select="$curFinalName"/>).</wrong-configuration-detected>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="(boolean($isExistSameProfile) and string-length(normalize-space($isExistSameProfile))&gt;0) and not(boolean($curRealName) and string-length(normalize-space($curRealName))&gt;0)">
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
</xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
