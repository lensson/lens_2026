<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:bbf-qos-filt="urn:bbf:yang:bbf-qos-filters" xmlns:bbf-qos-enhfilt="urn:bbf:yang:bbf-qos-enhanced-filters" xmlns:bbf-qos-pol="urn:bbf:yang:bbf-qos-policies" xmlns:bbf-qos-cls="urn:bbf:yang:bbf-qos-classifiers" xmlns:bbf-qos-plc="urn:bbf:yang:bbf-qos-policing" xmlns:nokia-qos-filt="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-qos-filters-ext" xmlns:nokia-sdan-qos-policing-extension="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension" xmlns:nokia-qos-cls-ext="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-classifier-extension" xmlns="" version="1.0">

  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" indent="yes"/>


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
  <!-- New Definition -->
  <xsl:variable name="POLICY_TYPE_QUEUE_COLOR" select="'POLICY_TYPE_QUEUE_COLOR'"/>

  <!-- default rule -->
  <xsl:template match="*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!--update policy type-->
  <xsl:template match="*[     local-name() = 'policy'     and parent::*[local-name() = 'policies']     and ancestor::*[local-name() = 'current']     and ancestor::*[local-name() = 'migration-cache']     and ancestor::*[local-name() = 'policy-profile']     and ancestor::*[local-name() = 'qos-policy-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']   ]">

    <xsl:variable name="firstClassifierTypeVar">
      <xsl:call-template name="getFirstValidClassifierType">
        <xsl:with-param name="curPolicySec" select="current()"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="policyTypeVar">
      <xsl:call-template name="clsTypeToPolicyType">
        <xsl:with-param name="clsType" select="$firstClassifierTypeVar"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:copy>
      <xsl:copy-of select="@*"/>
<xsl:for-each select="current()/node()">
        <xsl:choose>
          <xsl:when test="local-name() = 'name'">
            <xsl:copy>
              <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            <xsl:element name="policy-type">
              <xsl:value-of select="$policyTypeVar"/>
            </xsl:element>
            <xsl:element name="first-classifier-type">
              <xsl:value-of select="$firstClassifierTypeVar"/>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy>
              <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>

  <!--update sequence-->
  <xsl:template match="*[     local-name() = 'policy-list'     and parent::*[local-name() = 'policy-profile']     and ancestor::*[local-name() = 'qos-policy-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']   ]">
    <xsl:variable name="curPolicyName" select="child::*[local-name() = 'name']"/>
    <xsl:variable name="curPolicyInCache" select="../migration-cache/current/policies/policy[name=$curPolicyName]"/>
    <xsl:variable name="firstClassifierTypeVar">
      <xsl:call-template name="getFirstValidClassifierType">
        <xsl:with-param name="curPolicySec" select="$curPolicyInCache"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="policyTypeVar">
      <xsl:call-template name="clsTypeToPolicyType">
        <xsl:with-param name="clsType" select="$firstClassifierTypeVar"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="policySequence">
      <xsl:call-template name="getPolicyTypeSequence">
        <xsl:with-param name="policyType" select="$policyTypeVar"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:copy>
      <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
<xsl:element name="sequence">
        <xsl:value-of select="$policySequence"/>
      </xsl:element>
    </xsl:copy>
  </xsl:template>

  <!-- =========================== policy cache start ========================== -->
  <xsl:template match="*[     local-name() = 'policy-migration-cache'     and parent::*[local-name() = 'policy']     and ancestor::*[local-name() = 'policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies']   ]">

    <xsl:variable name="firstClassifierTypeVar">
      <xsl:call-template name="getFirstValidClassifierType_policy">
        <xsl:with-param name="curPolicySec" select="current()"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="policyTypeVar">
      <xsl:call-template name="clsTypeToPolicyType">
        <xsl:with-param name="clsType" select="$firstClassifierTypeVar"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:copy>
      <xsl:copy-of select="@*"/>
