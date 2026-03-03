<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cfgNs="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:bbf-qos-filt="urn:bbf:yang:bbf-qos-filters" xmlns:bbf-qos-enhfilt="urn:bbf:yang:bbf-qos-enhanced-filters" xmlns:bbf-qos-pol="urn:bbf:yang:bbf-qos-policies" xmlns:bbf-qos-cls="urn:bbf:yang:bbf-qos-classifiers" xmlns:bbf-qos-plc="urn:bbf:yang:bbf-qos-policing" xmlns:nokia-qos-filt="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-qos-filters-ext" xmlns:nokia-sdan-qos-policing-extension="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension" xmlns:nokia-qos-cls-ext="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-classifier-extension" xmlns="" version="1.0">

  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>

  <!-- enum Policing type -->
  <xsl:variable name="POLICING_TYPE_TRTCM_MEF_COLOR_BLIND" select="'POLICING_TYPE_TRTCM_MEF_COLOR_BLIND'"/>
  <xsl:variable name="POLICING_TYPE_TRTCM_MEF_COLOR_AWARE" select="'POLICING_TYPE_TRTCM_MEF_COLOR_AWARE'"/>

  <xsl:variable name="POLICING_TYPE_TRTCM_COS" select="'POLICING_TYPE_TRTCM_COS'"/>
  <xsl:variable name="POLICING_TYPE_TRTCM_MEF_COS" select="'POLICING_TYPE_TRTCM_MEF_COS'"/>
  <xsl:variable name="POLICING_TYPE_STB" select="'POLICING_TYPE_STB'"/>

  <!-- Color mode -->
  <xsl:variable name="color-blind" select="'color-blind'"/>
  <xsl:variable name="color-aware" select="'color-aware'"/>

  <!-- Filter Type enumeration -->
  <!-- Inline filter enumeration -->
  <xsl:variable name="F_MATCH_ALL" select="'F_MATCH_ALL'"/>
  <xsl:variable name="F_ANY_PROTOCOL" select="'F_ANY_PROTOCOL'"/>
  <xsl:variable name="F_PRECEDENC_RANGE" select="'F_PRECEDENC_RANGE'"/>
  <xsl:variable name="F_UNMETERED" select="'F_UNMETERED'"/>
  <!-- inline and enhanced-classifier in common -->
  <xsl:variable name="F_UNTAGGED" select="'F_UNTAGGED'"/>
  <xsl:variable name="F_FLOW_COLOR" select="'F_FLOW_COLOR'"/>
  <xsl:variable name="F_DSCP_RANGE" select="'F_DSCP_RANGE'"/>
  <xsl:variable name="F_DSCP_ANY" select="'F_DSCP_ANY'"/>
  <xsl:variable name="F_PROTOCOL_IGMP" select="'F_PROTOCOL_IGMP'"/>
  <xsl:variable name="F_PROTOCOL_NOT_IGMP" select="'F_PROTOCOL_NOT_IGMP'"/>
  <xsl:variable name="F_IN_PBIT_LIST" select="'F_IN_PBIT_LIST'"/>
  <xsl:variable name="F_IN_DEI" select="'F_IN_DEI'"/>
  <xsl:variable name="F_PBIT_MARKING" select="'F_PBIT_MARKING'"/>
  <xsl:variable name="F_DEI_MARKING" select="'F_DEI_MARKING'"/>
  <!-- any frame filter enumeration -->
  <xsl:variable name="F_ANY_FRAME" select="'F_ANY_FRAME'"/>

  <!-- enhanced classifier enumeration -->
  <xsl:variable name="F_EN_SOURCE_MAC" select="'F_EN_SOURCE_MAC'"/>
  <xsl:variable name="F_EN_DEST_MAC" select="'F_EN_DEST_MAC'"/>
  <xsl:variable name="F_EN_ETHERNET_FRAME_TYPE" select="'F_EN_ETHERNET_FRAME_TYPE'"/>
  <xsl:variable name="F_EN_ETHERNET_FRAME_TYPE_IPV4" select="'F_EN_ETHERNET_FRAME_TYPE_IPV4'"/>
  <xsl:variable name="F_EN_ETHERNET_FRAME_TYPE_IPV6" select="'F_EN_ETHERNET_FRAME_TYPE_IPV6'"/>
  <xsl:variable name="F_EN_ETHERNET_FRAME_TYPE_PPPOE" select="'F_EN_ETHERNET_FRAME_TYPE_PPPOE'"/>
  <xsl:variable name="F_EN_ETHERNET_FRAME_TYPE_UNKNOWN" select="'F_EN_ETHERNET_FRAME_TYPE_UNKNOWN'"/>
  <xsl:variable name="F_EN_IPV4" select="'F_EN_IPV4'"/>
  <xsl:variable name="F_EN_IPV6" select="'F_EN_IPV6'"/>
  <xsl:variable name="F_EN_IP_COMMON_DSCP" select="'F_EN_IP_COMMON_DSCP'"/>
  <xsl:variable name="F_EN_IP_COMMON_IGMP" select="'F_EN_IP_COMMON_IGMP'"/>
  <xsl:variable name="F_EN_IP_COMMON_NOT_DSCP_DSCPRANGE_IGMP" select="'F_EN_IP_COMMON_NOT_DSCP_DSCPRANGE_IGMP'"/>
  <xsl:variable name="F_EN_TRANSPORT" select="'F_EN_TRANSPORT'"/>
  <xsl:variable name="F_PROTOCOL_ARP" select="'F_PROTOCOL_ARP'"/>
  <xsl:variable name="F_UNKNOWN" select="'F_UNKNOWN'"/>

  <!-- Classifier Action Type enumeration -->
  <xsl:variable name="A_PBIT_MARKING" select="'A_PBIT_MARKING'"/>
  <xsl:variable name="A_DEI_MARKING" select="'A_DEI_MARKING'"/>
  <xsl:variable name="A_DSCP_MARKING" select="'A_DSCP_MARKING'"/>
  <xsl:variable name="A_SCHEDULING_TRAFFIC" select="'A_SCHEDULING_TRAFFIC'"/>
  <xsl:variable name="A_FLOW_COLOR" select="'A_FLOW_COLOR'"/>
  <xsl:variable name="A_BAC_COLOR" select="'A_BAC_COLOR'"/>
  <xsl:variable name="A_DISCARD" select="'A_DISCARD'"/>
  <xsl:variable name="A_POLICING" select="'A_POLICING'"/>
  <xsl:variable name="A_PASS" select="'A_PASS'"/>
  <xsl:variable name="A_RATE_LIMIT" select="'A_RATE_LIMIT'"/>
  <xsl:variable name="A_PBIT_POLICING_TC" select="'A_PBIT_POLICING_TC'"/>
  <xsl:variable name="A_COUNT" select="'A_COUNT'"/>
  <xsl:variable name="A_UNKNOWN" select="'A_UNKNOWN'"/>

  <!-- filter-operation enumeration -->
  <xsl:variable name="OPER_MATCH_ANY" select="'OPER_MATCH_ANY'"/>
  <xsl:variable name="OPER_MATCH_ALL" select="'OPER_MATCH_ALL'"/>
  <xsl:variable name="OPER_UNKNOWN" select="'OPER_UNKNOWN'"/>
  <!-- ip common protocol value enumeration -->
  <xsl:variable name="PROTOCAL_IGMP_IN_IP_HEAD" select="'2'"/>

  <!-- Classifier Type -->
  <!-- type 1 -->
  <xsl:variable name="CLS_TYPE_IGMP_TO_PBITMARKING" select="'CLS_TYPE_IGMP_TO_PBITMARKING'"/>
  <xsl:variable name="CLS_TYPE_UNTAGGED_TO_PBITMARKING" select="'CLS_TYPE_UNTAGGED_TO_PBITMARKING'"/>
  <xsl:variable name="CLS_TYPE_PBIT_TO_PBITMARKING" select="'CLS_TYPE_PBIT_TO_PBITMARKING'"/>
  <xsl:variable name="CLS_TYPE_DSCP_TO_PBITMARKING" select="'CLS_TYPE_DSCP_TO_PBITMARKING'"/>
  <!-- type 2 -->
  <xsl:variable name="CLS_TYPE_ACTION_FLOW_COLOR" select="'CLS_TYPE_ACTION_FLOW_COLOR'"/>
  <!-- type 3 -->
  <xsl:variable name="CLS_TYPE_PBIT_TO_POLICING_TC" select="'CLS_TYPE_PBIT_TO_POLICING_TC'"/>
  <!-- type 4 -->
  <xsl:variable name="CLS_TYPE_ACTION_WITH_POLICING" select="'CLS_TYPE_ACTION_WITH_POLICING'"/>
  <xsl:variable name="CLS_TYPE_ACTION_WITH_PASS" select="'CLS_TYPE_ACTION_WITH_PASS'"/>
  <xsl:variable name="CLS_TYPE_ACTION_WITH_DISCARD" select="'CLS_TYPE_ACTION_WITH_DISCARD'"/>
  <xsl:variable name="CLS_TYPE_ACTION_WITH_PBITMARKING_AND_FLOWCOLOR" select="'CLS_TYPE_ACTION_WITH_PBITMARKING_AND_FLOWCOLOR'"/>
  <xsl:variable name="CLS_TYPE_EN_FILTER_WITHOUT_FLOW_COLOR" select="'CLS_TYPE_EN_FILTER_WITHOUT_FLOW_COLOR'"/>
  <xsl:variable name="CLS_TYPE_EN_CLS_WITH_MAC_OR_IP_OR_PORT" select="'CLS_TYPE_EN_CLS_WITH_MAC_OR_IP_OR_PORT'"/>
  <xsl:variable name="CLS_TYPE_FILTER_WITH_PROTOCAL_NOT_IGMP" select="'CLS_TYPE_FILTER_WITH_PROTOCAL_NOT_IGMP'"/>
  <xsl:variable name="CLS_TYPE_DEI_MARKING_OR_IN_DEI_TO_PBIT_MARKING" select="'CLS_TYPE_DEI_MARKING_OR_IN_DEI_TO_PBIT_MARKING'"/>
  <xsl:variable name="CLS_TYPE_FILTER_MORE_THAN_TWO_TYPE_OF_ANYFRAME_DSCP_IGMP_PBIT" select="'CLS_TYPE_FILTER_MORE_THAN_TWO_TYPE_OF_ANYFRAME_DSCP_IGMP_PBIT'"/>
  <!-- type 5 -->
  <xsl:variable name="CLS_TYPE_UNMETERED_TO_POLICING" select="'CLS_TYPE_UNMETERED_TO_POLICING'"/>
  <xsl:variable name="CLS_TYPE_MATCHALL_TO_POLICING" select="'CLS_TYPE_MATCHALL_TO_POLICING'"/>
  <xsl:variable name="CLS_TYPE_ANYFRAME_CLS_TO_POLICING" select="'CLS_TYPE_ANYFRAME_CLS_TO_POLICING'"/>
  <!-- type 6 -->
  <xsl:variable name="CLS_TYPE_EN_FILTER_WITH_FOLOW_COLOR" select="'CLS_TYPE_EN_FILTER_WITH_FOLOW_COLOR'"/>
  <xsl:variable name="CLS_TYPE_FILTER_WITH_FLOW_COLOR" select="'CLS_TYPE_FILTER_WITH_FLOW_COLOR'"/>
  <!-- type 7 -->
  <xsl:variable name="CLS_TYPE_ACTION_COUNT" select="'CLS_TYPE_ACTION_COUNT'"/>
  <!-- type 8 -->
  <xsl:variable name="CLS_TYPE_ACTION_WITH_SCHEDULING_TC" select="'CLS_TYPE_ACTION_WITH_SCHEDULING_TC'"/>
  <!-- type 9 -->
  <xsl:variable name="CLS_TYPE_MATCHALL_TO_RATE_LIMIT" select="'CLS_TYPE_MATCHALL_TO_RATE_LIMIT'"/>
  <!-- type 10 -->
  <xsl:variable name="CLS_TYPE_ACTION_QUEUE_COLOR" select="'CLS_TYPE_ACTION_QUEUE_COLOR'"/>
  <!-- unknown type -->
  <xsl:variable name="CLS_TYPE_INVALID" select="'CLS_TYPE_INVALID'"/>

  <!-- enum PolicyType -->
  <xsl:variable name="POLICY_TYPE_MARKER" select="'POLICY_TYPE_MARKER'"/>
  <xsl:variable name="POLICY_TYPE_COLOR" select="'POLICY_TYPE_COLOR'"/>
  <xsl:variable name="POLICY_TYPE_CCL" select="'POLICY_TYPE_CCL'"/>
  <xsl:variable name="POLICY_TYPE_PORT_POLICER" select="'POLICY_TYPE_PORT_POLICER'"/>
  <xsl:variable name="POLICY_TYPE_ACTION" select="'POLICY_TYPE_ACTION'"/>
  <xsl:variable name="POLICY_TYPE_SCHEDULE" select="'POLICY_TYPE_SCHEDULE'"/>
  <xsl:variable name="POLICY_TYPE_RATE_LIMIT" select="'POLICY_TYPE_RATE_LIMIT'"/>
  <xsl:variable name="POLICY_TYPE_PBIT_POLICING_TC" select="'POLICY_TYPE_PBIT_POLICING_TC'"/>
  <xsl:variable name="POLICY_TYPE_COUNT" select="'POLICY_TYPE_COUNT'"/>
  <xsl:variable name="POLICY_TYPE_INVALID" select="'POLICY_TYPE_INVALID'"/>
  <!-- New Definition of PolicyType-->
  <xsl:variable name="POLICY_TYPE_QUEUE_COLOR" select="'POLICY_TYPE_QUEUE_COLOR'"/>

  <!-- Naming rule type enumeration -->
  <xsl:variable name="NAMING_RULE_GENERIC" select="'NAMING_RULE_GENERIC'"/>
  <xsl:variable name="NAMING_RULE_BOTH_IN_CCL_AND_MARKER_POLICY_CLASSIFIER" select="'NAMING_RULE_BOTH_IN_CCL_AND_MARKER_POLICY_CLASSIFIER'"/>
  <xsl:variable name="NAMING_RULE_GENERIC_WITHOUT_PROFILE_NAME" select="'NAMING_RULE_GENERIC_WITHOUT_PROFILE_NAME'"/>
  <xsl:variable name="NAMING_RULE_QC_POLICY" select="'NAMING_RULE_QC_POLICY'"/>
  <xsl:variable name="NAMING_RULE_QC_CLASSIFIER" select="'NAMING_RULE_QC_CLASSIFIER'"/>
  <xsl:variable name="NAMING_RULE_ACTION_PROFILE_FOR_STB" select="'NAMING_RULE_ACTION_PROFILE_FOR_STB'"/>
  <xsl:variable name="NAMING_RULE_PREHANDLING_ENTRY" select="'NAMING_RULE_PREHANDLING_ENTRY'"/>

  <xsl:variable name="TILDE" select="'~'"/>

  <!-- default rule -->
  <xsl:template match="*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!-- Label unused policy which will be deleted in step 8 -->
  <xsl:template match="*[     local-name() = 'policy'     and parent::*[local-name() = 'policies']     and ancestor::*[local-name() = 'current']     and ancestor::*[local-name() = 'migration-cache']     and ancestor::*[local-name() = 'policy-profile' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']     and ancestor::*[local-name() = 'qos-policy-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']     and (normalize-space(child::*[local-name() = 'policy-type']) = 'POLICY_TYPE_CCL'       or normalize-space(child::*[local-name() = 'policy-type']) = 'POLICY_TYPE_PORT_POLICER'       or normalize-space(child::*[local-name() = 'policy-type']) = 'POLICY_TYPE_ACTION'       or normalize-space(child::*[local-name() = 'policy-type']) = 'POLICY_TYPE_COLOR'       or normalize-space(child::*[local-name() = 'policy-type']) = 'POLICY_TYPE_PBIT_POLICING_TC'       or normalize-space(child::*[local-name() = 'policy-type']) = 'POLICY_TYPE_SCHEDULE')   ]">
    <xsl:variable name="curActionPolicyOfQueueColorSec" select="../policy[       policy-type = $POLICY_TYPE_ACTION       and boolean(classifiers/classifier/classifier-type = $CLS_TYPE_ACTION_QUEUE_COLOR)     ]"/>
    <xsl:variable name="curSchedulePolicyOfQueueColorSec" select="../policy[       policy-type = $POLICY_TYPE_SCHEDULE       and boolean(classifiers/classifier/actions/action = $A_BAC_COLOR)     ]"/>
    <xsl:variable name="curPortPolicerPolicySec" select="../policy[       policy-type = $POLICY_TYPE_PORT_POLICER     ]"/>
    <xsl:variable name="isCCLPolicy" select="child::*[local-name() = 'policy-type' and text() = $POLICY_TYPE_CCL]"/>

    <xsl:variable name="enhancedFiltersSec" select="../../child::*[local-name() = 'enhanced-filters']"/>

    <!-- PreColor Policy to new policing pre-handling profile -->
    <xsl:variable name="curPreColorPolicySec" select="../policy[       normalize-space(policy-type) = $POLICY_TYPE_COLOR       and boolean(classifiers/classifier/classifier-type = $CLS_TYPE_ACTION_FLOW_COLOR)     ]"/>
    <xsl:variable name="curPolicingTCPolicySec" select="../policy[       normalize-space(policy-type) = $POLICY_TYPE_PBIT_POLICING_TC     ]"/>
    <xsl:variable name="curActionPolicySec" select="../policy[       policy-type = $POLICY_TYPE_ACTION     ]"/>

    <xsl:variable name="classifierNameOfActionProfile4PortPolicerPolicy">
      <xsl:for-each select="$curActionPolicySec/classifiers/classifier[contains(filters/self-filter-types, $F_FLOW_COLOR) and contains(filters/inline-filter-type, $F_FLOW_COLOR) and boolean(filters/self-filter-flow-color)]">
        <xsl:variable name="curClassifierName">
          <xsl:value-of select="current()/child::*[local-name() = 'name']"/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="position() != 1">
            <xsl:value-of select="concat(classifierNameOfActionProfile4PortPolicerPolicy,'_',$curClassifierName)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$curClassifierName"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="isCCLPolicyChange">
      <xsl:if test="$isCCLPolicy">
        <xsl:call-template name="isCCLPolicyChange">
          <xsl:with-param name="curCCLPolicySec" select="current()"/>
          <xsl:with-param name="enhancedFiltersSec" select="$enhancedFiltersSec"/>
          <xsl:with-param name="curPreColorPolicySec" select="$curPreColorPolicySec"/>
          <xsl:with-param name="curPolicingTCPolicySec" select="$curPolicingTCPolicySec"/>
          <xsl:with-param name="classifierNameOfActionProfile4PortPolicerPolicy" select="$classifierNameOfActionProfile4PortPolicerPolicy"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:variable>

    <xsl:variable name="isPortPolicerPolicy" select="child::*[local-name() = 'policy-type' and text() = $POLICY_TYPE_PORT_POLICER]"/>

    <xsl:variable name="isPortPolicerPolicyChange">
      <xsl:call-template name="isPortPolicerPolicyChange">
        <xsl:with-param name="curPortPolicerPolicySec" select="$curPortPolicerPolicySec"/>
        <xsl:with-param name="curPreColorPolicySec" select="$curPreColorPolicySec"/>
        <xsl:with-param name="curPolicingTCPolicySec" select="$curPolicingTCPolicySec"/>
        <xsl:with-param name="classifierNameOfActionProfile4PortPolicerPolicy" select="$classifierNameOfActionProfile4PortPolicerPolicy"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="isPrecolorPolicy" select="child::*[local-name() = 'policy-type' and text() = $POLICY_TYPE_COLOR]"/>
    <xsl:variable name="isActionPolicy" select="child::*[local-name() = 'policy-type' and text() = $POLICY_TYPE_ACTION]"/>
    <xsl:variable name="isPolicingTCPolicy" select="child::*[local-name() = 'policy-type' and text() = $POLICY_TYPE_PBIT_POLICING_TC]"/>
    <xsl:choose>
      <xsl:when test="$curActionPolicyOfQueueColorSec or $curSchedulePolicyOfQueueColorSec       or $isPortPolicerPolicyChange = 'true' or $isCCLPolicyChange = 'true'       or $isPrecolorPolicy or $isActionPolicy or isPolicingTCPolicy">
        <xsl:choose>
          <xsl:when test="$isCCLPolicy and $isCCLPolicyChange = 'true'">
            <xsl:copy>
              <xsl:copy-of select="@*"/>
              <xsl:apply-templates/>
              <xsl:variable name="isPolicingInPolicy" select="current()/classifiers/classifier/actions/action/type[text()='A_POLICING']"/>
              <xsl:choose>
                <xsl:when test="not(boolean($isPolicingInPolicy) and string-length(normalize-space($isPolicingInPolicy))&gt;0)">
                </xsl:when>
                <xsl:otherwise>
                  <xsl:element name="deleted"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:copy>
          </xsl:when>
          <xsl:when test="$isPortPolicerPolicy and $isPortPolicerPolicyChange = 'true'">
            <xsl:copy>
              <xsl:copy-of select="@*"/>
              <xsl:apply-templates/>
              <xsl:element name="deleted"/>
            </xsl:copy>
          </xsl:when>
          <xsl:when test="$isPrecolorPolicy">
            <xsl:copy>
              <xsl:copy-of select="@*"/>
              <xsl:apply-templates/>
              <xsl:element name="deleted"/>
            </xsl:copy>
          </xsl:when>
          <xsl:when test="$isActionPolicy">
            <xsl:copy>
              <xsl:copy-of select="@*"/>
              <xsl:apply-templates/>
              <xsl:element name="deleted"/>
            </xsl:copy>
          </xsl:when>
          <xsl:when test="$isPolicingTCPolicy">
            <xsl:copy>
              <xsl:copy-of select="@*"/>
              <xsl:apply-templates/>
              <xsl:element name="deleted"/>
            </xsl:copy>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy>
              <xsl:copy-of select="@*"/>
              <xsl:apply-templates/>
            </xsl:copy>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:apply-templates/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <!-- Main Function to create new qos model in every policy-profile cache -->
  <xsl:template match="*[     local-name() = 'migration-cache'     and parent::*[local-name() = 'policy-profile']     and ancestor::*[local-name() = 'qos-policy-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']   ]">
    <xsl:variable name="originProfileName">
      <xsl:value-of select="../*[local-name() = 'name']"/>
    </xsl:variable>
    <xsl:variable name="profileName">
      <xsl:value-of select="../*[local-name() = 'name']"/>
    </xsl:variable>
    <xsl:variable name="cur" select="child::*[local-name() = 'current']"/>
    <xsl:variable name="enhancedFiltersSec" select="$cur/child::*[local-name() = 'enhanced-filters']"/>

    <!-- PreColor Policy to new policing pre-handling profile -->
    <xsl:variable name="curPreColorPolicySec" select="current/policies/policy[       normalize-space(policy-type) = $POLICY_TYPE_COLOR       and boolean(classifiers/classifier/classifier-type = $CLS_TYPE_ACTION_FLOW_COLOR)     ]"/>
    <xsl:variable name="curPreColorPolicyName">
      <xsl:value-of select="$curPreColorPolicySec/name"/>
    </xsl:variable>
    <xsl:variable name="preColorPolicy" select="//*[       local-name() = 'policy'       and child::*[local-name() = 'name' and text() = $curPreColorPolicyName]       and parent::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']     ]"/>

    <!-- PolicingTC Policy to new policing pre-handling profile -->
    <xsl:variable name="curPolicingTCPolicySec" select="current/policies/policy[       normalize-space(policy-type) = $POLICY_TYPE_PBIT_POLICING_TC     ]"/>
    <xsl:variable name="curPolicingTCPolicyName">
      <xsl:value-of select="$curPolicingTCPolicySec/name"/>
    </xsl:variable>
    <xsl:variable name="policingTCPolicy" select="//*[       local-name() = 'policy'       and child::*[local-name() = 'name' and text() = $curPolicingTCPolicyName]       and parent::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']     ]"/>

    <!-- Action Policy to new queue Color policy -->
    <xsl:variable name="curActionPolicyOfQueueColorSec" select="current/policies/policy[       policy-type = $POLICY_TYPE_ACTION       and boolean(classifiers/classifier/classifier-type = $CLS_TYPE_ACTION_QUEUE_COLOR)     ]"/>
    <xsl:variable name="curActionPolicySec" select="current/policies/policy[       policy-type = $POLICY_TYPE_ACTION     ]"/>
    <xsl:variable name="curActionPolicyName">
      <xsl:value-of select="$curActionPolicyOfQueueColorSec/name"/>
    </xsl:variable>

    <xsl:variable name="newActionBacColorPolicyName">
      <xsl:call-template name="createNoPolicingNewModelName">
        <xsl:with-param name="sourceName" select="$curActionPolicyName"/>
        <xsl:with-param name="namingRuleType" select="$NAMING_RULE_QC_POLICY"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="actionPolicy" select="//*[       local-name() = 'policy'       and child::*[local-name() = 'name' and text() = $curActionPolicyName]       and parent::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']     ]"/>

    <!-- Schedule Policy to new queue Color policy -->
    <xsl:variable name="curSchedulePolicySec" select="current/policies/policy[       policy-type = $POLICY_TYPE_SCHEDULE     ]"/>
    <xsl:variable name="curSchedulePolicyOfQueueColorSec" select="current/policies/policy[       policy-type = $POLICY_TYPE_SCHEDULE       and boolean(classifiers/classifier/actions/action = $A_BAC_COLOR)     ]"/>
    <xsl:variable name="curSchedulePolicyName">
      <xsl:value-of select="$curSchedulePolicySec/name"/>
    </xsl:variable>

    <xsl:variable name="newScheduleBacColorPolicyName">
      <xsl:call-template name="createNoPolicingNewModelName">
        <xsl:with-param name="namingRuleType" select="$NAMING_RULE_QC_POLICY"/>
        <xsl:with-param name="sourceName" select="$curSchedulePolicyName"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="schedulePolicySec" select="../child::*[local-name() = 'policy-list'       and child::*[ local-name() = 'name' and text() = $curSchedulePolicyName ]     ]"/>
    <xsl:variable name="schedulePolicy" select="//*[       local-name() = 'policy'       and child::*[local-name() = 'name' and text() = $curSchedulePolicyName]       and parent::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']     ]"/>

    <!-- Find port-policer policy in profile -->
    <xsl:variable name="curPortPolicerPolicySec" select="current/policies/policy[       policy-type = $POLICY_TYPE_PORT_POLICER     ]"/>

    <xsl:variable name="curPortPolicerPolicyName" select="$curPortPolicerPolicySec/name"/>

    <xsl:variable name="newPortPolicerPolicyName">
      <xsl:call-template name="createNewModelName">
        <xsl:with-param name="namingRuleType" select="$NAMING_RULE_GENERIC"/>
        <xsl:with-param name="profileName" select="$profileName"/>
        <xsl:with-param name="sourceName" select="$curPortPolicerPolicyName"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="newPortPolicerPolicyPolicingPorfileName">
      <xsl:call-template name="createNewModelName">
        <xsl:with-param name="sourceName" select="$curPortPolicerPolicyName"/>
        <xsl:with-param name="profileName" select="$profileName"/>
        <xsl:with-param name="namingRuleType" select="$NAMING_RULE_GENERIC"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="portPolicerPolicy" select="//*[       local-name() = 'policy'       and child::*[local-name() = 'name' and text() = $curPortPolicerPolicyName]       and parent::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']     ]"/>

    <!-- Find CCL policy in profile -->
    <xsl:variable name="curCCLPolicySec" select="current/policies/policy[       policy-type = $POLICY_TYPE_CCL     ]"/>
    <xsl:variable name="curCCLPolicyName" select="$curCCLPolicySec/name"/>

    <xsl:variable name="newCCLPolicyName">
      <xsl:call-template name="createNewModelName">
        <xsl:with-param name="sourceName" select="$curCCLPolicyName"/>
        <xsl:with-param name="profileName" select="$profileName"/>
        <xsl:with-param name="namingRuleType" select="$NAMING_RULE_GENERIC"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="CCLPolicy" select="//*[       local-name() = 'policy'       and child::*[local-name() = 'name' and text() = $curCCLPolicyName]       and parent::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']     ]"/>

    <!-- Find original Marker Policy in profile to new section -->
    <xsl:variable name="curMarkerPolicyName">
      <xsl:value-of select="current/policies/policy[policy-type = $POLICY_TYPE_MARKER]/name"/>
    </xsl:variable>
    <xsl:variable name="markerPolicySec" select="../child::*[local-name() = 'policy-list'       and child::*[ local-name() = 'name' and text() = $curMarkerPolicyName ]     ]"/>

    <!-- Find original Queue Count Policy in profile to new section -->
    <xsl:variable name="curQueueCountPolicyName">
      <xsl:value-of select="current/policies/policy[policy-type = $POLICY_TYPE_COUNT]/name"/>
    </xsl:variable>
    <xsl:variable name="countPolicySec" select="../child::*[local-name() = 'policy-list'       and child::*[ local-name() = 'name' and text() = $curQueueCountPolicyName ]     ]"/>

    <xsl:variable name="classifierNameOfActionProfile4PortPolicerPolicy">
      <xsl:call-template name="generateActionProfileSourceName4PortPolicerPolicy">
        <xsl:with-param name="curActionPolicySec" select="$curActionPolicySec"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="newPolicingActionProfileName">
      <xsl:call-template name="createNewModelName">
        <xsl:with-param name="namingRuleType" select="$NAMING_RULE_GENERIC_WITHOUT_PROFILE_NAME"/>
        <xsl:with-param name="profileName" select="$profileName"/>
        <xsl:with-param name="sourceName" select="$classifierNameOfActionProfile4PortPolicerPolicy"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="newPolicingActionProfileName4STB">
      <xsl:call-template name="createNewModelName">
        <xsl:with-param name="namingRuleType" select="$NAMING_RULE_ACTION_PROFILE_FOR_STB"/>
        <xsl:with-param name="profileName" select="$profileName"/>
        <xsl:with-param name="sourceName" select="$classifierNameOfActionProfile4PortPolicerPolicy"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="isCCLPolicyChange">
      <xsl:if test="$curCCLPolicySec">
        <xsl:call-template name="isCCLPolicyChange">
          <xsl:with-param name="curCCLPolicySec" select="$curCCLPolicySec"/>
          <xsl:with-param name="enhancedFiltersSec" select="$enhancedFiltersSec"/>
          <xsl:with-param name="curPolicingTCPolicySec" select="$curPolicingTCPolicySec"/>
          <xsl:with-param name="curPreColorPolicySec" select="$curPreColorPolicySec"/>
          <xsl:with-param name="classifierNameOfActionProfile4PortPolicerPolicy" select="$classifierNameOfActionProfile4PortPolicerPolicy"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:variable>

    <xsl:variable name="isPortPolicerPolicyChange">
      <xsl:if test="$curPortPolicerPolicySec">
        <xsl:call-template name="isPortPolicerPolicyChange">
          <xsl:with-param name="curPortPolicerPolicySec" select="$curPortPolicerPolicySec"/>
          <xsl:with-param name="curPolicingTCPolicySec" select="$curPolicingTCPolicySec"/>
          <xsl:with-param name="curPreColorPolicySec" select="$curPreColorPolicySec"/>
          <xsl:with-param name="classifierNameOfActionProfile4PortPolicerPolicy" select="$classifierNameOfActionProfile4PortPolicerPolicy"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:variable>

    <xsl:copy>
      <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
