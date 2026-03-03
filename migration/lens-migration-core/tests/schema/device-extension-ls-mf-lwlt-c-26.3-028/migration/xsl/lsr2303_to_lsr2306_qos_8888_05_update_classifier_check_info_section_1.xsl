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
  <xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>


  <!-- enum PolicyType -->
  <xsl:variable name="POLICY_TYPE_MARKER" select="'POLICY_TYPE_MARKER'"/>
  
  <xsl:variable name="VALID" select="'VALID'"/>
  <xsl:variable name="CLASSIFIERDELETE" select="'CLASSIFIERDELETE'"/>
  
  <xsl:variable name="UNTAGGED" select="'untagged'"/>
  <xsl:variable name="DSCP" select="'dscp'"/>
  <xsl:variable name="IGMP" select="'igmp'"/>
  <xsl:variable name="NOPBITFILTER" select="'NOPBITFILTER'"/>
  <xsl:variable name="NOPBITACTION" select="'NOPBITACTION'"/>
  <xsl:variable name="SEPARATOR1" select="','"/>
  <xsl:variable name="SEPARATOR2" select="'-'"/>
  <xsl:variable name="ZERO" select="'0'"/>
  <xsl:variable name="ONE" select="'1'"/>
  
  <xsl:variable name="PBIT0" select="'0'"/>
  <xsl:variable name="PBIT1" select="'1'"/>
  <xsl:variable name="PBIT2" select="'2'"/>
  <xsl:variable name="PBIT3" select="'3'"/>
  <xsl:variable name="PBIT4" select="'4'"/>
  <xsl:variable name="PBIT5" select="'5'"/>
  <xsl:variable name="PBIT6" select="'6'"/>
  <xsl:variable name="PBIT7" select="'7'"/>

  <!-- default rule -->
  <xsl:template match="*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!-- insert delete flag into classifier node in policy -->
  <xsl:template match="*[
    local-name() = 'classifier'
    and parent::*[local-name() = 'classifiers']
    and ancestor::*[local-name() = 'policy-migration-cache']
    and ancestor::*[local-name() = 'policy']
    and ancestor::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']
  ]">
    <xsl:variable name="classifiersSec" select="parent::*[local-name() = 'classifiers']"/>
    <xsl:variable name="isNeedToCheck" select="current()/pbitInfo/isValid"/>
    <xsl:variable name="hasPbitFromFrame" select="./pbitInfo/pbitFromFrame"/>

    <!-- check the policy whether has full pbit configuration -->
    <xsl:variable name="pbitStrInPolicy">
      <xsl:for-each select="$classifiersSec/classifier">
        <xsl:variable name="isValid" select="./pbitInfo/isValid"/>
        <xsl:variable name="isPbitFromFrame" select="./pbitInfo/pbitFromFrame"/>
        <xsl:variable name="curClassifierPbit" select="./pbitInfo/inpbit0"/>

        <xsl:choose>
          <xsl:when test="$isValid=$VALID and not (string-length(normalize-space($isPbitFromFrame))>0)">
            <xsl:if test="string-length(normalize-space($curClassifierPbit))>0">
              <xsl:value-of select="concat(pbitStrInPolicy,' ',$curClassifierPbit)"/>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:variable>

    <!-- check the policy whether has full pbit list configuration -->
    <xsl:variable name="pbitListStrInPolicy">
      <xsl:for-each select="$classifiersSec/classifier">
        <xsl:variable name="isValid" select="./pbitInfo/isValid"/>
        <xsl:variable name="isPbitFromFrame" select="./pbitInfo/pbitFromFrame"/>
        <xsl:variable name="curClassifierPbitList" select="./pbitInfo/inpbit0"/>

        <xsl:choose>
          <xsl:when test="$isValid=$VALID and string-length(normalize-space($isPbitFromFrame))>0">
            <xsl:if test="string-length(normalize-space($curClassifierPbitList))>0">
              <xsl:variable name="pbitListStr">
                <xsl:call-template name="parsePbitList">
                  <xsl:with-param name="pbitList" select="$curClassifierPbitList"/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:value-of select="concat(pbitListStrInPolicy,' ',$pbitListStr)"/>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:variable>

    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
      <xsl:choose>
        <xsl:when test="$isNeedToCheck=$VALID">
          <xsl:variable name="specialcase" select="current()/pbitInfo/specialCase"/>
          <xsl:if test="not (($specialcase=$UNTAGGED) or ($specialcase=$DSCP) or ($specialcase=$IGMP) or ($specialcase=$NOPBITACTION) or ($specialcase=$NOPBITFILTER))">
            <xsl:variable name="isNeedToDelete">
              <xsl:choose>
                <xsl:when test="string-length(normalize-space($hasPbitFromFrame))>0">
                  <xsl:value-of select="not (contains($pbitListStrInPolicy,$PBIT0) and contains($pbitListStrInPolicy,$PBIT1) and 
                              contains($pbitListStrInPolicy,$PBIT2) and contains($pbitListStrInPolicy,$PBIT3) and 
                              contains($pbitListStrInPolicy,$PBIT4) and contains($pbitListStrInPolicy,$PBIT5) and 
                              contains($pbitListStrInPolicy,$PBIT6) and contains($pbitListStrInPolicy,$PBIT7))"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="not (contains($pbitStrInPolicy,$PBIT0) and contains($pbitStrInPolicy,$PBIT1) and 
                              contains($pbitStrInPolicy,$PBIT2) and contains($pbitStrInPolicy,$PBIT3) and 
                              contains($pbitStrInPolicy,$PBIT4) and contains($pbitStrInPolicy,$PBIT5) and 
                              contains($pbitStrInPolicy,$PBIT6) and contains($pbitStrInPolicy,$PBIT7))"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <xsl:if test="$isNeedToDelete='true'">
              <xsl:element name="delete">
                <xsl:value-of select="$CLASSIFIERDELETE"/>
              </xsl:element>
            </xsl:if>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:element name="delete">
            <xsl:value-of select="$CLASSIFIERDELETE"/>
          </xsl:element>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template name="parsePbitList">
    <xsl:param name="pbitList"/>
      <xsl:if test="not($pbitList = '')">
        <xsl:variable name="firstChar" select="substring($pbitList,1,1)" />
        <xsl:variable name="secondChar" select="substring($pbitList,2,1)" />
        <xsl:variable name="thirdChar" select="substring($pbitList,3,1)" />
        <xsl:choose>
          <xsl:when test="$secondChar=$SEPARATOR1">
            <xsl:variable name="head" select="$firstChar" />
            <xsl:variable name="toBeProcess" select="substring($pbitList,3)" />
            <xsl:value-of select="$head"/>
            <xsl:call-template name="parsePbitList">
              <xsl:with-param name="pbitList" select="$toBeProcess"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$secondChar=$SEPARATOR2">
            <xsl:variable name="max" select="$firstChar" />
            <xsl:variable name="min" select="$thirdChar" />
            <xsl:variable name="toBeProcess" select="substring($pbitList,5)" />

            <xsl:variable name="pbitRanges">
              <xsl:choose>
                <xsl:when test="$max > $min">
                  <xsl:variable name="temp"> 
                    <xsl:call-template name="getPbitRange">
                      <xsl:with-param name="upper" select="$max"/>
                      <xsl:with-param name="lower" select="$min"/>
                    </xsl:call-template>
                  </xsl:variable>
                  <xsl:value-of select="$temp"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:variable name="temp">
                    <xsl:call-template name="getPbitRange">
                      <xsl:with-param name="upper" select="$min"/>
                      <xsl:with-param name="lower" select="$max"/>
                    </xsl:call-template>
                  </xsl:variable>
                  <xsl:value-of select="$temp"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <xsl:value-of select="$pbitRanges"/>
            <xsl:if test="not($toBeProcess = '')">
              <xsl:call-template name="parsePbitList">
                <xsl:with-param name="pbitList" select="$toBeProcess"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$firstChar"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
  </xsl:template>
  
  <xsl:template name="getPbitRange">
    <xsl:param name="upper"/>
    <xsl:param name="lower"/>
      <xsl:value-of select="$upper"/>
      <xsl:if test="$upper > $lower">
        <xsl:call-template name="getPbitRange">
          <xsl:with-param name="upper" select="$upper - 1"/>
          <xsl:with-param name="lower" select="$lower"/>
        </xsl:call-template>
      </xsl:if>
  </xsl:template>

</xsl:stylesheet>
