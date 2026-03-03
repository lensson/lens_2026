<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:bbf-qos-filt="urn:bbf:yang:bbf-qos-filters"
                xmlns:bbf-qos-enhfilt="urn:bbf:yang:bbf-qos-enhanced-filters"
                xmlns:bbf-qos-pol="urn:bbf:yang:bbf-qos-policies"
                xmlns:bbf-qos-cls="urn:bbf:yang:bbf-qos-classifiers"
                version="1.0">

  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" indent="yes"/>
  
  <xsl:key name="classifierByName" 
      match="*[local-name()='classifier-entry' and parent::*[local-name()='classifiers' and namespace-uri()='urn:bbf:yang:bbf-qos-classifiers']]" 
      use="*[local-name()='name']"/>

  <xsl:key name="enhancedFilterByName" 
      match="*[local-name()='enhanced-filter' and namespace-uri()='urn:bbf:yang:bbf-qos-enhanced-filters']" 
      use="*[local-name()='name']"/>  

  <!-- enum enhanced filter type-->
  <xsl:variable name="F_EN_FILTER_WITHOUT_FLOW_COLOR" select="'F_EN_FILTER_WITHOUT_FLOW_COLOR'"/>
  <xsl:variable name="F_EN_FILTER_FLOW_COLOR" select="'F_EN_FILTER_FLOW_COLOR'"/>
  
  <xsl:variable name="VALID" select="'VALID'"/>
  <xsl:variable name="INVALID" select="'INVALID'"/>
  
  <xsl:variable name="INDEX0" select="'0'"/>
  <xsl:variable name="INDEX1" select="'1'"/>
  
  <xsl:variable name="UNTAGGED" select="'untagged'"/>
  <xsl:variable name="DSCP" select="'dscp'"/>
  <xsl:variable name="DSCPANY" select="'any'"/>
  <xsl:variable name="IGMP" select="'igmp'"/>
  <xsl:variable name="NOSPECIAL" select="'NOSPECIAL'"/>
  <xsl:variable name="NOPBITFILTER" select="'NOPBITFILTER'"/>
  <xsl:variable name="NOPBITACTION" select="'NOPBITACTION'"/>
  <xsl:variable name="ZERO" select="'0'"/>
  <xsl:variable name="ONE" select="'1'"/>

  <!-- default rule -->
  <xsl:template match="*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="*[
    local-name() = 'policy'
    and parent::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']
  ]">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>

      <xsl:element name="policy-migration-cache">
        <xsl:variable name="curPolicyName">
          <xsl:value-of select="child::*[local-name() = 'name']"/>
        </xsl:variable>
        <xsl:element name="name">
          <xsl:value-of select="$curPolicyName"/>
        </xsl:element>

        <xsl:variable name="curPolicy" select="current()"/>

        <xsl:element name="classifiers">
          <xsl:element name="name">
            <xsl:value-of select="$curPolicyName"/>
          </xsl:element>
          <xsl:for-each select="$curPolicy/child::*[local-name() = 'classifiers']">
            <xsl:element name="classifier">
              <xsl:variable name="curClsName">
                <xsl:value-of select="child::*[local-name() = 'name']"/>
              </xsl:variable>
              <xsl:element name="name">
                <xsl:value-of select="$curClsName"/>
              </xsl:element>

              <xsl:variable name="classifier" select="key('classifierByName', $curClsName)"/>

              <xsl:element name="filters">
                <xsl:if test="$classifier/child::*[local-name() = 'enhanced-filter-name' and namespace-uri() = 'urn:bbf:yang:bbf-qos-enhanced-filters']">
                  <xsl:element name="ref-filter">
                    <xsl:variable name="refFilterName">
                      <xsl:value-of select="normalize-space($classifier/child::*[local-name() = 'enhanced-filter-name'])"/>
                    </xsl:variable>
                    <xsl:element name="name">
                      <xsl:value-of select="$refFilterName"/>
                    </xsl:element>

                    <xsl:variable name="enhancedFilter" select="key('enhancedFilterByName', $refFilterName)"/>

                    <xsl:element name="type">
                      <xsl:call-template name="getEnhancedFilterType">
                        <xsl:with-param name="enhancedFilterName" select="$refFilterName"/>
                      </xsl:call-template>
                    </xsl:element>

                    <xsl:variable name="ref" select="$enhancedFilter/child::*[local-name() = 'filter']/child::*[local-name() = 'enhanced-filter-name']"/>

                    <xsl:if test="boolean($ref)">
                      <xsl:element name="ref">
                        <xsl:value-of select="$ref"/>
                      </xsl:element>
                    </xsl:if>
                  </xsl:element>
                </xsl:if>
              </xsl:element>

              <xsl:element name="actions"/>

              <xsl:element name="pbitInfo">
                <!-- get in-pbit-list 0 -->
                <xsl:variable name="inPbit0">
                  <xsl:call-template name="getInpbit">
                    <xsl:with-param name="classifierSec" select="$classifier"/>
                    <xsl:with-param name="inPibtIndex" select="$INDEX0"/>
                  </xsl:call-template>
                </xsl:variable>

                <!-- get in-pbit-list 1 -->
                <xsl:variable name="inPbit1">
                  <xsl:call-template name="getInpbit">
                    <xsl:with-param name="classifierSec" select="$classifier"/>
                    <xsl:with-param name="inPibtIndex" select="$INDEX1"/>
                  </xsl:call-template>
                </xsl:variable>

                <!-- get pbit-marking-list -->
                <xsl:variable name="pbitList">
                  <xsl:call-template name="getPbitList">
                    <xsl:with-param name="classifierSec" select="$classifier"/>
                  </xsl:call-template>
                </xsl:variable>

                <!-- get pbit-marking-cfg 0 -->
                <xsl:variable name="pbitCfg0">
                  <xsl:call-template name="getPbitCfg">
                    <xsl:with-param name="classifierSec" select="$classifier"/>
                    <xsl:with-param name="pbitMarkIndex" select="$INDEX0"/>
                  </xsl:call-template>
                </xsl:variable>

                <!-- get pbit-marking-cfg 1 -->
                <xsl:variable name="pbitCfg1">
                  <xsl:call-template name="getPbitCfg">
                    <xsl:with-param name="classifierSec" select="$classifier"/>
                    <xsl:with-param name="pbitMarkIndex" select="$INDEX1"/>
                  </xsl:call-template>
                </xsl:variable>
				

                <!-- get pbit-from-frame-tag -->
                <xsl:variable name="pbitFromFrameTag">
                  <xsl:call-template name="getPbitFromFrameTag">
                    <xsl:with-param name="classifierSec" select="$classifier"/>
                  </xsl:call-template>
                </xsl:variable>

                <!-- get index of pbit-from-frame-tag -->
                <xsl:variable name="indexOfPbitFromFrameTag">
                  <xsl:call-template name="getIndexOfPbitFromFrameTag">
                    <xsl:with-param name="classifierSec" select="$classifier"/>
                  </xsl:call-template>
                </xsl:variable>
                <!-- get untagged or dscp or igmp -->
                <xsl:variable name="specialCase">
                  <xsl:call-template name="getSpecial">
                    <xsl:with-param name="classifierSec" select="$classifier"/>
                  </xsl:call-template>
                </xsl:variable>

                <xsl:choose>
                  <xsl:when test="not (string-length(normalize-space($pbitCfg0))>0 or string-length(normalize-space($pbitCfg1))>0 or string-length(normalize-space($pbitFromFrameTag))>0)">
                    <xsl:element name="specialCase">
                      <xsl:copy-of select="$NOPBITACTION"/>
                    </xsl:element>
                    <xsl:element name="isValid">
                      <xsl:copy-of select="$VALID"/>
                    </xsl:element>
                  </xsl:when>
                  <xsl:when test="$specialCase=$NOSPECIAL and not (string-length(normalize-space($inPbit0))>0 or string-length(normalize-space($inPbit1))>0 or string-length(normalize-space($pbitList))>0)">
                    <xsl:element name="specialCase">
                      <xsl:copy-of select="$NOPBITFILTER"/>
                    </xsl:element>
                    <xsl:element name="isValid">
                      <xsl:copy-of select="$VALID"/>
                    </xsl:element>
                  </xsl:when>
                  <xsl:when test="string-length(normalize-space($inPbit1))>0">
                    <xsl:element name="isValid">
                      <xsl:copy-of select="$INVALID"/>
                    </xsl:element>
                  </xsl:when>
                  <xsl:when test="($specialCase=$UNTAGGED) or ($specialCase=$DSCP) or ($specialCase=$IGMP)">
                    <xsl:element name="specialCase">
                      <xsl:copy-of select="$specialCase"/>
                    </xsl:element>
                    <xsl:element name="isValid">
                      <xsl:copy-of select="$VALID"/>
                    </xsl:element>
                  </xsl:when>
                  <xsl:when test="string-length(normalize-space($pbitFromFrameTag))>0 and string-length(normalize-space($inPbit0))>0">
                    <xsl:choose>
                      <xsl:when test="normalize-space($indexOfPbitFromFrameTag)=$ZERO and normalize-space($pbitFromFrameTag)=$ONE">
                        <xsl:element name="isValid">
                          <xsl:copy-of select="$INVALID"/>
                        </xsl:element>
                      </xsl:when>
                      <xsl:when test="normalize-space($indexOfPbitFromFrameTag)=$ZERO and normalize-space($pbitFromFrameTag)=$ZERO">
                        <xsl:element name="inpbit0">
                          <xsl:value-of select="$inPbit0"/>
                        </xsl:element>
                        <xsl:element name="isValid">
                          <xsl:copy-of select="$VALID"/>
                        </xsl:element>
                        <xsl:element name="pbitFromFrame">
                          <xsl:copy-of select="$pbitFromFrameTag"/>
                        </xsl:element>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:element name="isValid">
                          <xsl:copy-of select="$INVALID"/>
                        </xsl:element>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:when test="string-length(normalize-space($inPbit0))>1">
                    <xsl:element name="isValid">
                      <xsl:copy-of select="$INVALID"/>
                    </xsl:element>
                  </xsl:when>
                  <xsl:when test="string-length(normalize-space($inPbit0))>0 and string-length(normalize-space($pbitCfg0))>0 and ($inPbit0=$pbitCfg0) and not (string-length(normalize-space($inPbit1))>0) and not (string-length(normalize-space($pbitList))>0) and not (string-length(normalize-space($pbitCfg1))>0)">
                    <xsl:element name="inpbit0">
                      <xsl:value-of select="$inPbit0"/>
                    </xsl:element>

                    <xsl:element name="isValid">
                      <xsl:copy-of select="$VALID"/>
                    </xsl:element>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:element name="isValid">
                      <xsl:copy-of select="$INVALID"/>
                    </xsl:element>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:element>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:element>
    </xsl:copy>
  </xsl:template>

  <!-- =========================== Infra function ========================== -->
  <xsl:template name="getEnhancedFilterType">
    <xsl:param name="enhancedFilterName"/>
    <xsl:variable name="enhancedFilterNameVar">
      <xsl:value-of select="normalize-space($enhancedFilterName)"/>
    </xsl:variable>
	
    <xsl:variable name="enhancedFilter" select="key('enhancedFilterByName', $enhancedFilterNameVar)"/>
	
    <xsl:variable name="flowColorSec"
                  select="$enhancedFilter/child::*[local-name() = 'filter']/child::*[local-name() = 'flow-color']"/>
    <xsl:choose>
      <xsl:when test="boolean($flowColorSec)">
        <xsl:value-of select="$F_EN_FILTER_FLOW_COLOR"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$F_EN_FILTER_WITHOUT_FLOW_COLOR"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="getInpbit">
    <xsl:param name="classifierSec"/>
    <xsl:param name="inPibtIndex"/>
    <xsl:choose>
      <xsl:when test="$classifierSec/child::*[local-name()='match-criteria']/child::*[local-name()='tag']">
        <xsl:variable name="selectedTag" 
             select="$classifierSec/child::*[local-name()='match-criteria']/child::*[local-name()='tag' 
             and child::*[local-name()='index' and text() = $inPibtIndex]]"/>
        <xsl:if test="$selectedTag">
          <xsl:variable name="inPbitListValue" 
               select="$selectedTag/child::*[local-name()='in-pbit-list']"/>
          <xsl:value-of select="$inPbitListValue"/>
        </xsl:if>
      </xsl:when>
      <xsl:when test="$classifierSec/child::*[local-name()='vlans']/child::*[local-name()='tag']">
        <xsl:variable name="selectedTag" 
             select="$classifierSec/child::*[local-name()='vlans']/child::*[local-name()='tag' 
             and child::*[local-name()='index' and text() = $inPibtIndex]]"/>
        <xsl:if test="$selectedTag">
          <xsl:variable name="inPbitListValue" 
               select="$selectedTag/child::*[local-name()='in-pbit-list']"/>
          <xsl:value-of select="$inPbitListValue"/>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="getPbitList">
    <xsl:param name="classifierSec"/>
    <xsl:choose>
      <xsl:when test="$classifierSec/child::*[local-name()='match-criteria']/child::*[local-name()='pbit-marking-list' and namespace-uri()='urn:bbf:yang:bbf-qos-policing']">
        <xsl:variable name="selectedPbitList" 
             select="$classifierSec/child::*[local-name()='match-criteria']/child::*[local-name()='pbit-marking-list' and namespace-uri()='urn:bbf:yang:bbf-qos-policing']"/>
        <xsl:if test="$selectedPbitList">
          <xsl:variable name="pbitListValue" 
               select="$selectedPbitList/child::*[local-name()='pbit-value']"/>
          <xsl:value-of select="$pbitListValue"/>
        </xsl:if>
      </xsl:when>
      <xsl:when test="$classifierSec/child::*[local-name()='pbit-marking-list' and namespace-uri()='urn:bbf:yang:bbf-qos-enhanced-filters']">
        <xsl:variable name="selectedPbitList" 
             select="$classifierSec/child::*[local-name()='pbit-marking-list' and namespace-uri()='urn:bbf:yang:bbf-qos-enhanced-filters']"/>
        <xsl:if test="$selectedPbitList">
          <xsl:variable name="pbitListValue" 
               select="$selectedPbitList/child::*[local-name()='pbit-value']"/>
          <xsl:value-of select="$pbitListValue"/>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="getPbitCfg">
    <xsl:param name="classifierSec"/>
    <xsl:param name="pbitMarkIndex"/>
    <xsl:if test="$classifierSec/child::*[local-name()='classifier-action-entry-cfg']">
      <xsl:variable name="selectedPbitMarkingCfg" 
           select="$classifierSec/child::*[local-name()='classifier-action-entry-cfg']/child::*[local-name()='pbit-marking-cfg']/
           child::*[local-name()='pbit-marking-list' and child::*[local-name()='index' and text() = $pbitMarkIndex]]"/>
      <xsl:if test="$selectedPbitMarkingCfg">
        <xsl:variable name="pbitValue" 
             select="$selectedPbitMarkingCfg/child::*[local-name()='pbit-value']"/>
        <xsl:value-of select="$pbitValue"/>
      </xsl:if>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="getPbitFromFrameTag">
    <xsl:param name="classifierSec"/>
    <xsl:if test="$classifierSec/child::*[local-name()='classifier-action-entry-cfg']">
      <xsl:variable name="selectPbitFromFrameTag" 
           select="$classifierSec/child::*[local-name()='classifier-action-entry-cfg']/child::*[local-name()='pbit-marking-cfg']/
           child::*[local-name()='pbit-marking-list' and child::*[local-name()='pbit-from-frame-tag']]"/>
      <xsl:if test="$selectPbitFromFrameTag">
        <xsl:variable name="valueOfPbitFromFrameTag" 
             select="$selectPbitFromFrameTag/child::*[local-name()='pbit-from-frame-tag']"/>
        <xsl:value-of select="$valueOfPbitFromFrameTag"/>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template name="getIndexOfPbitFromFrameTag">
    <xsl:param name="classifierSec"/>
    <xsl:if test="$classifierSec/child::*[local-name()='classifier-action-entry-cfg']">
      <xsl:variable name="selectIndexOfPbitFromFrameTag" 
           select="$classifierSec/child::*[local-name()='classifier-action-entry-cfg']/child::*[local-name()='pbit-marking-cfg']/
           child::*[local-name()='pbit-marking-list' and child::*[local-name()='index']]"/>
      <xsl:if test="$selectIndexOfPbitFromFrameTag">
        <xsl:variable name="valueOfIndexPbitFromFrameTag" 
             select="$selectIndexOfPbitFromFrameTag/child::*[local-name()='index']"/>
        <xsl:value-of select="$valueOfIndexPbitFromFrameTag"/>
      </xsl:if>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="getUntagged">
    <xsl:param name="classifierSec"/>
    <xsl:choose>
      <xsl:when test="$classifierSec/child::*[local-name()='match-criteria']/child::*[local-name()='untagged']">
        <xsl:value-of select="$UNTAGGED"/>
      </xsl:when>
      <xsl:when test="$classifierSec/child::*[local-name()='vlans' and namespace-uri()='urn:bbf:yang:bbf-qos-enhanced-filters']/child::*[local-name()='untagged']">
        <xsl:value-of select="$UNTAGGED"/>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="getSpecial">
    <xsl:param name="classifierSec"/>
    <xsl:choose>
      <xsl:when test="$classifierSec/child::*[local-name()='match-criteria']/child::*[local-name()='untagged']">
        <xsl:value-of select="$UNTAGGED"/>
      </xsl:when>
      <xsl:when test="$classifierSec/child::*[local-name()='vlans' and namespace-uri()='urn:bbf:yang:bbf-qos-enhanced-filters']/child::*[local-name()='untagged']">
        <xsl:value-of select="$UNTAGGED"/>
      </xsl:when>
      <xsl:when test="$classifierSec/child::*[local-name()='match-criteria']/child::*[local-name()='dscp-range' or local-name()='dscp']">
        <xsl:variable name="dscpRangeValue" 
             select="$classifierSec/child::*[local-name()='match-criteria']/child::*[local-name()='dscp-range']"/>
        <xsl:choose>
          <xsl:when test="string-length(normalize-space($dscpRangeValue))>0 and $dscpRangeValue=$DSCPANY">
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$DSCP"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$classifierSec/child::*[local-name()='ip-common' and namespace-uri()='urn:bbf:yang:bbf-qos-enhanced-filters']/child::*[local-name()='dscp-range' or local-name()='dscp']">
        <xsl:variable name="dscpRangeValue" 
             select="$classifierSec/child::*[local-name()='ip-common' and namespace-uri()='urn:bbf:yang:bbf-qos-enhanced-filters']/child::*[local-name()='dscp-range']"/>
        <xsl:choose>
          <xsl:when test="string-length(normalize-space($dscpRangeValue))>0 and $dscpRangeValue=$DSCPANY">
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$DSCP"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$classifierSec/child::*[local-name()='match-criteria']/child::*[local-name()='protocol']">
        <xsl:variable name="protocolValue" 
             select="$classifierSec/child::*[local-name()='match-criteria']/child::*[local-name()='protocol']"/>
        <xsl:if test="$protocolValue=$IGMP">
          <xsl:value-of select="$IGMP"/>
        </xsl:if>
      </xsl:when>
      <xsl:when test="$classifierSec/child::*[local-name()='protocol' and namespace-uri()='urn:bbf:yang:bbf-qos-enhanced-filters']">
        <xsl:variable name="protocolValue" 
             select="$classifierSec/child::*[local-name()='protocol' and namespace-uri()='urn:bbf:yang:bbf-qos-enhanced-filters']"/>
        <xsl:if test="$protocolValue=$IGMP">
          <xsl:value-of select="$IGMP"/>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$NOSPECIAL"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
