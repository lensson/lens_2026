<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:cfg-ns="urn:ietf:params:xml:ns:netconf:base:1.0"
                              xmlns:itf-ns="urn:ietf:params:xml:ns:yang:ietf-interfaces"
                              xmlns:map="http://www.w3.org/2005/xpath-functions/map"
                              xmlns:bbf-qos-cls="urn:bbf:yang:bbf-qos-classifiers"
                              xmlns:bbf-qos-pol="urn:bbf:yang:bbf-qos-policies"
                              xmlns:bbf-qos-plc="urn:bbf:yang:bbf-qos-policing"
                              xmlns:bbf-qos-enhfilt="urn:bbf:yang:bbf-qos-enhanced-filters"
                              xmlns:bbf-qos-filt="urn:bbf:yang:bbf-qos-filters"
                              xmlns:bbf-qos-rc="urn:bbf:yang:bbf-qos-rate-control"
                              xmlns:nokia-qos-cls-ext="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-classifier-extension"
                              xmlns:nokia-qos-filt="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-qos-filters-ext"
                              xmlns:nokia-qos-plc-ext="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <!-- classifier action type start-->
  <xsl:variable name="A_RATE_LIMIT" select="'rate-limit-frames'"/>
  <xsl:variable name="A_RATE_LIMIT_WITH_NS" select="'bbf-qos-rc:rate-limit-frames'"/>
  <xsl:variable name="A_SCHEDULING_TRAFFIC" select="'scheduling-traffic-class'"/>
  <xsl:variable name="A_SCHEDULING_TRAFFIC_WITH_NS" select="'bbf-qos-cls:scheduling-traffic-class'"/>
  <xsl:variable name="A_POLICING" select="'policing'"/>
  <xsl:variable name="A_POLICING_WITH_NS" select="'bbf-qos-plc:policing'"/>
  <xsl:variable name="A_PASS" select="'pass'"/>
  <xsl:variable name="A_PASS_WITH_NS" select="'bbf-qos-cls:pass'"/>
  <xsl:variable name="A_DISCARD" select="'discard'"/>
  <xsl:variable name="A_DISCARD_WITH_NS" select="'bbf-qos-plc:discard'"/>
  <xsl:variable name="A_PBIT_MARKING" select="'pbit-marking'"/>
  <xsl:variable name="A_PBIT_MARKING_WITH_NS" select="'bbf-qos-cls:pbit-marking'"/>
  <xsl:variable name="A_DEI_MARKING" select="'dei-marking'"/>
  <xsl:variable name="A_DEI_MARKING_WITH_NS" select="'bbf-qos-cls:dei-marking'"/>
  <xsl:variable name="A_FLOW_COLOR" select="'flow-color'"/>
  <xsl:variable name="A_FLOW_COLOR_WITH_NS" select="'bbf-qos-plc:flow-color'"/>
  <xsl:variable name="A_COUNT" select="'count'"/>
  <xsl:variable name="A_COUNT_WITH_NS" select="'nokia-qos-cls-ext:count'"/>
  <xsl:variable name="A_BAC_COLOR" select="'bac-color'"/>
  <xsl:variable name="A_BAC_COLOR_WITH_NS" select="'bbf-qos-plc:bac-color'"/>
  <xsl:variable name="A_PBIT_POLICING_TC" select="'policing-traffic-class'"/>
  <xsl:variable name="A_PBIT_POLICING_TC_WITH_NS" select="'nokia-qos-cls-ext:policing-traffic-class'"/>
  <!-- classifier action type end-->
 
  <!-- classifier types start-->
  <!-- type 1 -->
  <xsl:variable name="CLS_TYPE_IGMP_TO_PBITMARKING" select="'CLS_TYPE_IGMP_TO_PBITMARKING'"/>
  <xsl:variable name="CLS_TYPE_UNTAGGED_TO_PBITMARKING" select="'CLS_TYPE_UNTAGGED_TO_PBITMARKING'"/>
  <xsl:variable name="CLS_TYPE_PBIT_TO_PBITMARKING" select="'CLS_TYPE_PBIT_TO_PBITMARKING'"/> <!-- include inpbit and pbit-marking -->
  <xsl:variable name="CLS_TYPE_PBIT_TO_DEIMARKING" select="'CLS_TYPE_PBIT_TO_DEIMARKING'"/>
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
  <xsl:variable name="CLS_TYPE_METERED_FLOW_TO_POLICING" select="'CLS_TYPE_METERED_FLOW_TO_POLICING'"/>
  <!-- type 6 -->
  <xsl:variable name="CLS_TYPE_EN_FILTER_WITH_FLOW_COLOR" select="'CLS_TYPE_EN_FILTER_WITH_FLOW_COLOR'"/>
  <xsl:variable name="CLS_TYPE_FILTER_WITH_FLOW_COLOR" select="'CLS_TYPE_FILTER_WITH_FLOW_COLOR'"/>
  <!-- type 7 -->
  <xsl:variable name="CLS_TYPE_ACTION_COUNT" select="'CLS_TYPE_ACTION_COUNT'"/>
  <!-- type 8 -->
  <xsl:variable name="CLS_TYPE_ACTION_WITH_SCHEDULING_TC" select="'CLS_TYPE_ACTION_WITH_SCHEDULING_TC'"/>
  <!-- type 9 -->
  <xsl:variable name="CLS_TYPE_MATCHALL_TO_RATE_LIMIT" select="'CLS_TYPE_MATCHALL_TO_RATE_LIMIT'"/>
  <!-- type 10 -->
  <xsl:variable name="CLS_TYPE_ACTION_BAC_COLOR" select="'CLS_TYPE_ACTION_BAC_COLOR'"/>
  <xsl:variable name="CLS_TYPE_INVALID_TWO_TAGS" select="'CLS_TYPE_INVALID_TWO_TAGS'"/>
  <xsl:variable name="CLS_TYPE_INVALID_ACTION" select="'CLS_TYPE_INVALID_ACTION'"/>
  <xsl:variable name="CLS_TYPE_INVALID" select="'CLS_TYPE_INVALID'"/>
  <!-- classifier types end-->


  <!--policy types start-->
  <!-- Allowed policy types -->
  <xsl:variable name="POLICY_TYPE_MARKER" select="'POLICY_TYPE_MARKER'"/>
  <xsl:variable name="POLICY_TYPE_CCL" select="'POLICY_TYPE_CCL'"/>
  <xsl:variable name="POLICY_TYPE_PORT_POLICER" select="'POLICY_TYPE_PORT_POLICER'"/>
  <xsl:variable name="POLICY_TYPE_SCHEDULE" select="'POLICY_TYPE_SCHEDULE'"/>
  <xsl:variable name="POLICY_TYPE_QUEUE_COLOR" select="'POLICY_TYPE_QUEUE_COLOR'"/>
  <xsl:variable name="POLICY_TYPE_COUNT" select="'POLICY_TYPE_COUNT'"/>
  <xsl:variable name="POLICY_TYPE_RATE_LIMIT" select="'POLICY_TYPE_RATE_LIMIT'"/>
  <!--Forbidden legacy obsolete policy types -->
  <xsl:variable name="POLICY_TYPE_COLOR" select="'POLICY_TYPE_COLOR'"/>
  <xsl:variable name="POLICY_TYPE_PBIT_POLICING_TC" select="'POLICY_TYPE_PBIT_POLICING_TC'"/>
  <xsl:variable name="POLICY_TYPE_ACTION" select="'POLICY_TYPE_ACTION'"/>
  <xsl:variable name="POLICY_TYPE_CCL_OBSOLETE" select="'POLICY_TYPE_CCL_OBSOLETE'"/>
  <!-- unknown policy type-->
  <xsl:variable name="POLICY_TYPE_UNKNOWN" select="'POLICY_TYPE_UNKNOWN'"/>
  <!--policy types end-->

  <!-- collecting classifiers info -->
  <xsl:variable name="classifiers_Info">
    <xsl:for-each select ="/cfg-ns:config/bbf-qos-cls:classifiers/bbf-qos-cls:classifier-entry">
      <xsl:variable name="currentEntry" select="."/>
      <xsl:variable name="classifierName" select="$currentEntry/bbf-qos-cls:name"/>

      <xsl:variable name="classifierType">
        <xsl:call-template name="getClassifierType">
        <xsl:with-param name="classifierNode" select="$currentEntry"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:element name="classifiers">
        <xsl:element name="name">
          <xsl:value-of select="$classifierName"/>
        </xsl:element>

        <xsl:element name="classifierType">
          <xsl:value-of select="$classifierType"/>
        </xsl:element>
      </xsl:element>
    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="classifiers_Info_map" select="map:merge(for $elem in $classifiers_Info/classifiers return map{$elem/name : $elem})"/>

  <!-- collecting policy info -->
  <xsl:variable name="policy_Info">
    <xsl:for-each select ="/cfg-ns:config/bbf-qos-pol:policies/bbf-qos-pol:policy">
      <xsl:element name="policy">
        <xsl:element name="name">
          <xsl:value-of select="current()/bbf-qos-pol:name"/>
        </xsl:element>

        <xsl:variable name="firstClassifierNameInPolicy">
          <xsl:value-of select="current()/bbf-qos-pol:classifiers[1]/bbf-qos-pol:name"/>
        </xsl:variable>
        <xsl:variable name="firstClassifierType">
          <xsl:value-of select="$classifiers_Info_map($firstClassifierNameInPolicy)/classifierType"/>
        </xsl:variable>
        <xsl:variable name="varPolicyType">
          <xsl:call-template name="getPolicyType">
          <xsl:with-param name="classifierType" select="$firstClassifierType"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:element name="policyType">
          <xsl:value-of select="$varPolicyType"/>
        </xsl:element>
      </xsl:element>
    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="policy_Info_map" select="map:merge(for $elem in $policy_Info/policy return map{$elem/name : $elem})"/>

  <!-- delete unnessary classifier reference -->
  <xsl:template match="/cfg-ns:config/bbf-qos-pol:policies/bbf-qos-pol:policy/bbf-qos-pol:classifiers">
    <xsl:variable name="policyName">
      <xsl:value-of  select="parent::bbf-qos-pol:policy/bbf-qos-pol:name"/>
    </xsl:variable>
    <xsl:variable name="policyType">
      <xsl:value-of  select="$policy_Info_map($policyName)/policyType"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$policyType=$POLICY_TYPE_COLOR or $policyType=$POLICY_TYPE_PBIT_POLICING_TC
                     or $policyType=$POLICY_TYPE_ACTION or $policyType=$POLICY_TYPE_CCL_OBSOLETE">
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:apply-templates/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="/cfg-ns:config/bbf-qos-pol:qos-policy-profiles/bbf-qos-pol:policy-profile/bbf-qos-pol:policy-list">
    <xsl:variable name="policyName">
      <xsl:value-of  select="current()/bbf-qos-pol:name"/>
    </xsl:variable>
    <xsl:variable name="policyType">
      <xsl:value-of  select="$policy_Info_map($policyName)/policyType"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$policyType=$POLICY_TYPE_COLOR or $policyType=$POLICY_TYPE_PBIT_POLICING_TC
                     or $policyType=$POLICY_TYPE_ACTION or $policyType=$POLICY_TYPE_CCL_OBSOLETE">
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:apply-templates/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- delete unsupported yang elements -->
  <xsl:template match="/cfg-ns:config/bbf-qos-cls:classifiers/bbf-qos-cls:classifier-entry/bbf-qos-cls:match-criteria">
    <xsl:variable name="hasFlowColor" select="boolean(current()/bbf-qos-plc:flow-color)"/>
    <xsl:variable name="hasUnmetered" select="boolean(current()/nokia-qos-filt:unmetered)"/>
    <xsl:variable name="childCount" select="count(*)"/>

    <xsl:choose>
      <xsl:when test="($hasFlowColor and $childCount = 1)
                    or($hasUnmetered and $childCount = 1)
                    or($hasFlowColor and $hasUnmetered and $childCount = 2)">
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:apply-templates select="node()[not(self::bbf-qos-plc:flow-color) and not(self::nokia-qos-filt:unmetered)]"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="/cfg-ns:config/bbf-qos-cls:classifiers/bbf-qos-cls:classifier-entry/bbf-qos-enhfilt:source-mac-address">
  </xsl:template>
  <xsl:template match="/cfg-ns:config/bbf-qos-cls:classifiers/bbf-qos-cls:classifier-entry/bbf-qos-enhfilt:destination-mac-address">
  </xsl:template>
  <xsl:template match="/cfg-ns:config/bbf-qos-cls:classifiers/bbf-qos-cls:classifier-entry/bbf-qos-enhfilt:ethernet-frame-type">
  </xsl:template>
  <xsl:template match="/cfg-ns:config/bbf-qos-cls:classifiers/bbf-qos-cls:classifier-entry/bbf-qos-enhfilt:ipv4">
  </xsl:template>
  <xsl:template match="/cfg-ns:config/bbf-qos-cls:classifiers/bbf-qos-cls:classifier-entry/bbf-qos-enhfilt:ipv6">
  </xsl:template>
  <xsl:template match="/cfg-ns:config/bbf-qos-cls:classifiers/bbf-qos-cls:classifier-entry/bbf-qos-enhfilt:transport">
  </xsl:template>
  <xsl:template match="/cfg-ns:config/bbf-qos-cls:classifiers/bbf-qos-cls:classifier-entry/bbf-qos-enhfilt:flow-color">
  </xsl:template>
  <xsl:template match="/cfg-ns:config/bbf-qos-cls:classifiers/bbf-qos-cls:classifier-entry/bbf-qos-cls:classifier-action-entry-cfg">
    <xsl:variable name="hasActionTypeSpec"   select="boolean(current()/bbf-qos-cls:action-type[text()='bbf-qos-plc:flow-color' or text()='nokia-qos-cls-ext:policing-traffic-class'])"/>
    <xsl:variable name="hasFlowColor" select="boolean(current()/bbf-qos-plc:flow-color)"/>
    <xsl:variable name="hasPolicingTrafficClass" select="boolean(current()/nokia-qos-cls-ext:policing-traffic-class)"/>
    <xsl:choose>
      <xsl:when test="$hasFlowColor or $hasPolicingTrafficClass or $hasActionTypeSpec">
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:apply-templates/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="/cfg-ns:config/bbf-qos-filt:filters/bbf-qos-enhfilt:enhanced-filter/bbf-qos-enhfilt:filter/bbf-qos-enhfilt:flow-color">
  </xsl:template>
  
  <!-- sorting elements -->
  <xsl:template match="/cfg-ns:config/bbf-qos-cls:classifiers/bbf-qos-cls:classifier-entry">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="*[not(self::bbf-qos-cls:classifier-action-entry-cfg)]"/>

      <xsl:apply-templates select="bbf-qos-cls:classifier-action-entry-cfg">
        <xsl:sort select="if (count(bbf-qos-cls:pbit-marking-cfg) &gt; 0) then 1 
                          else if (count(bbf-qos-plc:policing) &gt; 0) then 2 
                          else 3" 
                  order="ascending"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <!-- get policy type -->
  <xsl:template name="getPolicyType">
    <xsl:param name="classifierType"/>

    <xsl:choose>
      <!-- type rate-limit -->
      <xsl:when test="$classifierType=$CLS_TYPE_MATCHALL_TO_RATE_LIMIT">
        <xsl:value-of select="$POLICY_TYPE_RATE_LIMIT"/>
      </xsl:when>
      <!-- type count -->
      <xsl:when test="$classifierType=$CLS_TYPE_ACTION_COUNT">
        <xsl:value-of select="$POLICY_TYPE_COUNT"/>
      </xsl:when>
      <!-- type scheduler -->
      <xsl:when test="$classifierType=$CLS_TYPE_ACTION_WITH_SCHEDULING_TC">
        <xsl:value-of select="$POLICY_TYPE_SCHEDULE"/>
      </xsl:when>
      <!-- type action-->
      <xsl:when test="$classifierType=$CLS_TYPE_EN_FILTER_WITH_FLOW_COLOR or $classifierType=$CLS_TYPE_FILTER_WITH_FLOW_COLOR">
        <xsl:value-of select="$POLICY_TYPE_ACTION"/>
      </xsl:when>
      <!-- type queue color -->
      <xsl:when test="$classifierType=$CLS_TYPE_ACTION_BAC_COLOR">
        <xsl:value-of select="$POLICY_TYPE_QUEUE_COLOR"/>
      </xsl:when>
      <!-- type port-policer-->
      <xsl:when test="$classifierType=$CLS_TYPE_UNMETERED_TO_POLICING or $classifierType=$CLS_TYPE_METERED_FLOW_TO_POLICING
                      or $classifierType=$CLS_TYPE_MATCHALL_TO_POLICING or $classifierType=$CLS_TYPE_ANYFRAME_CLS_TO_POLICING">
        <xsl:value-of select="$POLICY_TYPE_PORT_POLICER"/>
      </xsl:when>
      <!-- type CCL -->
      <xsl:when test="$classifierType=$CLS_TYPE_EN_FILTER_WITHOUT_FLOW_COLOR">
        <xsl:value-of select="$POLICY_TYPE_CCL"/>
      </xsl:when>
      <!-- type CCL obsolete-->
      <xsl:when test="$classifierType=$CLS_TYPE_ACTION_WITH_POLICING or $classifierType=$CLS_TYPE_ACTION_WITH_PASS
                      or $classifierType=$CLS_TYPE_ACTION_WITH_DISCARD or $classifierType=$CLS_TYPE_ACTION_WITH_PBITMARKING_AND_FLOWCOLOR
                      or $classifierType=$CLS_TYPE_EN_CLS_WITH_MAC_OR_IP_OR_PORT
                      or $classifierType=$CLS_TYPE_FILTER_WITH_PROTOCAL_NOT_IGMP
                      or $classifierType=$CLS_TYPE_DEI_MARKING_OR_IN_DEI_TO_PBIT_MARKING
                      or $classifierType=$CLS_TYPE_FILTER_MORE_THAN_TWO_TYPE_OF_ANYFRAME_DSCP_IGMP_PBIT
                      or $classifierType=$CLS_TYPE_INVALID_TWO_TAGS
                      or $classifierType=$CLS_TYPE_INVALID_ACTION">
        <xsl:value-of select="$POLICY_TYPE_CCL_OBSOLETE"/>
      </xsl:when>
      <!-- type pbit to policing tc -->
      <xsl:when test="$classifierType=$CLS_TYPE_PBIT_TO_POLICING_TC">
        <xsl:value-of select="$POLICY_TYPE_PBIT_POLICING_TC"/>
      </xsl:when>
      <!-- type color -->
      <xsl:when test="$classifierType=$CLS_TYPE_ACTION_FLOW_COLOR">
        <xsl:value-of select="$POLICY_TYPE_COLOR"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$POLICY_TYPE_MARKER"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- get classifier type -->
  <xsl:template name="getClassifierType">
    <xsl:param name="classifierNode"/>
    <xsl:variable name="node" select="$classifierNode"/>

    <xsl:variable name="referencedEnhancdFilterName">
      <xsl:value-of  select="$node/bbf-qos-enhfilt:enhanced-filter-name"/>
    </xsl:variable>

    <!-- CLS_TYPE_EN_FILTER_WITH_FOLOW_COLOR -->
    <xsl:variable name="IS_EN_FILTER_WITH_FLOW_COLOR">
      <xsl:if test="string-length(normalize-space($referencedEnhancdFilterName))>0">
        <xsl:value-of  select="/cfg-ns:config/bbf-qos-filt:filters/bbf-qos-enhfilt:enhanced-filter[$referencedEnhancdFilterName=bbf-qos-enhfilt:name]/bbf-qos-enhfilt:filter/bbf-qos-enhfilt:flow-color"/>
      </xsl:if>
    </xsl:variable>

    <!-- CLS_TYPE_FILTER_WITH_FLOW_COLOR CLS_TYPE_EN_FILTER_WITHOUT_FLOW_COLOR-->
    <xsl:variable name="IS_INLINE_WITH_FLOW_COLOR">
      <xsl:value-of  select="$node/bbf-qos-cls:match-criteria/bbf-qos-plc:flow-color"/>
    </xsl:variable>
    <xsl:variable name="IS_EN_CLASSIFIER_WITH_FLOW_COLOR">
      <xsl:value-of  select="$node/bbf-qos-enhfilt:flow-color"/>
    </xsl:variable>
    <xsl:variable name="IS_EN_INLINE_AND_WITHOUT_FLOW_COLOR"
                select="not(/cfg-ns:config/bbf-qos-filt:filters/bbf-qos-enhfilt:enhanced-filter[$referencedEnhancdFilterName=bbf-qos-enhfilt:name]/bbf-qos-enhfilt:filter/bbf-qos-enhfilt:flow-color)"/>

    <!-- get classifier action type -->
    <xsl:variable name="classifierAction">
      <xsl:value-of  select="$node/bbf-qos-cls:classifier-action-entry-cfg/bbf-qos-cls:action-type"/>
    </xsl:variable>

    <!-- CLS_TYPE_ACTION_WITH_PBITMARKING_AND_FLOWCOLOR -->
    <xsl:variable name="classifierActionPbitMarking">
      <xsl:value-of  select="$node/bbf-qos-cls:classifier-action-entry-cfg/bbf-qos-cls:action-type[text()=$A_PBIT_MARKING or text()=$A_PBIT_MARKING_WITH_NS]"/>
    </xsl:variable>
    <xsl:variable name="classifierActionFlowColor">
      <xsl:value-of  select="$node/bbf-qos-cls:classifier-action-entry-cfg/bbf-qos-cls:action-type[text()=$A_FLOW_COLOR or text()=$A_FLOW_COLOR_WITH_NS]"/>
    </xsl:variable>

    <!-- CLS_TYPE_ANYFRAME_CLS_TO_POLICING -->
    <xsl:variable name="IS_ANY_FRAME" select="exists($node/bbf-qos-enhfilt:any-frame)"/>

    <!-- CLS_TYPE_MATCHALL_TO_POLICING -->
    <xsl:variable name="HAS_ELEMENT_EXCEPT_MATCH_ALL" select="
      $node/bbf-qos-cls:match-criteria/*[not(self::bbf-qos-cls:match-all) 
                                      and not(self::bbf-qos-cls:dscp-range) 
                                      and not(self::bbf-qos-cls:any-protocol)]"/>
    <xsl:variable name="HAS_MATCH_ALL" select="
      exists($node/bbf-qos-cls:match-criteria/(bbf-qos-cls:match-all | bbf-qos-cls:dscp-range | bbf-qos-cls:any-protocol))"/>
    <xsl:variable name="IS_INLINE" select="
      exists($node/bbf-qos-cls:match-criteria/*)"/>

    <!-- CLS_TYPE_METERED_FLOW_TO_POLICING -->
    <xsl:variable name="IS_EN_CLASSIFIER_METERED_FLOW">
      <xsl:value-of  select="$node/nokia-qos-filt:metered-flow"/>
    </xsl:variable>

    <!-- CLS_TYPE_UNMETERED_TO_POLICING -->
    <xsl:variable name="IS_INLINE_UNMETERED" select="exists($node/bbf-qos-cls:match-criteria/nokia-qos-filt:unmetered)"/>

    <!-- CLS_TYPE_EN_FILTER_WITHOUT_FLOW_COLOR -->
    <xsl:variable name="IS_EN_FILTER_BY_REFERENCE">
      <xsl:value-of  select="/cfg-ns:config/bbf-qos-filt:filters/bbf-qos-enhfilt:enhanced-filter[$referencedEnhancdFilterName=bbf-qos-enhfilt:name]/bbf-qos-enhfilt:filter/bbf-qos-enhfilt:enhanced-filter-name"/>
    </xsl:variable>

    <!-- CLS_TYPE_EN_CLS_WITH_MAC_OR_IP_OR_PORT -->
    <xsl:variable name="IS_EN_CLASSIFIER_SRC_MAC_ADDRESS">
      <xsl:value-of  select="$node/bbf-qos-enhfilt:source-mac-address"/>
    </xsl:variable>
    <xsl:variable name="IS_EN_CLASSIFIER_DEST_MAC_ADDRESS">
      <xsl:value-of  select="$node/bbf-qos-enhfilt:destination-mac-address"/>
    </xsl:variable>
    <xsl:variable name="IS_EN_CLASSIFIER_IPV4">
      <xsl:value-of  select="$node/bbf-qos-enhfilt:ipv4"/>
    </xsl:variable>
    <xsl:variable name="IS_EN_CLASSIFIER_IPV6">
      <xsl:value-of  select="$node/bbf-qos-enhfilt:ipv6"/>
    </xsl:variable>
    <xsl:variable name="IS_EN_CLASSIFIER_IP_COMMON_NOT_DSCP_DSCPRANGE_IGMP">
      <xsl:value-of  select="$node/bbf-qos-enhfilt:ip-common/bbf-qos-enhfilt:protocol[text()!='2']"/>
    </xsl:variable>
    <xsl:variable name="IS_EN_CLASSIFIER_TRANSPORT">
      <xsl:value-of  select="$node/bbf-qos-enhfilt:transport"/>
    </xsl:variable>
    <xsl:variable name="IS_EN_CLASSIFIER_ETHERNET_FRAME_TYPE">
      <xsl:value-of  select="$node/bbf-qos-enhfilt:ethernet-frame-type"/>
    </xsl:variable>
    <xsl:variable name="IS_EN_CLASSIFIER_ETHERNET_FRAME_TYPE_IPV4">
      <xsl:value-of  select="$node/bbf-qos-enhfilt:ethernet-frame-type"/>
    </xsl:variable>
    <xsl:variable name="IS_EN_CLASSIFIER_ETHERNET_FRAME_TYPE_IPV6">
      <xsl:value-of  select="$node/bbf-qos-enhfilt:ethernet-frame-type"/>
    </xsl:variable>
    <xsl:variable name="IS_EN_CLASSIFIER_ETHERNET_FRAME_TYPE_PPPOE">
      <xsl:value-of  select="$node/bbf-qos-enhfilt:ethernet-frame-type"/>
    </xsl:variable>

    <!-- CLS_TYPE_FILTER_WITH_PROTOCAL_NOT_IGMP -->
    <xsl:variable name="IS_INLINE_PROTOCOL_NOT_IGMP">
      <xsl:value-of  select="$node/bbf-qos-cls:match-criteria/bbf-qos-cls:protocol[text()!='igmp']"/>
    </xsl:variable>
    <xsl:variable name="IS_EN_CLASSIFIER_PROTOCOL_NOT_IGMP">
      <xsl:value-of  select="$node/bbf-qos-enhfilt:protocol[text()!='igmp']"/>
    </xsl:variable>

    <!-- CLS_TYPE_DEI_MARKING_OR_IN_DEI_TO_PBIT_MARKING -->
    <xsl:variable name="IS_INLINE_IN_DEI">
      <xsl:value-of  select="$node/bbf-qos-cls:match-criteria/bbf-qos-cls:tag/bbf-qos-cls:in-dei"/>
    </xsl:variable>
    <xsl:variable name="IS_EN_CLASSIFIER_IN_DEI">
      <xsl:value-of  select="$node/bbf-qos-enhfilt:vlans/bbf-qos-enhfilt:tag/bbf-qos-enhfilt:in-dei"/>
    </xsl:variable>
    <xsl:variable name="IS_INLINE_DEI_MARKING_LIST">
      <xsl:value-of  select="$node/bbf-qos-cls:match-criteria/bbf-qos-plc:dei-marking-list"/>
    </xsl:variable>
    <xsl:variable name="IS_EN_CLASSIFIER_DEI_MARKING_LIST">
      <xsl:value-of  select="$node/bbf-qos-enhfilt:dei-marking-list"/>
    </xsl:variable>

    <!-- CLS_TYPE_PBIT_TO_POLICING_TC -->
    <xsl:variable name="IS_INLINE_IN_PBIT_LIST">
      <xsl:value-of  select="$node/bbf-qos-cls:match-criteria/bbf-qos-cls:tag/bbf-qos-cls:in-pbit-list"/>
    </xsl:variable>
    <xsl:variable name="IS_EN_CLASSIFIER_IN_PBIT_LIST">
      <xsl:value-of  select="$node/bbf-qos-enhfilt:vlans/bbf-qos-enhfilt:tag/bbf-qos-enhfilt:in-pbit-list"/>
    </xsl:variable>

    <!-- CLS_TYPE_PBIT_TO_PBITMARKING -->
    <xsl:variable name="IS_INLINE_PBIT_MARKING_LIST">
      <xsl:value-of  select="$node/bbf-qos-cls:match-criteria/bbf-qos-plc:pbit-marking-list"/>
    </xsl:variable>
    <xsl:variable name="IS_EN_CLASSIFIER_PBIT_MARKING_LIST">
      <xsl:value-of  select="$node/bbf-qos-enhfilt:pbit-marking-list"/>
    </xsl:variable>

    <!-- CLS_TYPE_IGMP_TO_PBITMARKING -->
    <xsl:variable name="IS_INLINE_PROTOCOL_IGMP">
      <xsl:value-of  select="$node/bbf-qos-cls:match-criteria/bbf-qos-cls:protocol[text()='igmp']"/>
    </xsl:variable>
    <xsl:variable name="IS_EN_CLASSIFIER_PROTOCOL_IGMP">
      <xsl:value-of  select="$node/bbf-qos-enhfilt:protocol[text()='igmp']"/>
    </xsl:variable>

    <!-- CLS_TYPE_UNTAGGED_TO_PBITMARKING -->
    <xsl:variable name="IS_INLINE_UNTAGGED" select="exists($node/bbf-qos-cls:match-criteria/bbf-qos-cls:untagged)"/>
    <xsl:variable name="IS_EN_CLASSIFIER_UNTAGGED" select="exists($node/bbf-qos-enhfilt:vlans/bbf-qos-enhfilt:untagged)"/>

    <!-- CLS_TYPE_DSCP_TO_PBITMARKING -->
    <xsl:variable name="IS_INLINE_DSCP_RANGE">
      <xsl:value-of  select="$node/bbf-qos-cls:match-criteria/bbf-qos-cls:dscp-range"/>
    </xsl:variable>
    <xsl:variable name="IS_EN_CLASSIFIER_DSCP_RANGE">
      <xsl:value-of  select="$node/bbf-qos-enhfilt:ip-common/bbf-qos-enhfilt:dscp-range"/>
    </xsl:variable>

    <!-- CLS_TYPE_FILTER_MORE_THAN_TWO_TYPE_OF_ANYFRAME_DSCP_IGMP_PBIT -->
    <xsl:variable name="IS_EN_IP_COMMON_DSCP">
      <xsl:value-of  select="$node/bbf-qos-enhfilt:ip-common/bbf-qos-enhfilt:dscp"/>
    </xsl:variable>
    <xsl:variable name="IS_EN_IP_COMMON_IGMP">
      <xsl:value-of  select="$node/bbf-qos-enhfilt:ip-common/bbf-qos-enhfilt:protocol[text()='2']"/>
    </xsl:variable>

    <xsl:variable name="IS_CLS_FILTER_MORE_THAN_TWO_OF_ANY_FRAME_DSCP_IGMP_PBIT"
      select="
        (if ($IS_ANY_FRAME) then 1 else 0) +
        (if ((string-length(normalize-space($IS_EN_IP_COMMON_DSCP)) > 0) or 
             (string-length(normalize-space($IS_INLINE_DSCP_RANGE)) > 0) or 
             (string-length(normalize-space($IS_EN_CLASSIFIER_DSCP_RANGE)) > 0)) then 1 else 0) +
        (if ((string-length(normalize-space($IS_INLINE_PROTOCOL_IGMP)) > 0) or 
             (string-length(normalize-space($IS_EN_CLASSIFIER_PROTOCOL_IGMP)) > 0) or 
             (string-length(normalize-space($IS_EN_IP_COMMON_IGMP)) > 0)) then 1 else 0) +
        (if ((string-length(normalize-space($IS_INLINE_IN_PBIT_LIST)) > 0) or 
             (string-length(normalize-space($IS_EN_CLASSIFIER_IN_PBIT_LIST)) > 0) or 
             (string-length(normalize-space($IS_INLINE_PBIT_MARKING_LIST)) > 0) or 
             (string-length(normalize-space($IS_EN_CLASSIFIER_PBIT_MARKING_LIST)) > 0)) then 1 else 0)
        >= 2"/>

    <xsl:variable name="IS_INLINE_TWO_TAGS" 
      select="count($node/bbf-qos-cls:match-criteria/bbf-qos-cls:tag/bbf-qos-cls:in-dei)"/>

    <xsl:variable name="ACTION_NUMBER" 
      select="count($node/bbf-qos-cls:classifier-action-entry-cfg/bbf-qos-cls:action-type)"/>

    <xsl:choose>
      <!-- type rate-limit -->
      <xsl:when test="$classifierAction=$A_RATE_LIMIT or $classifierAction=$A_RATE_LIMIT_WITH_NS">
        <xsl:value-of select="$CLS_TYPE_MATCHALL_TO_RATE_LIMIT"/>
      </xsl:when>
      <!-- type count -->
      <xsl:when test="$classifierAction=$A_COUNT or $classifierAction=$A_COUNT_WITH_NS">
        <xsl:value-of select="$CLS_TYPE_ACTION_COUNT"/>
      </xsl:when>
      <!-- type scheduler -->
      <xsl:when test="$classifierAction=$A_SCHEDULING_TRAFFIC or $classifierAction=$A_SCHEDULING_TRAFFIC_WITH_NS">
        <xsl:value-of select="$CLS_TYPE_ACTION_WITH_SCHEDULING_TC"/>
      </xsl:when>
      <!-- type action (identify classifier type of action-policy before queue-color policy for migration)-->
      <xsl:when test="string-length(normalize-space($IS_EN_FILTER_WITH_FLOW_COLOR))>0">
        <xsl:value-of select="$CLS_TYPE_EN_FILTER_WITH_FLOW_COLOR"/>
      </xsl:when>
      <xsl:when test="(string-length(normalize-space($IS_INLINE_WITH_FLOW_COLOR))>0)
                      or (string-length(normalize-space($IS_EN_CLASSIFIER_WITH_FLOW_COLOR))>0)">
        <xsl:value-of select="$CLS_TYPE_FILTER_WITH_FLOW_COLOR"/>
      </xsl:when>
      <!-- type queue_color -->
      <xsl:when test="$classifierAction=$A_BAC_COLOR or $classifierAction=$A_BAC_COLOR_WITH_NS">
        <xsl:value-of select="$CLS_TYPE_ACTION_BAC_COLOR"/>
      </xsl:when>
      <!-- type policer -->
      <xsl:when test="$IS_ANY_FRAME
                      and ($classifierAction=$A_POLICING or $classifierAction=$A_POLICING_WITH_NS)">
        <xsl:value-of select="$CLS_TYPE_ANYFRAME_CLS_TO_POLICING"/>
      </xsl:when>
      <xsl:when test="count($HAS_ELEMENT_EXCEPT_MATCH_ALL)=0
                      and $HAS_MATCH_ALL	  
                      and $IS_INLINE
                      and ($classifierAction=$A_POLICING or $classifierAction=$A_POLICING_WITH_NS)">
        <xsl:value-of select="$CLS_TYPE_MATCHALL_TO_POLICING"/>
      </xsl:when>
      <xsl:when test="(string-length(normalize-space($IS_EN_CLASSIFIER_METERED_FLOW))>0) 
                      and ($classifierAction=$A_POLICING or $classifierAction=$A_POLICING_WITH_NS)">
        <xsl:value-of select="$CLS_TYPE_METERED_FLOW_TO_POLICING"/>
      </xsl:when>
      <xsl:when test="$IS_INLINE_UNMETERED
                      and ($classifierAction=$A_POLICING or $classifierAction=$A_POLICING_WITH_NS)">
        <xsl:value-of select="$CLS_TYPE_UNMETERED_TO_POLICING"/>
      </xsl:when>
      <!-- type CCL-->
      <xsl:when test="string-length(normalize-space($IS_EN_FILTER_BY_REFERENCE))>0
                      or (string-length(normalize-space($referencedEnhancdFilterName))>0 and $IS_EN_INLINE_AND_WITHOUT_FLOW_COLOR)">
        <xsl:value-of select="$CLS_TYPE_EN_FILTER_WITHOUT_FLOW_COLOR"/>
      </xsl:when>
      <xsl:when test="$classifierAction=$A_POLICING or $classifierAction=$A_POLICING_WITH_NS">
        <xsl:value-of select="$CLS_TYPE_ACTION_WITH_POLICING"/>
      </xsl:when>
      <xsl:when test="$classifierAction=$A_PASS or $classifierAction=$A_PASS_WITH_NS">
        <xsl:value-of select="$CLS_TYPE_ACTION_WITH_PASS"/>
      </xsl:when>
      <xsl:when test="$classifierAction=$A_DISCARD or $classifierAction=$A_DISCARD_WITH_NS">
        <xsl:value-of select="$CLS_TYPE_ACTION_WITH_DISCARD"/>
      </xsl:when>
      <xsl:when test="string-length(normalize-space($classifierActionPbitMarking))>0
                     and string-length(normalize-space($classifierActionFlowColor))>0">
        <xsl:value-of select="$CLS_TYPE_ACTION_WITH_PBITMARKING_AND_FLOWCOLOR"/>
      </xsl:when>
      <xsl:when test="string-length(normalize-space($IS_EN_CLASSIFIER_SRC_MAC_ADDRESS))>0
                     or string-length(normalize-space($IS_EN_CLASSIFIER_DEST_MAC_ADDRESS))>0
                     or string-length(normalize-space($IS_EN_CLASSIFIER_IPV4))>0
                     or string-length(normalize-space($IS_EN_CLASSIFIER_IPV6))>0
                     or string-length(normalize-space($IS_EN_CLASSIFIER_IP_COMMON_NOT_DSCP_DSCPRANGE_IGMP))>0
                     or string-length(normalize-space($IS_EN_CLASSIFIER_TRANSPORT))>0
                     or string-length(normalize-space($IS_EN_CLASSIFIER_ETHERNET_FRAME_TYPE))>0
                     or string-length(normalize-space($IS_EN_CLASSIFIER_ETHERNET_FRAME_TYPE_IPV4))>0
                     or string-length(normalize-space($IS_EN_CLASSIFIER_ETHERNET_FRAME_TYPE_IPV6))>0
                     or string-length(normalize-space($IS_EN_CLASSIFIER_ETHERNET_FRAME_TYPE_PPPOE))>0">
        <xsl:value-of select="$CLS_TYPE_EN_CLS_WITH_MAC_OR_IP_OR_PORT"/>
      </xsl:when>
      <xsl:when test="string-length(normalize-space($IS_INLINE_PROTOCOL_NOT_IGMP))>0
                      or string-length(normalize-space($IS_EN_CLASSIFIER_PROTOCOL_NOT_IGMP))>0">
        <xsl:value-of select="$CLS_TYPE_FILTER_WITH_PROTOCAL_NOT_IGMP"/>
      </xsl:when>
      <xsl:when test="(string-length(normalize-space($IS_INLINE_IN_DEI))>0 
                      or string-length(normalize-space($IS_EN_CLASSIFIER_IN_DEI))>0 
                      or string-length(normalize-space($IS_INLINE_DEI_MARKING_LIST))>0 
                      or string-length(normalize-space($IS_EN_CLASSIFIER_DEI_MARKING_LIST))>0) 
                      and ($classifierAction=$A_PBIT_MARKING or $classifierAction=$A_PBIT_MARKING_WITH_NS) 
                      and ($classifierAction!=$A_DEI_MARKING and $classifierAction!=$A_DEI_MARKING_WITH_NS)">
        <xsl:value-of select="$CLS_TYPE_DEI_MARKING_OR_IN_DEI_TO_PBIT_MARKING"/>
      </xsl:when>
      <xsl:when test="$IS_CLS_FILTER_MORE_THAN_TWO_OF_ANY_FRAME_DSCP_IGMP_PBIT">
        <xsl:value-of select="$CLS_TYPE_FILTER_MORE_THAN_TWO_TYPE_OF_ANYFRAME_DSCP_IGMP_PBIT"/>
      </xsl:when>
      <xsl:when test="(string-length(normalize-space($IS_INLINE_IN_PBIT_LIST))>0
                      or string-length(normalize-space($IS_EN_CLASSIFIER_IN_PBIT_LIST))>0
                      or string-length(normalize-space($IS_INLINE_PBIT_MARKING_LIST))>0
                      or string-length(normalize-space($IS_EN_CLASSIFIER_PBIT_MARKING_LIST))>0)
                      and ($classifierAction=$A_PBIT_POLICING_TC or $classifierAction=$A_PBIT_POLICING_TC_WITH_NS)">
        <xsl:value-of select="$CLS_TYPE_PBIT_TO_POLICING_TC"/>
      </xsl:when>

      <!-- type pre-color -->
      <xsl:when test="$classifierAction=$A_FLOW_COLOR or $classifierAction=$A_FLOW_COLOR_WITH_NS">
        <xsl:value-of select="$CLS_TYPE_ACTION_FLOW_COLOR"/>
      </xsl:when>
      <!-- type marker -->
      <xsl:when test="(string-length(normalize-space($IS_INLINE_IN_PBIT_LIST))>0
                      or string-length(normalize-space($IS_EN_CLASSIFIER_IN_PBIT_LIST))>0
                      or string-length(normalize-space($IS_INLINE_PBIT_MARKING_LIST))>0
                      or string-length(normalize-space($IS_EN_CLASSIFIER_PBIT_MARKING_LIST))>0)
                      and ($classifierAction=$A_PBIT_MARKING or $classifierAction=$A_PBIT_MARKING_WITH_NS)">
        <xsl:value-of select="$CLS_TYPE_PBIT_TO_PBITMARKING"/>
      </xsl:when>
      <xsl:when test="(string-length(normalize-space($IS_INLINE_PROTOCOL_IGMP))>0 
                      or string-length(normalize-space($IS_EN_CLASSIFIER_PROTOCOL_IGMP))>0)
                      and ($classifierAction=$A_PBIT_MARKING or $classifierAction=$A_PBIT_MARKING_WITH_NS)">
        <xsl:value-of select="$CLS_TYPE_IGMP_TO_PBITMARKING"/>
      </xsl:when>
      <xsl:when test="($IS_INLINE_UNTAGGED
                      or $IS_EN_CLASSIFIER_UNTAGGED)
                      and ($classifierAction=$A_PBIT_MARKING or $classifierAction=$A_PBIT_MARKING_WITH_NS)">
        <xsl:value-of select="$CLS_TYPE_UNTAGGED_TO_PBITMARKING"/>
      </xsl:when>
      <xsl:when test="(string-length(normalize-space($IS_EN_IP_COMMON_DSCP)) > 0
                      or string-length(normalize-space($IS_INLINE_DSCP_RANGE))>0
                      or string-length(normalize-space($IS_EN_CLASSIFIER_DSCP_RANGE))>0)
                      and ($classifierAction=$A_PBIT_MARKING or $classifierAction=$A_PBIT_MARKING_WITH_NS)">
        <xsl:value-of select="$CLS_TYPE_DSCP_TO_PBITMARKING"/>
      </xsl:when>
      <xsl:when test="$IS_INLINE_TWO_TAGS >= 2">
        <xsl:value-of select="$CLS_TYPE_INVALID_TWO_TAGS"/>
      </xsl:when>
      <xsl:when test="($ACTION_NUMBER=1) and ($classifierAction=$A_DEI_MARKING or $classifierAction=$A_DEI_MARKING_WITH_NS)">
        <xsl:value-of select="$CLS_TYPE_INVALID_ACTION"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$CLS_TYPE_INVALID"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