<!-- determine whether need to create a new policy-profile -->
      <xsl:if test="$curActionPolicyOfQueueColorSec or ($curSchedulePolicyOfQueueColorSec and $curSchedulePolicySec)         or $curPortPolicerPolicySec or $isCCLPolicyChange = 'true'">
        <xsl:element name="new">
          <xsl:element name="qos-policy-profiles" namespace="urn:bbf:yang:bbf-qos-policies">
            <xsl:element name="policy-profile" namespace="urn:bbf:yang:bbf-qos-policies">
              <xsl:element name="name" namespace="urn:bbf:yang:bbf-qos-policies">
                <xsl:value-of select="$originProfileName"/>
              </xsl:element>
              <!-- Move marker policy to new policy-profile -->
              <xsl:copy-of select="$markerPolicySec"/>
              <!-- Add CCL policy to policy-profile -->
              <xsl:if test="$curCCLPolicySec">
                <xsl:element name="policy-list" namespace="urn:bbf:yang:bbf-qos-policies">
                  <xsl:variable name="isPolicingInPolicy" select="$curCCLPolicySec/classifiers/classifier/actions/action/policing-profile"/>
                  <xsl:element name="name" namespace="urn:bbf:yang:bbf-qos-policies">
                    <xsl:choose>
                      <xsl:when test="$isCCLPolicyChange = 'true'">
                        <xsl:choose>
                          <xsl:when test="boolean($isPolicingInPolicy) and string-length(normalize-space($isPolicingInPolicy))&gt;0">
                            <xsl:value-of select="$newCCLPolicyName"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="$curCCLPolicyName"/>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="$curCCLPolicyName"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:element>
                  <xsl:if test="$isCCLPolicyChange = 'true' and boolean($isPolicingInPolicy) and string-length(normalize-space($isPolicingInPolicy))&gt;0">
                    <xsl:element name="sourceName" namespace="urn:bbf:yang:bbf-qos-policies">
                      <xsl:value-of select="$curCCLPolicyName"/>
                    </xsl:element>
                  </xsl:if>
                </xsl:element>
              </xsl:if>
              <!-- Add port-policer policy to policy-profile -->
              <xsl:if test="$curPortPolicerPolicySec">
                <xsl:element name="policy-list" namespace="urn:bbf:yang:bbf-qos-policies">
                  <xsl:element name="name" namespace="urn:bbf:yang:bbf-qos-policies">
                    <xsl:choose>
                      <xsl:when test="$isPortPolicerPolicyChange = 'true'">
                        <xsl:value-of select="$newPortPolicerPolicyName"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="$curPortPolicerPolicyName"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:element>
                  <xsl:if test="$isPortPolicerPolicyChange = 'true'">
                    <xsl:element name="sourceName" namespace="urn:bbf:yang:bbf-qos-policies">
                      <xsl:value-of select="$curPortPolicerPolicyName"/>
                    </xsl:element>
                  </xsl:if>
                </xsl:element>
              </xsl:if>
              <!-- Add scheduler policy to policy-profile -->
              <xsl:if test="$curSchedulePolicyOfQueueColorSec">
                <xsl:element name="policy-list" namespace="urn:bbf:yang:bbf-qos-policies">
                  <xsl:element name="name" namespace="urn:bbf:yang:bbf-qos-policies">
                    <xsl:value-of select="$curSchedulePolicyName"/>
                  </xsl:element>
                </xsl:element>
                <xsl:element name="policy-list" namespace="urn:bbf:yang:bbf-qos-policies">
                  <xsl:element name="name" namespace="urn:bbf:yang:bbf-qos-policies">
                    <xsl:value-of select="$newScheduleBacColorPolicyName"/>
                  </xsl:element>
                </xsl:element>
              </xsl:if>
              <!-- Move schedule policy to new profile if no bac-color in it -->
              <xsl:if test="$curSchedulePolicySec and not($curSchedulePolicyOfQueueColorSec)">
                <xsl:copy-of select="$schedulePolicySec"/>
              </xsl:if>
              <!-- Add queue color policy to policy-profile -->
              <xsl:if test="$curActionPolicyOfQueueColorSec">
                <xsl:element name="policy-list" namespace="urn:bbf:yang:bbf-qos-policies">
                  <xsl:element name="name" namespace="urn:bbf:yang:bbf-qos-policies">
                    <xsl:value-of select="$newActionBacColorPolicyName"/>
                  </xsl:element>
                </xsl:element>
              </xsl:if>
              <!-- Move count policy to new profile -->
              <xsl:copy-of select="$countPolicySec"/>
            </xsl:element>
          </xsl:element>
          <xsl:element name="policies" namespace="urn:bbf:yang:bbf-qos-policies">
            <!-- Create Bac-color policy from action policy -->
            <xsl:if test="$curActionPolicyOfQueueColorSec">
              <xsl:element name="policy" namespace="urn:bbf:yang:bbf-qos-policies">
                <xsl:element name="name" namespace="urn:bbf:yang:bbf-qos-policies">
                  <xsl:value-of select="$newActionBacColorPolicyName"/>
                </xsl:element>
                <xsl:variable name="duplicateEntry" select="//cfgNs:config/bbf-qos-pol:policies/bbf-qos-pol:policy[child::*[local-name() = 'name' and text() = $newActionBacColorPolicyName]]"/>
                <xsl:if test="boolean($duplicateEntry) and string-length(normalize-space($duplicateEntry))&gt;0">
                  <wrong-configuration-detected>There is a conflict with the policy profile name(<xsl:value-of select="$newActionBacColorPolicyName"/>).</wrong-configuration-detected>
                </xsl:if>
                <xsl:for-each select="$actionPolicy/node()">
                  <xsl:variable name="curClassifierName">
                    <xsl:value-of select="child::*[local-name() = 'name']"/>
                  </xsl:variable>
                  <xsl:if test="                     local-name() = 'classifiers'                     and boolean($curActionPolicyOfQueueColorSec/classifiers/classifier[name = $curClassifierName][classifier-type = $CLS_TYPE_ACTION_QUEUE_COLOR])                   ">

                    <xsl:element name="classifiers" namespace="urn:bbf:yang:bbf-qos-policies">
                      <xsl:element name="name" namespace="urn:bbf:yang:bbf-qos-policies">
                        <xsl:value-of select="$curClassifierName"/>
                      </xsl:element>
                    </xsl:element>
                  </xsl:if>
                </xsl:for-each>
              </xsl:element>
            </xsl:if>
            <xsl:if test="$curSchedulePolicyOfQueueColorSec">
              <!-- Create new schedule policy from current schedule policy -->
              <xsl:element name="policy" namespace="urn:bbf:yang:bbf-qos-policies">
                <xsl:element name="name" namespace="urn:bbf:yang:bbf-qos-policies">
                  <xsl:value-of select="$curSchedulePolicyName"/>
                </xsl:element>
                <xsl:element name="newPolicy" namespace="urn:bbf:yang:bbf-qos-policies">
                  <xsl:value-of select="$curSchedulePolicyName"/>
                </xsl:element>
                <xsl:for-each select="$schedulePolicy/node()">
                  <xsl:variable name="curClassifierName">
                    <xsl:value-of select="child::*[local-name() = 'name']"/>
                  </xsl:variable>
                  <xsl:if test="                     local-name() = 'classifiers'                     and boolean($curSchedulePolicySec/classifiers/classifier[name = $curClassifierName]/actions/action != $A_BAC_COLOR)                   ">
                    <xsl:element name="classifiers" namespace="urn:bbf:yang:bbf-qos-policies">
                      <xsl:element name="name" namespace="urn:bbf:yang:bbf-qos-policies">
                        <xsl:value-of select="$curClassifierName"/>
                      </xsl:element>
                    </xsl:element>
                  </xsl:if>
                </xsl:for-each>
              </xsl:element>
              <!-- Create new bac-color policy from schedule policy -->
              <xsl:element name="policy" namespace="urn:bbf:yang:bbf-qos-policies">
                <xsl:element name="name" namespace="urn:bbf:yang:bbf-qos-policies">
                  <xsl:value-of select="$newScheduleBacColorPolicyName"/>
                </xsl:element>
                <xsl:variable name="duplicateEntry" select="//cfgNs:config/bbf-qos-pol:policies/bbf-qos-pol:policy[child::*[local-name() = 'name' and text() = $newScheduleBacColorPolicyName]]"/>
                <xsl:if test="boolean($duplicateEntry) and string-length(normalize-space($duplicateEntry))&gt;0">
                    <wrong-configuration-detected>There is a conflict with the policy profile name(<xsl:value-of select="$newScheduleBacColorPolicyName"/>).</wrong-configuration-detected>
                </xsl:if>

                <xsl:for-each select="$schedulePolicy/node()">
                  <xsl:variable name="curClassifierName">
                    <xsl:value-of select="child::*[local-name() = 'name']"/>
                  </xsl:variable>
                  <xsl:if test="                     local-name() = 'classifiers'                     and boolean($curSchedulePolicySec/classifiers/classifier[name = $curClassifierName]/actions/action = $A_BAC_COLOR)                   ">
                    <xsl:element name="classifiers" namespace="urn:bbf:yang:bbf-qos-policies">
                      <xsl:element name="name" namespace="urn:bbf:yang:bbf-qos-policies">
                        <xsl:call-template name="createNoPolicingNewModelName">
                          <xsl:with-param name="namingRuleType" select="$NAMING_RULE_QC_CLASSIFIER"/>
                          <xsl:with-param name="sourceName" select="$curClassifierName"/>
                        </xsl:call-template>
                      </xsl:element>
                    </xsl:element>
                  </xsl:if>
                </xsl:for-each>
              </xsl:element>
            </xsl:if>
            <xsl:if test="$curPortPolicerPolicySec and $isPortPolicerPolicyChange = 'true'">
              <xsl:element name="policy" namespace="urn:bbf:yang:bbf-qos-policies">
                <xsl:element name="name" namespace="urn:bbf:yang:bbf-qos-policies">
                  <xsl:value-of select="$newPortPolicerPolicyName"/>
                </xsl:element>
                <xsl:element name="sourceName" namespace="urn:bbf:yang:bbf-qos-policies">
                  <xsl:value-of select="$curPortPolicerPolicyName"/>
                </xsl:element>
                <xsl:for-each select="$portPolicerPolicy/node()">
                  <xsl:variable name="curClassifierName">
                    <xsl:value-of select="child::*[local-name() = 'name']"/>
                  </xsl:variable>
                  <xsl:variable name="curClassifier" select="$curPortPolicerPolicySec/classifiers/classifier[name = $curClassifierName]"/>
                  <xsl:variable name="isPortPolicerClassifierChanged">
                    <xsl:call-template name="isPortPolicerClassifierChange">
                      <xsl:with-param name="curPortPolicerClassifierSec" select="$curClassifier"/>
                      <xsl:with-param name="curPreColorPolicySec" select="$curPreColorPolicySec"/>
                      <xsl:with-param name="curPolicingTCPolicySec" select="$curPolicingTCPolicySec"/>
                      <xsl:with-param name="classifierNameOfActionProfile4PortPolicerPolicy" select="$classifierNameOfActionProfile4PortPolicerPolicy"/>
                    </xsl:call-template>
                  </xsl:variable>
                  <xsl:if test="                     local-name() = 'classifiers'                     and boolean($curClassifier)                   ">
                    <xsl:element name="classifiers" namespace="urn:bbf:yang:bbf-qos-policies">
                      <xsl:variable name="newClassifierName">
                        <xsl:call-template name="createNewModelName">
                          <xsl:with-param name="namingRuleType" select="$NAMING_RULE_GENERIC"/>
                          <xsl:with-param name="profileName" select="$profileName"/>
                          <xsl:with-param name="sourceName" select="$curClassifierName"/>
                        </xsl:call-template>
                      </xsl:variable>
                      <xsl:element name="name" namespace="urn:bbf:yang:bbf-qos-policies">
                        <xsl:choose>
                          <xsl:when test="$isPortPolicerClassifierChanged">
                            <xsl:value-of select="$newClassifierName"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="$curClassifierName"/>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:element>
                    </xsl:element>
                  </xsl:if>
                </xsl:for-each>
              </xsl:element>
            </xsl:if>
            <!-- For CCL policy, only have policing-profile classifier or have enhanced-classifier-filter, then need to create new one -->
            <xsl:if test="$isCCLPolicyChange = 'true'">
              <xsl:element name="policy" namespace="urn:bbf:yang:bbf-qos-policies">
                <xsl:variable name="isPolicingInPolicy" select="$curCCLPolicySec/classifiers/classifier/actions/action/policing-profile"/>
                <xsl:element name="name" namespace="urn:bbf:yang:bbf-qos-policies">
                  <xsl:choose>
                    <xsl:when test="boolean($isPolicingInPolicy) and string-length(normalize-space($isPolicingInPolicy))&gt;0">
                      <xsl:value-of select="$newCCLPolicyName"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="$curCCLPolicyName"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:element>
                <xsl:if test="boolean($isPolicingInPolicy) and string-length(normalize-space($isPolicingInPolicy))&gt;0">
                  <xsl:element name="sourceName" namespace="urn:bbf:yang:bbf-qos-policies">
                    <xsl:value-of select="$curCCLPolicyName"/>
                  </xsl:element>
                </xsl:if>
                <xsl:if test="not(boolean($isPolicingInPolicy) and string-length(normalize-space($isPolicingInPolicy))&gt;0)">
                  <xsl:element name="newPolicy" namespace="urn:bbf:yang:bbf-qos-policies">
                    <xsl:value-of select="$curCCLPolicyName"/>
                  </xsl:element>
                </xsl:if>
                <xsl:for-each select="$curCCLPolicySec/classifiers/classifier">
                  <xsl:variable name="curClassifier" select="current()"/>
                  <xsl:variable name="curClassifierName">
                    <xsl:value-of select="child::*[local-name() = 'name']"/>
                  </xsl:variable>
                  <xsl:variable name="curClassifierNeedChange">
                    <xsl:call-template name="isCCLClassifierChange">
                      <xsl:with-param name="curCCLClassifierSec" select="$curClassifier"/>
                      <xsl:with-param name="enhancedFiltersSec" select="$enhancedFiltersSec"/>
                      <xsl:with-param name="curPreColorPolicySec" select="$curPreColorPolicySec"/>
                      <xsl:with-param name="curPolicingTCPolicySec" select="$curPolicingTCPolicySec"/>
                      <xsl:with-param name="classifierNameOfActionProfile4PortPolicerPolicy" select="$classifierNameOfActionProfile4PortPolicerPolicy"/>
                    </xsl:call-template>
                  </xsl:variable>
                  <xsl:element name="classifiers" namespace="urn:bbf:yang:bbf-qos-policies">
                    <xsl:element name="name" namespace="urn:bbf:yang:bbf-qos-policies">
                      <xsl:choose>
                        <xsl:when test="$curClassifierNeedChange = 'true'">
                          <xsl:variable name="isPolicingInClassifier" select="$curCCLPolicySec/classifiers/classifier[child::*[local-name() = 'name' and text() = $curClassifierName]]/actions/action/policing-profile"/>
                          <xsl:choose>
                            <xsl:when test="boolean($isPolicingInClassifier) and string-length(normalize-space($isPolicingInClassifier))&gt;0">
                              <xsl:variable name="newClassifierName">
                                <xsl:call-template name="createNewModelName">
                                  <xsl:with-param name="namingRuleType" select="$NAMING_RULE_GENERIC"/>
                                  <xsl:with-param name="profileName" select="$profileName"/>
                                  <xsl:with-param name="sourceName" select="$curClassifierName"/>
                                </xsl:call-template>
                              </xsl:variable>
                              <xsl:value-of select="$newClassifierName"/>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:variable name="isClsInMarkerPolicy">
                                <xsl:call-template name="isClsUsedByMarkerPolicy">
                                  <xsl:with-param name="ClsName" select="$curClassifierName"/>
                                </xsl:call-template>
                              </xsl:variable>
                              <xsl:choose>
                                <xsl:when test="boolean($isClsInMarkerPolicy) and string-length(normalize-space($isClsInMarkerPolicy))&gt;0">
                                  <xsl:variable name="newNoPolicingClassifierName">
                                    <xsl:call-template name="createNoPolicingNewModelName">
                                      <xsl:with-param name="namingRuleType" select="$NAMING_RULE_BOTH_IN_CCL_AND_MARKER_POLICY_CLASSIFIER"/>
                                      <xsl:with-param name="sourceName" select="$curClassifierName"/>
                                    </xsl:call-template>
                                  </xsl:variable>
                                  <xsl:value-of select="$newNoPolicingClassifierName"/>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:value-of select="$curClassifierName"/>
                                </xsl:otherwise>
                              </xsl:choose>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="$curClassifierName"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:element>
                  </xsl:element>
                </xsl:for-each>
              </xsl:element>
            </xsl:if>
          </xsl:element>
          <xsl:element name="classifiers" namespace="urn:bbf:yang:bbf-qos-classifiers">
            <xsl:if test="$curActionPolicyOfQueueColorSec">
              <xsl:for-each select="$curActionPolicyOfQueueColorSec/classifiers/classifier[classifier-type = $CLS_TYPE_ACTION_QUEUE_COLOR]">
                <xsl:variable name="curClassifier" select="//*[                   local-name() = 'classifier-entry'                   and parent::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']                   and child::*[local-name() = 'name' and text() = current()/name]                 ]"/>
                <xsl:element name="classifier-entry" namespace="urn:bbf:yang:bbf-qos-classifiers">
                  <xsl:element name="name" namespace="urn:bbf:yang:bbf-qos-classifiers">
                    <xsl:value-of select="$curClassifier/child::*[local-name() = 'name']"/>
                  </xsl:element>
                  <xsl:copy-of select="$curClassifier/child::*[local-name() = 'filter-operation']"/>
                  <xsl:element name="metered-color" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-qos-filters-ext">false</xsl:element>
                  <xsl:for-each select="$curClassifier/node()">
                    <xsl:choose>
                      <xsl:when test="local-name() = 'name' or local-name() = 'filter-operation'">
                      </xsl:when>
                      <xsl:when test="local-name() = 'match-criteria'">
                        <!-- When filter is inline filter (pbit-marking-list , dei-marking-list, in-pbit-list, in-dei need to
                        move to outer and change the namespace of enhanced-filter -->
                        <xsl:choose>
                          <xsl:when test="child::*[local-name() = 'pbit-marking-list']">
                            <xsl:element name="pbit-marking-list" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                              <xsl:element name="index" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                                <xsl:value-of select="child::*[local-name() = 'pbit-marking-list']/child::*[local-name() = 'index']"/>
                              </xsl:element>
                              <xsl:element name="pbit-value" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                                <xsl:value-of select="child::*[local-name() = 'pbit-marking-list']/child::*[local-name() = 'pbit-value']"/>
                              </xsl:element>
                            </xsl:element>
                          </xsl:when>
                          <xsl:when test="child::*[local-name() = 'dei-marking-list']">
                            <xsl:element name="dei-marking-list" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                              <xsl:element name="index" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                                <xsl:value-of select="child::*[local-name() = 'dei-marking-list']/child::*[local-name() = 'index']"/>
                              </xsl:element>
                              <xsl:element name="dei-value" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                                <xsl:value-of select="child::*[local-name() = 'dei-marking-list']/child::*[local-name() = 'dei-value']"/>
                              </xsl:element>
                            </xsl:element>
                          </xsl:when>
                          <xsl:when test="child::*[local-name() = 'tag']/child::*[local-name() = 'in-pbit-list' or local-name() = 'in-dei']">
                            <xsl:element name="vlans" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                              <xsl:for-each select="child::*[local-name() = 'tag']">
                                <xsl:element name="tag" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                                  <xsl:if test="child::*[local-name() = 'tag']/child::*[local-name() = 'index']">
                                    <xsl:element name="index" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                                      <xsl:value-of select="child::*[local-name() = 'tag']/child::*[local-name() = 'index']"/>
                                    </xsl:element>
                                  </xsl:if>
                                  <xsl:if test="child::*[local-name() = 'tag']/child::*[local-name() = 'in-pbit-list']">
                                    <xsl:element name="in-pbit-list" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                                      <xsl:value-of select="child::*[local-name() = 'tag']/child::*[local-name() = 'in-pbit-list']"/>
                                    </xsl:element>
                                  </xsl:if>
                                  <xsl:if test="child::*[local-name() = 'tag']/child::*[local-name() = 'in-dei']">
                                    <xsl:element name="in-pbit-list" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                                      <xsl:value-of select="child::*[local-name() = 'tag']/child::*[local-name() = 'in-dei']"/>
                                    </xsl:element>
                                  </xsl:if>
                                </xsl:element>
                              </xsl:for-each>
                            </xsl:element>
                          </xsl:when>
                        </xsl:choose>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:copy-of select="."/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:for-each>
                </xsl:element>
              </xsl:for-each>
            </xsl:if>
            <xsl:if test="$curSchedulePolicyOfQueueColorSec">
              <xsl:for-each select="$curSchedulePolicySec/classifiers/classifier">
                <xsl:variable name="hasBacColorAction">
                  <xsl:value-of select="boolean(current()/actions/action = $A_BAC_COLOR)"/>
                </xsl:variable>
                <xsl:variable name="hasNoBacColorAction">
                  <xsl:value-of select="boolean(current()/actions/action != $A_BAC_COLOR)"/>
                </xsl:variable>
                <xsl:variable name="curClassifier" select="//*[                   local-name() = 'classifier-entry'                   and parent::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']                   and child::*[local-name() = 'name' and text() = current()/name]                 ]"/>
                <!-- Create bac-color Classifier -->
                <xsl:if test="$hasBacColorAction">
                  <xsl:element name="classifier-entry" namespace="urn:bbf:yang:bbf-qos-classifiers">
                    <xsl:variable name="qcClassifierName">
                      <xsl:call-template name="createNoPolicingNewModelName">
                        <xsl:with-param name="namingRuleType" select="$NAMING_RULE_QC_CLASSIFIER"/>
                        <xsl:with-param name="sourceName" select="$curClassifier/child::*[local-name() = 'name']"/>
                      </xsl:call-template>
                    </xsl:variable>
                    <xsl:element name="name" namespace="urn:bbf:yang:bbf-qos-classifiers">
                      <xsl:value-of select="$qcClassifierName"/>
                    </xsl:element>
                    <xsl:variable name="duplicateEntry" select="//cfgNs:config/bbf-qos-cls:classifiers/bbf-qos-cls:classifier-entry[child::*[local-name() = 'name' and text() = $qcClassifierName]]"/>
                    <xsl:if test="boolean($duplicateEntry) and string-length(normalize-space($duplicateEntry))&gt;0">
                      <wrong-configuration-detected>There is a conflict with the classifier profile name(<xsl:value-of select="$qcClassifierName"/>).</wrong-configuration-detected>
                    </xsl:if>
                    <xsl:copy-of select="$curClassifier/child::*[local-name() = 'filter-operation']"/>
                    <xsl:element name="metered-color" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-qos-filters-ext">false</xsl:element>
                    <xsl:for-each select="$curClassifier/node()">
                      <xsl:choose>
                        <xsl:when test="local-name() = 'name' or local-name() = 'filter-operation'                         or (local-name() = 'classifier-action-entry-cfg' and not(child::*[local-name() = 'bac-color']))">
                        </xsl:when>
                        <xsl:when test="local-name() = 'match-criteria'">
                          <!-- When filter is inline filter (pbit-marking-list , dei-marking-list, in-pbit-list, in-dei need to
                          move to outer and change the namespace of enhanced-filter -->
                          <xsl:choose>
                            <xsl:when test="child::*[local-name() = 'pbit-marking-list']">
                              <xsl:element name="pbit-marking-list" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                                <xsl:element name="index" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                                  <xsl:value-of select="child::*[local-name() = 'pbit-marking-list']/child::*[local-name() = 'index']"/>
                                </xsl:element>
                                <xsl:element name="pbit-value" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                                  <xsl:value-of select="child::*[local-name() = 'pbit-marking-list']/child::*[local-name() = 'pbit-value']"/>
                                </xsl:element>
                              </xsl:element>
                            </xsl:when>
                            <xsl:when test="child::*[local-name() = 'dei-marking-list']">
                              <xsl:element name="dei-marking-list" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                                <xsl:element name="index" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                                  <xsl:value-of select="child::*[local-name() = 'dei-marking-list']/child::*[local-name() = 'index']"/>
                                </xsl:element>
                                <xsl:element name="dei-value" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                                  <xsl:value-of select="child::*[local-name() = 'dei-marking-list']/child::*[local-name() = 'dei-value']"/>
                                </xsl:element>
                              </xsl:element>
                            </xsl:when>
                            <xsl:when test="child::*[local-name() = 'tag']/child::*[local-name() = 'in-pbit-list' or local-name() = 'in-dei']">
                              <xsl:element name="vlans" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                                <xsl:for-each select="child::*[local-name() = 'tag']">
                                  <xsl:element name="tag" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                                    <xsl:if test="child::*[local-name() = 'tag']/child::*[local-name() = 'index']">
                                      <xsl:element name="index" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                                        <xsl:value-of select="child::*[local-name() = 'tag']/child::*[local-name() = 'index']"/>
                                      </xsl:element>
                                    </xsl:if>
                                    <xsl:if test="child::*[local-name() = 'tag']/child::*[local-name() = 'in-pbit-list']">
                                      <xsl:element name="in-pbit-list" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                                        <xsl:value-of select="child::*[local-name() = 'tag']/child::*[local-name() = 'in-pbit-list']"/>
                                      </xsl:element>
                                    </xsl:if>
                                    <xsl:if test="child::*[local-name() = 'tag']/child::*[local-name() = 'in-dei']">
                                      <xsl:element name="in-pbit-list" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                                        <xsl:value-of select="child::*[local-name() = 'tag']/child::*[local-name() = 'in-dei']"/>
                                      </xsl:element>
                                    </xsl:if>
                                  </xsl:element>
                                </xsl:for-each>
                              </xsl:element>
                            </xsl:when>
                          </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:copy-of select="."/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:for-each>
                  </xsl:element>
                </xsl:if>
                <xsl:if test="$hasNoBacColorAction">
                  <xsl:element name="classifier-entry" namespace="urn:bbf:yang:bbf-qos-classifiers">
                    <xsl:element name="name" namespace="urn:bbf:yang:bbf-qos-classifiers">
                      <xsl:value-of select="$curClassifier/child::*[local-name() = 'name']"/>
                    </xsl:element>
                    <xsl:copy-of select="$curClassifier/child::*[local-name() = 'filter-operation']"/>
                    <xsl:for-each select="$curClassifier/node()">
                      <xsl:choose>
                        <xsl:when test="local-name() = 'name' or local-name() = 'filter-operation'                         or (local-name() = 'classifier-action-entry-cfg' and boolean(child::*[local-name() = 'bac-color']))">
                        </xsl:when>
                        <xsl:when test="local-name() = 'match-criteria'">
                          <!-- When filter is inline filter (pbit-marking-list , dei-marking-list, in-pbit-list, in-dei need to
                          move to outer and change the namespace of enhanced-filter -->
                          <xsl:choose>
                            <xsl:when test="child::*[local-name() = 'pbit-marking-list']">
                              <xsl:element name="pbit-marking-list" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                                <xsl:element name="index" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                                  <xsl:value-of select="child::*[local-name() = 'pbit-marking-list']/child::*[local-name() = 'index']"/>
                                </xsl:element>
                                <xsl:element name="pbit-value" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                                  <xsl:value-of select="child::*[local-name() = 'pbit-marking-list']/child::*[local-name() = 'pbit-value']"/>
                                </xsl:element>
                              </xsl:element>
                            </xsl:when>
                            <xsl:when test="child::*[local-name() = 'dei-marking-list']">
                              <xsl:element name="dei-marking-list" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                                <xsl:element name="index" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                                  <xsl:value-of select="child::*[local-name() = 'dei-marking-list']/child::*[local-name() = 'index']"/>
                                </xsl:element>
                                <xsl:element name="dei-value" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                                  <xsl:value-of select="child::*[local-name() = 'dei-marking-list']/child::*[local-name() = 'dei-value']"/>
                                </xsl:element>
                              </xsl:element>
                            </xsl:when>
                            <xsl:when test="child::*[local-name() = 'tag']/child::*[local-name() = 'in-pbit-list' or local-name() = 'in-dei']">
                              <xsl:element name="vlans" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                                <xsl:for-each select="child::*[local-name() = 'tag']">
                                  <xsl:element name="tag" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                                    <xsl:if test="child::*[local-name() = 'tag']/child::*[local-name() = 'index']">
                                      <xsl:element name="index" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                                        <xsl:value-of select="child::*[local-name() = 'tag']/child::*[local-name() = 'index']"/>
                                      </xsl:element>
                                    </xsl:if>
                                    <xsl:if test="child::*[local-name() = 'tag']/child::*[local-name() = 'in-pbit-list']">
                                      <xsl:element name="in-pbit-list" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                                        <xsl:value-of select="child::*[local-name() = 'tag']/child::*[local-name() = 'in-pbit-list']"/>
                                      </xsl:element>
                                    </xsl:if>
                                    <xsl:if test="child::*[local-name() = 'tag']/child::*[local-name() = 'in-dei']">
                                      <xsl:element name="in-pbit-list" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                                        <xsl:value-of select="child::*[local-name() = 'tag']/child::*[local-name() = 'in-dei']"/>
                                      </xsl:element>
                                    </xsl:if>
                                  </xsl:element>
                                </xsl:for-each>
                              </xsl:element>
                            </xsl:when>
                          </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:copy-of select="."/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:for-each>
                  </xsl:element>
                </xsl:if>
              </xsl:for-each>
            </xsl:if>
            <xsl:if test="$curPortPolicerPolicySec">
              <xsl:for-each select="$curPortPolicerPolicySec/classifiers/classifier">
                <xsl:variable name="curClassifier" select="current()"/>
                <xsl:variable name="classifier" select="//*[                   local-name() = 'classifier-entry'                   and parent::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']                   and child::*[local-name() = 'name' and text() = current()/name]                 ]"/>
                <xsl:variable name="isPortPolicerClassifierChange">
                  <xsl:call-template name="isPortPolicerClassifierChange">
                    <xsl:with-param name="curPortPolicerClassifierSec" select="$curClassifier"/>
                    <xsl:with-param name="curPolicingTCPolicySec" select="$curPolicingTCPolicySec"/>
                    <xsl:with-param name="curPreColorPolicySec" select="$curPreColorPolicySec"/>
                    <xsl:with-param name="classifierNameOfActionProfile4PortPolicerPolicy" select="$classifierNameOfActionProfile4PortPolicerPolicy"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:if test="$isPortPolicerClassifierChange">
                  <xsl:variable name="portPolicerClassifierName">
                    <xsl:call-template name="createNewModelName">
                      <xsl:with-param name="namingRuleType" select="$NAMING_RULE_GENERIC"/>
                      <xsl:with-param name="profileName" select="$profileName"/>
                      <xsl:with-param name="sourceName" select="$classifier/child::*[local-name() = 'name']"/>
                    </xsl:call-template>
                  </xsl:variable>
                  <xsl:element name="classifier-entry" namespace="urn:bbf:yang:bbf-qos-classifiers">
                    <xsl:element name="name" namespace="urn:bbf:yang:bbf-qos-classifiers">
                      <xsl:value-of select="$portPolicerClassifierName"/>
                    </xsl:element>
                    <xsl:element name="sourceName" namespace="urn:bbf:yang:bbf-qos-classifiers">
                      <xsl:value-of select="$classifier/child::*[local-name() = 'name']"/>
                    </xsl:element>
                    <xsl:for-each select="$classifier/node()">
                      <xsl:choose>
                        <xsl:when test="local-name() = 'name'">
                        </xsl:when>
                        <xsl:when test="local-name() = 'match-criteria'">
                          <xsl:choose>
                            <xsl:when test="child::*[local-name() = 'unmetered']">
                              <xsl:element name="metered-flow" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-qos-filters-ext">false</xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                              <!-- For match-all case -->
                              <xsl:copy-of select="."/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:when>
                        <xsl:when test="local-name() = 'classifier-action-entry-cfg'">
                          <xsl:copy>
                            <xsl:copy-of select="@*"/>
<xsl:choose>
                              <xsl:when test="child::*[local-name() = 'policing']">
                                <xsl:for-each select="node()">
                                  <xsl:choose>
                                    <xsl:when test="local-name() = 'policing'">
                                      <xsl:copy>
                                        <xsl:copy-of select="@*"/>
<xsl:variable name="curPortPolicerClassifier" select="$curPortPolicerPolicySec/classifiers/classifier"/>
                                        <xsl:variable name="curPortPolicerClassifierName" select="$curPortPolicerClassifier/name"/>
                                        <xsl:variable name="newPolicingProfileName">
                                          <xsl:call-template name="createNewModelName">
                                            <xsl:with-param name="namingRuleType" select="$NAMING_RULE_GENERIC"/>
                                            <xsl:with-param name="profileName" select="$profileName"/>
                                            <xsl:with-param name="sourceName" select="$curPortPolicerClassifierName"/>
                                          </xsl:call-template>
                                        </xsl:variable>

                                        <xsl:variable name="curPolicingProfileSec" select="$curPortPolicerClassifier/actions/action/policing-profile"/>
                                        <xsl:variable name="curPolicingProfileName">
                                          <xsl:value-of select="$curPolicingProfileSec/name"/>
                                        </xsl:variable>
                                        <xsl:variable name="policingProfile" select="//*[                                           local-name() = 'policing-profile'                                           and child::*[local-name() = 'name' and text() = $curPolicingProfileName]                                           and parent::*[local-name() = 'policing-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policing']                                         ]"/>
                                        <xsl:variable name="isPortPolicerPolicingProfileChange">
                                          <xsl:call-template name="isPortPolicerPolicingProfileChange">
                                            <xsl:with-param name="curPortPolicerPolicingProfileSec" select="$curPolicingProfileSec"/>
                                            <xsl:with-param name="curPolicingTCPolicySec" select="$curPolicingTCPolicySec"/>
                                            <xsl:with-param name="curPreColorPolicySec" select="$curPreColorPolicySec"/>
                                            <xsl:with-param name="classifierNameOfActionProfile4PortPolicerPolicy" select="$classifierNameOfActionProfile4PortPolicerPolicy"/>
                                          </xsl:call-template>
                                        </xsl:variable>
                                        <xsl:choose>
                                          <xsl:when test="$policingProfile and $isPortPolicerPolicingProfileChange = 'true'">
                                            <xsl:element name="policing-profile" namespace="urn:bbf:yang:bbf-qos-policing">
                                              <xsl:value-of select="$newPolicingProfileName"/>
                                            </xsl:element>
                                          </xsl:when>
                                          <xsl:otherwise>
                                            <xsl:element name="policing-profile" namespace="urn:bbf:yang:bbf-qos-policing">
                                              <xsl:value-of select="$curPolicingProfileName"/>
                                            </xsl:element>
                                          </xsl:otherwise>
                                        </xsl:choose>
                                      </xsl:copy>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      <xsl:copy-of select="."/>
                                    </xsl:otherwise>
                                  </xsl:choose>
                                </xsl:for-each>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:copy-of select="."/>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:copy>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:copy-of select="."/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:for-each>
                  </xsl:element>
                </xsl:if>
              </xsl:for-each>
            </xsl:if>
            <xsl:if test="$curCCLPolicySec">
              <xsl:for-each select="$curCCLPolicySec/classifiers/classifier">
                <xsl:variable name="curClassifier" select="current()"/>
                <xsl:variable name="curClassifierName">
                  <xsl:value-of select="$curClassifier/child::*[local-name() = 'name']"/>
                </xsl:variable>
                <xsl:variable name="classifier" select="//*[                   local-name() = 'classifier-entry'                   and parent::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']                   and child::*[local-name() = 'name' and text() = $curClassifierName]                 ]"/>
                <xsl:variable name="newPolicingProfileName">
                  <xsl:call-template name="createNewModelName">
                    <xsl:with-param name="namingRuleType" select="$NAMING_RULE_GENERIC"/>
                    <xsl:with-param name="profileName" select="$profileName"/>
                    <xsl:with-param name="sourceName" select="$curClassifierName"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="curPolicingProfileSec" select="$curClassifier/actions/action/policing-profile"/>
                <xsl:variable name="curPolicingProfileName">
                  <xsl:value-of select="$curPolicingProfileSec/child::*[local-name() = 'name']"/>
                </xsl:variable>
                <xsl:variable name="isCCLClassifierNeedChange">
                  <xsl:call-template name="isCCLClassifierChange">
                    <xsl:with-param name="curCCLClassifierSec" select="$curClassifier"/>
                    <xsl:with-param name="enhancedFiltersSec" select="$enhancedFiltersSec"/>
                    <xsl:with-param name="curPreColorPolicySec" select="$curPreColorPolicySec"/>
                    <xsl:with-param name="curPolicingTCPolicySec" select="$curPolicingTCPolicySec"/>
                    <xsl:with-param name="classifierNameOfActionProfile4PortPolicerPolicy" select="$classifierNameOfActionProfile4PortPolicerPolicy"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:if test="$isCCLClassifierNeedChange = 'true'">
                  <xsl:variable name="isPolicingInClassifier" select="$curCCLPolicySec/classifiers/classifier[child::*[local-name() = 'name' and text() = $curClassifierName]]/actions/action/policing-profile"/>
                  <xsl:element name="classifier-entry" namespace="urn:bbf:yang:bbf-qos-classifiers">
                    <xsl:element name="name" namespace="urn:bbf:yang:bbf-qos-classifiers">
                      <xsl:choose>
                        <xsl:when test="boolean($isPolicingInClassifier) and string-length(normalize-space($isPolicingInClassifier))&gt;0">
                          <xsl:call-template name="createNewModelName">
                            <xsl:with-param name="namingRuleType" select="$NAMING_RULE_GENERIC"/>
                            <xsl:with-param name="profileName" select="$profileName"/>
                            <xsl:with-param name="sourceName" select="$curClassifierName"/>
                          </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:variable name="isClsInMarkerPolicy">
                            <xsl:call-template name="isClsUsedByMarkerPolicy">
                            <xsl:with-param name="ClsName" select="$curClassifierName"/>
                            </xsl:call-template>
                          </xsl:variable>
                          <xsl:choose>
                            <xsl:when test="boolean($isClsInMarkerPolicy) and string-length(normalize-space($isClsInMarkerPolicy))&gt;0">
                              <xsl:call-template name="createNoPolicingNewModelName">
                                <xsl:with-param name="namingRuleType" select="$NAMING_RULE_BOTH_IN_CCL_AND_MARKER_POLICY_CLASSIFIER"/>
                                <xsl:with-param name="sourceName" select="$curClassifierName"/>
                              </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="$curClassifierName"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:element>

                    <xsl:choose>
                      <xsl:when test="boolean($isPolicingInClassifier) and string-length(normalize-space($isPolicingInClassifier))&gt;0">
                        <xsl:variable name="cclClassifierName">
                          <xsl:call-template name="createNewModelName">
                            <xsl:with-param name="namingRuleType" select="$NAMING_RULE_GENERIC"/>
                            <xsl:with-param name="profileName" select="$profileName"/>
                            <xsl:with-param name="sourceName" select="$curClassifierName"/>
                          </xsl:call-template>
                        </xsl:variable>
                        <xsl:element name="sourceName" namespace="urn:bbf:yang:bbf-qos-classifiers">
                          <xsl:value-of select="$curClassifierName"/>
                        </xsl:element>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:variable name="isClsInMarkerPolicy">
                          <xsl:call-template name="isClsUsedByMarkerPolicy">
                          <xsl:with-param name="ClsName" select="$curClassifierName"/>
                          </xsl:call-template>
                        </xsl:variable>
                        <xsl:if test="boolean($isClsInMarkerPolicy) and string-length(normalize-space($isClsInMarkerPolicy))&gt;0">
                          <xsl:variable name="cclNoPolicingClassifierName">
                            <xsl:call-template name="createNoPolicingNewModelName">
                              <xsl:with-param name="namingRuleType" select="$NAMING_RULE_BOTH_IN_CCL_AND_MARKER_POLICY_CLASSIFIER"/>
                              <xsl:with-param name="sourceName" select="$curClassifierName"/>
                            </xsl:call-template>
                          </xsl:variable>
                          <xsl:variable name="duplicateEntry" select="//cfgNs:config/bbf-qos-cls:classifiers/bbf-qos-cls:classifier-entry[child::*[local-name() = 'name' and text() = $cclNoPolicingClassifierName]]"/>
                          <xsl:if test="boolean($duplicateEntry) and string-length(normalize-space($duplicateEntry))&gt;0">
                            <wrong-configuration-detected>There is a conflict with the classifier profile name(<xsl:value-of select="$cclNoPolicingClassifierName"/>).</wrong-configuration-detected>
                          </xsl:if>
                        </xsl:if>
                      </xsl:otherwise>
                    </xsl:choose>

                    <xsl:if test="not(boolean($isPolicingInClassifier) and string-length(normalize-space($isPolicingInClassifier))&gt;0)">
                      <xsl:element name="newClassifiers" namespace="urn:bbf:yang:bbf-qos-classifiers">
                        <xsl:value-of select="$curClassifierName"/>
                      </xsl:element>
                    </xsl:if>
                    <xsl:copy-of select="$classifier/child::*[local-name() = 'filter-operation']"/>
                    <xsl:variable name="isCCLClassifierOwnNeedChange">
                      <xsl:call-template name="isCCLClassifierOwnNeedChange">
                        <xsl:with-param name="curCCLClassifierSec" select="$curClassifier"/>
                      </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="isCCLPolicingProfileNeedChange">
                      <xsl:call-template name="isCCLPolicingProfileChange">
                        <xsl:with-param name="curCCLPolicingProfileSec" select="$curPolicingProfileSec"/>
                        <xsl:with-param name="curCCLClassifierSec" select="$curClassifier"/>
                        <xsl:with-param name="enhancedFiltersSec" select="$enhancedFiltersSec"/>
                        <xsl:with-param name="curPreColorPolicySec" select="$curPreColorPolicySec"/>
                        <xsl:with-param name="curPolicingTCPolicySec" select="$curPolicingTCPolicySec"/>
                        <xsl:with-param name="classifierNameOfActionProfile4PortPolicerPolicy" select="$classifierNameOfActionProfile4PortPolicerPolicy"/>
                      </xsl:call-template>
                    </xsl:variable>

                    <xsl:choose>
                      <xsl:when test="$isCCLClassifierOwnNeedChange = 'true'">
                        <xsl:variable name="duplicateEntry" select="//cfgNs:config/bbf-qos-filt:filters/bbf-qos-enhfilt:enhanced-filter[child::*[local-name() = 'name' and text() = $curClassifierName]]"/>
                        <xsl:choose>
                          <xsl:when test="boolean($duplicateEntry) and string-length(normalize-space($duplicateEntry))&gt;0">
                            <xsl:element name="enhanced-filter-name" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                              <xsl:call-template name="createNewModelName">
                                <xsl:with-param name="namingRuleType" select="$NAMING_RULE_GENERIC"/>
                                <xsl:with-param name="profileName" select="$profileName"/>
                                <xsl:with-param name="sourceName" select="$curClassifierName"/>
                              </xsl:call-template>
                            </xsl:element>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:element name="enhanced-filter-name" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                              <xsl:value-of select="$curClassifierName"/>
                            </xsl:element>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:copy-of select="$classifier/child::*[local-name() = 'enhanced-filter-name']"/>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:for-each select="$classifier/node()">
                      <xsl:choose>
                        <xsl:when test="local-name() = 'any-frame'">
                          <xsl:copy-of select="."/>
                        </xsl:when>
                        <xsl:when test="local-name() = 'classifier-action-entry-cfg'">
                          <xsl:copy>
                            <xsl:copy-of select="@*"/>
<xsl:for-each select="node()">
                              <xsl:choose>
                                <xsl:when test="local-name() = 'policing'">
                                  <xsl:copy>
                                    <xsl:copy-of select="@*"/>
<xsl:element name="policing-profile" namespace="urn:bbf:yang:bbf-qos-policing">
                                      <xsl:choose>
                                        <xsl:when test="$isCCLPolicingProfileNeedChange = 'true'">
                                          <xsl:value-of select="$newPolicingProfileName"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                          <xsl:value-of select="$curPolicingProfileName"/>
                                        </xsl:otherwise>
                                      </xsl:choose>
                                    </xsl:element>
                                  </xsl:copy>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:copy-of select="."/>
                                </xsl:otherwise>
                              </xsl:choose>
                            </xsl:for-each>
                          </xsl:copy>
                        </xsl:when>
                      </xsl:choose>
                    </xsl:for-each>
                  </xsl:element>
                </xsl:if>
              </xsl:for-each>
            </xsl:if>
          </xsl:element>
          <xsl:element name="filters" namespace="urn:bbf:yang:bbf-qos-filters">
            <xsl:for-each select="$curCCLPolicySec/classifiers/classifier">
              <xsl:variable name="curClassifer" select="current()"/>
              <xsl:variable name="curClassifierName" select="current()/child::*[local-name() = 'name']"/>
              <xsl:variable name="isCCLClassifierOwnNeedChange">
                <xsl:call-template name="isCCLClassifierOwnNeedChange">
                  <xsl:with-param name="curCCLClassifierSec" select="$curClassifer"/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:variable name="classifier" select="//*[                 local-name() = 'classifier-entry'                 and parent::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']                 and child::*[local-name() = 'name' and text() = $curClassifierName]               ]"/>
              <xsl:variable name="enhFilterType">
                <xsl:value-of select="current()/child::*[local-name() = 'filters']/child::*[local-name() = 'enh-filter-type']"/>
              </xsl:variable>
              <xsl:if test="$isCCLClassifierOwnNeedChange = 'true'">
                <xsl:element name="enhanced-filter" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                  <xsl:variable name="duplicateEntry" select="//cfgNs:config/bbf-qos-filt:filters/bbf-qos-enhfilt:enhanced-filter[child::*[local-name() = 'name' and text() = $curClassifierName]]"/>
                  <xsl:choose>
                    <xsl:when test="boolean($duplicateEntry) and string-length(normalize-space($duplicateEntry))&gt;0">
                      <xsl:variable name="newEnhanceFilterName">
                        <xsl:call-template name="createNewModelName">
                          <xsl:with-param name="namingRuleType" select="$NAMING_RULE_GENERIC"/>
                          <xsl:with-param name="profileName" select="$profileName"/>
                          <xsl:with-param name="sourceName" select="$curClassifierName"/>
                        </xsl:call-template>
                      </xsl:variable>

                      <xsl:element name="name" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                        <xsl:value-of select="normalize-space($newEnhanceFilterName)"/>
                      </xsl:element>

                      <xsl:variable name="duplicateEntry" select="//cfgNs:config/bbf-qos-filt:filters/bbf-qos-enhfilt:enhanced-filter[child::*[local-name() = 'name' and text() = $newEnhanceFilterName]]"/>
                      <xsl:if test="boolean($duplicateEntry) and string-length(normalize-space($duplicateEntry))&gt;0">
                          <wrong-configuration-detected>There is a conflict with the enhance filter profile name(<xsl:value-of select="$newEnhanceFilterName"/>).</wrong-configuration-detected>
                      </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:element name="name" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                        <xsl:value-of select="$curClassifierName"/>
                      </xsl:element>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:element name="filter-operation" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                    <xsl:copy-of select="$classifier/child::*[local-name() = 'filter-operation']/namespace::*[ . = 'urn:bbf:yang:bbf-qos-classifiers']"/>

                    <xsl:variable name="originalFilterOperation">
                      <xsl:value-of select="$classifier/child::*[local-name() = 'filter-operation']/text()"/>
                    </xsl:variable>
                    <xsl:choose>
                      <xsl:when test="contains(normalize-space($originalFilterOperation),':')">
                        <xsl:value-of select="substring-after(normalize-space($originalFilterOperation),':')"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="normalize-space($originalFilterOperation)"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:element>

                  <xsl:element name="filter" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                    <xsl:element name="name" namespace="urn:bbf:yang:bbf-qos-enhanced-filters">
                      <xsl:call-template name="createNewModelName">
                        <xsl:with-param name="namingRuleType" select="$NAMING_RULE_GENERIC_WITHOUT_PROFILE_NAME"/>
                        <xsl:with-param name="profileName" select="$profileName"/>
                        <xsl:with-param name="sourceName" select="$curClassifierName"/>
                      </xsl:call-template>
                    </xsl:element>

                    <xsl:if test="contains($enhFilterType,$F_EN_IPV4) and $classifier/child::*[local-name() = 'ipv4']">
                      <xsl:copy-of select="$classifier/child::*[local-name() = 'ipv4']"/>
                    </xsl:if>
                    <xsl:if test="contains($enhFilterType,$F_EN_IPV6) and $classifier/child::*[local-name() = 'ipv6']">
                      <xsl:copy-of select="$classifier/child::*[local-name() = 'ipv6']"/>
                    </xsl:if>
                    <xsl:if test="$classifier/child::*[local-name() = 'source-mac-address']">
                      <xsl:copy-of select="$classifier/child::*[local-name() = 'source-mac-address']"/>
                    </xsl:if>
                    <xsl:if test="$classifier/child::*[local-name() = 'destination-mac-address']">
                      <xsl:copy-of select="$classifier/child::*[local-name() = 'destination-mac-address']"/>
                    </xsl:if>
                    <xsl:if test="$classifier/child::*[local-name() = 'vlans']">
                      <xsl:copy-of select="$classifier/child::*[local-name() = 'vlans']"/>
                    </xsl:if>
                    <xsl:if test="$classifier/child::*[local-name() = 'ethernet-frame-type']">
                      <xsl:copy-of select="$classifier/child::*[local-name() = 'ethernet-frame-type']"/>
                    </xsl:if>
                    <xsl:if test="$classifier/child::*[local-name() = 'ip-common']">
                      <xsl:copy-of select="$classifier/child::*[local-name() = 'ip-common']"/>
                    </xsl:if>
                    <xsl:if test="$classifier/child::*[local-name() = 'transport']">
                      <xsl:copy-of select="$classifier/child::*[local-name() = 'transport']"/>
                    </xsl:if>
                    <xsl:if test="$classifier/child::*[local-name() = 'protocol']">
                      <xsl:copy-of select="$classifier/child::*[local-name() = 'protocol']"/>
                    </xsl:if>
                    <xsl:if test="$classifier/child::*[local-name() = 'pbit-marking-list']">
                      <xsl:copy-of select="$classifier/child::*[local-name() = 'pbit-marking-list']"/>
                    </xsl:if>
                    <xsl:if test="$classifier/child::*[local-name() = 'dei-marking-list']">
                      <xsl:copy-of select="$classifier/child::*[local-name() = 'dei-marking-list']"/>
                    </xsl:if>
                  </xsl:element>
                </xsl:element>
              </xsl:if>
            </xsl:for-each>
          </xsl:element>
          <xsl:element name="policing-profiles" namespace="urn:bbf:yang:bbf-qos-policing">
            <!-- Find port policer global policing profile -->
            <xsl:if test="$curPortPolicerPolicySec">

              <!-- There should only 1 classifier in port policer, if others exist, ignore -->
              <xsl:variable name="curPortPolicerClassifier" select="$curPortPolicerPolicySec/classifiers/classifier"/>
              <xsl:variable name="curPortPolicerClassifierName" select="$curPortPolicerClassifier/name"/>

              <xsl:variable name="curPolicingProfileSec" select="$curPortPolicerClassifier/actions/action/policing-profile"/>

              <xsl:variable name="curPolicingProfileName">
                <xsl:value-of select="$curPolicingProfileSec/name"/>
              </xsl:variable>
              <xsl:variable name="curPolicingProfileType">
                <xsl:value-of select="$curPolicingProfileSec/type"/>
              </xsl:variable>

              <xsl:variable name="policingProfile" select="//*[                 local-name() = 'policing-profile'                 and child::*[local-name() = 'name' and text() = $curPolicingProfileName]                 and parent::*[local-name() = 'policing-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policing']               ]"/>
              <xsl:variable name="isPortPolicerPolicingProfileChange">
                <xsl:call-template name="isPortPolicerPolicingProfileChange">
                  <xsl:with-param name="curPortPolicerPolicingProfileSec" select="$curPolicingProfileSec"/>
                  <xsl:with-param name="curPolicingTCPolicySec" select="$curPolicingTCPolicySec"/>
                  <xsl:with-param name="curPreColorPolicySec" select="$curPreColorPolicySec"/>
                  <xsl:with-param name="classifierNameOfActionProfile4PortPolicerPolicy" select="$classifierNameOfActionProfile4PortPolicerPolicy"/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:if test="$policingProfile and $isPortPolicerPolicingProfileChange = 'true'">
                <xsl:element name="policing-profile" namespace="urn:bbf:yang:bbf-qos-policing">
                  <xsl:variable name="newPolicingProfileName">
                    <xsl:call-template name="createNewModelName">
                      <xsl:with-param name="namingRuleType" select="$NAMING_RULE_GENERIC"/>
                      <xsl:with-param name="profileName" select="$profileName"/>
                      <xsl:with-param name="sourceName" select="$curPortPolicerClassifierName"/>
                    </xsl:call-template>
                  </xsl:variable>
                  <xsl:element name="name" namespace="urn:bbf:yang:bbf-qos-policing">
                    <xsl:value-of select="$newPolicingProfileName"/>
                  </xsl:element>
                  <xsl:element name="sourceName" namespace="urn:bbf:yang:bbf-qos-policing">
                    <xsl:value-of select="$curPolicingProfileName"/>
                  </xsl:element>
                  <xsl:for-each select="$policingProfile/node()">
                    <xsl:choose>
                      <xsl:when test="local-name() = 'name' or local-name() = 'migration-cache'">
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:copy-of select="."/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:for-each>
                  <xsl:variable name="isPortPolicerPrehandlingChanged">
                    <xsl:call-template name="isPortPolicerPrehandlingChanged">
                      <xsl:with-param name="curPortPolicerPolicingProfileSec" select="$curPolicingProfileSec"/>
                      <xsl:with-param name="curPreColorPolicySec" select="$curPreColorPolicySec"/>
                      <xsl:with-param name="curPolicingTCPolicySec" select="$curPolicingTCPolicySec"/>
                    </xsl:call-template>
                  </xsl:variable>
                  <xsl:variable name="isPortPolicerActionChanged">
                    <xsl:call-template name="isPortPolicerActionChanged">
                      <xsl:with-param name="classifierNameOfActionProfile4PortPolicerPolicy" select="$classifierNameOfActionProfile4PortPolicerPolicy"/>
                    </xsl:call-template>
                  </xsl:variable>
                  <xsl:element name="realName" namespace="urn:bbf:yang:bbf-qos-policing">
                    <xsl:call-template name="generateRealPolicingName">
                      <xsl:with-param name="isPrehandlingChanged" select="$isPortPolicerPrehandlingChanged"/>
                      <xsl:with-param name="isActionChanged" select="$isPortPolicerActionChanged"/>
                      <xsl:with-param name="policingType" select="$curPolicingProfileType"/>
                      <xsl:with-param name="policingName" select="$curPolicingProfileName"/>
                      <xsl:with-param name="policingPolicyName" select="$curPolicingTCPolicyName"/>
                      <xsl:with-param name="colorPolicyName" select="$curPreColorPolicyName"/>
                      <xsl:with-param name="actionProfileName4STB" select="$newPolicingActionProfileName4STB"/>
                      <xsl:with-param name="actionProfileName" select="$newPolicingActionProfileName"/>
                    </xsl:call-template>
                  </xsl:element>
                  <xsl:if test="$isPortPolicerPrehandlingChanged = 'true'">
                    <xsl:element name="policing-pre-handling-profile" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                      <xsl:choose>
                        <xsl:when test="$curPolicingProfileType = $POLICING_TYPE_TRTCM_COS or $curPolicingProfileType = $POLICING_TYPE_TRTCM_MEF_COS">
                          <xsl:call-template name="createNewModelName">
                            <xsl:with-param name="namingRuleType" select="$NAMING_RULE_GENERIC_WITHOUT_PROFILE_NAME"/>
                            <xsl:with-param name="profileName" select="$profileName"/>
                            <xsl:with-param name="sourceName" select="$curPolicingTCPolicyName"/>
                          </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="$curPolicingProfileType = $POLICING_TYPE_TRTCM_MEF_COLOR_AWARE">
                          <xsl:call-template name="createNewModelName">
                            <xsl:with-param name="namingRuleType" select="$NAMING_RULE_GENERIC_WITHOUT_PROFILE_NAME"/>
                            <xsl:with-param name="profileName" select="$profileName"/>
                            <xsl:with-param name="sourceName" select="$curPreColorPolicyName"/>
                          </xsl:call-template>
                        </xsl:when>
                      </xsl:choose>
                    </xsl:element>
                  </xsl:if>
                  <xsl:if test="$isPortPolicerActionChanged = 'true'">
                    <xsl:element name="policing-action-profile" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                      <xsl:choose>
                        <xsl:when test="$curPolicingProfileType = $POLICING_TYPE_STB">
                          <xsl:value-of select="$newPolicingActionProfileName4STB"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="$newPolicingActionProfileName"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:element>
                  </xsl:if>
                </xsl:element>
              </xsl:if>
            </xsl:if>

            <!-- Create policing-profile from CCL policy -->
            <xsl:if test="$curCCLPolicySec">
              <xsl:for-each select="$curCCLPolicySec/classifiers/classifier[actions/action/policing-profile]">
                <xsl:variable name="curClassifier" select="current()"/>
                <xsl:variable name="curClassifierName">
                  <xsl:value-of select="current()/child::*[local-name() = 'name']"/>
                </xsl:variable>
                <xsl:variable name="curRefFilterName">
                  <xsl:value-of select="$curClassifier/filters/ref-filter/name"/>
                </xsl:variable>
                <xsl:variable name="curEnhancedFilterSecByRef" select="$enhancedFiltersSec/enhanced-filter[                   name = $curRefFilterName                   and child::*[local-name() = 'ref-by']/child::*[local-name() = 'filter']                 ]"/>
                <xsl:variable name="isActionChanged">
                  <xsl:call-template name="isCCLActionChanged">
                    <xsl:with-param name="curEnhancedFilterSecByRef" select="$curEnhancedFilterSecByRef"/>
                    <xsl:with-param name="classifierNameOfActionProfile4PortPolicerPolicy" select="$classifierNameOfActionProfile4PortPolicerPolicy"/>
                  </xsl:call-template>
                </xsl:variable>

                <xsl:variable name="curPolicingProfileName">
                  <xsl:value-of select="current()/actions/action/policing-profile/name"/>
                </xsl:variable>
                <xsl:variable name="curPolicingProfileType">
                  <xsl:value-of select="current()/actions/action/policing-profile/type"/>
                </xsl:variable>
                <xsl:variable name="isCCLPreHandlingChanged">
                  <xsl:call-template name="isCCLPreHandlingChanged">
                    <xsl:with-param name="curCCLPolicingProfileSec" select="current()/actions/action/policing-profile"/>
                    <xsl:with-param name="curPreColorPolicySec" select="$curPreColorPolicySec"/>
                    <xsl:with-param name="curPolicingTCPolicySec" select="$curPolicingTCPolicySec"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="policingProfile" select="//*[                   local-name() = 'policing-profile'                   and child::*[local-name() = 'name' and text() = $curPolicingProfileName]                   and parent::*[local-name() = 'policing-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policing']                 ]"/>
                <xsl:variable name="newPolicingProfileName">
                  <xsl:call-template name="createNewModelName">
                    <xsl:with-param name="namingRuleType" select="$NAMING_RULE_GENERIC"/>
                    <xsl:with-param name="profileName" select="$profileName"/>
                    <xsl:with-param name="sourceName" select="$curClassifierName"/>
                  </xsl:call-template>
                </xsl:variable>

                <xsl:variable name="classifierNameOfActionProfile4CCLPolicy">
                  <xsl:call-template name="generateActionProfileSourceName4CCLPolicy">
                    <xsl:with-param name="curRootFilter" select="$curEnhancedFilterSecByRef"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="newPolicingActionProfileName4CCL">
                  <xsl:call-template name="createNewModelName">
                    <xsl:with-param name="namingRuleType" select="$NAMING_RULE_GENERIC_WITHOUT_PROFILE_NAME"/>
                    <xsl:with-param name="profileName" select="$profileName"/>
                    <xsl:with-param name="sourceName" select="$classifierNameOfActionProfile4CCLPolicy"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="newPolicingActionProfileName4CCLandSTB">
                  <xsl:call-template name="createNewModelName">
                    <xsl:with-param name="namingRuleType" select="$NAMING_RULE_ACTION_PROFILE_FOR_STB"/>
                    <xsl:with-param name="profileName" select="$profileName"/>
                    <xsl:with-param name="sourceName" select="$classifierNameOfActionProfile4CCLPolicy"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:if test="$isActionChanged = 'true' or $isCCLPreHandlingChanged = 'true'">
                  <xsl:element name="policing-profile" namespace="urn:bbf:yang:bbf-qos-policing">
                    <xsl:element name="name" namespace="urn:bbf:yang:bbf-qos-policing">
                      <xsl:value-of select="$newPolicingProfileName"/>
                    </xsl:element>
                    <xsl:element name="sourceName" namespace="urn:bbf:yang:bbf-qos-policing">
                      <xsl:value-of select="$curPolicingProfileName"/>
                    </xsl:element>
                    <xsl:for-each select="$policingProfile/node()">
                      <xsl:choose>
                        <xsl:when test="local-name() = 'name' or local-name() = 'migration-cache'">
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:copy-of select="."/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:for-each>
                    <xsl:choose>
                      <xsl:when test="$curEnhancedFilterSecByRef">
                        <xsl:element name="realName" namespace="urn:bbf:yang:bbf-qos-policing">
                          <xsl:call-template name="generateRealPolicingName">
                            <xsl:with-param name="isPrehandlingChanged" select="$isCCLPreHandlingChanged"/>
                            <xsl:with-param name="isActionChanged" select="$isActionChanged"/>
                            <xsl:with-param name="policingType" select="$curPolicingProfileType"/>
                            <xsl:with-param name="policingName" select="$curPolicingProfileName"/>
                            <xsl:with-param name="policingPolicyName" select="$curPolicingTCPolicyName"/>
                            <xsl:with-param name="colorPolicyName" select="$curPreColorPolicyName"/>
                            <xsl:with-param name="actionProfileName4STB" select="$newPolicingActionProfileName4CCLandSTB"/>
                            <xsl:with-param name="actionProfileName" select="$newPolicingActionProfileName4CCL"/>
                          </xsl:call-template>
                        </xsl:element>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:element name="realName" namespace="urn:bbf:yang:bbf-qos-policing">
                          <xsl:call-template name="generateRealPolicingName">
                            <xsl:with-param name="isPrehandlingChanged" select="$isCCLPreHandlingChanged"/>
                            <xsl:with-param name="isActionChanged" select="$isActionChanged"/>
                            <xsl:with-param name="policingType" select="$curPolicingProfileType"/>
                            <xsl:with-param name="policingName" select="$curPolicingProfileName"/>
                            <xsl:with-param name="policingPolicyName" select="$curPolicingTCPolicyName"/>
                            <xsl:with-param name="colorPolicyName" select="$curPreColorPolicyName"/>
                            <xsl:with-param name="actionProfileName4STB" select="$newPolicingActionProfileName4STB"/>
                            <xsl:with-param name="actionProfileName" select="$newPolicingActionProfileName"/>
                          </xsl:call-template>
                        </xsl:element>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="$isCCLPreHandlingChanged = 'true'">
                      <xsl:choose>
                        <xsl:when test="$curPolicingProfileType = $POLICING_TYPE_TRTCM_COS or $curPolicingProfileType = $POLICING_TYPE_TRTCM_MEF_COS">
                          <xsl:element name="policing-pre-handling-profile" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">

                            <xsl:call-template name="createNewModelName">
                              <xsl:with-param name="namingRuleType" select="$NAMING_RULE_GENERIC_WITHOUT_PROFILE_NAME"/>
                              <xsl:with-param name="profileName" select="$profileName"/>
                              <xsl:with-param name="sourceName" select="$curPolicingTCPolicyName"/>
                            </xsl:call-template>
                          </xsl:element>
                        </xsl:when>
                        <xsl:when test="$curPolicingProfileType = $POLICING_TYPE_TRTCM_MEF_COLOR_AWARE">
                          <xsl:element name="policing-pre-handling-profile" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                            <xsl:call-template name="createNewModelName">
                              <xsl:with-param name="namingRuleType" select="$NAMING_RULE_GENERIC_WITHOUT_PROFILE_NAME"/>
                              <xsl:with-param name="profileName" select="$profileName"/>
                              <xsl:with-param name="sourceName" select="$curPreColorPolicyName"/>
                            </xsl:call-template>
                          </xsl:element>
                        </xsl:when>
                      </xsl:choose>
                    </xsl:if>
                    <xsl:if test="$isActionChanged = 'true'">
                      <xsl:element name="policing-action-profile" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                        <xsl:choose>
                          <xsl:when test="$curEnhancedFilterSecByRef">
                            <xsl:choose>
                              <xsl:when test="$curPolicingProfileType = $POLICING_TYPE_STB">
                                <xsl:value-of select="$newPolicingActionProfileName4CCLandSTB"/>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of select="$newPolicingActionProfileName4CCL"/>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:choose>
                              <xsl:when test="$curPolicingProfileType = $POLICING_TYPE_STB">
                                <xsl:value-of select="$newPolicingActionProfileName4STB"/>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of select="$newPolicingActionProfileName"/>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:element>
                    </xsl:if>
                  </xsl:element>
                </xsl:if>
              </xsl:for-each>
            </xsl:if>
          </xsl:element>
          <xsl:element name="policing-pre-handling-profiles" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
            <xsl:if test="$curPreColorPolicySec">
              <xsl:element name="pre-handling-profile" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                <xsl:element name="name" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                  <xsl:call-template name="createNewModelName">
                    <xsl:with-param name="namingRuleType" select="$NAMING_RULE_GENERIC_WITHOUT_PROFILE_NAME"/>
                    <xsl:with-param name="profileName" select="$profileName"/>
                    <xsl:with-param name="sourceName" select="$curPreColorPolicyName"/>
                  </xsl:call-template>
                </xsl:element>
                <xsl:for-each select="$curPreColorPolicySec/classifiers/classifier">
                  <xsl:variable name="preColorClassifier" select="//*[                     local-name() = 'classifier-entry'                     and child::*[local-name() = 'name' and text() = current()/name]                     and parent::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']                   ]"/>
                  <xsl:element name="pre-handling-entry" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                    <xsl:element name="name" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                      <xsl:call-template name="createNewModelName">
                        <xsl:with-param name="namingRuleType" select="$NAMING_RULE_PREHANDLING_ENTRY"/>
                        <xsl:with-param name="profileName" select="$profileName"/>
                        <xsl:with-param name="sourceName" select="$preColorClassifier/child::*[local-name() = 'name']"/>
                      </xsl:call-template>
                    </xsl:element>
                    <xsl:element name="match-params" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                      <xsl:choose>
                        <xsl:when test="$preColorClassifier/child::*[local-name() = 'match-criteria']/child::*[local-name() = 'pbit-marking-list']/child::*[local-name() = 'index']">
                          <xsl:element name="pbit-marking-list" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                            <xsl:element name="index" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                              <xsl:value-of select="$preColorClassifier/child::*[local-name() = 'match-criteria']/child::*[local-name() = 'pbit-marking-list']/child::*[local-name() = 'index']"/>
                            </xsl:element>
                            <xsl:element name="pbit-value" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                              <xsl:value-of select="$preColorClassifier/child::*[local-name() = 'match-criteria']/child::*[local-name() = 'pbit-marking-list']/child::*[local-name() = 'pbit-value']"/>
                            </xsl:element>
                          </xsl:element>
                        </xsl:when>
                        <xsl:when test="$preColorClassifier/child::*[local-name() = 'pbit-marking-list']/child::*[local-name() = 'index']">
                          <xsl:element name="pbit-marking-list" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                            <xsl:element name="index" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                              <xsl:value-of select="$preColorClassifier/child::*[local-name() = 'pbit-marking-list']/child::*[local-name() = 'index']"/>
                            </xsl:element>
                            <xsl:element name="pbit-value" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                              <xsl:value-of select="$preColorClassifier/child::*[local-name() = 'pbit-marking-list']/child::*[local-name() = 'pbit-value']"/>
                            </xsl:element>
                          </xsl:element>
                        </xsl:when>
                        <xsl:when test="$preColorClassifier/child::*[local-name() = 'match-criteria']/child::*[local-name() = 'dei-marking-list']/child::*[local-name() = 'index']">
                          <xsl:element name="dei-marking-list" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                            <xsl:element name="index" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                              <xsl:value-of select="$preColorClassifier/child::*[local-name() = 'match-criteria']/child::*[local-name() = 'dei-marking-list']/child::*[local-name() = 'index']"/>
                            </xsl:element>
                            <xsl:element name="dei-value" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                              <xsl:value-of select="$preColorClassifier/child::*[local-name() = 'match-criteria']/child::*[local-name() = 'dei-marking-list']/child::*[local-name() = 'dei-value']"/>
                            </xsl:element>
                          </xsl:element>
                        </xsl:when>
                        <xsl:when test="$preColorClassifier/child::*[local-name() = 'dei-marking-list']/child::*[local-name() = 'index']">
                          <xsl:element name="dei-marking-list" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                            <xsl:element name="index" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                              <xsl:value-of select="$preColorClassifier/child::*[local-name() = 'dei-marking-list']/child::*[local-name() = 'index']"/>
                            </xsl:element>
                            <xsl:element name="dei-value" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                              <xsl:value-of select="$preColorClassifier/child::*[local-name() = 'dei-marking-list']/child::*[local-name() = 'dei-value']"/>
                            </xsl:element>
                          </xsl:element>
                        </xsl:when>
                        <xsl:when test="$preColorClassifier/child::*[local-name() = 'match-criteria']/child::*[local-name() = 'tag']/child::*[local-name() = 'index']">
                          <xsl:element name="vlans" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                            <xsl:variable name="index1Tag" select="$preColorClassifier/child::*[local-name() = 'match-criteria']/child::*[local-name() = 'tag' and child::*[local-name() = 'index'] = 1]"/>
                            <xsl:choose>
                              <xsl:when test="$index1Tag">
                                <xsl:element name="tag" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                  <xsl:element name="index" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                    <xsl:value-of select="$index1Tag/child::*[local-name() = 'index']"/>
                                  </xsl:element>
                                  <xsl:choose>
                                    <xsl:when test="$index1Tag/child::*[local-name() = 'in-pbit-list']">
                                      <xsl:element name="in-pbit-list" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                        <xsl:value-of select="$index1Tag/child::*[local-name() = 'in-pbit-list']"/>
                                      </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      <xsl:element name="in-dei" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                        <xsl:value-of select="$index1Tag/child::*[local-name() = 'in-dei']"/>
                                      </xsl:element>
                                    </xsl:otherwise>
                                  </xsl:choose>
                                </xsl:element>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:element name="tag" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                  <xsl:element name="index" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                    <xsl:value-of select="$preColorClassifier/child::*[local-name() = 'match-criteria']/child::*[local-name() = 'tag']/child::*[local-name() = 'index']"/>
                                  </xsl:element>
                                  <xsl:choose>
                                    <xsl:when test="$preColorClassifier/child::*[local-name() = 'match-criteria']/child::*[local-name() = 'tag']/child::*[local-name() = 'in-pbit-list']">
                                      <xsl:element name="in-pbit-list" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                        <xsl:value-of select="$preColorClassifier/child::*[local-name() = 'match-criteria']/child::*[local-name() = 'tag']/child::*[local-name() = 'in-pbit-list']"/>
                                      </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      <xsl:element name="in-dei" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                        <xsl:value-of select="$preColorClassifier/child::*[local-name() = 'match-criteria']/child::*[local-name() = 'tag']/child::*[local-name() = 'in-dei']"/>
                                      </xsl:element>
                                    </xsl:otherwise>
                                  </xsl:choose>
                                </xsl:element>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:element>
                        </xsl:when>
                        <xsl:when test="$preColorClassifier/child::*[local-name() = 'vlans']/child::*[local-name() = 'tag']/child::*[local-name() = 'index']">
                          <xsl:element name="vlans" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                            <xsl:variable name="index1Tag" select="$preColorClassifier/child::*[local-name() = 'vlans']/child::*[local-name() = 'tag' and child::*[local-name() = 'index'] = 1]"/>
                            <xsl:choose>
                              <xsl:when test="$index1Tag">
                                <xsl:element name="tag" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                  <xsl:element name="index" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                    <xsl:value-of select="$index1Tag/child::*[local-name() = 'index']"/>
                                  </xsl:element>
                                  <xsl:choose>
                                    <xsl:when test="$index1Tag/child::*[local-name() = 'in-pbit-list']">
                                      <xsl:element name="in-pbit-list" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                        <xsl:value-of select="$index1Tag/child::*[local-name() = 'in-pbit-list']"/>
                                      </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      <xsl:element name="in-dei" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                        <xsl:value-of select="$index1Tag/child::*[local-name() = 'in-dei']"/>
                                      </xsl:element>
                                    </xsl:otherwise>
                                  </xsl:choose>
                                </xsl:element>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:element name="tag" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                  <xsl:element name="index" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                    <xsl:value-of select="$preColorClassifier/child::*[local-name() = 'vlans']/child::*[local-name() = 'tag']/child::*[local-name() = 'index']"/>
                                  </xsl:element>
                                  <xsl:choose>
                                    <xsl:when test="$preColorClassifier/child::*[local-name() = 'vlans']/child::*[local-name() = 'tag']/child::*[local-name() = 'in-pbit-list']">
                                      <xsl:element name="in-pbit-list" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                        <xsl:value-of select="$preColorClassifier/child::*[local-name() = 'vlans']/child::*[local-name() = 'tag']/child::*[local-name() = 'in-pbit-list']"/>
                                      </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      <xsl:element name="in-dei" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                        <xsl:value-of select="$preColorClassifier/child::*[local-name() = 'vlans']/child::*[local-name() = 'tag']/child::*[local-name() = 'in-dei']"/>
                                      </xsl:element>
                                    </xsl:otherwise>
                                  </xsl:choose>
                                </xsl:element>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:element>
                        </xsl:when>
                      </xsl:choose>
                    </xsl:element>
                    <xsl:element name="flow-color" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                      <xsl:value-of select="$preColorClassifier/child::*[local-name() = 'classifier-action-entry-cfg']/child::*[local-name() = 'flow-color']"/>
                    </xsl:element>
                  </xsl:element>
                </xsl:for-each>
              </xsl:element>
            </xsl:if>
            <xsl:if test="$curPolicingTCPolicySec">
              <xsl:element name="pre-handling-profile" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                <xsl:element name="name" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                  <xsl:call-template name="createNewModelName">
                    <xsl:with-param name="namingRuleType" select="$NAMING_RULE_GENERIC_WITHOUT_PROFILE_NAME"/>
                    <xsl:with-param name="profileName" select="$profileName"/>
                    <xsl:with-param name="sourceName" select="$curPolicingTCPolicyName"/>
                  </xsl:call-template>
                </xsl:element>
                <xsl:for-each select="$curPolicingTCPolicySec/classifiers/classifier">
                  <xsl:variable name="policingTCClassifier" select="//*[                     local-name() = 'classifier-entry'                     and child::*[local-name() = 'name' and text() = current()/name]                     and parent::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']                   ]"/>
                  <xsl:element name="pre-handling-entry" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                    <xsl:element name="name" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                      <xsl:call-template name="createNewModelName">
                        <xsl:with-param name="namingRuleType" select="$NAMING_RULE_PREHANDLING_ENTRY"/>
                        <xsl:with-param name="profileName" select="$profileName"/>
                        <xsl:with-param name="sourceName" select="$policingTCClassifier/child::*[local-name() = 'name']"/>
                      </xsl:call-template>
                    </xsl:element>
                    <xsl:element name="match-params" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                      <xsl:choose>
                        <xsl:when test="$policingTCClassifier/child::*[local-name() = 'match-criteria']/child::*[local-name() = 'pbit-marking-list']/child::*[local-name() = 'index']">
                          <xsl:element name="pbit-marking-list" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                            <xsl:element name="index" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                              <xsl:value-of select="$policingTCClassifier/child::*[local-name() = 'match-criteria']/child::*[local-name() = 'pbit-marking-list']/child::*[local-name() = 'index']"/>
                            </xsl:element>
                            <xsl:element name="pbit-value" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                              <xsl:value-of select="$policingTCClassifier/child::*[local-name() = 'match-criteria']/child::*[local-name() = 'pbit-marking-list']/child::*[local-name() = 'pbit-value']"/>
                            </xsl:element>
                          </xsl:element>
                        </xsl:when>
                        <xsl:when test="$policingTCClassifier/child::*[local-name() = 'pbit-marking-list']/child::*[local-name() = 'index']">
                          <xsl:element name="pbit-marking-list" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                            <xsl:element name="index" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                              <xsl:value-of select="$policingTCClassifier/child::*[local-name() = 'pbit-marking-list']/child::*[local-name() = 'index']"/>
                            </xsl:element>
                            <xsl:element name="pbit-value" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                              <xsl:value-of select="$policingTCClassifier/child::*[local-name() = 'pbit-marking-list']/child::*[local-name() = 'pbit-value']"/>
                            </xsl:element>
                          </xsl:element>
                        </xsl:when>
                        <xsl:when test="$policingTCClassifier/child::*[local-name() = 'match-criteria']/child::*[local-name() = 'tag']/child::*[local-name() = 'index']">
                          <xsl:element name="vlans" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                            <xsl:variable name="index1Tag" select="$policingTCClassifier/child::*[local-name() = 'match-criteria']/child::*[local-name() = 'tag' and child::*[local-name() = 'index'] = 1]"/>
                            <xsl:choose>
                              <xsl:when test="$index1Tag">
                                <xsl:element name="tag" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                  <xsl:element name="index" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                    <xsl:value-of select="$index1Tag/child::*[local-name() = 'index']"/>
                                  </xsl:element>
                                  <xsl:choose>
                                    <xsl:when test="$index1Tag/child::*[local-name() = 'in-pbit-list']">
                                      <xsl:element name="in-pbit-list" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                        <xsl:value-of select="$index1Tag/child::*[local-name() = 'in-pbit-list']"/>
                                      </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      <xsl:element name="in-dei" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                        <xsl:value-of select="$index1Tag/child::*[local-name() = 'in-dei']"/>
                                      </xsl:element>
                                    </xsl:otherwise>
                                  </xsl:choose>
                                </xsl:element>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:element name="tag" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                  <xsl:element name="index" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                    <xsl:value-of select="$policingTCClassifier/child::*[local-name() = 'match-criteria']/child::*[local-name() = 'tag']/child::*[local-name() = 'index']"/>
                                  </xsl:element>
                                  <xsl:element name="in-pbit-list" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                    <xsl:value-of select="$policingTCClassifier/child::*[local-name() = 'match-criteria']/child::*[local-name() = 'tag']/child::*[local-name() = 'in-pbit-list']"/>
                                  </xsl:element>
                                </xsl:element>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:element>
                        </xsl:when>
                        <xsl:when test="$policingTCClassifier/child::*[local-name() = 'vlans']/child::*[local-name() = 'tag']/child::*[local-name() = 'index']">
                          <xsl:element name="vlans" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                            <xsl:variable name="index1Tag" select="$policingTCClassifier/child::*[local-name() = 'vlans']/child::*[local-name() = 'tag' and child::*[local-name() = 'index'] = 1]"/>
                            <xsl:choose>
                              <xsl:when test="$index1Tag">
                                <xsl:element name="tag" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                  <xsl:element name="index" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                    <xsl:value-of select="$index1Tag/child::*[local-name() = 'index']"/>
                                  </xsl:element>
                                  <xsl:element name="in-pbit-list" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                    <xsl:value-of select="$index1Tag/child::*[local-name() = 'in-pbit-list']"/>
                                  </xsl:element>
                                </xsl:element>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:element name="tag" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                  <xsl:element name="index" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                    <xsl:value-of select="$policingTCClassifier/child::*[local-name() = 'vlans']/child::*[local-name() = 'tag']/child::*[local-name() = 'index']"/>
                                  </xsl:element>
                                  <xsl:element name="in-pbit-list" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                    <xsl:value-of select="$policingTCClassifier/child::*[local-name() = 'vlans']/child::*[local-name() = 'tag']/child::*[local-name() = 'in-pbit-list']"/>
                                  </xsl:element>
                                </xsl:element>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:element>
                        </xsl:when>
                      </xsl:choose>
                    </xsl:element>
                    <xsl:element name="policing-traffic-class" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                      <xsl:value-of select="$policingTCClassifier/child::*[local-name() = 'classifier-action-entry-cfg']/child::*[local-name() = 'policing-traffic-class']"/>
                    </xsl:element>
                  </xsl:element>
                </xsl:for-each>
              </xsl:element>
            </xsl:if>
          </xsl:element>
          <xsl:element name="policing-action-profiles" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">

            <!-- Create global port policer policing action profile -->
            <xsl:if test="boolean($curPortPolicerPolicySec) and boolean($curActionPolicySec)">
              <!-- pap for port-policer policy -->
              <xsl:element name="action-profile" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                <xsl:element name="name" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                  <xsl:value-of select="$newPolicingActionProfileName"/>
                </xsl:element>
                <xsl:element name="realName" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                  <xsl:value-of select="$classifierNameOfActionProfile4PortPolicerPolicy"/>
                </xsl:element>
                <xsl:for-each select="$curActionPolicySec/classifiers/classifier[contains(filters/self-filter-types, $F_FLOW_COLOR) and contains(filters/inline-filter-type, $F_FLOW_COLOR) and boolean(filters/self-filter-flow-color)]">
                  <xsl:variable name="curActionClassifierName">
                    <xsl:value-of select="name"/>
                  </xsl:variable>
                  <xsl:variable name="color">
                    <xsl:value-of select="current()/child::*[local-name() = 'filters']/child::*[local-name() = 'self-filter-flow-color']"/>
                  </xsl:variable>
                  <xsl:variable name="classifierOfOnlyInlineFlowColor" select="//*[                     local-name() = 'classifier-entry'                     and parent::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']                     and child::*[local-name() = 'name'] = $curActionClassifierName                   ]"/>
                  <xsl:if test="$classifierOfOnlyInlineFlowColor">
                    <xsl:element name="action" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                      <xsl:element name="flow-color" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                        <xsl:value-of select="$color"/>
                      </xsl:element>
                      <xsl:choose>
                        <xsl:when test="current()/actions/action/type = $A_DISCARD">
                          <xsl:element name="discard" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:if test="boolean(current()/actions/action/type = $A_PBIT_MARKING)">
                            <xsl:variable name="actionCfg" select="$classifierOfOnlyInlineFlowColor/child::*[local-name() = 'classifier-action-entry-cfg' and child::*[local-name() = 'action-type' and contains(text(),'pbit-marking')]]"/>
                            <xsl:element name="pbit-marking-list" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                              <xsl:element name="index" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                <xsl:value-of select="$actionCfg/child::*[local-name() = 'pbit-marking-cfg']/child::*[local-name() = 'pbit-marking-list']/child::*[local-name() = 'index']"/>
                              </xsl:element>
                              <xsl:element name="pbit-value" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                <xsl:value-of select="$actionCfg/child::*[local-name() = 'pbit-marking-cfg']/child::*[local-name() = 'pbit-marking-list']/child::*[local-name() = 'pbit-value']"/>
                              </xsl:element>
                            </xsl:element>
                          </xsl:if>
                          <xsl:if test="boolean(current()/actions/action/type = $A_DEI_MARKING)">
                            <xsl:variable name="actionCfg" select="$classifierOfOnlyInlineFlowColor/child::*[local-name() = 'classifier-action-entry-cfg' and child::*[local-name() = 'action-type' and contains(text(),'dei-marking')]]"/>
                            <xsl:element name="dei-marking-list" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                              <xsl:element name="index" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                <xsl:value-of select="$actionCfg/child::*[local-name() = 'dei-marking-cfg']/child::*[local-name() = 'dei-marking-list']/child::*[local-name() = 'index']"/>
                              </xsl:element>
                              <xsl:element name="dei-value" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                <xsl:value-of select="$actionCfg/child::*[local-name() = 'dei-marking-cfg']/child::*[local-name() = 'dei-marking-list']/child::*[local-name() = 'dei-value']"/>
                              </xsl:element>
                            </xsl:element>
                          </xsl:if>
                          <xsl:if test="boolean(current()/actions/action/type = $A_BAC_COLOR)">
                            <xsl:variable name="actionCfg" select="$classifierOfOnlyInlineFlowColor/child::*[local-name() = 'classifier-action-entry-cfg' and child::*[local-name() = 'action-type' and contains(text(),'bac-color')]]"/>
                            <xsl:element name="bac-color" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                              <xsl:value-of select="$actionCfg/child::*[local-name() = 'bac-color']"/>
                            </xsl:element>
                          </xsl:if>
                          <xsl:element name="metered-flow" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">true</xsl:element>
                          <xsl:element name="metered-color" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">true</xsl:element>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:element>
                  </xsl:if>
                </xsl:for-each>
              </xsl:element>

              <!-- Another pap candidate only for STB policing-profile -->
              <xsl:element name="action-profile" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                <xsl:element name="name" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                  <xsl:value-of select="$newPolicingActionProfileName4STB"/>
                </xsl:element>
                <xsl:element name="realName" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                  <xsl:value-of select="$classifierNameOfActionProfile4PortPolicerPolicy"/>
                </xsl:element>
                <xsl:for-each select="$curActionPolicySec/classifiers/classifier[contains(filters/self-filter-types, $F_FLOW_COLOR) and contains(filters/inline-filter-type, $F_FLOW_COLOR) and boolean(filters/self-filter-flow-color)]">
                  <xsl:variable name="curActionClassifierName">
                    <xsl:value-of select="name"/>
                  </xsl:variable>
                  <xsl:variable name="color">
                    <xsl:value-of select="current()/child::*[local-name() = 'filters']/child::*[local-name() = 'self-filter-flow-color']"/>
                  </xsl:variable>
                  <xsl:variable name="classifierOfOnlyInlineFlowColor" select="//*[                     local-name() = 'classifier-entry'                     and parent::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']                     and child::*[local-name() = 'name'] = $curActionClassifierName                   ]"/>
                  <xsl:if test="$classifierOfOnlyInlineFlowColor">
                    <xsl:element name="action" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                      <xsl:element name="flow-color" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                        <xsl:value-of select="$color"/>
                      </xsl:element>
                      <xsl:choose>
                        <xsl:when test="current()/actions/action/type = $A_DISCARD">
                          <xsl:element name="discard" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:if test="boolean(current()/actions/action/type = $A_PBIT_MARKING)">
                            <xsl:variable name="actionCfg" select="$classifierOfOnlyInlineFlowColor/child::*[local-name() = 'classifier-action-entry-cfg' and child::*[local-name() = 'action-type' and contains(text(),'pbit-marking')]]"/>
                            <xsl:element name="pbit-marking-list" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                              <xsl:element name="index" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                <xsl:value-of select="$actionCfg/child::*[local-name() = 'pbit-marking-cfg']/child::*[local-name() = 'pbit-marking-list']/child::*[local-name() = 'index']"/>
                              </xsl:element>
                              <xsl:element name="pbit-value" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                <xsl:value-of select="$actionCfg/child::*[local-name() = 'pbit-marking-cfg']/child::*[local-name() = 'pbit-marking-list']/child::*[local-name() = 'pbit-value']"/>
                              </xsl:element>
                            </xsl:element>
                          </xsl:if>
                          <xsl:if test="boolean(current()/actions/action/type = $A_DEI_MARKING)">
                            <xsl:element name="dei-marking-list" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                              <xsl:variable name="actionCfg" select="$classifierOfOnlyInlineFlowColor/child::*[local-name() = 'classifier-action-entry-cfg' and child::*[local-name() = 'action-type' and contains(text(),'dei-marking')]]"/>
                              <xsl:element name="index" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                <xsl:value-of select="$actionCfg/child::*[local-name() = 'dei-marking-cfg']/child::*[local-name() = 'dei-marking-list']/child::*[local-name() = 'index']"/>
                              </xsl:element>
                              <xsl:element name="dei-value" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                <xsl:value-of select="$actionCfg/child::*[local-name() = 'dei-marking-cfg']/child::*[local-name() = 'dei-marking-list']/child::*[local-name() = 'dei-value']"/>
                              </xsl:element>
                            </xsl:element>
                          </xsl:if>
                          <xsl:if test="boolean(current()/actions/action/type = $A_BAC_COLOR)">
                            <xsl:variable name="actionCfg" select="$classifierOfOnlyInlineFlowColor/child::*[local-name() = 'classifier-action-entry-cfg' and child::*[local-name() = 'action-type' and contains(text(),'bac-color')]]"/>
                            <xsl:element name="bac-color" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                              <xsl:value-of select="$actionCfg/child::*[local-name() = 'bac-color']"/>
                            </xsl:element>
                          </xsl:if>
                          <xsl:element name="metered-flow" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">true</xsl:element>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:element>
                  </xsl:if>
                </xsl:for-each>
              </xsl:element>
            </xsl:if>

            <!-- Create CCL rule policing action profile -->
            <xsl:if test="boolean($curCCLPolicySec) and boolean($curActionPolicySec)">
              <xsl:for-each select="$enhancedFiltersSec/enhanced-filter">
                <xsl:variable name="curRootFilter" select="current()"/>
                <xsl:variable name="curRootFilterName">
                  <xsl:value-of select="name"/>
                </xsl:variable>
                <xsl:variable name="hasRefBy" select="boolean($curRootFilter/ref-by/filter)"/>
                <xsl:variable name="classifierNameOfActionProfile4CCLPolicy">
                  <xsl:call-template name="generateActionProfileSourceName4CCLPolicy">
                    <xsl:with-param name="curRootFilter" select="$curRootFilter"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="newPolicingActionProfileName4CCL">
                  <xsl:call-template name="createNewModelName">
                    <xsl:with-param name="namingRuleType" select="$NAMING_RULE_GENERIC_WITHOUT_PROFILE_NAME"/>
                    <xsl:with-param name="profileName" select="$profileName"/>
                    <xsl:with-param name="sourceName" select="$classifierNameOfActionProfile4CCLPolicy"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="newPolicingActionProfileName4CCLandSTB">
                  <xsl:call-template name="createNewModelName">
                    <xsl:with-param name="namingRuleType" select="$NAMING_RULE_ACTION_PROFILE_FOR_STB"/>
                    <xsl:with-param name="profileName" select="$profileName"/>
                    <xsl:with-param name="sourceName" select="$classifierNameOfActionProfile4CCLPolicy"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                  <xsl:when test="$hasRefBy = 'true'">
                    <xsl:element name="action-profile" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                      <xsl:element name="name" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                        <xsl:value-of select="$newPolicingActionProfileName4CCL"/>
                      </xsl:element>
                      <xsl:element name="realName" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                        <xsl:value-of select="$classifierNameOfActionProfile4CCLPolicy"/>
                      </xsl:element>
                      <xsl:for-each select="$curRootFilter/ref-by/filter">
                        <xsl:variable name="curChildFilterName">
                          <xsl:value-of select="child::*[local-name() = 'name']"/>
                        </xsl:variable>
                        <xsl:element name="action" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                          <xsl:element name="flow-color" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                            <xsl:value-of select="current()/color"/>
                          </xsl:element>
                          <xsl:variable name="curActionClassifier" select="$curActionPolicySec/classifiers/classifier[filters/ref-filter/name = $curChildFilterName and filters/ref-filter/ref = $curRootFilterName]"/>
                          <xsl:variable name="curActionClassifierName">
                            <xsl:value-of select="$curActionClassifier/name"/>
                          </xsl:variable>
                          <xsl:variable name="actionClassifier" select="//*[                             local-name() = 'classifier-entry'                             and parent::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']                             and child::*[local-name() = 'name'] = $curActionClassifierName                           ]"/>
                          <xsl:choose>
                            <xsl:when test="$curActionClassifier/actions/action/type = $A_DISCARD">
                              <xsl:element name="discard" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension"/>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:if test="$curActionClassifier/actions/action/type = $A_PBIT_MARKING">
                                <xsl:element name="pbit-marking-list" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                  <xsl:element name="index" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                    <xsl:value-of select="$actionClassifier/child::*[local-name() = 'classifier-action-entry-cfg']/child::*[local-name() = 'pbit-marking-cfg']/child::*[local-name() = 'pbit-marking-list']/child::*[local-name() = 'index']"/>
                                  </xsl:element>
                                  <xsl:element name="pbit-value" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                    <xsl:value-of select="$actionClassifier/child::*[local-name() = 'classifier-action-entry-cfg']/child::*[local-name() = 'pbit-marking-cfg']/child::*[local-name() = 'pbit-marking-list']/child::*[local-name() = 'pbit-value']"/>
                                  </xsl:element>
                                </xsl:element>
                              </xsl:if>
                              <xsl:if test="$curActionClassifier/actions/action/type = $A_DEI_MARKING">
                                <xsl:element name="dei-marking-list" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                  <xsl:element name="index" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                    <xsl:value-of select="$actionClassifier/child::*[local-name() = 'classifier-action-entry-cfg']/child::*[local-name() = 'dei-marking-cfg']/child::*[local-name() = 'dei-marking-list']/child::*[local-name() = 'index']"/>
                                  </xsl:element>
                                  <xsl:element name="dei-value" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                    <xsl:value-of select="$actionClassifier/child::*[local-name() = 'classifier-action-entry-cfg']/child::*[local-name() = 'dei-marking-cfg']/child::*[local-name() = 'dei-marking-list']/child::*[local-name() = 'dei-value']"/>
                                  </xsl:element>
                                </xsl:element>
                              </xsl:if>
                              <xsl:if test="$curActionClassifier/actions/action/type = $A_BAC_COLOR">
                                <xsl:element name="bac-color" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                  <xsl:value-of select="$actionClassifier/child::*[local-name() = 'classifier-action-entry-cfg']/child::*[local-name() = 'bac-color']"/>
                                </xsl:element>
                              </xsl:if>
                              <xsl:element name="metered-flow" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">true</xsl:element>
                              <xsl:element name="metered-color" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">true</xsl:element>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:element>
                      </xsl:for-each>
                    </xsl:element>
                    <xsl:element name="action-profile" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                      <xsl:element name="name" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                        <xsl:value-of select="$newPolicingActionProfileName4CCLandSTB"/>
                      </xsl:element>
                      <xsl:element name="realName" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                        <xsl:value-of select="$classifierNameOfActionProfile4PortPolicerPolicy"/>
                      </xsl:element>
                      <xsl:for-each select="$curRootFilter/ref-by/filter">
                        <xsl:variable name="curChildFilterName">
                          <xsl:value-of select="child::*[local-name() = 'name']"/>
                        </xsl:variable>
                        <xsl:element name="action" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                          <xsl:element name="flow-color" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                            <xsl:value-of select="current()/color"/>
                          </xsl:element>
                          <xsl:variable name="curActionClassifier" select="$curActionPolicySec/classifiers/classifier[filters/ref-filter/name = $curChildFilterName and filters/ref-filter/ref = $curRootFilterName]"/>
                          <xsl:variable name="curActionClassifierName">
                            <xsl:value-of select="$curActionClassifier/name"/>
                          </xsl:variable>
                          <xsl:variable name="actionClassifier" select="//*[                             local-name() = 'classifier-entry'                             and parent::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']                             and child::*[local-name() = 'name'] = $curActionClassifierName                           ]"/>
                          <xsl:choose>
                            <xsl:when test="$curActionClassifier/actions/action/type = $A_DISCARD">
                              <xsl:element name="discard" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension"/>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:if test="$curActionClassifier/actions/action/type = $A_PBIT_MARKING">
                                <xsl:element name="pbit-marking-list" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                  <xsl:element name="index" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                    <xsl:value-of select="$actionClassifier/child::*[local-name() = 'classifier-action-entry-cfg']/child::*[local-name() = 'pbit-marking-cfg']/child::*[local-name() = 'pbit-marking-list']/child::*[local-name() = 'index']"/>
                                  </xsl:element>
                                  <xsl:element name="pbit-value" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                    <xsl:value-of select="$actionClassifier/child::*[local-name() = 'classifier-action-entry-cfg']/child::*[local-name() = 'pbit-marking-cfg']/child::*[local-name() = 'pbit-marking-list']/child::*[local-name() = 'pbit-value']"/>
                                  </xsl:element>
                                </xsl:element>
                              </xsl:if>
                              <xsl:if test="$curActionClassifier/actions/action/type = $A_DEI_MARKING">
                                <xsl:element name="dei-marking-list" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                  <xsl:element name="index" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                    <xsl:value-of select="$actionClassifier/child::*[local-name() = 'classifier-action-entry-cfg']/child::*[local-name() = 'dei-marking-cfg']/child::*[local-name() = 'dei-marking-list']/child::*[local-name() = 'index']"/>
                                  </xsl:element>
                                  <xsl:element name="dei-value" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                    <xsl:value-of select="$actionClassifier/child::*[local-name() = 'classifier-action-entry-cfg']/child::*[local-name() = 'dei-marking-cfg']/child::*[local-name() = 'dei-marking-list']/child::*[local-name() = 'dei-value']"/>
                                  </xsl:element>
                                </xsl:element>
                              </xsl:if>
                              <xsl:if test="$curActionClassifier/actions/action/type = $A_BAC_COLOR">
                                <xsl:element name="bac-color" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                  <xsl:value-of select="$actionClassifier/child::*[local-name() = 'classifier-action-entry-cfg']/child::*[local-name() = 'bac-color']"/>
                                </xsl:element>
                              </xsl:if>
                              <xsl:element name="metered-flow" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">true</xsl:element>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:element>
                      </xsl:for-each>
                    </xsl:element>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:if test="string-length($classifierNameOfActionProfile4PortPolicerPolicy)&gt;0">
                      <!-- get from action profile -->
                      <xsl:element name="action-profile" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                        <xsl:element name="name" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                          <xsl:value-of select="$newPolicingActionProfileName"/>
                        </xsl:element>
                        <xsl:element name="realName" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                          <xsl:value-of select="$classifierNameOfActionProfile4PortPolicerPolicy"/>
                        </xsl:element>
                        <xsl:for-each select="$curActionPolicySec/classifiers/classifier[contains(filters/self-filter-types, $F_FLOW_COLOR) and contains(filters/inline-filter-type, $F_FLOW_COLOR) and boolean(filters/self-filter-flow-color)]">
                          <xsl:variable name="curActionClassifierName">
                            <xsl:value-of select="name"/>
                          </xsl:variable>
                          <xsl:variable name="color">
                            <xsl:value-of select="current()/child::*[local-name() = 'filters']/child::*[local-name() = 'self-filter-flow-color']"/>
                          </xsl:variable>
                          <xsl:variable name="classifierOfOnlyInlineFlowColor" select="//*[                             local-name() = 'classifier-entry'                             and parent::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']                             and child::*[local-name() = 'name'] = $curActionClassifierName                           ]"/>
                          <xsl:if test="$classifierOfOnlyInlineFlowColor">
                            <xsl:element name="action" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                              <xsl:element name="flow-color" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                <xsl:value-of select="$color"/>
                              </xsl:element>
                              <xsl:choose>
                                <xsl:when test="current()/actions/action/type = $A_DISCARD">
                                  <xsl:element name="discard" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension"/>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:if test="boolean(current()/actions/action/type = $A_PBIT_MARKING)">
                                    <xsl:variable name="actionCfg" select="$classifierOfOnlyInlineFlowColor/child::*[local-name() = 'classifier-action-entry-cfg' and child::*[local-name() = 'action-type' and contains(text(),'pbit-marking')]]"/>
                                    <xsl:element name="pbit-marking-list" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                      <xsl:element name="index" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                        <xsl:value-of select="$actionCfg/child::*[local-name() = 'pbit-marking-cfg']/child::*[local-name() = 'pbit-marking-list']/child::*[local-name() = 'index']"/>
                                      </xsl:element>
                                      <xsl:element name="pbit-value" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                        <xsl:value-of select="$actionCfg/child::*[local-name() = 'pbit-marking-cfg']/child::*[local-name() = 'pbit-marking-list']/child::*[local-name() = 'pbit-value']"/>
                                      </xsl:element>
                                    </xsl:element>
                                  </xsl:if>
                                  <xsl:if test="boolean(current()/actions/action/type = $A_DEI_MARKING)">
                                    <xsl:variable name="actionCfg" select="$classifierOfOnlyInlineFlowColor/child::*[local-name() = 'classifier-action-entry-cfg' and child::*[local-name() = 'action-type' and contains(text(),'dei-marking')]]"/>
                                    <xsl:element name="dei-marking-list" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                      <xsl:element name="index" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                        <xsl:value-of select="$actionCfg/child::*[local-name() = 'dei-marking-cfg']/child::*[local-name() = 'dei-marking-list']/child::*[local-name() = 'index']"/>
                                      </xsl:element>
                                      <xsl:element name="dei-value" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                        <xsl:value-of select="$actionCfg/child::*[local-name() = 'dei-marking-cfg']/child::*[local-name() = 'dei-marking-list']/child::*[local-name() = 'dei-value']"/>
                                      </xsl:element>
                                    </xsl:element>
                                  </xsl:if>
                                  <xsl:if test="boolean(current()/actions/action/type = $A_BAC_COLOR)">
                                    <xsl:variable name="actionCfg" select="$classifierOfOnlyInlineFlowColor/child::*[local-name() = 'classifier-action-entry-cfg' and child::*[local-name() = 'action-type' and contains(text(),'bac-color')]]"/>
                                    <xsl:element name="bac-color" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                      <xsl:value-of select="$actionCfg/child::*[local-name() = 'bac-color']"/>
                                    </xsl:element>
                                  </xsl:if>
                                  <xsl:element name="metered-flow" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">true</xsl:element>
                                  <xsl:element name="metered-color" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">true</xsl:element>
                                </xsl:otherwise>
                              </xsl:choose>
                            </xsl:element>
                          </xsl:if>
                        </xsl:for-each>
                      </xsl:element>
                      <!-- Another pap candidate only for STB policing-profile -->
                      <xsl:element name="action-profile" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                        <xsl:element name="name" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                          <xsl:value-of select="$newPolicingActionProfileName4STB"/>
                        </xsl:element>
                        <xsl:element name="realName" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                          <xsl:value-of select="$classifierNameOfActionProfile4PortPolicerPolicy"/>
                        </xsl:element>
                        <xsl:for-each select="$curActionPolicySec/classifiers/classifier[contains(filters/self-filter-types, $F_FLOW_COLOR) and contains(filters/inline-filter-type, $F_FLOW_COLOR) and boolean(filters/self-filter-flow-color)]">
                          <xsl:variable name="curActionClassifierName">
                            <xsl:value-of select="name"/>
                          </xsl:variable>
                          <xsl:variable name="color">
                            <xsl:value-of select="current()/child::*[local-name() = 'filters']/child::*[local-name() = 'self-filter-flow-color']"/>
                          </xsl:variable>
                          <xsl:variable name="classifierOfOnlyInlineFlowColor" select="//*[                             local-name() = 'classifier-entry'                             and parent::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']                             and child::*[local-name() = 'name'] = $curActionClassifierName                           ]"/>
                          <xsl:if test="$classifierOfOnlyInlineFlowColor">
                            <xsl:element name="action" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                              <xsl:element name="flow-color" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                <xsl:value-of select="$color"/>
                              </xsl:element>
                              <xsl:choose>
                                <xsl:when test="current()/actions/action/type = $A_DISCARD">
                                  <xsl:element name="discard" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension"/>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:if test="boolean(current()/actions/action/type = $A_PBIT_MARKING)">
                                    <xsl:variable name="actionCfg" select="$classifierOfOnlyInlineFlowColor/child::*[local-name() = 'classifier-action-entry-cfg' and child::*[local-name() = 'action-type' and contains(text(),'pbit-marking')]]"/>
                                    <xsl:element name="pbit-marking-list" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                      <xsl:element name="index" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                        <xsl:value-of select="$actionCfg/child::*[local-name() = 'pbit-marking-cfg']/child::*[local-name() = 'pbit-marking-list']/child::*[local-name() = 'index']"/>
                                      </xsl:element>
                                      <xsl:element name="pbit-value" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                        <xsl:value-of select="$actionCfg/child::*[local-name() = 'pbit-marking-cfg']/child::*[local-name() = 'pbit-marking-list']/child::*[local-name() = 'pbit-value']"/>
                                      </xsl:element>
                                    </xsl:element>
                                  </xsl:if>
                                  <xsl:if test="boolean(current()/actions/action/type = $A_DEI_MARKING)">
                                    <xsl:element name="dei-marking-list" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                      <xsl:variable name="actionCfg" select="$classifierOfOnlyInlineFlowColor/child::*[local-name() = 'classifier-action-entry-cfg' and child::*[local-name() = 'action-type' and contains(text(),'dei-marking')]]"/>
                                      <xsl:element name="index" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                        <xsl:value-of select="$actionCfg/child::*[local-name() = 'dei-marking-cfg']/child::*[local-name() = 'dei-marking-list']/child::*[local-name() = 'index']"/>
                                      </xsl:element>
                                      <xsl:element name="dei-value" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                        <xsl:value-of select="$actionCfg/child::*[local-name() = 'dei-marking-cfg']/child::*[local-name() = 'dei-marking-list']/child::*[local-name() = 'dei-value']"/>
                                      </xsl:element>
                                    </xsl:element>
                                  </xsl:if>
                                  <xsl:if test="boolean(current()/actions/action/type = $A_BAC_COLOR)">
                                    <xsl:variable name="actionCfg" select="$classifierOfOnlyInlineFlowColor/child::*[local-name() = 'classifier-action-entry-cfg' and child::*[local-name() = 'action-type' and contains(text(),'bac-color')]]"/>
                                    <xsl:element name="bac-color" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
                                      <xsl:value-of select="$actionCfg/child::*[local-name() = 'bac-color']"/>
                                    </xsl:element>
                                  </xsl:if>
                                  <xsl:element name="metered-flow" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">true</xsl:element>
                                </xsl:otherwise>
                              </xsl:choose>
                            </xsl:element>
                          </xsl:if>
                        </xsl:for-each>
                      </xsl:element>
                    </xsl:if>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </xsl:if>
          </xsl:element>
        </xsl:element>
      </xsl:if>
    </xsl:copy>
  </xsl:template>

  <!-- ====================================== Infra Function ====================================== -->

  <xsl:template name="isPortPolicerPrehandlingChanged">
    <xsl:param name="curPortPolicerPolicingProfileSec"/>
    <xsl:param name="curPreColorPolicySec"/>
    <xsl:param name="curPolicingTCPolicySec"/>
    <xsl:call-template name="isCCLPreHandlingChanged">
      <xsl:with-param name="curCCLPolicingProfileSec" select="$curPortPolicerPolicingProfileSec"/>
      <xsl:with-param name="curPreColorPolicySec" select="$curPreColorPolicySec"/>
      <xsl:with-param name="curPolicingTCPolicySec" select="$curPolicingTCPolicySec"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="isCCLPreHandlingChanged">
    <xsl:param name="curCCLPolicingProfileSec"/>
    <xsl:param name="curPreColorPolicySec"/>
    <xsl:param name="curPolicingTCPolicySec"/>
    <xsl:variable name="curPolicingProfileType">
      <xsl:value-of select="$curCCLPolicingProfileSec/type"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="($curPreColorPolicySec or $curPolicingTCPolicySec)                   and ($curPolicingProfileType = $POLICING_TYPE_TRTCM_COS                   or $curPolicingProfileType = $POLICING_TYPE_TRTCM_MEF_COS                   or $curPolicingProfileType = $POLICING_TYPE_TRTCM_MEF_COLOR_AWARE)">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="isPortPolicerActionChanged">
    <xsl:param name="classifierNameOfActionProfile4PortPolicerPolicy"/>
    <xsl:choose>
      <xsl:when test="string-length($classifierNameOfActionProfile4PortPolicerPolicy)&gt;0">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="isCCLActionChanged">
    <xsl:param name="curEnhancedFilterSecByRef"/>
    <xsl:param name="classifierNameOfActionProfile4PortPolicerPolicy"/>
    <xsl:choose>
      <xsl:when test="$curEnhancedFilterSecByRef or string-length($classifierNameOfActionProfile4PortPolicerPolicy)&gt;0">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="isPortPolicerPolicingProfileChange">
    <xsl:param name="curPortPolicerPolicingProfileSec"/>
    <xsl:param name="curPreColorPolicySec"/>
    <xsl:param name="curPolicingTCPolicySec"/>
    <xsl:param name="classifierNameOfActionProfile4PortPolicerPolicy"/>

    <xsl:variable name="isPortPolicerActionChanged">
      <xsl:call-template name="isPortPolicerActionChanged">
        <xsl:with-param name="classifierNameOfActionProfile4PortPolicerPolicy" select="$classifierNameOfActionProfile4PortPolicerPolicy"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="isPortPolicerPrehandlingChanged">
      <xsl:call-template name="isPortPolicerPrehandlingChanged">
        <xsl:with-param name="curPortPolicerPolicingProfileSec" select="$curPortPolicerPolicingProfileSec"/>
        <xsl:with-param name="curPreColorPolicySec" select="$curPreColorPolicySec"/>
        <xsl:with-param name="curPolicingTCPolicySec" select="$curPolicingTCPolicySec"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:value-of select="$isPortPolicerPrehandlingChanged = 'true' or $isPortPolicerActionChanged = 'true'"/>
  </xsl:template>

  <xsl:template name="isCCLPolicingProfileChange">
    <xsl:param name="curCCLPolicingProfileSec"/>
    <xsl:param name="curCCLClassifierSec"/>
    <xsl:param name="enhancedFiltersSec"/>
    <xsl:param name="curPreColorPolicySec"/>
    <xsl:param name="curPolicingTCPolicySec"/>
    <xsl:param name="classifierNameOfActionProfile4PortPolicerPolicy"/>

    <xsl:variable name="curRefFilterName">
      <xsl:value-of select="$curCCLClassifierSec/filters/ref-filter/name"/>
    </xsl:variable>
    <xsl:variable name="curEnhancedFilterSecByRef" select="$enhancedFiltersSec/enhanced-filter[       name = $curRefFilterName       and child::*[local-name() = 'ref-by']/child::*[local-name() = 'filter']     ]"/>
    <xsl:variable name="isCCLActionChanged">
      <xsl:call-template name="isCCLActionChanged">
        <xsl:with-param name="curEnhancedFilterSecByRef" select="$curEnhancedFilterSecByRef"/>
        <xsl:with-param name="classifierNameOfActionProfile4PortPolicerPolicy" select="$classifierNameOfActionProfile4PortPolicerPolicy"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="isCCLPreHandlingChanged">
      <xsl:call-template name="isCCLPreHandlingChanged">
        <xsl:with-param name="curCCLPolicingProfileSec" select="$curCCLPolicingProfileSec"/>
        <xsl:with-param name="curPreColorPolicySec" select="$curPreColorPolicySec"/>
        <xsl:with-param name="curPolicingTCPolicySec" select="$curPolicingTCPolicySec"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="$isCCLPreHandlingChanged = 'true' or $isCCLActionChanged = 'true'"/>
  </xsl:template>

  <xsl:template name="isCCLClassifierOwnNeedChange">
    <xsl:param name="curCCLClassifierSec"/>
    <xsl:variable name="classifierOwnNeedChanged">
      <xsl:choose>
        <xsl:when test="$curCCLClassifierSec/filters/enh-filter-type">
          <xsl:value-of select="true()"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="false()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$classifierOwnNeedChanged"/>
  </xsl:template>

  <xsl:template name="isPortPolicerClassifierChange">
    <xsl:param name="curPortPolicerClassifierSec"/>
    <xsl:param name="curPreColorPolicySec"/>
    <xsl:param name="curPolicingTCPolicySec"/>
    <xsl:param name="classifierNameOfActionProfile4PortPolicerPolicy"/>

    <xsl:variable name="curPortPolicerPolicingProfileSec" select="$curPortPolicerClassifierSec/actions/action/policing-profile"/>
    <xsl:choose>
      <xsl:when test="$curPortPolicerPolicingProfileSec">
        <xsl:call-template name="isPortPolicerPolicingProfileChange">
          <xsl:with-param name="curPortPolicerPolicingProfileSec" select="$curPortPolicerPolicingProfileSec"/>
          <xsl:with-param name="curPreColorPolicySec" select="$curPreColorPolicySec"/>
          <xsl:with-param name="curPolicingTCPolicySec" select="$curPolicingTCPolicySec"/>
          <xsl:with-param name="classifierNameOfActionProfile4PortPolicerPolicy" select="$classifierNameOfActionProfile4PortPolicerPolicy"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="isCCLClassifierChange">
    <xsl:param name="curCCLClassifierSec"/>
    <xsl:param name="enhancedFiltersSec"/>
    <xsl:param name="curPreColorPolicySec"/>
    <xsl:param name="curPolicingTCPolicySec"/>
    <xsl:param name="classifierNameOfActionProfile4PortPolicerPolicy"/>

    <xsl:variable name="classifierOwnNeedChanged">
      <xsl:call-template name="isCCLClassifierOwnNeedChange">
        <xsl:with-param name="curCCLClassifierSec" select="$curCCLClassifierSec"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="policingNeedChanged">
      <xsl:variable name="curCCLPolicingProfileSec" select="$curCCLClassifierSec/actions/action/policing-profile"/>
      <xsl:choose>
        <xsl:when test="$curCCLPolicingProfileSec">
          <xsl:call-template name="isCCLPolicingProfileChange">
            <xsl:with-param name="curCCLPolicingProfileSec" select="$curCCLPolicingProfileSec"/>
            <xsl:with-param name="curCCLClassifierSec" select="$curCCLClassifierSec"/>
            <xsl:with-param name="enhancedFiltersSec" select="$enhancedFiltersSec"/>
            <xsl:with-param name="curPreColorPolicySec" select="$curPreColorPolicySec"/>
            <xsl:with-param name="curPolicingTCPolicySec" select="$curPolicingTCPolicySec"/>
            <xsl:with-param name="classifierNameOfActionProfile4PortPolicerPolicy" select="$classifierNameOfActionProfile4PortPolicerPolicy"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="false()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$classifierOwnNeedChanged = 'true' or $policingNeedChanged = 'true'"/>
  </xsl:template>

  <xsl:template name="isPortPolicerPolicyChange">
    <xsl:param name="curPortPolicerPolicySec"/>
    <xsl:param name="curPreColorPolicySec"/>
    <xsl:param name="curPolicingTCPolicySec"/>
    <xsl:param name="classifierNameOfActionProfile4PortPolicerPolicy"/>

    <xsl:variable name="curPortPolicerClassifierSec" select="$curPortPolicerPolicySec/classifiers/classifier"/>
    <xsl:call-template name="isPortPolicerClassifierChange">
      <xsl:with-param name="curPortPolicerClassifierSec" select="$curPortPolicerClassifierSec"/>
      <xsl:with-param name="curPreColorPolicySec" select="$curPreColorPolicySec"/>
      <xsl:with-param name="curPolicingTCPolicySec" select="$curPolicingTCPolicySec"/>
      <xsl:with-param name="classifierNameOfActionProfile4PortPolicerPolicy" select="$classifierNameOfActionProfile4PortPolicerPolicy"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="isCCLPolicyChange">
    <xsl:param name="curCCLPolicySec"/>
    <xsl:param name="enhancedFiltersSec"/>
    <xsl:param name="curPreColorPolicySec"/>
    <xsl:param name="curPolicingTCPolicySec"/>
    <xsl:param name="classifierNameOfActionProfile4PortPolicerPolicy"/>

    <xsl:variable name="hasClassifierChange">
      <xsl:for-each select="$curCCLPolicySec/classifiers/classifier">
        <xsl:variable name="curCCLClassifierSec" select="current()"/>
        <xsl:call-template name="isCCLClassifierChange">
          <xsl:with-param name="curCCLClassifierSec" select="$curCCLClassifierSec"/>
          <xsl:with-param name="enhancedFiltersSec" select="$enhancedFiltersSec"/>
          <xsl:with-param name="curPreColorPolicySec" select="$curPreColorPolicySec"/>
          <xsl:with-param name="curPolicingTCPolicySec" select="$curPolicingTCPolicySec"/>
          <xsl:with-param name="classifierNameOfActionProfile4PortPolicerPolicy" select="$classifierNameOfActionProfile4PortPolicerPolicy"/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:variable>

    <xsl:value-of select="contains($hasClassifierChange,'true')"/>

  </xsl:template>

  <xsl:template name="findCurClassifierByPolicyAndRefFilterName">
    <xsl:param name="policySec"/>
    <xsl:param name="refFilterName"/>

    <xsl:variable name="curClassifierSec" select="       $policySec/classifiers/classifier[normalize-space(filters/ref-filter/name) = $refFilterName]     "/>

    <xsl:value-of select="normalize-space($curClassifierSec/name)"/>

  </xsl:template>

  <xsl:template name="findEnhancedFilterFromCCLClassifier">
    <xsl:param name="curCCLClassifier"/>
    <xsl:param name="curEnhancedFiltersSec"/>
    <xsl:variable name="refFilterName" select="$curCCLClassifier/filters/ref-filter/name"/>
    <xsl:if test="$refFilterName">
      <xsl:variable name="curEnhancedFilterSec" select="$curEnhancedFiltersSec/enhanced-filter[name = $refFilterName]"/>
      <xsl:if test="$curEnhancedFilterSec and $curEnhancedFilterSec/ref-by/filter">
        <xsl:value-of select="$curEnhancedFilterSec/name"/>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template name="generateActionProfileSourceName4PortPolicerPolicy">
    <xsl:param name="curActionPolicySec"/>
    <xsl:variable name="slicingPrefix">
      <xsl:variable name="firstClassifierName">
        <xsl:value-of select="$curActionPolicySec/classifiers/classifier[contains(filters/self-filter-types, $F_FLOW_COLOR) and contains(filters/inline-filter-type, $F_FLOW_COLOR) and boolean(filters/self-filter-flow-color)][position() = 1]/child::*[local-name() = 'name']"/>
      </xsl:variable>
      <xsl:call-template name="getSlicingPrefix">
        <xsl:with-param name="name" select="$firstClassifierName"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="classifierNameOfActionProfile4PortPolicerPolicyWithoutSlicingPrefix">
      <xsl:for-each select="$curActionPolicySec/classifiers/classifier[contains(filters/self-filter-types, $F_FLOW_COLOR) and contains(filters/inline-filter-type, $F_FLOW_COLOR) and boolean(filters/self-filter-flow-color)]">
        <xsl:variable name="curClassifierName">
          <xsl:value-of select="current()/child::*[local-name() = 'name']"/>
        </xsl:variable>
        <xsl:variable name="curClassifierNameWithoutPrefix">
          <xsl:call-template name="getNameWithoutSlicingPrefix">
            <xsl:with-param name="name" select="$curClassifierName"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="position() != 1">
            <xsl:value-of select="concat(classifierNameOfActionProfile4PortPolicerPolicyWithoutSlicingPrefix,'_',$curClassifierNameWithoutPrefix)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$curClassifierNameWithoutPrefix"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$slicingPrefix and string-length($slicingPrefix) &gt; 0">
        <xsl:value-of select="concat($slicingPrefix,$TILDE,$classifierNameOfActionProfile4PortPolicerPolicyWithoutSlicingPrefix)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$classifierNameOfActionProfile4PortPolicerPolicyWithoutSlicingPrefix"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="generateActionProfileSourceName4CCLPolicy">
    <xsl:param name="curRootFilter"/>
    <xsl:variable name="slicingPrefix">
      <xsl:variable name="firstClassifierName">
        <xsl:value-of select="$curRootFilter/ref-by/filter/use-in-classifier[position() = 1]"/>
      </xsl:variable>
      <xsl:call-template name="getSlicingPrefix">
        <xsl:with-param name="name" select="$firstClassifierName"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="classifierNameOfActionProfile4CCLPolicyWithoutSlicingPrefix">
      <xsl:for-each select="$curRootFilter/ref-by/filter/use-in-classifier">
        <xsl:variable name="curClassifierName">
          <xsl:value-of select="current()"/>
        </xsl:variable>
        <xsl:variable name="curClassifierNameWithoutPrefix">
          <xsl:call-template name="getNameWithoutSlicingPrefix">
            <xsl:with-param name="name" select="$curClassifierName"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="position() != 1">
            <xsl:value-of select="concat(classifierNameOfActionProfile4CCLPolicyWithoutSlicingPrefix,'_',$curClassifierNameWithoutPrefix)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$curClassifierNameWithoutPrefix"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$slicingPrefix and string-length($slicingPrefix) &gt; 0">
        <xsl:value-of select="concat($slicingPrefix,$TILDE,$classifierNameOfActionProfile4CCLPolicyWithoutSlicingPrefix)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$classifierNameOfActionProfile4CCLPolicyWithoutSlicingPrefix"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="generateRealPolicingName">
    <xsl:param name="isPrehandlingChanged"/>
    <xsl:param name="isActionChanged"/>
    <xsl:param name="policingType"/>
    <xsl:param name="policingName"/>
    <xsl:param name="policingPolicyName"/>
    <xsl:param name="colorPolicyName"/>
    <xsl:param name="actionProfileName4STB"/>
    <xsl:param name="actionProfileName"/>

    <xsl:variable name="preHandlingName">
      <xsl:if test="$isPrehandlingChanged = 'true'">
        <xsl:choose>
          <xsl:when test="$policingType = $POLICING_TYPE_TRTCM_COS or $policingType = $POLICING_TYPE_TRTCM_MEF_COS">
            <xsl:call-template name="createNewModelName">
              <xsl:with-param name="namingRuleType" select="$NAMING_RULE_GENERIC_WITHOUT_PROFILE_NAME"/>
              <xsl:with-param name="profileName" select="''"/>
              <xsl:with-param name="sourceName" select="$policingPolicyName"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$policingType = $POLICING_TYPE_TRTCM_MEF_COLOR_AWARE">
            <xsl:call-template name="createNewModelName">
              <xsl:with-param name="namingRuleType" select="$NAMING_RULE_GENERIC_WITHOUT_PROFILE_NAME"/>
              <xsl:with-param name="profileName" select="''"/>
              <xsl:with-param name="sourceName" select="$colorPolicyName"/>
            </xsl:call-template>
          </xsl:when>
        </xsl:choose>
      </xsl:if>
    </xsl:variable>

    <xsl:variable name="preActionName">
      <xsl:if test="$isActionChanged = 'true'">
        <xsl:choose>
          <xsl:when test="$policingType = $POLICING_TYPE_STB">
            <xsl:value-of select="$actionProfileName4STB"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$actionProfileName"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </xsl:variable>

    <xsl:variable name="policingNameWithoutPrefix">
      <xsl:call-template name="getNameWithoutSlicingPrefix">
        <xsl:with-param name="name" select="$policingName"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:value-of select="concat($policingNameWithoutPrefix,$preHandlingName,$preActionName)"/>
  </xsl:template>

  <xsl:template name="createNewModelName">
    <xsl:param name="namingRuleType"/>
    <xsl:param name="sourceName"/>
    <xsl:param name="profileName"/>

    <xsl:variable name="sourceNameSlicingPrefix">
      <xsl:call-template name="getSlicingPrefix">
        <xsl:with-param name="name" select="$sourceName"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="sourceNameWithoutSlicingPrefix">
      <xsl:call-template name="getNameWithoutSlicingPrefix">
        <xsl:with-param name="name" select="$sourceName"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="profileWithoutSlicingPrefix">
      <xsl:call-template name="getNameWithoutSlicingPrefix">
        <xsl:with-param name="name" select="$profileName"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="genericName">
      <xsl:choose>
        <xsl:when test="$namingRuleType = $NAMING_RULE_QC_POLICY or $namingRuleType = $NAMING_RULE_QC_CLASSIFIER">
          <xsl:value-of select="concat('QC_',$sourceNameWithoutSlicingPrefix,'_',$profileWithoutSlicingPrefix)"/>
        </xsl:when>
        <xsl:when test="$namingRuleType = $NAMING_RULE_ACTION_PROFILE_FOR_STB">
          <xsl:value-of select="concat('S_',$sourceNameWithoutSlicingPrefix)"/>
        </xsl:when>
        <xsl:when test="$namingRuleType = $NAMING_RULE_GENERIC_WITHOUT_PROFILE_NAME or $namingRuleType = $NAMING_RULE_PREHANDLING_ENTRY">
          <xsl:value-of select="$sourceNameWithoutSlicingPrefix"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat($sourceNameWithoutSlicingPrefix,'_',$profileWithoutSlicingPrefix)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="finalNameWithoutPrefix">
      <xsl:choose>
        <xsl:when test="string-length($genericName) &gt; 61">
          <xsl:variable name="modeId">
            <xsl:call-template name="asciiSum">
              <xsl:with-param name="inputStr" select="$genericName"/>
              <xsl:with-param name="ratio" select="67"/>
              <xsl:with-param name="preResult" select="0"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:value-of select="concat(substring($genericName,1, 61 - string-length($modeId) - 1),'_',$modeId)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$genericName"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="finalName">
      <xsl:choose>
        <xsl:when test="$sourceNameSlicingPrefix and string-length($sourceNameSlicingPrefix)&gt;0 and $namingRuleType != $NAMING_RULE_PREHANDLING_ENTRY">
          <xsl:value-of select="concat($sourceNameSlicingPrefix,$TILDE,$finalNameWithoutPrefix)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$finalNameWithoutPrefix"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:value-of select="$finalName"/>
  </xsl:template>
  
  <xsl:template name="createNoPolicingNewModelName">
    <xsl:param name="namingRuleType"/>
    <xsl:param name="sourceName"/>

    <xsl:variable name="sourceNameSlicingPrefix">
      <xsl:call-template name="getSlicingPrefix">
        <xsl:with-param name="name" select="$sourceName"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="sourceNameWithoutSlicingPrefix">
      <xsl:call-template name="getNameWithoutSlicingPrefix">
        <xsl:with-param name="name" select="$sourceName"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="genericName">
      <xsl:choose>
        <xsl:when test="$namingRuleType = $NAMING_RULE_QC_POLICY or $namingRuleType = $NAMING_RULE_QC_CLASSIFIER">
          <xsl:value-of select="concat('QC_',$sourceNameWithoutSlicingPrefix)"/>
        </xsl:when>
        <xsl:when test="$namingRuleType = $NAMING_RULE_BOTH_IN_CCL_AND_MARKER_POLICY_CLASSIFIER">
          <xsl:value-of select="concat($sourceNameWithoutSlicingPrefix, '_CCL')"/>
        </xsl:when>
        <xsl:when test="$namingRuleType = $NAMING_RULE_ACTION_PROFILE_FOR_STB">
          <xsl:value-of select="concat('S_',$sourceNameWithoutSlicingPrefix)"/>
        </xsl:when>
        <xsl:when test="$namingRuleType = $NAMING_RULE_GENERIC_WITHOUT_PROFILE_NAME or $namingRuleType = $NAMING_RULE_PREHANDLING_ENTRY">
          <xsl:value-of select="$sourceNameWithoutSlicingPrefix"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$sourceNameWithoutSlicingPrefix"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="finalNameWithoutPrefix">
      <xsl:choose>
        <xsl:when test="string-length($genericName) &gt; 61">
          <xsl:variable name="modeId">
            <xsl:call-template name="asciiSum">
              <xsl:with-param name="inputStr" select="$genericName"/>
              <xsl:with-param name="ratio" select="67"/>
              <xsl:with-param name="preResult" select="0"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:value-of select="concat(substring($genericName,1, 61 - string-length($modeId) - 1),'_',$modeId)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$genericName"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="finalName">
      <xsl:choose>
        <xsl:when test="$sourceNameSlicingPrefix and string-length($sourceNameSlicingPrefix)&gt;0 and $namingRuleType != $NAMING_RULE_PREHANDLING_ENTRY">
          <xsl:value-of select="concat($sourceNameSlicingPrefix,$TILDE,$finalNameWithoutPrefix)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$finalNameWithoutPrefix"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:value-of select="$finalName"/>
  </xsl:template>

  <xsl:template name="asciiSum">
    <xsl:param name="inputStr"/>
    <xsl:param name="preResult"/>
    <xsl:param name="ratio"/>
    <xsl:choose>
      <xsl:when test="$inputStr != ''">
        <xsl:variable name="letter" select="substring($inputStr, string-length($inputStr), 1)"/>
        <xsl:variable name="letterValue">
          <xsl:call-template name="asciiValue">
            <xsl:with-param name="inputChar" select="$letter"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="result">
          <xsl:value-of select="format-number($ratio * $preResult + $letterValue,'#')"/>
        </xsl:variable>
        <xsl:variable name="computedResult">
          <xsl:choose>
            <xsl:when test="$result &gt; 999999">
              <xsl:value-of select="format-number($result mod 100000,'000000')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="format-number($result,'000000')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:call-template name="asciiSum">
          <xsl:with-param name="inputStr" select="substring($inputStr,1,string-length($inputStr) - 1)"/>
          <xsl:with-param name="preResult" select="$computedResult"/>
          <xsl:with-param name="ratio" select="$ratio"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$preResult"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="asciiValue">
    <xsl:param name="inputChar"/>

    <xsl:choose>
      <xsl:when test="$inputChar = ' '">
        <xsl:value-of select="32"/>
      </xsl:when>
      <xsl:when test="$inputChar = '!'">
        <xsl:value-of select="33"/>
      </xsl:when>
      <xsl:when test="$inputChar = '&quot;'">
        <xsl:value-of select="34"/>
      </xsl:when>
      <xsl:when test="$inputChar = '#'">
        <xsl:value-of select="35"/>
      </xsl:when>
      <xsl:when test="$inputChar = '$'">
        <xsl:value-of select="36"/>
      </xsl:when>
      <xsl:when test="$inputChar = '%'">
        <xsl:value-of select="37"/>
      </xsl:when>
      <xsl:when test="$inputChar = '&amp;'">
        <xsl:value-of select="38"/>
      </xsl:when>
      <xsl:when test="$inputChar = ','">
        <xsl:value-of select="39"/>
      </xsl:when>
      <xsl:when test="$inputChar = '('">
        <xsl:value-of select="40"/>
      </xsl:when>
      <xsl:when test="$inputChar = ')'">
        <xsl:value-of select="41"/>
      </xsl:when>
      <xsl:when test="$inputChar = '*'">
        <xsl:value-of select="42"/>
      </xsl:when>
      <xsl:when test="$inputChar = '+'">
        <xsl:value-of select="43"/>
      </xsl:when>
      <xsl:when test="$inputChar = ','">
        <xsl:value-of select="44"/>
      </xsl:when>
      <xsl:when test="$inputChar = '-'">
        <xsl:value-of select="45"/>
      </xsl:when>
      <xsl:when test="$inputChar = '.'">
        <xsl:value-of select="46"/>
      </xsl:when>
      <xsl:when test="$inputChar = '/'">
        <xsl:value-of select="47"/>
      </xsl:when>
      <xsl:when test="$inputChar = '0'">
        <xsl:value-of select="48"/>
      </xsl:when>
      <xsl:when test="$inputChar = '1'">
        <xsl:value-of select="49"/>
      </xsl:when>
      <xsl:when test="$inputChar = '2'">
        <xsl:value-of select="50"/>
      </xsl:when>
      <xsl:when test="$inputChar = '3'">
        <xsl:value-of select="51"/>
      </xsl:when>
      <xsl:when test="$inputChar = '4'">
        <xsl:value-of select="52"/>
      </xsl:when>
      <xsl:when test="$inputChar = '5'">
        <xsl:value-of select="53"/>
      </xsl:when>
      <xsl:when test="$inputChar = '6'">
        <xsl:value-of select="54"/>
      </xsl:when>
      <xsl:when test="$inputChar = '7'">
        <xsl:value-of select="55"/>
      </xsl:when>
      <xsl:when test="$inputChar = '8'">
        <xsl:value-of select="56"/>
      </xsl:when>
      <xsl:when test="$inputChar = '9'">
        <xsl:value-of select="57"/>
      </xsl:when>
      <xsl:when test="$inputChar = ':'">
        <xsl:value-of select="58"/>
      </xsl:when>
      <xsl:when test="$inputChar = ';'">
        <xsl:value-of select="59"/>
      </xsl:when>
      <xsl:when test="$inputChar = '&lt;'">
        <xsl:value-of select="60"/>
      </xsl:when>
      <xsl:when test="$inputChar = '='">
        <xsl:value-of select="61"/>
      </xsl:when>
      <xsl:when test="$inputChar = '&gt;'">
        <xsl:value-of select="62"/>
      </xsl:when>
      <xsl:when test="$inputChar = '?'">
        <xsl:value-of select="63"/>
      </xsl:when>
      <xsl:when test="$inputChar = '@'">
        <xsl:value-of select="64"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'A'">
        <xsl:value-of select="65"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'B'">
        <xsl:value-of select="66"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'C'">
        <xsl:value-of select="67"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'D'">
        <xsl:value-of select="68"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'E'">
        <xsl:value-of select="69"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'F'">
        <xsl:value-of select="70"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'G'">
        <xsl:value-of select="71"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'H'">
        <xsl:value-of select="72"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'I'">
        <xsl:value-of select="73"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'J'">
        <xsl:value-of select="74"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'K'">
        <xsl:value-of select="75"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'L'">
        <xsl:value-of select="76"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'M'">
        <xsl:value-of select="77"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'N'">
        <xsl:value-of select="78"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'O'">
        <xsl:value-of select="79"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'P'">
        <xsl:value-of select="80"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'Q'">
        <xsl:value-of select="81"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'R'">
        <xsl:value-of select="82"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'S'">
        <xsl:value-of select="83"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'T'">
        <xsl:value-of select="84"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'U'">
        <xsl:value-of select="85"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'V'">
        <xsl:value-of select="86"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'W'">
        <xsl:value-of select="87"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'X'">
        <xsl:value-of select="88"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'Y'">
        <xsl:value-of select="89"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'Z'">
        <xsl:value-of select="90"/>
      </xsl:when>
      <xsl:when test="$inputChar = '['">
        <xsl:value-of select="91"/>
      </xsl:when>
      <xsl:when test="$inputChar = '\'">
        <xsl:value-of select="92"/>
      </xsl:when>
      <xsl:when test="$inputChar = ']'">
        <xsl:value-of select="93"/>
      </xsl:when>
      <xsl:when test="$inputChar = '^'">
        <xsl:value-of select="94"/>
      </xsl:when>
      <xsl:when test="$inputChar = '_'">
        <xsl:value-of select="95"/>
      </xsl:when>
      <xsl:when test="$inputChar = '`'">
        <xsl:value-of select="96"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'a'">
        <xsl:value-of select="97"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'b'">
        <xsl:value-of select="98"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'c'">
        <xsl:value-of select="99"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'd'">
        <xsl:value-of select="100"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'e'">
        <xsl:value-of select="101"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'f'">
        <xsl:value-of select="102"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'g'">
        <xsl:value-of select="103"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'h'">
        <xsl:value-of select="104"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'i'">
        <xsl:value-of select="105"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'j'">
        <xsl:value-of select="106"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'k'">
        <xsl:value-of select="107"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'l'">
        <xsl:value-of select="108"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'm'">
        <xsl:value-of select="109"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'n'">
        <xsl:value-of select="110"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'o'">
        <xsl:value-of select="111"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'p'">
        <xsl:value-of select="112"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'q'">
        <xsl:value-of select="113"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'r'">
        <xsl:value-of select="114"/>
      </xsl:when>
      <xsl:when test="$inputChar = 's'">
        <xsl:value-of select="115"/>
      </xsl:when>
      <xsl:when test="$inputChar = 't'">
        <xsl:value-of select="116"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'u'">
        <xsl:value-of select="117"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'v'">
        <xsl:value-of select="118"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'w'">
        <xsl:value-of select="119"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'x'">
        <xsl:value-of select="120"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'y'">
        <xsl:value-of select="121"/>
      </xsl:when>
      <xsl:when test="$inputChar = 'z'">
        <xsl:value-of select="122"/>
      </xsl:when>
      <xsl:when test="$inputChar = '{'">
        <xsl:value-of select="123"/>
      </xsl:when>
      <xsl:when test="$inputChar = '|'">
        <xsl:value-of select="124"/>
      </xsl:when>
      <xsl:when test="$inputChar = '}'">
        <xsl:value-of select="125"/>
      </xsl:when>
      <xsl:when test="$inputChar = '~'">
        <xsl:value-of select="126"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="0"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="getNameWithoutSlicingPrefix">
    <xsl:param name="name"/>
    <xsl:choose>
      <xsl:when test="contains($name,$TILDE)">
        <xsl:value-of select="substring-after($name,$TILDE)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$name"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="getSlicingPrefix">
    <xsl:param name="name"/>
    <xsl:if test="contains($name,$TILDE)">
      <xsl:value-of select="substring-before($name,$TILDE)"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="isClsUsedByMarkerPolicy">
    <xsl:param name="ClsName"/>
    <xsl:variable name="isClsInMarkPolicy" select="//*[       local-name() = 'classifiers'       and child::*[local-name() = 'name' and text() = $ClsName]       and parent::*[local-name() = 'policy-migration-cache' and child::*[local-name() = 'policy-type' and text() = $POLICY_TYPE_MARKER]]       and ancestor::*[local-name() = 'policy']       and ancestor::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']     ]"/>
    <xsl:if test="$isClsInMarkPolicy">
      <xsl:value-of select="$isClsInMarkPolicy"/>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