<xsl:for-each select="current()/node()">
        <xsl:choose>
          <xsl:when test="local-name() = 'name'">
            <xsl:copy>
              <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            <xsl:element name="policy-type">
              <xsl:value-of select="$policyTypeVar"/>
            </xsl:element>
            <xsl:element name="first-classifier-type">
              <xsl:value-of select="$firstClassifierTypeVar"/>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy>
              <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>
  <!-- =========================== policy cache end ========================== -->

  <!-- ================================== Infra functions ================================== -->

  <xsl:template name="getFirstValidClassifierType">
    <xsl:param name="curPolicySec"/>
    <xsl:variable name="firstClsTypeVar">
      <xsl:value-of select="$curPolicySec/classifiers/classifier/classifier-type[position() = 1 and not(text() = $CLS_TYPE_INVALID)]"/>
    </xsl:variable>
    <xsl:value-of select="$firstClsTypeVar"/>
  </xsl:template>
 
   <xsl:template name="getFirstValidClassifierType_policy">
    <xsl:param name="curPolicySec"/>
    <xsl:variable name="firstClsTypeVar">
      <xsl:value-of select="$curPolicySec/classifiers/classifier-type[position() = 1 and not(text() = $CLS_TYPE_INVALID)]"/>
    </xsl:variable>
    <xsl:value-of select="$firstClsTypeVar"/>
  </xsl:template>

  <xsl:template name="clsTypeToPolicyType">
    <xsl:param name="clsType"/>
    <xsl:choose>
      <xsl:when test="$clsType = $CLS_TYPE_MATCHALL_TO_RATE_LIMIT">
        <xsl:value-of select="$POLICY_TYPE_RATE_LIMIT"/>
      </xsl:when>
      <xsl:when test="$clsType = $CLS_TYPE_ACTION_WITH_SCHEDULING_TC">
        <xsl:value-of select="$POLICY_TYPE_SCHEDULE"/>
      </xsl:when>
      <xsl:when test="$clsType = $CLS_TYPE_EN_FILTER_WITH_FOLOW_COLOR or $clsType = $CLS_TYPE_FILTER_WITH_FLOW_COLOR">
        <xsl:value-of select="$POLICY_TYPE_ACTION"/>
      </xsl:when>
      <xsl:when test="$clsType = $CLS_TYPE_UNMETERED_TO_POLICING       or $clsType = $CLS_TYPE_MATCHALL_TO_POLICING or $clsType = $CLS_TYPE_ANYFRAME_CLS_TO_POLICING">
        <xsl:value-of select="$POLICY_TYPE_PORT_POLICER"/>
      </xsl:when>
      <xsl:when test="$clsType = $CLS_TYPE_ACTION_WITH_POLICING       or $clsType = $CLS_TYPE_ACTION_WITH_PASS or $clsType = $CLS_TYPE_ACTION_WITH_DISCARD       or $clsType = $CLS_TYPE_ACTION_WITH_PBITMARKING_AND_FLOWCOLOR or $clsType = $CLS_TYPE_EN_FILTER_WITHOUT_FLOW_COLOR       or $clsType = $CLS_TYPE_EN_CLS_WITH_MAC_OR_IP_OR_PORT or $clsType = $CLS_TYPE_FILTER_WITH_PROTOCAL_NOT_IGMP       or $clsType = $CLS_TYPE_DEI_MARKING_OR_IN_DEI_TO_PBIT_MARKING or $clsType = $CLS_TYPE_FILTER_MORE_THAN_TWO_TYPE_OF_ANYFRAME_DSCP_IGMP_PBIT">
        <xsl:value-of select="$POLICY_TYPE_CCL"/>
      </xsl:when>
      <xsl:when test="$clsType = $CLS_TYPE_ACTION_FLOW_COLOR">
        <xsl:value-of select="$POLICY_TYPE_COLOR"/>
      </xsl:when>
      <xsl:when test="$clsType = $CLS_TYPE_PBIT_TO_POLICING_TC">
        <xsl:value-of select="$POLICY_TYPE_PBIT_POLICING_TC"/>
      </xsl:when>
      <xsl:when test="$clsType = $CLS_TYPE_ACTION_COUNT">
        <xsl:value-of select="$POLICY_TYPE_COUNT"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$POLICY_TYPE_MARKER"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="getPolicyTypeSequence">
    <xsl:param name="policyType"/>
    <xsl:choose>
      <xsl:when test="$policyType = $POLICY_TYPE_MARKER">
        <xsl:value-of select="2"/>
      </xsl:when>
      <xsl:when test="$policyType = $POLICY_TYPE_COLOR">
        <xsl:value-of select="3"/>
      </xsl:when>
      <xsl:when test="$policyType = $POLICY_TYPE_PBIT_POLICING_TC">
        <xsl:value-of select="4"/>
      </xsl:when>
      <xsl:when test="$policyType = $POLICY_TYPE_CCL">
        <xsl:value-of select="5"/>
      </xsl:when>
      <xsl:when test="$policyType = $POLICY_TYPE_PORT_POLICER">
        <xsl:value-of select="6"/>
      </xsl:when>
      <xsl:when test="$policyType = $POLICY_TYPE_ACTION">
        <xsl:value-of select="7"/>
      </xsl:when>
      <xsl:when test="$policyType = $POLICY_TYPE_SCHEDULE">
        <xsl:value-of select="8"/>
      </xsl:when>
      <xsl:when test="$policyType = $POLICY_TYPE_COUNT">
        <xsl:value-of select="9"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="10"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
