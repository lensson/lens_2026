<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:cfg-ns="urn:ietf:params:xml:ns:netconf:base:1.0"
                              xmlns:itf-ns="urn:ietf:params:xml:ns:yang:ietf-interfaces"
                              xmlns:map="http://www.w3.org/2005/xpath-functions/map"
                              xmlns:bbf-subif="urn:bbf:yang:bbf-sub-interfaces"
                              xmlns:bbf-subif-tag="urn:bbf:yang:bbf-sub-interface-tagging"
                              xmlns:bbf-if-usg="urn:bbf:yang:bbf-interface-usage"
                              xmlns:bbf-frameproc="urn:bbf:yang:bbf-frame-processing-profile"
                              xmlns:itf-type-ns="urn:bbf:yang:bbf-if-type"
                              xmlns:bbf-vsi-vctr="urn:bbf:yang:bbf-vlan-sub-interface-vector"
                              xmlns:bbf-vsi-vctr-fpp="urn:bbf:yang:bbf-vlan-sub-interface-vector-fpp"
                              xmlns:bbf-vsi-vctr-usg="urn:bbf:yang:bbf-vlan-sub-interface-vector-usage"
                              xmlns:bbf-l2-fwd="urn:bbf:yang:bbf-l2-forwarding"
                              xmlns:bbf-qos-cls="urn:bbf:yang:bbf-qos-classifiers"
                              xmlns:bbf-qos-pol="urn:bbf:yang:bbf-qos-policies"
                              xmlns:bbf-qos-plc="urn:bbf:yang:bbf-qos-policing"
                              xmlns:bbf-qos-enhfilt="urn:bbf:yang:bbf-qos-enhanced-filters"
                              xmlns:bbf-qos-filt="urn:bbf:yang:bbf-qos-filters"
                              xmlns:nokia-qos-plc-ext="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <!-- Classifier Action Type -->
  <xsl:variable name="A_SCHEDULING_TRAFFIC_CLASS" select="'scheduling-traffic-class'"/>
  <xsl:variable name="A_SCHEDULING_TRAFFIC_CLASS_WITH_NS" select="'bbf-qos-cls:scheduling-traffic-class'"/>
  <xsl:variable name="A_PBIT_MARKING" select="'pbit-marking'"/>
  <xsl:variable name="A_PBIT_MARKING_WITH_NS" select="'bbf-qos-cls:pbit-marking'"/>
  <xsl:variable name="A_DEI_MARKING" select="'dei-marking'"/>
  <xsl:variable name="A_DEI_MARKING_WITH_NS" select="'bbf-qos-cls:dei-marking'"/>
  <xsl:variable name="A_POLICING" select="'bbf-qos-plc:policing'"/>
  <xsl:variable name="A_BAC_COLOR" select="'bbf-qos-plc:bac-color'"/>
  <xsl:variable name="A_COUNT" select="'nokia-qos-cls-ext:count'"/>

  <!-- Policy Type -->
  <xsl:variable name="POLICY_TYPE_CCL" select="'POLICY_TYPE_CCL'"/>
  <xsl:variable name="POLICY_TYPE_SCHEDULE" select="'POLICY_TYPE_SCHEDULE'"/>
  <xsl:variable name="POLICY_TYPE_QUEUE_COLOR" select="'POLICY_TYPE_QUEUE_COLOR'"/>
  <xsl:variable name="POLICY_TYPE_PORT_POLICER" select="'POLICY_TYPE_PORT_POLICER'"/>
  <xsl:variable name="POLICY_TYPE_COUNT" select="'POLICY_TYPE_COUNT'"/>
  <xsl:variable name="POLICY_TYPE_MARKER" select="'POLICY_TYPE_MARKER'"/>
  <xsl:variable name="POLICY_TYPE_UNKNOWN" select="'POLICY_TYPE_UNKNOWN'"/>

  <xsl:variable name="PARAMETER_VLAN_ID" select="'parameter-vlan-id'"/>
  <xsl:variable name="C_FORWARDER" select="'C'"/>
  <xsl:variable name="SC_FORWARDER" select="'SC'"/>
  <xsl:variable name="BP_ETH" select="'BP_Eth'"/>

  <xsl:variable name="USAGE_USER" select="'user-port'"/>
  <xsl:variable name="USAGE_NETWORK" select="'network-port'"/>
  <xsl:variable name="USAGE_SUBTENDED_NODE" select="'subtended-node-port'"/>
  <xsl:variable name="USAGE_INHERIT" select="'inherit'"/>

  <xsl:variable name="FILTER_TYPE_PBIT_MARKING_LIST" select="'PBIT_MARKING_LIST'"/>
  <xsl:variable name="FILTER_TYPE_DEI_MARKING_LIST" select="'DEI_MARKING_LIST'"/>
  <xsl:variable name="FILTER_TYPE_IN_PBIT_LIST" select="'IN_PBIT_LIST'"/>
  <xsl:variable name="FILTER_TYPE_IN_DEI" select="'IN_DEI'"/>

  <xsl:variable name="FILTER_INDEX_0" select="'INDEX0'"/>
  <xsl:variable name="FILTER_INDEX_1" select="'INDEX1'"/>
  <xsl:variable name="FILTER_INDEX_01" select="'INDEX01'"/>
  <xsl:variable name="INDEX_OUT_OF_RANGE" select="'INDEX_OUT_OF_RANGE'"/>

  <xsl:variable name="ACTION_PBIT_DEI_MARKING_LIST" select="'ACTION_PBIT_DEI_MARKING_LIST'"/>
  <xsl:variable name="IN_PBIT_LIST_IN_DEI_CFG" select="'IN_PBIT_LIST_IN_DEI_CFG'"/>
  <xsl:variable name="POLICING_IN_PBIT_LIST_IN_DEI_CFG" select="'POLICING_IN_PBIT_LIST_IN_DEI_CFG'"/>

  <!-- collecting profile name -->
  <xsl:variable name="qosProfileNameInVsi">
    <xsl:copy-of select="distinct-values(/cfg-ns:config/itf-ns:interfaces/itf-ns:interface/bbf-qos-pol:ingress-qos-policy-profile)"/>
    <xsl:copy-of select="distinct-values(/cfg-ns:config/itf-ns:interfaces/itf-ns:interface/bbf-qos-pol:egress-qos-policy-profile)"/>
  </xsl:variable>

  <!-- collecting classifiers info -->
  <xsl:variable name="classifiers_Info">
    <xsl:for-each select ="/cfg-ns:config/bbf-qos-cls:classifiers/bbf-qos-cls:classifier-entry">
      <xsl:variable name="pbitMarkingList0">
        <xsl:variable name="inlinePbitMarkingList0">
          <xsl:value-of select="current()/bbf-qos-cls:match-criteria/bbf-qos-plc:pbit-marking-list/bbf-qos-plc:index[text()='0']"/>
        </xsl:variable>
        <xsl:variable name="enhanceClassifierPbitMarkingList0">
          <xsl:value-of select="current()/bbf-qos-enhfilt:pbit-marking-list/bbf-qos-enhfilt:index[text()='0']"/>
        </xsl:variable>
        <xsl:variable name="enhanceFilterRefName">
          <xsl:value-of select="current()/bbf-qos-enhfilt:enhanced-filter-name"/>
        </xsl:variable>

        <xsl:choose>
          <xsl:when test="string-length(normalize-space($inlinePbitMarkingList0))>0">
            <xsl:value-of select="$inlinePbitMarkingList0"/>
          </xsl:when>
          <xsl:when test="string-length(normalize-space($enhanceClassifierPbitMarkingList0))>0">
            <xsl:value-of select="$enhanceClassifierPbitMarkingList0"/>
          </xsl:when>
          <xsl:when test="string-length(normalize-space($enhanceFilterRefName))>0">
            <xsl:variable name="enhanceFilterPbitMarkingList0">
              <xsl:value-of select="/cfg-ns:config/bbf-qos-filt:filters/bbf-qos-enhfilt:enhanced-filter[bbf-qos-enhfilt:name=$enhanceFilterRefName]/bbf-qos-enhfilt:filter/bbf-qos-enhfilt:pbit-marking-list/bbf-qos-enhfilt:index[text()='0']"/>
            </xsl:variable>
            <xsl:choose>
              <xsl:when test="string-length(normalize-space($enhanceFilterPbitMarkingList0))>0">
                <xsl:value-of select="$enhanceFilterPbitMarkingList0"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="enhanceFilterRefNameInFilter">
                  <xsl:value-of select="/cfg-ns:config/bbf-qos-filt:filters/bbf-qos-enhfilt:enhanced-filter[bbf-qos-enhfilt:name=$enhanceFilterRefName]/bbf-qos-enhfilt:filter/bbf-qos-enhfilt:enhanced-filter-name"/>
                </xsl:variable>
                <xsl:if test="string-length(normalize-space($enhanceFilterRefNameInFilter))>0">
                  <xsl:variable name="enhanceFilterInRefPbitMarkingList0">
                    <xsl:value-of select="/cfg-ns:config/bbf-qos-filt:filters/bbf-qos-enhfilt:enhanced-filter[bbf-qos-enhfilt:name=$enhanceFilterRefNameInFilter]/bbf-qos-enhfilt:filter/bbf-qos-enhfilt:pbit-marking-list/bbf-qos-enhfilt:index[text()='0']"/>
                  </xsl:variable>
                  <xsl:if test="string-length(normalize-space($enhanceFilterInRefPbitMarkingList0))>0">
                    <xsl:value-of select="$enhanceFilterInRefPbitMarkingList0"/>
                  </xsl:if>
                </xsl:if>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="pbitMarkingList1">
        <xsl:variable name="inlinePbitMarkingList1">
          <xsl:value-of select="current()/bbf-qos-cls:match-criteria/bbf-qos-plc:pbit-marking-list/bbf-qos-plc:index[text()='1']"/>
        </xsl:variable>
        <xsl:variable name="enhanceClassifierPbitMarkingList1">
          <xsl:value-of select="current()/bbf-qos-enhfilt:pbit-marking-list/bbf-qos-enhfilt:index[text()='1']"/>
        </xsl:variable>
        <xsl:variable name="enhanceFilterRefName">
          <xsl:value-of select="current()/bbf-qos-enhfilt:enhanced-filter-name"/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="string-length(normalize-space($inlinePbitMarkingList1))>0">
            <xsl:value-of select="$inlinePbitMarkingList1"/>
          </xsl:when>
          <xsl:when test="string-length(normalize-space($enhanceClassifierPbitMarkingList1))>0">
            <xsl:value-of select="$enhanceClassifierPbitMarkingList1"/>
          </xsl:when>
          <xsl:when test="string-length(normalize-space($enhanceFilterRefName))>0">
            <xsl:variable name="enhanceFilterPbitMarkingList1">
              <xsl:value-of select="/cfg-ns:config/bbf-qos-filt:filters/bbf-qos-enhfilt:enhanced-filter[bbf-qos-enhfilt:name=$enhanceFilterRefName]/bbf-qos-enhfilt:filter/bbf-qos-enhfilt:pbit-marking-list/bbf-qos-enhfilt:index[text()='1']"/>
            </xsl:variable>
            <xsl:choose>
              <xsl:when test="string-length(normalize-space($enhanceFilterPbitMarkingList1))>0">
                <xsl:value-of select="$enhanceFilterPbitMarkingList1"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="enhanceFilterRefNameInFilter">
                  <xsl:value-of select="/cfg-ns:config/bbf-qos-filt:filters/bbf-qos-enhfilt:enhanced-filter[bbf-qos-enhfilt:name=$enhanceFilterRefName]/bbf-qos-enhfilt:filter/bbf-qos-enhfilt:enhanced-filter-name"/>
                </xsl:variable>
                <xsl:if test="string-length(normalize-space($enhanceFilterRefNameInFilter))>0">
                  <xsl:variable name="enhanceFilterInRefPbitMarkingList1">
                    <xsl:value-of select="/cfg-ns:config/bbf-qos-filt:filters/bbf-qos-enhfilt:enhanced-filter[bbf-qos-enhfilt:name=$enhanceFilterRefNameInFilter]/bbf-qos-enhfilt:filter/bbf-qos-enhfilt:pbit-marking-list/bbf-qos-enhfilt:index[text()='1']"/>
                  </xsl:variable>
                  <xsl:if test="string-length(normalize-space($enhanceFilterInRefPbitMarkingList1))>0">
                    <xsl:value-of select="$enhanceFilterInRefPbitMarkingList1"/>
                  </xsl:if>
                </xsl:if>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="deiMarkingList0">
        <xsl:variable name="inlineDeiMarkingList0">
          <xsl:value-of select="current()/bbf-qos-cls:match-criteria/bbf-qos-plc:dei-marking-list/bbf-qos-plc:index[text()='0']"/>
        </xsl:variable>
        <xsl:variable name="enhanceClassifierDeiMarkingList0">
          <xsl:value-of select="current()/bbf-qos-enhfilt:dei-marking-list/bbf-qos-enhfilt:index[text()='0']"/>
        </xsl:variable>
        <xsl:variable name="enhanceFilterRefName">
          <xsl:value-of select="current()/bbf-qos-enhfilt:enhanced-filter-name"/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="string-length(normalize-space($inlineDeiMarkingList0))>0">
            <xsl:value-of select="$inlineDeiMarkingList0"/>
          </xsl:when>
          <xsl:when test="string-length(normalize-space($enhanceClassifierDeiMarkingList0))>0">
            <xsl:value-of select="$enhanceClassifierDeiMarkingList0"/>
          </xsl:when>
          <xsl:when test="string-length(normalize-space($enhanceFilterRefName))>0">
            <xsl:variable name="enhanceFilterDeiMarkingList0">
              <xsl:value-of select="/cfg-ns:config/bbf-qos-filt:filters/bbf-qos-enhfilt:enhanced-filter[bbf-qos-enhfilt:name=$enhanceFilterRefName]/bbf-qos-enhfilt:filter/bbf-qos-enhfilt:dei-marking-list/bbf-qos-enhfilt:index[text()='0']"/>
            </xsl:variable>
            <xsl:choose>
              <xsl:when test="string-length(normalize-space($enhanceFilterDeiMarkingList0))>0">
                <xsl:value-of select="$enhanceFilterDeiMarkingList0"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="enhanceFilterRefNameInFilter">
                  <xsl:value-of select="/cfg-ns:config/bbf-qos-filt:filters/bbf-qos-enhfilt:enhanced-filter[bbf-qos-enhfilt:name=$enhanceFilterRefName]/bbf-qos-enhfilt:filter/bbf-qos-enhfilt:enhanced-filter-name"/>
                </xsl:variable>
                <xsl:if test="string-length(normalize-space($enhanceFilterRefNameInFilter))>0">
                  <xsl:variable name="enhanceFilterInRefDeiMarkingList0">
                    <xsl:value-of select="/cfg-ns:config/bbf-qos-filt:filters/bbf-qos-enhfilt:enhanced-filter[bbf-qos-enhfilt:name=$enhanceFilterRefNameInFilter]/bbf-qos-enhfilt:filter/bbf-qos-enhfilt:dei-marking-list/bbf-qos-enhfilt:index[text()='0']"/>
                  </xsl:variable>
                  <xsl:if test="string-length(normalize-space($enhanceFilterInRefDeiMarkingList0))>0">
                    <xsl:value-of select="$enhanceFilterInRefDeiMarkingList0"/>
                  </xsl:if>
                </xsl:if>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="deiMarkingList1">
        <xsl:variable name="inlineDeiMarkingList1">
          <xsl:value-of select="current()/bbf-qos-cls:match-criteria/bbf-qos-plc:dei-marking-list/bbf-qos-plc:index[text()='1']"/>
        </xsl:variable>
        <xsl:variable name="enhanceClassifierDeiMarkingList1">
          <xsl:value-of select="current()/bbf-qos-enhfilt:dei-marking-list/bbf-qos-enhfilt:index[text()='1']"/>
        </xsl:variable>
        <xsl:variable name="enhanceFilterRefName">
          <xsl:value-of select="current()/bbf-qos-enhfilt:enhanced-filter-name"/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="string-length(normalize-space($inlineDeiMarkingList1))>0">
            <xsl:value-of select="$inlineDeiMarkingList1"/>
          </xsl:when>
          <xsl:when test="string-length(normalize-space($enhanceClassifierDeiMarkingList1))>0">
            <xsl:value-of select="$enhanceClassifierDeiMarkingList1"/>
          </xsl:when>
          <xsl:when test="string-length(normalize-space($enhanceFilterRefName))>0">
            <xsl:variable name="enhanceFilterPbitMarkingList1">
              <xsl:value-of select="/cfg-ns:config/bbf-qos-filt:filters/bbf-qos-enhfilt:enhanced-filter[bbf-qos-enhfilt:name=$enhanceFilterRefName]/bbf-qos-enhfilt:filter/bbf-qos-enhfilt:dei-marking-list/bbf-qos-enhfilt:index[text()='1']"/>
            </xsl:variable>
            <xsl:choose>
              <xsl:when test="string-length(normalize-space($enhanceFilterPbitMarkingList1))>0">
                <xsl:value-of select="$enhanceFilterPbitMarkingList1"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="enhanceFilterRefNameInFilter">
                  <xsl:value-of select="/cfg-ns:config/bbf-qos-filt:filters/bbf-qos-enhfilt:enhanced-filter[bbf-qos-enhfilt:name=$enhanceFilterRefName]/bbf-qos-enhfilt:filter/bbf-qos-enhfilt:enhanced-filter-name"/>
                </xsl:variable>
                <xsl:if test="string-length(normalize-space($enhanceFilterRefNameInFilter))>0">
                  <xsl:variable name="enhanceFilterInRefDeiMarkingList1">
                    <xsl:value-of select="/cfg-ns:config/bbf-qos-filt:filters/bbf-qos-enhfilt:enhanced-filter[bbf-qos-enhfilt:name=$enhanceFilterRefNameInFilter]/bbf-qos-enhfilt:filter/bbf-qos-enhfilt:dei-marking-list/bbf-qos-enhfilt:index[text()='1']"/>
                  </xsl:variable>
                  <xsl:if test="string-length(normalize-space($enhanceFilterInRefDeiMarkingList1))>0">
                    <xsl:value-of select="$enhanceFilterInRefDeiMarkingList1"/>
                  </xsl:if>
                </xsl:if>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="inPbitList0">
        <xsl:variable name="inlineInPbitList0">
          <xsl:value-of select="current()/bbf-qos-cls:match-criteria/bbf-qos-cls:tag[bbf-qos-cls:in-pbit-list[normalize-space()]]/bbf-qos-cls:index[text()='0']"/>
        </xsl:variable>
        <xsl:variable name="enhanceClassifierInPbitList0">
          <xsl:value-of select="current()/bbf-qos-enhfilt:vlans/bbf-qos-enhfilt:tag[bbf-qos-enhfilt:in-pbit-list[normalize-space()]]/bbf-qos-enhfilt:index[text()='0']"/>
        </xsl:variable>
        <xsl:variable name="enhanceFilterRefName">
          <xsl:value-of select="current()/bbf-qos-enhfilt:enhanced-filter-name"/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="string-length(normalize-space($inlineInPbitList0))>0">
            <xsl:value-of select="$inlineInPbitList0"/>
          </xsl:when>
          <xsl:when test="string-length(normalize-space($enhanceClassifierInPbitList0))>0">
            <xsl:value-of select="$enhanceClassifierInPbitList0"/>
          </xsl:when>
          <xsl:when test="string-length(normalize-space($enhanceFilterRefName))>0">
            <xsl:variable name="enhanceFilterInPbitList0">
              <xsl:value-of select="/cfg-ns:config/bbf-qos-filt:filters/bbf-qos-enhfilt:enhanced-filter[bbf-qos-enhfilt:name=$enhanceFilterRefName]/bbf-qos-enhfilt:filter/bbf-qos-enhfilt:vlans/bbf-qos-enhfilt:tag[bbf-qos-enhfilt:in-pbit-list[normalize-space()]]/bbf-qos-enhfilt:index[text()='0']"/>
            </xsl:variable>
            <xsl:choose>
              <xsl:when test="string-length(normalize-space($enhanceFilterInPbitList0))>0">
                <xsl:value-of select="$enhanceFilterInPbitList0"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="enhanceFilterRefNameInFilter">
                  <xsl:value-of select="/cfg-ns:config/bbf-qos-filt:filters/bbf-qos-enhfilt:enhanced-filter[bbf-qos-enhfilt:name=$enhanceFilterRefName]/bbf-qos-enhfilt:filter/bbf-qos-enhfilt:enhanced-filter-name"/>
                </xsl:variable>
                <xsl:if test="string-length(normalize-space($enhanceFilterRefNameInFilter))>0">
                  <xsl:variable name="enhanceFilterInRefInPbitList0">
                    <xsl:value-of select="/cfg-ns:config/bbf-qos-filt:filters/bbf-qos-enhfilt:enhanced-filter[bbf-qos-enhfilt:name=$enhanceFilterRefNameInFilter]/bbf-qos-enhfilt:filter/bbf-qos-enhfilt:vlans/bbf-qos-enhfilt:tag[bbf-qos-enhfilt:in-pbit-list[normalize-space()]]/bbf-qos-enhfilt:index[text()='0']"/>
                  </xsl:variable>
                  <xsl:if test="string-length(normalize-space($enhanceFilterInRefInPbitList0))>0">
                    <xsl:value-of select="$enhanceFilterInRefInPbitList0"/>
                  </xsl:if>
                </xsl:if>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="inPbitList1">
        <xsl:variable name="inlineInPbitList1">
          <xsl:value-of select="current()/bbf-qos-cls:match-criteria/bbf-qos-cls:tag[bbf-qos-cls:in-pbit-list[normalize-space()]]/bbf-qos-cls:index[text()='1']"/>
        </xsl:variable>
        <xsl:variable name="enhanceClassifierInPbitList1">
          <xsl:value-of select="current()/bbf-qos-enhfilt:vlans/bbf-qos-enhfilt:tag[bbf-qos-enhfilt:in-pbit-list[normalize-space()]]/bbf-qos-enhfilt:index[text()='1']"/>
        </xsl:variable>
        <xsl:variable name="enhanceFilterRefName">
          <xsl:value-of select="current()/bbf-qos-enhfilt:enhanced-filter-name"/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="string-length(normalize-space($inlineInPbitList1))>0">
            <xsl:value-of select="$inlineInPbitList1"/>
          </xsl:when>
          <xsl:when test="string-length(normalize-space($enhanceClassifierInPbitList1))>0">
            <xsl:value-of select="$enhanceClassifierInPbitList1"/>
          </xsl:when>
          <xsl:when test="string-length(normalize-space($enhanceFilterRefName))>0">
            <xsl:variable name="enhanceFilterInPbitList1">
              <xsl:value-of select="/cfg-ns:config/bbf-qos-filt:filters/bbf-qos-enhfilt:enhanced-filter[bbf-qos-enhfilt:name=$enhanceFilterRefName]/bbf-qos-enhfilt:filter/bbf-qos-enhfilt:vlans/bbf-qos-enhfilt:tag[bbf-qos-enhfilt:in-pbit-list[normalize-space()]]/bbf-qos-enhfilt:index[text()='1']"/>
            </xsl:variable>
            <xsl:choose>
              <xsl:when test="string-length(normalize-space($enhanceFilterInPbitList1))>0">
                <xsl:value-of select="$enhanceFilterInPbitList1"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="enhanceFilterRefNameInFilter">
                  <xsl:value-of select="/cfg-ns:config/bbf-qos-filt:filters/bbf-qos-enhfilt:enhanced-filter[bbf-qos-enhfilt:name=$enhanceFilterRefName]/bbf-qos-enhfilt:filter/bbf-qos-enhfilt:enhanced-filter-name"/>
                </xsl:variable>
                <xsl:if test="string-length(normalize-space($enhanceFilterRefNameInFilter))>0">
                  <xsl:variable name="enhanceFilterInRefInPbitList1">
                    <xsl:value-of select="/cfg-ns:config/bbf-qos-filt:filters/bbf-qos-enhfilt:enhanced-filter[bbf-qos-enhfilt:name=$enhanceFilterRefNameInFilter]/bbf-qos-enhfilt:filter/bbf-qos-enhfilt:vlans/bbf-qos-enhfilt:tag[bbf-qos-enhfilt:in-pbit-list[normalize-space()]]/bbf-qos-enhfilt:index[text()='1']"/>
                  </xsl:variable>
                  <xsl:if test="string-length(normalize-space($enhanceFilterInRefInPbitList1))>0">
                    <xsl:value-of select="$enhanceFilterInRefInPbitList1"/>
                  </xsl:if>
                </xsl:if>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="inDei0">
        <xsl:variable name="inlineDei0">
          <xsl:value-of select="current()/bbf-qos-cls:match-criteria/bbf-qos-cls:tag[bbf-qos-cls:in-dei[normalize-space()]]/bbf-qos-cls:index[text()='0']"/>
        </xsl:variable>
        <xsl:variable name="enhanceClassifierInDei0">
          <xsl:value-of select="current()/bbf-qos-enhfilt:vlans/bbf-qos-enhfilt:tag[bbf-qos-enhfilt:in-dei[normalize-space()]]/bbf-qos-enhfilt:index[text()='0']"/>
        </xsl:variable>
        <xsl:variable name="enhanceFilterRefName">
          <xsl:value-of select="current()/bbf-qos-enhfilt:enhanced-filter-name"/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="string-length(normalize-space($inlineDei0))>0">
            <xsl:value-of select="$inlineDei0"/>
          </xsl:when>
          <xsl:when test="string-length(normalize-space($enhanceClassifierInDei0))>0">
            <xsl:value-of select="$enhanceClassifierInDei0"/>
          </xsl:when>
          <xsl:when test="string-length(normalize-space($enhanceFilterRefName))>0">
            <xsl:variable name="enhanceFilterInDei0">
              <xsl:value-of select="/cfg-ns:config/bbf-qos-filt:filters/bbf-qos-enhfilt:enhanced-filter[bbf-qos-enhfilt:name=$enhanceFilterRefName]/bbf-qos-enhfilt:filter/bbf-qos-enhfilt:vlans/bbf-qos-enhfilt:tag[bbf-qos-enhfilt:in-dei[normalize-space()]]/bbf-qos-enhfilt:index[text()='0']"/>
            </xsl:variable>
            <xsl:choose>
              <xsl:when test="string-length(normalize-space($enhanceFilterInDei0))>0">
                <xsl:value-of select="$enhanceFilterInDei0"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="enhanceFilterRefNameInFilter">
                  <xsl:value-of select="/cfg-ns:config/bbf-qos-filt:filters/bbf-qos-enhfilt:enhanced-filter[bbf-qos-enhfilt:name=$enhanceFilterRefName]/bbf-qos-enhfilt:filter/bbf-qos-enhfilt:enhanced-filter-name"/>
                </xsl:variable>
                <xsl:if test="string-length(normalize-space($enhanceFilterRefNameInFilter))>0">
                  <xsl:variable name="enhanceFilterInRefInDei0">
                    <xsl:value-of select="/cfg-ns:config/bbf-qos-filt:filters/bbf-qos-enhfilt:enhanced-filter[bbf-qos-enhfilt:name=$enhanceFilterRefNameInFilter]/bbf-qos-enhfilt:filter/bbf-qos-enhfilt:vlans/bbf-qos-enhfilt:tag[bbf-qos-enhfilt:in-dei[normalize-space()]]/bbf-qos-enhfilt:index[text()='0']"/>
                  </xsl:variable>
                  <xsl:if test="string-length(normalize-space($enhanceFilterInRefInDei0))>0">
                    <xsl:value-of select="$enhanceFilterInRefInDei0"/>
                  </xsl:if>
                </xsl:if>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="inDei1">
        <xsl:variable name="inlineInDei1">
          <xsl:value-of select="current()/bbf-qos-cls:match-criteria/bbf-qos-cls:tag[bbf-qos-cls:in-dei[normalize-space()]]/bbf-qos-cls:index[text()='1']"/>
        </xsl:variable>
        <xsl:variable name="enhanceClassifierInDei1">
          <xsl:value-of select="current()/bbf-qos-enhfilt:vlans/bbf-qos-enhfilt:tag[bbf-qos-enhfilt:in-dei[normalize-space()]]/bbf-qos-enhfilt:index[text()='1']"/>
        </xsl:variable>
        <xsl:variable name="enhanceFilterRefName">
          <xsl:value-of select="current()/bbf-qos-enhfilt:enhanced-filter-name"/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="string-length(normalize-space($inlineInDei1))>0">
            <xsl:value-of select="$inlineInDei1"/>
          </xsl:when>
          <xsl:when test="string-length(normalize-space($enhanceClassifierInDei1))>0">
            <xsl:value-of select="$enhanceClassifierInDei1"/>
          </xsl:when>
          <xsl:when test="string-length(normalize-space($enhanceFilterRefName))>0">
            <xsl:variable name="enhanceFilterInDei1">
              <xsl:value-of select="/cfg-ns:config/bbf-qos-filt:filters/bbf-qos-enhfilt:enhanced-filter[bbf-qos-enhfilt:name=$enhanceFilterRefName]/bbf-qos-enhfilt:filter/bbf-qos-enhfilt:vlans/bbf-qos-enhfilt:tag[bbf-qos-enhfilt:in-dei[normalize-space()]]/bbf-qos-enhfilt:index[text()='1']"/>
            </xsl:variable>
            <xsl:choose>
              <xsl:when test="string-length(normalize-space($enhanceFilterInDei1))>0">
                <xsl:value-of select="$enhanceFilterInDei1"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="enhanceFilterRefNameInFilter">
                  <xsl:value-of select="/cfg-ns:config/bbf-qos-filt:filters/bbf-qos-enhfilt:enhanced-filter[bbf-qos-enhfilt:name=$enhanceFilterRefName]/bbf-qos-enhfilt:filter/bbf-qos-enhfilt:enhanced-filter-name"/>
                </xsl:variable>
                <xsl:if test="string-length(normalize-space($enhanceFilterRefNameInFilter))>0">
                  <xsl:variable name="enhanceFilterInRefInDei1">
                    <xsl:value-of select="/cfg-ns:config/bbf-qos-filt:filters/bbf-qos-enhfilt:enhanced-filter[bbf-qos-enhfilt:name=$enhanceFilterRefNameInFilter]/bbf-qos-enhfilt:filter/bbf-qos-enhfilt:vlans/bbf-qos-enhfilt:tag[bbf-qos-enhfilt:in-dei[normalize-space()]]/bbf-qos-enhfilt:index[text()='1']"/>
                  </xsl:variable>
                  <xsl:if test="string-length(normalize-space($enhanceFilterInRefInDei1))>0">
                    <xsl:value-of select="$enhanceFilterInRefInDei1"/>
                  </xsl:if>
                </xsl:if>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="policingProfile">
        <xsl:value-of select="current()/bbf-qos-cls:classifier-action-entry-cfg/bbf-qos-plc:policing/bbf-qos-plc:policing-profile"/>
      </xsl:variable>

      <xsl:variable name="pbitMarkingList0InPolicing">
        <xsl:if test="string-length(normalize-space($policingProfile))>0">
          <xsl:variable name="policingPreHandlingProfile">
            <xsl:value-of select="/cfg-ns:config/bbf-qos-plc:policing-profiles/bbf-qos-plc:policing-profile[bbf-qos-plc:name=$policingProfile]/nokia-qos-plc-ext:policing-pre-handling-profile"/>
          </xsl:variable>
          <xsl:if test="string-length(normalize-space($policingPreHandlingProfile))>0">
            <xsl:variable name="policingPreHandlingProfilePbitMarkingList0">
              <xsl:value-of select="/cfg-ns:config/nokia-qos-plc-ext:policing-pre-handling-profiles/nokia-qos-plc-ext:pre-handling-profile[nokia-qos-plc-ext:name=$policingPreHandlingProfile]/nokia-qos-plc-ext:pre-handling-entry/nokia-qos-plc-ext:match-params/nokia-qos-plc-ext:pbit-marking-list/nokia-qos-plc-ext:index[text()='0']"/>
            </xsl:variable>
            <xsl:if test="string-length(normalize-space($policingPreHandlingProfilePbitMarkingList0))>0">
              <xsl:value-of select="$policingPreHandlingProfilePbitMarkingList0"/>
            </xsl:if>
          </xsl:if>
        </xsl:if>
      </xsl:variable>
      <xsl:variable name="pbitMarkingList1InPolicing">
        <xsl:if test="string-length(normalize-space($policingProfile))>0">
          <xsl:variable name="policingPreHandlingProfile">
            <xsl:value-of select="/cfg-ns:config/bbf-qos-plc:policing-profiles/bbf-qos-plc:policing-profile[bbf-qos-plc:name=$policingProfile]/nokia-qos-plc-ext:policing-pre-handling-profile"/>
          </xsl:variable>
          <xsl:if test="string-length(normalize-space($policingPreHandlingProfile))>0">
            <xsl:variable name="policingPreHandlingProfilePbitMarkingList1">
              <xsl:value-of select="/cfg-ns:config/nokia-qos-plc-ext:policing-pre-handling-profiles/nokia-qos-plc-ext:pre-handling-profile[nokia-qos-plc-ext:name=$policingPreHandlingProfile]/nokia-qos-plc-ext:pre-handling-entry/nokia-qos-plc-ext:match-params/nokia-qos-plc-ext:pbit-marking-list/nokia-qos-plc-ext:index[text()='1']"/>
            </xsl:variable>
            <xsl:if test="string-length(normalize-space($policingPreHandlingProfilePbitMarkingList1))>0">
              <xsl:value-of select="$policingPreHandlingProfilePbitMarkingList1"/>
            </xsl:if>
          </xsl:if>
        </xsl:if>
      </xsl:variable>

      <xsl:variable name="deiMarkingList0InPolicing">
        <xsl:if test="string-length(normalize-space($policingProfile))>0">
          <xsl:variable name="policingPreHandlingProfile">
            <xsl:value-of select="/cfg-ns:config/bbf-qos-plc:policing-profiles/bbf-qos-plc:policing-profile[bbf-qos-plc:name=$policingProfile]/nokia-qos-plc-ext:policing-pre-handling-profile"/>
          </xsl:variable>
          <xsl:if test="string-length(normalize-space($policingPreHandlingProfile))>0">
            <xsl:variable name="policingPreHandlingProfileDeiMarkingList0">
              <xsl:value-of select="/cfg-ns:config/nokia-qos-plc-ext:policing-pre-handling-profiles/nokia-qos-plc-ext:pre-handling-profile[nokia-qos-plc-ext:name=$policingPreHandlingProfile]/nokia-qos-plc-ext:pre-handling-entry/nokia-qos-plc-ext:match-params/nokia-qos-plc-ext:dei-marking-list/nokia-qos-plc-ext:index[text()='0']"/>
            </xsl:variable>
            <xsl:if test="string-length(normalize-space($policingPreHandlingProfileDeiMarkingList0))>0">
              <xsl:value-of select="$policingPreHandlingProfileDeiMarkingList0"/>
            </xsl:if>
          </xsl:if>
        </xsl:if>
      </xsl:variable>
      <xsl:variable name="deiMarkingList1InPolicing">
        <xsl:if test="string-length(normalize-space($policingProfile))>0">
          <xsl:variable name="policingPreHandlingProfile">
            <xsl:value-of select="/cfg-ns:config/bbf-qos-plc:policing-profiles/bbf-qos-plc:policing-profile[bbf-qos-plc:name=$policingProfile]/nokia-qos-plc-ext:policing-pre-handling-profile"/>
          </xsl:variable>
          <xsl:if test="string-length(normalize-space($policingPreHandlingProfile))>0">
            <xsl:variable name="policingPreHandlingProfileDeiMarkingList1">
              <xsl:value-of select="/cfg-ns:config/nokia-qos-plc-ext:policing-pre-handling-profiles/nokia-qos-plc-ext:pre-handling-profile[nokia-qos-plc-ext:name=$policingPreHandlingProfile]/nokia-qos-plc-ext:pre-handling-entry/nokia-qos-plc-ext:match-params/nokia-qos-plc-ext:dei-marking-list/nokia-qos-plc-ext:index[text()='1']"/>
            </xsl:variable>
            <xsl:if test="string-length(normalize-space($policingPreHandlingProfileDeiMarkingList1))>0">
              <xsl:value-of select="$policingPreHandlingProfileDeiMarkingList1"/>
            </xsl:if>
          </xsl:if>
        </xsl:if>
      </xsl:variable>

      <xsl:variable name="inPbitList0InPolicing">
        <xsl:if test="string-length(normalize-space($policingProfile))>0">
          <xsl:variable name="policingPreHandlingProfile">
            <xsl:value-of select="/cfg-ns:config/bbf-qos-plc:policing-profiles/bbf-qos-plc:policing-profile[bbf-qos-plc:name=$policingProfile]/nokia-qos-plc-ext:policing-pre-handling-profile"/>
          </xsl:variable>
          <xsl:if test="string-length(normalize-space($policingPreHandlingProfile))>0">
            <xsl:variable name="policingPreHandlingProfileInPbitList0">
              <xsl:value-of select="/cfg-ns:config/nokia-qos-plc-ext:policing-pre-handling-profiles/nokia-qos-plc-ext:pre-handling-profile[nokia-qos-plc-ext:name=$policingPreHandlingProfile]/nokia-qos-plc-ext:pre-handling-entry/nokia-qos-plc-ext:match-params/nokia-qos-plc-ext:vlans/nokia-qos-plc-ext:tag[nokia-qos-plc-ext:in-pbit-list[normalize-space()]]/nokia-qos-plc-ext:index[text()='0']"/>
            </xsl:variable>
            <xsl:if test="string-length(normalize-space($policingPreHandlingProfileInPbitList0))>0">
              <xsl:value-of select="$policingPreHandlingProfileInPbitList0"/>
            </xsl:if>
          </xsl:if>
        </xsl:if>
      </xsl:variable>
      <xsl:variable name="inPbitList1InPolicing">
        <xsl:if test="string-length(normalize-space($policingProfile))>0">
          <xsl:variable name="policingPreHandlingProfile">
            <xsl:value-of select="/cfg-ns:config/bbf-qos-plc:policing-profiles/bbf-qos-plc:policing-profile[bbf-qos-plc:name=$policingProfile]/nokia-qos-plc-ext:policing-pre-handling-profile"/>
          </xsl:variable>
          <xsl:if test="string-length(normalize-space($policingPreHandlingProfile))>0">
            <xsl:variable name="policingPreHandlingProfileInPbitList1">
              <xsl:value-of select="/cfg-ns:config/nokia-qos-plc-ext:policing-pre-handling-profiles/nokia-qos-plc-ext:pre-handling-profile[nokia-qos-plc-ext:name=$policingPreHandlingProfile]/nokia-qos-plc-ext:pre-handling-entry/nokia-qos-plc-ext:match-params/nokia-qos-plc-ext:vlans/nokia-qos-plc-ext:tag[nokia-qos-plc-ext:in-pbit-list[normalize-space()]]/nokia-qos-plc-ext:index[text()='1']"/>
            </xsl:variable>
            <xsl:if test="string-length(normalize-space($policingPreHandlingProfileInPbitList1))>0">
              <xsl:value-of select="$policingPreHandlingProfileInPbitList1"/>
            </xsl:if>
          </xsl:if>
        </xsl:if>
      </xsl:variable>

      <xsl:variable name="inDei0InPolicing">
        <xsl:if test="string-length(normalize-space($policingProfile))>0">
          <xsl:variable name="policingPreHandlingProfile">
            <xsl:value-of select="/cfg-ns:config/bbf-qos-plc:policing-profiles/bbf-qos-plc:policing-profile[bbf-qos-plc:name=$policingProfile]/nokia-qos-plc-ext:policing-pre-handling-profile"/>
          </xsl:variable>
          <xsl:if test="string-length(normalize-space($policingPreHandlingProfile))>0">
            <xsl:variable name="policingPreHandlingProfileInDei0">
              <xsl:value-of select="/cfg-ns:config/nokia-qos-plc-ext:policing-pre-handling-profiles/nokia-qos-plc-ext:pre-handling-profile[nokia-qos-plc-ext:name=$policingPreHandlingProfile]/nokia-qos-plc-ext:pre-handling-entry/nokia-qos-plc-ext:match-params/nokia-qos-plc-ext:vlans/nokia-qos-plc-ext:tag[nokia-qos-plc-ext:in-dei[normalize-space()]]/nokia-qos-plc-ext:index[text()='0']"/>
            </xsl:variable>
            <xsl:if test="string-length(normalize-space($policingPreHandlingProfileInDei0))>0">
              <xsl:value-of select="$policingPreHandlingProfileInDei0"/>
            </xsl:if>
          </xsl:if>
        </xsl:if>
      </xsl:variable>
      <xsl:variable name="inDei1InPolicing">
        <xsl:if test="string-length(normalize-space($policingProfile))>0">
          <xsl:variable name="policingPreHandlingProfile">
            <xsl:value-of select="/cfg-ns:config/bbf-qos-plc:policing-profiles/bbf-qos-plc:policing-profile[bbf-qos-plc:name=$policingProfile]/nokia-qos-plc-ext:policing-pre-handling-profile"/>
          </xsl:variable>
          <xsl:if test="string-length(normalize-space($policingPreHandlingProfile))>0">
            <xsl:variable name="policingPreHandlingProfileInDei1">
              <xsl:value-of select="/cfg-ns:config/nokia-qos-plc-ext:policing-pre-handling-profiles/nokia-qos-plc-ext:pre-handling-profile[nokia-qos-plc-ext:name=$policingPreHandlingProfile]/nokia-qos-plc-ext:pre-handling-entry/nokia-qos-plc-ext:match-params/nokia-qos-plc-ext:vlans/nokia-qos-plc-ext:tag[nokia-qos-plc-ext:in-dei[normalize-space()]]/nokia-qos-plc-ext:index[text()='1']"/>
            </xsl:variable>
            <xsl:if test="string-length(normalize-space($policingPreHandlingProfileInDei1))>0">
              <xsl:value-of select="$policingPreHandlingProfileInDei1"/>
            </xsl:if>
          </xsl:if>
        </xsl:if>
      </xsl:variable>

      <xsl:variable name="actionPbitMarkingList0">
        <xsl:variable name="classifierActionEntryCfgPbit0">
          <xsl:value-of select="current()/bbf-qos-cls:classifier-action-entry-cfg/bbf-qos-cls:pbit-marking-cfg/bbf-qos-cls:pbit-marking-list/bbf-qos-cls:index[text()='0']"/>
        </xsl:variable>

        <xsl:if test="string-length(normalize-space($classifierActionEntryCfgPbit0))>0">
          <xsl:value-of select="$classifierActionEntryCfgPbit0"/>
        </xsl:if>
      </xsl:variable>
      <xsl:variable name="actionPbitMarkingList1">
        <xsl:variable name="classifierActionEntryCfgPbit1">
          <xsl:value-of select="current()/bbf-qos-cls:classifier-action-entry-cfg/bbf-qos-cls:pbit-marking-cfg/bbf-qos-cls:pbit-marking-list//bbf-qos-cls:index[text()='1']"/>
        </xsl:variable>

        <xsl:if test="string-length(normalize-space($classifierActionEntryCfgPbit1))>0">
          <xsl:value-of select="$classifierActionEntryCfgPbit1"/>
        </xsl:if>
      </xsl:variable>

      <xsl:variable name="actionDeiMarkingList0">
        <xsl:variable name="classifierActionEntryCfgDei0">
          <xsl:value-of select="current()/bbf-qos-cls:classifier-action-entry-cfg/bbf-qos-cls:dei-marking-cfg/bbf-qos-cls:dei-marking-list/bbf-qos-cls:index[text()='0']"/>
        </xsl:variable>

        <xsl:if test="string-length(normalize-space($classifierActionEntryCfgDei0))>0">
          <xsl:value-of select="$classifierActionEntryCfgDei0"/>
        </xsl:if>
      </xsl:variable>
      <xsl:variable name="actionDeiMarkingList1">
        <xsl:variable name="classifierActionEntryCfgDei1">
          <xsl:value-of select="current()/bbf-qos-cls:classifier-action-entry-cfg/bbf-qos-cls:dei-marking-cfg/bbf-qos-cls:dei-marking-list/bbf-qos-cls:index[text()='1']"/>
        </xsl:variable>

        <xsl:if test="string-length(normalize-space($classifierActionEntryCfgDei1))>0">
          <xsl:value-of select="$classifierActionEntryCfgDei1"/>
        </xsl:if>
      </xsl:variable>

      <xsl:variable name="poilicingActionPbitMarkingList0">
        <xsl:if test="string-length(normalize-space($policingProfile))>0">
          <xsl:variable name="policingActionProfile">
            <xsl:value-of select="/cfg-ns:config/bbf-qos-plc:policing-profiles/bbf-qos-plc:policing-profile[bbf-qos-plc:name=$policingProfile]/nokia-qos-plc-ext:policing-action-profile"/>
          </xsl:variable>
          <xsl:if test="string-length(normalize-space($policingActionProfile))>0">
            <xsl:variable name="policingActionProfileCfgPbit0">
              <xsl:value-of select="/cfg-ns:config/nokia-qos-plc-ext:policing-action-profiles/nokia-qos-plc-ext:action-profile[nokia-qos-plc-ext:name=$policingActionProfile]/nokia-qos-plc-ext:action/nokia-qos-plc-ext:pbit-marking-list/nokia-qos-plc-ext:index[text()='0']"/>
            </xsl:variable>
            <xsl:if test="string-length(normalize-space($policingActionProfileCfgPbit0))>0">
              <xsl:value-of select="$policingActionProfileCfgPbit0"/>
            </xsl:if>
          </xsl:if>
        </xsl:if>
      </xsl:variable>
      <xsl:variable name="poilicingActionPbitMarkingList1">
        <xsl:if test="string-length(normalize-space($policingProfile))>0">
          <xsl:variable name="policingActionProfile">
            <xsl:value-of select="/cfg-ns:config/bbf-qos-plc:policing-profiles/bbf-qos-plc:policing-profile[bbf-qos-plc:name=$policingProfile]/nokia-qos-plc-ext:policing-action-profile"/>
          </xsl:variable>
          <xsl:if test="string-length(normalize-space($policingActionProfile))>0">
            <xsl:variable name="policingActionProfileCfgPbit1">
              <xsl:value-of select="/cfg-ns:config/nokia-qos-plc-ext:policing-action-profiles/nokia-qos-plc-ext:action-profile[nokia-qos-plc-ext:name=$policingActionProfile]/nokia-qos-plc-ext:action/nokia-qos-plc-ext:pbit-marking-list/nokia-qos-plc-ext:index[text()='1']"/>
            </xsl:variable>
            <xsl:if test="string-length(normalize-space($policingActionProfileCfgPbit1))>0">
              <xsl:value-of select="$policingActionProfileCfgPbit1"/>
            </xsl:if>
          </xsl:if>
        </xsl:if>
      </xsl:variable>

      <xsl:variable name="policingActionDeiMarkingList0">
        <xsl:if test="string-length(normalize-space($policingProfile))>0">
          <xsl:variable name="policingActionProfile">
            <xsl:value-of select="/cfg-ns:config/bbf-qos-plc:policing-profiles/bbf-qos-plc:policing-profile[bbf-qos-plc:name=$policingProfile]/nokia-qos-plc-ext:policing-action-profile"/>
          </xsl:variable>
          <xsl:if test="string-length(normalize-space($policingActionProfile))>0">
            <xsl:variable name="policingActionProfileCfgDei0">
              <xsl:value-of select="/cfg-ns:config/nokia-qos-plc-ext:policing-action-profiles/nokia-qos-plc-ext:action-profile[nokia-qos-plc-ext:name=$policingActionProfile]/nokia-qos-plc-ext:action/nokia-qos-plc-ext:dei-marking-list/nokia-qos-plc-ext:index[text()='0']"/>
            </xsl:variable>
            <xsl:if test="string-length(normalize-space($policingActionProfileCfgDei0))>0">
              <xsl:value-of select="$policingActionProfileCfgDei0"/>
            </xsl:if>
          </xsl:if>
        </xsl:if>
      </xsl:variable>
      <xsl:variable name="policingActionDeiMarkingList1">
        <xsl:if test="string-length(normalize-space($policingProfile))>0">
          <xsl:variable name="policingActionProfile">
            <xsl:value-of select="/cfg-ns:config/bbf-qos-plc:policing-profiles/bbf-qos-plc:policing-profile[bbf-qos-plc:name=$policingProfile]/nokia-qos-plc-ext:policing-action-profile"/>
          </xsl:variable>
          <xsl:if test="string-length(normalize-space($policingActionProfile))>0">
            <xsl:variable name="policingActionProfileCfgDei1">
              <xsl:value-of select="/cfg-ns:config/nokia-qos-plc-ext:policing-action-profiles/nokia-qos-plc-ext:action-profile[nokia-qos-plc-ext:name=$policingActionProfile]/nokia-qos-plc-ext:action/nokia-qos-plc-ext:dei-marking-list/nokia-qos-plc-ext:index[text()='1']"/>
            </xsl:variable>
            <xsl:if test="string-length(normalize-space($policingActionProfileCfgDei1))>0">
              <xsl:value-of select="$policingActionProfileCfgDei1"/>
            </xsl:if>
          </xsl:if>
        </xsl:if>
      </xsl:variable>

      <xsl:variable name="isActionPbitMarkingList">
        <xsl:variable name="classifierActionEntryCfgPbit">
          <xsl:value-of select="current()/bbf-qos-cls:classifier-action-entry-cfg/bbf-qos-cls:pbit-marking-cfg/bbf-qos-cls:pbit-marking-list"/>
        </xsl:variable>

        <xsl:if test="string-length(normalize-space($classifierActionEntryCfgPbit))>0">
          <xsl:value-of select="$classifierActionEntryCfgPbit"/>
        </xsl:if>
      </xsl:variable>
      <xsl:variable name="isPoilicingActionPbitMarkingList">
        <xsl:if test="string-length(normalize-space($policingProfile))>0">
          <xsl:variable name="policingActionProfile">
            <xsl:value-of select="/cfg-ns:config/bbf-qos-plc:policing-profiles/bbf-qos-plc:policing-profile[bbf-qos-plc:name=$policingProfile]/nokia-qos-plc-ext:policing-action-profile"/>
          </xsl:variable>
          <xsl:if test="string-length(normalize-space($policingActionProfile))>0">
            <xsl:variable name="policingActionProfileCfgPbit">
              <xsl:value-of select="/cfg-ns:config/nokia-qos-plc-ext:policing-action-profiles/nokia-qos-plc-ext:action-profile[nokia-qos-plc-ext:name=$policingActionProfile]/nokia-qos-plc-ext:action/nokia-qos-plc-ext:pbit-marking-list"/>
            </xsl:variable>
            <xsl:if test="string-length(normalize-space($policingActionProfileCfgPbit))>0">
              <xsl:value-of select="$policingActionProfileCfgPbit"/>
            </xsl:if>
          </xsl:if>
        </xsl:if>
      </xsl:variable>

      <xsl:variable name="isActionDeiMarkingList">
        <xsl:variable name="classifierActionEntryCfgDei">
          <xsl:value-of select="current()/bbf-qos-cls:classifier-action-entry-cfg/bbf-qos-cls:dei-marking-cfg/bbf-qos-cls:dei-marking-list"/>
        </xsl:variable>

        <xsl:if test="string-length(normalize-space($classifierActionEntryCfgDei))>0">
          <xsl:value-of select="$classifierActionEntryCfgDei"/>
        </xsl:if>
      </xsl:variable>
      <xsl:variable name="isPolicingActionDeiMarkingList">
        <xsl:if test="string-length(normalize-space($policingProfile))>0">
          <xsl:variable name="policingActionProfile">
            <xsl:value-of select="/cfg-ns:config/bbf-qos-plc:policing-profiles/bbf-qos-plc:policing-profile[bbf-qos-plc:name=$policingProfile]/nokia-qos-plc-ext:policing-action-profile"/>
          </xsl:variable>
          <xsl:if test="string-length(normalize-space($policingActionProfile))>0">
            <xsl:variable name="policingActionProfileCfgDei">
              <xsl:value-of select="/cfg-ns:config/nokia-qos-plc-ext:policing-action-profiles/nokia-qos-plc-ext:action-profile[nokia-qos-plc-ext:name=$policingActionProfile]/nokia-qos-plc-ext:action/nokia-qos-plc-ext:dei-marking-list"/>
            </xsl:variable>
            <xsl:if test="string-length(normalize-space($policingActionProfileCfgDei))>0">
              <xsl:value-of select="$policingActionProfileCfgDei"/>
            </xsl:if>
          </xsl:if>
        </xsl:if>
      </xsl:variable>

      <xsl:variable name="type">
        <xsl:call-template name="getPolicyType">
        <xsl:with-param name="classifierName" select="current()/bbf-qos-cls:name"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:element name="classifiers">
        <xsl:element name="name">
          <xsl:value-of select="current()/bbf-qos-cls:name"/>
        </xsl:element>

        <xsl:element name="type">
          <xsl:value-of select="$type"/>
        </xsl:element>

        <xsl:if test="string-length(normalize-space($pbitMarkingList0))>0 or string-length(normalize-space($pbitMarkingList1))>0 or string-length(normalize-space($pbitMarkingList0InPolicing))>0 or string-length(normalize-space($pbitMarkingList1InPolicing))>0">
          <xsl:element name="filterType">
            <xsl:value-of select="$FILTER_TYPE_PBIT_MARKING_LIST"/>
          </xsl:element>
        </xsl:if>

        <xsl:if test="string-length(normalize-space($deiMarkingList0))>0 or string-length(normalize-space($deiMarkingList1))>0 or string-length(normalize-space($deiMarkingList0InPolicing))>0 or string-length(normalize-space($deiMarkingList1InPolicing))>0">
          <xsl:element name="filterType">
            <xsl:value-of select="$FILTER_TYPE_DEI_MARKING_LIST"/>
          </xsl:element>
        </xsl:if>

        <xsl:if test="string-length(normalize-space($inPbitList0))>0 or string-length(normalize-space($inPbitList1))>0 or string-length(normalize-space($inPbitList0InPolicing))>0 or string-length(normalize-space($inPbitList1InPolicing))>0">
          <xsl:element name="filterType">
            <xsl:value-of select="$FILTER_TYPE_IN_PBIT_LIST"/>
          </xsl:element>
        </xsl:if>

        <xsl:if test="string-length(normalize-space($inDei0))>0 or string-length(normalize-space($inDei1))>0 or string-length(normalize-space($inDei0InPolicing))>0 or string-length(normalize-space($inDei1InPolicing))>0">
          <xsl:element name="filterType">
            <xsl:value-of select="$FILTER_TYPE_IN_DEI"/>
          </xsl:element>
        </xsl:if>

        <xsl:choose>
          <xsl:when test="(string-length(normalize-space($pbitMarkingList0))>0 or string-length(normalize-space($deiMarkingList0))>0 or string-length(normalize-space($inPbitList0))>0 or string-length(normalize-space($inDei0))>0 or string-length(normalize-space($pbitMarkingList0InPolicing))>0 or string-length(normalize-space($deiMarkingList0InPolicing))>0 or string-length(normalize-space($inPbitList0InPolicing))>0 or string-length(normalize-space($inDei0InPolicing))>0) and (string-length(normalize-space($pbitMarkingList1))>0 or string-length(normalize-space($deiMarkingList1))>0 or string-length(normalize-space($inPbitList1))>0 or string-length(normalize-space($inDei1))>0 or string-length(normalize-space($pbitMarkingList1InPolicing))>0 or string-length(normalize-space($deiMarkingList1InPolicing))>0 or string-length(normalize-space($inPbitList1InPolicing))>0 or string-length(normalize-space($inDei1InPolicing))>0)">
            <xsl:element name="filterIndexType">
              <xsl:value-of select="$FILTER_INDEX_01"/>
            </xsl:element>
          </xsl:when>
          <xsl:when test="string-length(normalize-space($pbitMarkingList0))>0 or string-length(normalize-space($deiMarkingList0))>0 or string-length(normalize-space($inPbitList0))>0 or string-length(normalize-space($inDei0))>0 or string-length(normalize-space($pbitMarkingList0InPolicing))>0 or string-length(normalize-space($deiMarkingList0InPolicing))>0 or string-length(normalize-space($inPbitList0InPolicing))>0 or string-length(normalize-space($inDei0InPolicing))>0">
            <xsl:element name="filterIndexType">
              <xsl:value-of select="$FILTER_INDEX_0"/>
            </xsl:element>
          </xsl:when>
          <xsl:when test="string-length(normalize-space($pbitMarkingList1))>0 or string-length(normalize-space($deiMarkingList1))>0 or string-length(normalize-space($inPbitList1))>0 or string-length(normalize-space($inDei1))>0 or string-length(normalize-space($pbitMarkingList1InPolicing))>0 or string-length(normalize-space($deiMarkingList1InPolicing))>0 or string-length(normalize-space($inPbitList1InPolicing))>0 or string-length(normalize-space($inDei1InPolicing))>0">
            <xsl:element name="filterIndexType">
              <xsl:value-of select="$FILTER_INDEX_1"/>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
          </xsl:otherwise>
        </xsl:choose>

        <xsl:choose>
          <xsl:when test="(string-length(normalize-space($pbitMarkingList0))>0 or string-length(normalize-space($deiMarkingList0))>0 or string-length(normalize-space($inPbitList0))>0 or string-length(normalize-space($inDei0))>0) and (string-length(normalize-space($pbitMarkingList1))>0 or string-length(normalize-space($deiMarkingList1))>0 or string-length(normalize-space($inPbitList1))>0 or string-length(normalize-space($inDei1))>0)">
            <xsl:element name="filterIndexTypeWithoutPolicing">
              <xsl:value-of select="$FILTER_INDEX_01"/>
            </xsl:element>
          </xsl:when>
          <xsl:when test="string-length(normalize-space($pbitMarkingList0))>0 or string-length(normalize-space($deiMarkingList0))>0 or string-length(normalize-space($inPbitList0))>0 or string-length(normalize-space($inDei0))>0">
            <xsl:element name="filterIndexTypeWithoutPolicing">
              <xsl:value-of select="$FILTER_INDEX_0"/>
            </xsl:element>
          </xsl:when>
          <xsl:when test="string-length(normalize-space($pbitMarkingList1))>0 or string-length(normalize-space($deiMarkingList1))>0 or string-length(normalize-space($inPbitList1))>0 or string-length(normalize-space($inDei1))>0">
            <xsl:element name="filterIndexTypeWithoutPolicing">
              <xsl:value-of select="$FILTER_INDEX_1"/>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
          </xsl:otherwise>
        </xsl:choose>

        <xsl:if test="string-length(normalize-space($policingProfile))>0">
          <xsl:choose>
            <xsl:when test="(string-length(normalize-space($pbitMarkingList0InPolicing))>0 or string-length(normalize-space($deiMarkingList0InPolicing))>0 or string-length(normalize-space($inPbitList0InPolicing))>0 or string-length(normalize-space($inDei0InPolicing))>0) and (string-length(normalize-space($pbitMarkingList1InPolicing))>0 or string-length(normalize-space($deiMarkingList1InPolicing))>0 or string-length(normalize-space($inPbitList1InPolicing))>0 or string-length(normalize-space($inDei1InPolicing))>0)">
              <xsl:element name="policingFilterIndexType">
                <xsl:value-of select="$FILTER_INDEX_01"/>
              </xsl:element>
            </xsl:when>
            <xsl:when test="string-length(normalize-space($pbitMarkingList0InPolicing))>0 or string-length(normalize-space($deiMarkingList0InPolicing))>0 or string-length(normalize-space($inPbitList0InPolicing))>0 or string-length(normalize-space($inDei0InPolicing))>0">
              <xsl:element name="policingFilterIndexType">
                <xsl:value-of select="$FILTER_INDEX_0"/>
              </xsl:element>
            </xsl:when>
            <xsl:when test="string-length(normalize-space($pbitMarkingList1InPolicing))>0 or string-length(normalize-space($deiMarkingList1InPolicing))>0 or string-length(normalize-space($inPbitList1InPolicing))>0 or string-length(normalize-space($inDei1InPolicing))>0">
              <xsl:element name="policingFilterIndexType">
                <xsl:value-of select="$FILTER_INDEX_1"/>
              </xsl:element>
            </xsl:when>
            <xsl:otherwise>
            </xsl:otherwise>
          </xsl:choose>

          <xsl:choose>
            <xsl:when test="string-length(normalize-space($pbitMarkingList0InPolicing))>0 and string-length(normalize-space($pbitMarkingList1InPolicing))>0">
              <xsl:element name="policingPbitMarkingListFilterIndexType">
                <xsl:value-of select="$FILTER_INDEX_01"/>
              </xsl:element>
            </xsl:when>
            <xsl:when test="string-length(normalize-space($pbitMarkingList0InPolicing))>0">
              <xsl:element name="policingPbitMarkingListFilterIndexType">
                <xsl:value-of select="$FILTER_INDEX_0"/>
              </xsl:element>
            </xsl:when>
            <xsl:when test="string-length(normalize-space($pbitMarkingList1InPolicing))>0 ">
              <xsl:element name="policingPbitMarkingListFilterIndexType">
                <xsl:value-of select="$FILTER_INDEX_1"/>
              </xsl:element>
            </xsl:when>
            <xsl:otherwise>
            </xsl:otherwise>
          </xsl:choose>

          <xsl:choose>
            <xsl:when test="string-length(normalize-space($inPbitList0InPolicing))>0 and string-length(normalize-space($inPbitList1InPolicing))>0">
              <xsl:element name="policingInPbitListFilterIndexType">
                <xsl:value-of select="$FILTER_INDEX_01"/>
              </xsl:element>
            </xsl:when>
            <xsl:when test="string-length(normalize-space($inPbitList0InPolicing))>0">
              <xsl:element name="policingInPbitListFilterIndexType">
                <xsl:value-of select="$FILTER_INDEX_0"/>
              </xsl:element>
            </xsl:when>
            <xsl:when test="string-length(normalize-space($inPbitList1InPolicing))>0">
              <xsl:element name="policingInPbitListFilterIndexType">
                <xsl:value-of select="$FILTER_INDEX_1"/>
              </xsl:element>
            </xsl:when>
            <xsl:otherwise>
            </xsl:otherwise>
          </xsl:choose>

          <xsl:choose>
            <xsl:when test="string-length(normalize-space($deiMarkingList0InPolicing))>0  and string-length(normalize-space($deiMarkingList1InPolicing))>0">
              <xsl:element name="policingDeiMarkingListFilterIndexType">
                <xsl:value-of select="$FILTER_INDEX_01"/>
              </xsl:element>
            </xsl:when>
            <xsl:when test="string-length(normalize-space($deiMarkingList0InPolicing))>0 ">
              <xsl:element name="policingDeiMarkingListFilterIndexType">
                <xsl:value-of select="$FILTER_INDEX_0"/>
              </xsl:element>
            </xsl:when>
            <xsl:when test="string-length(normalize-space($deiMarkingList1InPolicing))>0">
              <xsl:element name="policingDeiMarkingListFilterIndexType">
                <xsl:value-of select="$FILTER_INDEX_1"/>
              </xsl:element>
            </xsl:when>
            <xsl:otherwise>
            </xsl:otherwise>
          </xsl:choose>

          <xsl:choose>
            <xsl:when test="string-length(normalize-space($inDei0InPolicing))>0 and string-length(normalize-space($inDei1InPolicing))>0">
              <xsl:element name="policingInDeiFilterIndexType">
                <xsl:value-of select="$FILTER_INDEX_01"/>
              </xsl:element>
            </xsl:when>
            <xsl:when test="string-length(normalize-space($inDei0InPolicing))>0">
              <xsl:element name="policingInDeiFilterIndexType">
                <xsl:value-of select="$FILTER_INDEX_0"/>
              </xsl:element>
            </xsl:when>
            <xsl:when test="string-length(normalize-space($inDei1InPolicing))>0">
              <xsl:element name="policingInDeiFilterIndexType">
                <xsl:value-of select="$FILTER_INDEX_1"/>
              </xsl:element>
            </xsl:when>
            <xsl:otherwise>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>

        <xsl:if test="string-length(normalize-space($isActionPbitMarkingList))>0 or string-length(normalize-space($isActionDeiMarkingList))>0">
          <xsl:element name="isActionPbitOrDeiMarking">
            <xsl:value-of select="$ACTION_PBIT_DEI_MARKING_LIST"/>
          </xsl:element>
        </xsl:if>
        <xsl:if test="string-length(normalize-space($isPoilicingActionPbitMarkingList))>0 or string-length(normalize-space($isPolicingActionDeiMarkingList))>0">
          <xsl:element name="isPolicingActionPbitOrDeiMarking">
            <xsl:value-of select="$ACTION_PBIT_DEI_MARKING_LIST"/>
          </xsl:element>
        </xsl:if>

        <xsl:if test="string-length(normalize-space($inPbitList0))>0 or string-length(normalize-space($inPbitList1))>0 or string-length(normalize-space($inDei0))>0 or string-length(normalize-space($inDei1))>0">
          <xsl:element name="isInPbitListInDeiCfg">
            <xsl:value-of select="$IN_PBIT_LIST_IN_DEI_CFG"/>
          </xsl:element>
        </xsl:if>
        <xsl:if test="string-length(normalize-space($inPbitList0InPolicing))>0 or string-length(normalize-space($inPbitList1InPolicing))>0 or string-length(normalize-space($inDei0InPolicing))>0 or string-length(normalize-space($inDei1InPolicing))>0">
          <xsl:element name="isPolicingInPbitListInDeiCfg">
            <xsl:value-of select="$POLICING_IN_PBIT_LIST_IN_DEI_CFG"/>
          </xsl:element>
        </xsl:if>

        <xsl:if test="string-length(normalize-space($actionPbitMarkingList0))>0">
          <xsl:element name="isActionPbitMarkingList0">
            <xsl:value-of select="$ACTION_PBIT_DEI_MARKING_LIST"/>
          </xsl:element>
        </xsl:if>
        <xsl:if test="string-length(normalize-space($actionPbitMarkingList1))>0">
          <xsl:element name="isActionPbitMarkingList1">
            <xsl:value-of select="$ACTION_PBIT_DEI_MARKING_LIST"/>
          </xsl:element>
        </xsl:if>
        <xsl:if test="string-length(normalize-space($actionDeiMarkingList0))>0">
          <xsl:element name="isActionDeiMarkingList0">
            <xsl:value-of select="$ACTION_PBIT_DEI_MARKING_LIST"/>
          </xsl:element>
        </xsl:if>
        <xsl:if test="string-length(normalize-space($actionDeiMarkingList1))>0">
          <xsl:element name="isActionDeiMarkingList1">
            <xsl:value-of select="$ACTION_PBIT_DEI_MARKING_LIST"/>
          </xsl:element>
        </xsl:if>

        <xsl:if test="string-length(normalize-space($inPbitList0))>0">
          <xsl:element name="isInPbitList0Cfg">
            <xsl:value-of select="$IN_PBIT_LIST_IN_DEI_CFG"/>
          </xsl:element>
        </xsl:if>
        <xsl:if test="string-length(normalize-space($inPbitList1))>0">
          <xsl:element name="isInPbitList1Cfg">
            <xsl:value-of select="$IN_PBIT_LIST_IN_DEI_CFG"/>
          </xsl:element>
        </xsl:if>
        <xsl:if test="string-length(normalize-space($inDei0))>0">
          <xsl:element name="isInDei0Cfg">
            <xsl:value-of select="$IN_PBIT_LIST_IN_DEI_CFG"/>
          </xsl:element>
        </xsl:if>
        <xsl:if test="string-length(normalize-space($inDei1))>0">
          <xsl:element name="isInDei1Cfg">
            <xsl:value-of select="$IN_PBIT_LIST_IN_DEI_CFG"/>
          </xsl:element>
        </xsl:if>

        <xsl:if test="string-length(normalize-space($poilicingActionPbitMarkingList0))>0">
          <xsl:element name="isPoilicingActionPbitMarkingList0">
            <xsl:value-of select="$ACTION_PBIT_DEI_MARKING_LIST"/>
          </xsl:element>
        </xsl:if>
        <xsl:if test="string-length(normalize-space($poilicingActionPbitMarkingList1))>0">
          <xsl:element name="isPoilicingActionPbitMarkingList1">
            <xsl:value-of select="$ACTION_PBIT_DEI_MARKING_LIST"/>
          </xsl:element>
        </xsl:if>
        <xsl:if test="string-length(normalize-space($policingActionDeiMarkingList0))>0">
          <xsl:element name="isPolicingActionDeiMarkingList0">
            <xsl:value-of select="$ACTION_PBIT_DEI_MARKING_LIST"/>
          </xsl:element>
        </xsl:if>
        <xsl:if test="string-length(normalize-space($policingActionDeiMarkingList1))>0">
          <xsl:element name="isPolicingActionDeiMarkingList1">
            <xsl:value-of select="$ACTION_PBIT_DEI_MARKING_LIST"/>
          </xsl:element>
        </xsl:if>

        <xsl:if test="string-length(normalize-space($inPbitList0InPolicing))>0">
          <xsl:element name="isPolicingInPbitList0Cfg">
            <xsl:value-of select="$POLICING_IN_PBIT_LIST_IN_DEI_CFG"/>
          </xsl:element>
        </xsl:if>
        <xsl:if test="string-length(normalize-space($inPbitList1InPolicing))>0">
          <xsl:element name="isPolicingInPbitList1Cfg">
            <xsl:value-of select="$POLICING_IN_PBIT_LIST_IN_DEI_CFG"/>
          </xsl:element>
        </xsl:if>
        <xsl:if test="string-length(normalize-space($inDei0InPolicing))>0">
          <xsl:element name="isPolicingInDei0Cfg">
            <xsl:value-of select="$POLICING_IN_PBIT_LIST_IN_DEI_CFG"/>
          </xsl:element>
        </xsl:if>
        <xsl:if test="string-length(normalize-space($inDei1InPolicing))>0">
          <xsl:element name="isPolicingInDei1Cfg">
            <xsl:value-of select="$POLICING_IN_PBIT_LIST_IN_DEI_CFG"/>
          </xsl:element>
        </xsl:if>

        <xsl:if test="string-length(normalize-space($policingProfile))>0">
          <xsl:element name="isPolicingProfileCfg">
            <xsl:value-of select="$policingProfile"/>
          </xsl:element>
        </xsl:if>

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
        <xsl:element name="policyType">
          <xsl:value-of select="$classifiers_Info_map($firstClassifierNameInPolicy)/type"/>
        </xsl:element>
        <xsl:for-each select ="current()/bbf-qos-pol:classifiers">
          <xsl:variable name="classifierName">
            <xsl:value-of select="current()/bbf-qos-pol:name"/>
          </xsl:variable>
          <xsl:element name="classifiers">
            <xsl:element name="name">
              <xsl:value-of select="$classifierName"/>
            </xsl:element>

            <xsl:if test="string-length(normalize-space($classifiers_Info_map($classifierName)/filterIndexType))>0">
              <xsl:element name="filterIndexType">
                <xsl:value-of select="$classifiers_Info_map($classifierName)/filterIndexType"/>
              </xsl:element>
            </xsl:if>
            <xsl:if test="string-length(normalize-space($classifiers_Info_map($classifierName)/filterIndexTypeWithoutPolicing))>0">
              <xsl:element name="filterIndexTypeWithoutPolicing">
                <xsl:value-of select="$classifiers_Info_map($classifierName)/filterIndexTypeWithoutPolicing"/>
              </xsl:element>
            </xsl:if>
            <xsl:if test="string-length(normalize-space($classifiers_Info_map($classifierName)/policingFilterIndexType))>0">
              <xsl:element name="policingFilterIndexType">
                <xsl:value-of select="$classifiers_Info_map($classifierName)/policingFilterIndexType"/>
              </xsl:element>
            </xsl:if>
            <xsl:if test="string-length(normalize-space($classifiers_Info_map($classifierName)/policingPbitMarkingListFilterIndexType))>0">
              <xsl:element name="policingPbitMarkingListFilterIndexType">
                <xsl:value-of select="$classifiers_Info_map($classifierName)/policingPbitMarkingListFilterIndexType"/>
              </xsl:element>
            </xsl:if>
            <xsl:if test="string-length(normalize-space($classifiers_Info_map($classifierName)/policingInPbitListFilterIndexType))>0">
              <xsl:element name="policingInPbitListFilterIndexType">
                <xsl:value-of select="$classifiers_Info_map($classifierName)/policingInPbitListFilterIndexType"/>
              </xsl:element>
            </xsl:if>
            <xsl:if test="string-length(normalize-space($classifiers_Info_map($classifierName)/policingDeiMarkingListFilterIndexType))>0">
              <xsl:element name="policingDeiMarkingListFilterIndexType">
                <xsl:value-of select="$classifiers_Info_map($classifierName)/policingDeiMarkingListFilterIndexType"/>
              </xsl:element>
            </xsl:if>
            <xsl:if test="string-length(normalize-space($classifiers_Info_map($classifierName)/policingInDeiFilterIndexType))>0">
              <xsl:element name="policingInDeiFilterIndexType">
                <xsl:value-of select="$classifiers_Info_map($classifierName)/policingInDeiFilterIndexType"/>
              </xsl:element>
            </xsl:if>

            <xsl:if test="string-length(normalize-space($classifiers_Info_map($classifierName)/filterType))>0">
              <xsl:for-each select ="$classifiers_Info_map($classifierName)/filterType">
                <xsl:element name="filterType">
                  <xsl:copy-of select="text()"/>
                </xsl:element>
              </xsl:for-each>
            </xsl:if>

            <xsl:if test="string-length(normalize-space($classifiers_Info_map($classifierName)/isActionPbitOrDeiMarking))>0">
              <xsl:element name="isActionPbitOrDeiMarking">
                <xsl:value-of select="$classifiers_Info_map($classifierName)/isActionPbitOrDeiMarking"/>
              </xsl:element>
            </xsl:if>
            <xsl:if test="string-length(normalize-space($classifiers_Info_map($classifierName)/isPolicingActionPbitOrDeiMarking))>0">
              <xsl:element name="isPolicingActionPbitOrDeiMarking">
                <xsl:value-of select="$classifiers_Info_map($classifierName)/isPolicingActionPbitOrDeiMarking"/>
              </xsl:element>
            </xsl:if>

            <xsl:if test="string-length(normalize-space($classifiers_Info_map($classifierName)/isInPbitListInDeiCfg))>0">
              <xsl:element name="isInPbitListInDeiCfg">
                <xsl:value-of select="$classifiers_Info_map($classifierName)/isInPbitListInDeiCfg"/>
              </xsl:element>
            </xsl:if>
            <xsl:if test="string-length(normalize-space($classifiers_Info_map($classifierName)/isPolicingInPbitListInDeiCfg))>0">
              <xsl:element name="isPolicingInPbitListInDeiCfg">
                <xsl:value-of select="$classifiers_Info_map($classifierName)/isPolicingInPbitListInDeiCfg"/>
              </xsl:element>
            </xsl:if>

            <xsl:if test="string-length(normalize-space($classifiers_Info_map($classifierName)/isActionPbitMarkingList0))>0">
              <xsl:element name="isActionPbitMarkingList0">
                <xsl:value-of select="$classifiers_Info_map($classifierName)/isActionPbitMarkingList0"/>
              </xsl:element>
            </xsl:if>
            <xsl:if test="string-length(normalize-space($classifiers_Info_map($classifierName)/isActionPbitMarkingList1))>0">
              <xsl:element name="isActionPbitMarkingList1">
                <xsl:value-of select="$classifiers_Info_map($classifierName)/isActionPbitMarkingList1"/>
              </xsl:element>
            </xsl:if>
            <xsl:if test="string-length(normalize-space($classifiers_Info_map($classifierName)/isActionDeiMarkingList0))>0">
              <xsl:element name="isActionDeiMarkingList0">
                <xsl:value-of select="$classifiers_Info_map($classifierName)/isActionDeiMarkingList0"/>
              </xsl:element>
            </xsl:if>
            <xsl:if test="string-length(normalize-space($classifiers_Info_map($classifierName)/isActionDeiMarkingList1))>0">
              <xsl:element name="isActionDeiMarkingList1">
                <xsl:value-of select="$classifiers_Info_map($classifierName)/isActionDeiMarkingList1"/>
              </xsl:element>
            </xsl:if>

            <xsl:if test="string-length(normalize-space($classifiers_Info_map($classifierName)/isInPbitList0Cfg))>0">
              <xsl:element name="isInPbitList0Cfg">
                <xsl:value-of select="$classifiers_Info_map($classifierName)/isInPbitList0Cfg"/>
              </xsl:element>
            </xsl:if>
            <xsl:if test="string-length(normalize-space($classifiers_Info_map($classifierName)/isInPbitList1Cfg))>0">
              <xsl:element name="isInPbitList1Cfg">
                <xsl:value-of select="$classifiers_Info_map($classifierName)/isInPbitList1Cfg"/>
              </xsl:element>
            </xsl:if>
            <xsl:if test="string-length(normalize-space($classifiers_Info_map($classifierName)/isInDei0Cfg))>0">
              <xsl:element name="isInDei0Cfg">
                <xsl:value-of select="$classifiers_Info_map($classifierName)/isInDei0Cfg"/>
              </xsl:element>
            </xsl:if>
            <xsl:if test="string-length(normalize-space($classifiers_Info_map($classifierName)/isInDei1Cfg))>0">
              <xsl:element name="isInDei1Cfg">
                <xsl:value-of select="$classifiers_Info_map($classifierName)/isInDei1Cfg"/>
              </xsl:element>
            </xsl:if>

            <xsl:if test="string-length(normalize-space($classifiers_Info_map($classifierName)/isPoilicingActionPbitMarkingList0))>0">
              <xsl:element name="isPoilicingActionPbitMarkingList0">
                <xsl:value-of select="$classifiers_Info_map($classifierName)/isPoilicingActionPbitMarkingList0"/>
              </xsl:element>
            </xsl:if>
            <xsl:if test="string-length(normalize-space($classifiers_Info_map($classifierName)/isPoilicingActionPbitMarkingList1))>0">
              <xsl:element name="isPoilicingActionPbitMarkingList1">
                <xsl:value-of select="$classifiers_Info_map($classifierName)/isPoilicingActionPbitMarkingList1"/>
              </xsl:element>
            </xsl:if>
            <xsl:if test="string-length(normalize-space($classifiers_Info_map($classifierName)/isPolicingActionDeiMarkingList0))>0">
              <xsl:element name="isPolicingActionDeiMarkingList0">
                <xsl:value-of select="$classifiers_Info_map($classifierName)/isPolicingActionDeiMarkingList0"/>
              </xsl:element>
            </xsl:if>
            <xsl:if test="string-length(normalize-space($classifiers_Info_map($classifierName)/isPolicingActionDeiMarkingList1))>0">
              <xsl:element name="isPolicingActionDeiMarkingList1">
                <xsl:value-of select="$classifiers_Info_map($classifierName)/isPolicingActionDeiMarkingList1"/>
              </xsl:element>
            </xsl:if>

            <xsl:if test="string-length(normalize-space($classifiers_Info_map($classifierName)/isPolicingInPbitList0Cfg))>0">
              <xsl:element name="isPolicingInPbitList0Cfg">
                <xsl:value-of select="$classifiers_Info_map($classifierName)/isPolicingInPbitList0Cfg"/>
              </xsl:element>
            </xsl:if>
            <xsl:if test="string-length(normalize-space($classifiers_Info_map($classifierName)/isPolicingInPbitList1Cfg))>0">
              <xsl:element name="isPolicingInPbitList1Cfg">
                <xsl:value-of select="$classifiers_Info_map($classifierName)/isPolicingInPbitList1Cfg"/>
              </xsl:element>
            </xsl:if>
            <xsl:if test="string-length(normalize-space($classifiers_Info_map($classifierName)/isPolicingInDei0Cfg))>0">
              <xsl:element name="isPolicingInDei0Cfg">
                <xsl:value-of select="$classifiers_Info_map($classifierName)/isPolicingInDei0Cfg"/>
              </xsl:element>
            </xsl:if>
            <xsl:if test="string-length(normalize-space($classifiers_Info_map($classifierName)/isPolicingInDei1Cfg))>0">
              <xsl:element name="isPolicingInDei1Cfg">
                <xsl:value-of select="$classifiers_Info_map($classifierName)/isPolicingInDei1Cfg"/>
              </xsl:element>
            </xsl:if>

            <xsl:if test="string-length(normalize-space($classifiers_Info_map($classifierName)/isPolicingProfileCfg))>0">
              <xsl:element name="isPolicingProfileCfg">
                <xsl:value-of select="$classifiers_Info_map($classifierName)/isPolicingProfileCfg"/>
              </xsl:element>
            </xsl:if>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="policy_Info_map" select="map:merge(for $elem in $policy_Info/policy return map{$elem/name : $elem})"/>

  <!-- collecting policy profile info -->
  <xsl:variable name="policy_profile_Info">
    <xsl:for-each select ="/cfg-ns:config/bbf-qos-pol:qos-policy-profiles/bbf-qos-pol:policy-profile[contains($qosProfileNameInVsi,bbf-qos-pol:name)]">
      <xsl:element name="policyProfile">
        <xsl:element name="name">
          <xsl:value-of select="current()/bbf-qos-pol:name"/>
        </xsl:element>
        <xsl:copy-of select="current()/bbf-qos-pol:policy-list"/>
      </xsl:element>
    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="policy_profile_Info_map" select="map:merge(for $elem in $policy_profile_Info/policyProfile return map{$elem/name : $elem})"/>

  <!-- collecting vsi info -->
  <xsl:variable name="vsi_Info">
    <xsl:for-each select ="/cfg-ns:config/itf-ns:interfaces/itf-ns:interface[itf-ns:type='bbfift:vlan-sub-interface']">
      <xsl:variable name="interfaceName">
        <xsl:value-of select="current()/itf-ns:name"/>
      </xsl:variable>

      <xsl:variable name="interfaceUsageType">
        <xsl:variable name="interfaceUsage">
          <xsl:variable name="inlineInterfaceUsage">
            <xsl:value-of select="current()/bbf-if-usg:interface-usage/bbf-if-usg:interface-usage"/>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="string-length(normalize-space($inlineInterfaceUsage))>0">
              <xsl:value-of select="$inlineInterfaceUsage"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name="vectorInterfaceUsage">
                <xsl:variable name="vectorProfileName">
                  <xsl:value-of select="current()/bbf-vsi-vctr:vector-profile"/>
                </xsl:variable>
                <xsl:if test="string-length(normalize-space($vectorProfileName))>0">
                  <xsl:variable name="interfaceUsageInVector">
                    <xsl:value-of select="/cfg-ns:config/bbf-vsi-vctr:vsi-vector-profiles/bbf-vsi-vctr:vsi-vector-profile[bbf-vsi-vctr:name=$vectorProfileName]/bbf-vsi-vctr-usg:interface-usage/bbf-vsi-vctr-usg:interface-usage"/>
                  </xsl:variable>
                  <xsl:if test="string-length(normalize-space($interfaceUsageInVector))>0">
                    <xsl:value-of select="$interfaceUsageInVector"/>
                  </xsl:if>
                </xsl:if>
              </xsl:variable>

              <xsl:if test="string-length(normalize-space($vectorInterfaceUsage))>0">
                <xsl:value-of select="$vectorInterfaceUsage"/>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:if test="string-length(normalize-space($interfaceUsage))>0">
          <xsl:variable name="subIfLowerLayer">
            <xsl:value-of select="current()/bbf-subif:subif-lower-layer/bbf-subif:interface"/>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="$interfaceUsage=$USAGE_NETWORK or ($interfaceUsage=$USAGE_INHERIT and $subIfLowerLayer=$BP_ETH)">
              <xsl:value-of select="$USAGE_NETWORK"/>
            </xsl:when>
            <xsl:when test="$interfaceUsage=$USAGE_USER or $interfaceUsage=$USAGE_SUBTENDED_NODE">
              <xsl:value-of select="$USAGE_USER"/>
            </xsl:when>
            <xsl:otherwise>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:variable>

      <xsl:variable name="tag0">
        <xsl:variable name="inlineIndex0">
          <xsl:value-of select="current()/bbf-subif:inline-frame-processing/bbf-subif:ingress-rule/bbf-subif:rule/bbf-subif:flexible-match/bbf-subif-tag:match-criteria/bbf-subif-tag:tag/bbf-subif-tag:index[text()='0']"/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="string-length(normalize-space($inlineIndex0))>0">
            <xsl:value-of select="$inlineIndex0"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="frameProcessingProfileRef">
              <xsl:value-of select="current()/bbf-frameproc:frame-processing-profile-ref"/>
            </xsl:variable>
            <xsl:choose>
              <xsl:when test="string-length(normalize-space($frameProcessingProfileRef))>0">
                <xsl:variable name="frame0VlanId">
                  <xsl:value-of select="/cfg-ns:config/bbf-frameproc:frame-processing-profiles/bbf-frameproc:frame-processing-profile[bbf-frameproc:name=$frameProcessingProfileRef]/bbf-frameproc:match-criteria/bbf-frameproc:tag[bbf-frameproc:index='0']/bbf-frameproc:vlan-id"/>
                </xsl:variable>
                <xsl:choose>
                  <xsl:when test="$frame0VlanId=$PARAMETER_VLAN_ID">
                    <xsl:value-of select="current()/bbf-frameproc:tag-0/bbf-frameproc:vlan-id"/>
                  </xsl:when>
                  <xsl:when test="string-length(normalize-space($frame0VlanId))>0">
                    <xsl:value-of select="$frame0VlanId"/>
                  </xsl:when>
                  <xsl:otherwise>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="vectorFrame0VlanId">
                  <xsl:variable name="vectorProfileName">
                    <xsl:value-of select="current()/bbf-vsi-vctr:vector-profile"/>
                  </xsl:variable>
                  <xsl:if test="string-length(normalize-space($vectorProfileName))>0">
                    <xsl:variable name="vectorFrameProcessingProfileRef">
                      <xsl:value-of select="/cfg-ns:config/bbf-vsi-vctr:vsi-vector-profiles/bbf-vsi-vctr:vsi-vector-profile[bbf-vsi-vctr:name=$vectorProfileName]/bbf-vsi-vctr-fpp:frame-processing-profile-ref"/>
                    </xsl:variable>
                    <xsl:choose>
                      <xsl:when test="string-length(normalize-space($vectorFrameProcessingProfileRef))>0">
                        <xsl:variable name="frame0VlanId">
                          <xsl:value-of select="/cfg-ns:config/bbf-frameproc:frame-processing-profiles/bbf-frameproc:frame-processing-profile[bbf-frameproc:name=$vectorFrameProcessingProfileRef]/bbf-frameproc:match-criteria/bbf-frameproc:tag[bbf-frameproc:index='0']/bbf-frameproc:vlan-id"/>
                        </xsl:variable>
                        <xsl:choose>
                          <xsl:when test="$frame0VlanId=$PARAMETER_VLAN_ID">
                            <xsl:value-of select="/cfg-ns:config/bbf-vsi-vctr:vsi-vector-profiles/bbf-vsi-vctr:vsi-vector-profile[bbf-vsi-vctr:name=$vectorProfileName]/bbf-vsi-vctr-fpp:tag-0/bbf-vsi-vctr-fpp:vlan-id"/>
                          </xsl:when>
                          <xsl:when test="string-length(normalize-space($frame0VlanId))>0">
                            <xsl:value-of select="$frame0VlanId"/>
                          </xsl:when>
                          <xsl:otherwise>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:when>
                      <xsl:otherwise>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:if>
                </xsl:variable>
                <xsl:if test="string-length(normalize-space($vectorFrame0VlanId))>0">
                  <xsl:value-of select="$vectorFrame0VlanId"/>
                </xsl:if>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="tag1">
        <xsl:variable name="inlineIndex1">
          <xsl:value-of select="current()/bbf-subif:inline-frame-processing/bbf-subif:ingress-rule/bbf-subif:rule/bbf-subif:flexible-match/bbf-subif-tag:match-criteria/bbf-subif-tag:tag/bbf-subif-tag:index[text()='1']"/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="string-length(normalize-space($inlineIndex1))>0">
            <xsl:value-of select="$inlineIndex1"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="frameProcessingProfileRef">
              <xsl:value-of select="current()/bbf-frameproc:frame-processing-profile-ref"/>
            </xsl:variable>
            <xsl:choose>
              <xsl:when test="string-length(normalize-space($frameProcessingProfileRef))>0">
                <xsl:variable name="frame1VlanId">
                  <xsl:value-of select="/cfg-ns:config/bbf-frameproc:frame-processing-profiles/bbf-frameproc:frame-processing-profile[bbf-frameproc:name=$frameProcessingProfileRef]/bbf-frameproc:match-criteria/bbf-frameproc:tag[bbf-frameproc:index='1']/bbf-frameproc:vlan-id"/>
                </xsl:variable>
                <xsl:choose>
                  <xsl:when test="$frame1VlanId=$PARAMETER_VLAN_ID">
                    <xsl:value-of select="current()/bbf-frameproc:tag-1/bbf-frameproc:vlan-id"/>
                  </xsl:when>
                  <xsl:when test="string-length(normalize-space($frame1VlanId))>0">
                    <xsl:value-of select="$frame1VlanId"/>
                  </xsl:when>
                  <xsl:otherwise>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="vectorFrame1VlanId">
                  <xsl:variable name="vectorProfileName">
                    <xsl:value-of select="current()/bbf-vsi-vctr:vector-profile"/>
                  </xsl:variable>
                  <xsl:if test="string-length(normalize-space($vectorProfileName))>0">
                    <xsl:variable name="vectorFrameProcessingProfileRef">
                      <xsl:value-of select="/cfg-ns:config/bbf-vsi-vctr:vsi-vector-profiles/bbf-vsi-vctr:vsi-vector-profile[bbf-vsi-vctr:name=$vectorProfileName]/bbf-vsi-vctr-fpp:frame-processing-profile-ref"/>
                    </xsl:variable>
                    <xsl:choose>
                      <xsl:when test="string-length(normalize-space($vectorFrameProcessingProfileRef))>0">
                        <xsl:variable name="frame1VlanId">
                          <xsl:value-of select="/cfg-ns:config/bbf-frameproc:frame-processing-profiles/bbf-frameproc:frame-processing-profile[bbf-frameproc:name=$vectorFrameProcessingProfileRef]/bbf-frameproc:match-criteria/bbf-frameproc:tag[bbf-frameproc:index='1']/bbf-frameproc:vlan-id"/>
                        </xsl:variable>
                        <xsl:choose>
                          <xsl:when test="$frame1VlanId=$PARAMETER_VLAN_ID">
                            <xsl:value-of select="/cfg-ns:config/bbf-vsi-vctr:vsi-vector-profiles/bbf-vsi-vctr:vsi-vector-profile[bbf-vsi-vctr:name=$vectorProfileName]/bbf-vsi-vctr-fpp:tag-1/bbf-vsi-vctr-fpp:vlan-id"/>
                          </xsl:when>
                          <xsl:when test="string-length(normalize-space($frame1VlanId))>0">
                            <xsl:value-of select="$frame1VlanId"/>
                          </xsl:when>
                          <xsl:otherwise>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:when>
                      <xsl:otherwise>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:if>
                </xsl:variable>
                <xsl:if test="string-length(normalize-space($vectorFrame1VlanId))>0">
                  <xsl:value-of select="$vectorFrame1VlanId"/>
                </xsl:if>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:element name="vlanSubInterface">
        <xsl:element name="name">
          <xsl:value-of select="$interfaceName"/>
        </xsl:element>

        <xsl:if test="string-length(normalize-space($interfaceUsageType))>0">
          <xsl:element name="interfaceUsageType">
            <xsl:value-of select="$interfaceUsageType"/>
          </xsl:element>
        </xsl:if>

        <xsl:choose>
          <xsl:when test="string-length(normalize-space($tag0))>0 and string-length(normalize-space($tag1))>0">
            <xsl:element name="fwdType">
              <xsl:value-of select="$SC_FORWARDER"/>
            </xsl:element>
          </xsl:when>
          <xsl:when test="string-length(normalize-space($tag0))>0 or string-length(normalize-space($tag1))>0">
            <xsl:element name="fwdType">
              <xsl:value-of select="$C_FORWARDER"/>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:element>
    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="vsi_Info_map" select="map:merge(for $elem in $vsi_Info/vlanSubInterface return map{$elem/name : $elem})"/>

  <!-- collecting forwarder info -->
  <xsl:variable name="forwarder_Info">
    <xsl:for-each select ="/cfg-ns:config/bbf-l2-fwd:forwarding/bbf-l2-fwd:forwarders/bbf-l2-fwd:forwarder">
      <xsl:element name="forwarder">
        <xsl:element name="name">
          <xsl:value-of select="current()/bbf-l2-fwd:name"/>
        </xsl:element>
        <xsl:element name="ports">
          <xsl:for-each select ="current()/bbf-l2-fwd:ports/bbf-l2-fwd:port">
            <xsl:element name="port">
              <xsl:value-of select="current()/bbf-l2-fwd:sub-interface"/>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
        <xsl:variable name="fwdType">
          <xsl:iterate select="current()/bbf-l2-fwd:ports/bbf-l2-fwd:port/bbf-l2-fwd:sub-interface">
            <xsl:variable name="nameOfSubInterface">
              <xsl:value-of select="."/>
            </xsl:variable>
            <xsl:variable name="forwardType">
              <xsl:value-of select="$vsi_Info_map($nameOfSubInterface)[interfaceUsageType=$USAGE_NETWORK]/fwdType"/>
            </xsl:variable>
            <xsl:if test="string-length(normalize-space($forwardType))>0">
              <xsl:value-of  select="$forwardType"/>
              <xsl:break/>
            </xsl:if>
          </xsl:iterate>
        </xsl:variable>
        <xsl:element name="fwdType">
          <xsl:value-of select="$fwdType"/>
        </xsl:element>
      </xsl:element>
    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="forwarder_Info_map" select="map:merge(for $elem in $forwarder_Info/forwarder/ports/port return map{$elem : $elem/../..})"/>

  <!-- check index range for rule 14 -->
  <xsl:template match="/cfg-ns:config/bbf-qos-cls:classifiers/bbf-qos-cls:classifier-entry">
    <xsl:copy>
      <xsl:copy-of select="@*"/>

      <xsl:variable name="indexRangeCheck">
        <xsl:variable name="inlineIndexOfPbitMarkingList">
          <xsl:value-of select="current()/bbf-qos-cls:match-criteria/bbf-qos-plc:pbit-marking-list[bbf-qos-plc:index>1]"/>
        </xsl:variable>
        <xsl:variable name="inlineIndexOfDeiMarkingList">
          <xsl:value-of select="current()/bbf-qos-cls:match-criteria/bbf-qos-plc:dei-marking-list[bbf-qos-plc:index>1]"/>
        </xsl:variable>
        <xsl:variable name="inlineIndexOfInPbitListInDei">
          <xsl:value-of select="current()/bbf-qos-cls:match-criteria/bbf-qos-cls:tag[bbf-qos-cls:index>1]"/>
        </xsl:variable>
        <xsl:variable name="enhanceClassifierIndexPbitMarkingList">
          <xsl:value-of select="current()/bbf-qos-enhfilt:pbit-marking-list[bbf-qos-enhfilt:index>1]"/>
        </xsl:variable>
        <xsl:variable name="enhanceClassifierIndexOfDeiMarkingList">
          <xsl:value-of select="current()/bbf-qos-enhfilt:dei-marking-list[bbf-qos-enhfilt:index>1]"/>
        </xsl:variable>
        <xsl:variable name="enhanceClassifierIndexOfInPbitListInDei">
          <xsl:value-of select="current()/bbf-qos-enhfilt:vlans/bbf-qos-enhfilt:tag[bbf-qos-enhfilt:index>1]"/>
        </xsl:variable>

        <xsl:variable name="indexOfActionPbitMarkingList">
          <xsl:value-of select="current()/bbf-qos-cls:classifier-action-entry-cfg/bbf-qos-cls:pbit-marking-cfg/bbf-qos-cls:pbit-marking-list[bbf-qos-cls:index>1]"/>
        </xsl:variable>
        <xsl:variable name="indexOfActionDeiMarkingList">
          <xsl:value-of select="current()/bbf-qos-cls:classifier-action-entry-cfg/bbf-qos-cls:dei-marking-cfg/bbf-qos-cls:dei-marking-list[bbf-qos-cls:index>1]"/>
        </xsl:variable>

        <xsl:choose>
          <xsl:when test="string-length(normalize-space($inlineIndexOfPbitMarkingList))>0 or string-length(normalize-space($inlineIndexOfDeiMarkingList))>0 or string-length(normalize-space($inlineIndexOfInPbitListInDei))>0">
            <xsl:value-of select="$INDEX_OUT_OF_RANGE"/>
          </xsl:when>
          <xsl:when test="string-length(normalize-space($enhanceClassifierIndexPbitMarkingList))>0 or string-length(normalize-space($enhanceClassifierIndexOfDeiMarkingList))>0 or string-length(normalize-space($enhanceClassifierIndexOfInPbitListInDei))>0">
            <xsl:value-of select="$INDEX_OUT_OF_RANGE"/>
          </xsl:when>
          <xsl:when test="string-length(normalize-space($indexOfActionPbitMarkingList))>0 or string-length(normalize-space($indexOfActionDeiMarkingList))>0">
            <xsl:value-of select="$INDEX_OUT_OF_RANGE"/>
          </xsl:when>
          <xsl:otherwise>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:if test="string-length(normalize-space($indexRangeCheck))>0">
        <xsl:variable name="errorMessage">
          <xsl:value-of  select="'Index of pbit or dei should only configure as 0 or 1. classifier name is '"/>
        </xsl:variable>
        <wrong-configuration-detected>
          <xsl:value-of  select="concat($errorMessage,current()/bbf-qos-cls:name, '.')"/>
        </wrong-configuration-detected>
      </xsl:if>

      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!-- check index range for rule 14 -->
  <xsl:template match="/cfg-ns:config/bbf-qos-filt:filters/bbf-qos-enhfilt:enhanced-filter">
    <xsl:copy>
      <xsl:copy-of select="@*"/>

      <xsl:variable name="indexRangeCheck">
        <xsl:variable name="indexOfEnhanceFilterPbitMarkingList">
          <xsl:value-of select="current()/bbf-qos-enhfilt:filter/bbf-qos-enhfilt:pbit-marking-list[bbf-qos-enhfilt:index>1]"/>
        </xsl:variable>
        <xsl:variable name="indexOfEnhanceFilterDeiMarkingList">
          <xsl:value-of select="current()/bbf-qos-enhfilt:filter/bbf-qos-enhfilt:dei-marking-list[bbf-qos-enhfilt:index>1]"/>
        </xsl:variable>
        <xsl:variable name="indexOfEnhanceFilterInPbitListInDei">
          <xsl:value-of select="current()/bbf-qos-enhfilt:filter/bbf-qos-enhfilt:vlans/bbf-qos-enhfilt:tag[bbf-qos-enhfilt:index>1]"/>
        </xsl:variable>
        <xsl:if test="string-length(normalize-space($indexOfEnhanceFilterPbitMarkingList))>0 or string-length(normalize-space($indexOfEnhanceFilterDeiMarkingList))>0 or string-length(normalize-space($indexOfEnhanceFilterInPbitListInDei))>0">
          <xsl:value-of select="$INDEX_OUT_OF_RANGE"/>
        </xsl:if>
      </xsl:variable>

      <xsl:if test="string-length(normalize-space($indexRangeCheck))>0">
        <xsl:variable name="errorMessage">
          <xsl:value-of  select="'Index of pbit or dei should only configure as 0 or 1. enhanced-filter name is '"/>
        </xsl:variable>
        <wrong-configuration-detected>
          <xsl:value-of  select="concat($errorMessage,current()/bbf-qos-enhfilt:name, '.')"/>
        </wrong-configuration-detected>
      </xsl:if>

      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!-- check index range for rule 14 -->
  <xsl:template match="/cfg-ns:config/nokia-qos-plc-ext:policing-pre-handling-profiles/nokia-qos-plc-ext:pre-handling-profile">
    <xsl:copy>
      <xsl:copy-of select="@*"/>

      <xsl:variable name="indexRangeCheck">
        <xsl:variable name="IndexOfpolicingPreHandlingProfilePbitMarkingList">
          <xsl:value-of select="current()/nokia-qos-plc-ext:pre-handling-entry/nokia-qos-plc-ext:match-params/nokia-qos-plc-ext:pbit-marking-list[nokia-qos-plc-ext:index>1]"/>
        </xsl:variable>
        <xsl:variable name="IndexOfpolicingPreHandlingProfileDeiMarkingList">
          <xsl:value-of select="current()/nokia-qos-plc-ext:pre-handling-entry/nokia-qos-plc-ext:match-params/nokia-qos-plc-ext:dei-marking-list[nokia-qos-plc-ext:index>1]"/>
        </xsl:variable>
        <xsl:variable name="IndexOfpolicingPreHandlingProfileInPbitListInDei">
          <xsl:value-of select="current()/nokia-qos-plc-ext:pre-handling-entry/nokia-qos-plc-ext:match-params/nokia-qos-plc-ext:vlans/nokia-qos-plc-ext:tag[nokia-qos-plc-ext:index>1]"/>
        </xsl:variable>
        <xsl:if test="string-length(normalize-space($IndexOfpolicingPreHandlingProfilePbitMarkingList))>0 or string-length(normalize-space($IndexOfpolicingPreHandlingProfileDeiMarkingList))>0 or string-length(normalize-space($IndexOfpolicingPreHandlingProfileInPbitListInDei))>0">
          <xsl:value-of select="$INDEX_OUT_OF_RANGE"/>
        </xsl:if>
      </xsl:variable>

      <xsl:if test="string-length(normalize-space($indexRangeCheck))>0">
        <xsl:variable name="errorMessage">
          <xsl:value-of  select="'Index of pbit or dei should only configure as 0 or 1. prehandling profile name is '"/>
        </xsl:variable>
        <wrong-configuration-detected>
          <xsl:value-of  select="concat($errorMessage,current()/nokia-qos-plc-ext:name, '.')"/>
        </wrong-configuration-detected>
      </xsl:if>

      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!-- check index range for rule 14 -->
  <xsl:template match="/cfg-ns:config/nokia-qos-plc-ext:policing-action-profiles/nokia-qos-plc-ext:action-profile">
    <xsl:copy>
      <xsl:copy-of select="@*"/>

      <xsl:variable name="indexRangeCheck">
        <xsl:variable name="IndexOfpolicingActionProfilePbitMarkingList">
          <xsl:value-of select="current()/nokia-qos-plc-ext:action/nokia-qos-plc-ext:pbit-marking-list[nokia-qos-plc-ext:index>1]"/>
        </xsl:variable>
        <xsl:variable name="IndexOfpolicingActionProfileDeiMarkingList">
          <xsl:value-of select="current()/nokia-qos-plc-ext:action/nokia-qos-plc-ext:dei-marking-list[nokia-qos-plc-ext:index>1]"/>
        </xsl:variable>
        <xsl:if test="string-length(normalize-space($IndexOfpolicingActionProfilePbitMarkingList))>0 or string-length(normalize-space($IndexOfpolicingActionProfileDeiMarkingList))>0">
          <xsl:value-of select="$INDEX_OUT_OF_RANGE"/>
        </xsl:if>
      </xsl:variable>

      <xsl:if test="string-length(normalize-space($indexRangeCheck))>0">
        <xsl:variable name="errorMessage">
          <xsl:value-of  select="'Index of pbit or dei should only configure as 0 or 1. pre action profile name is '"/>
        </xsl:variable>
        <wrong-configuration-detected>
          <xsl:value-of  select="concat($errorMessage,current()/nokia-qos-plc-ext:name, '.')"/>
        </wrong-configuration-detected>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!-- check policy index ref and filter type using for rule 5/6 -->
  <xsl:template match="/cfg-ns:config/bbf-qos-pol:policies/bbf-qos-pol:policy">
    <xsl:copy>
      <xsl:copy-of select="@*"/>

      <xsl:variable name="policyName">
        <xsl:value-of  select="current()/bbf-qos-pol:name"/>
      </xsl:variable>
      <xsl:variable name="policyType">
        <xsl:value-of  select="$policy_Info_map($policyName)/policyType"/>
      </xsl:variable>

      <xsl:if test="$policyType!=$POLICY_TYPE_CCL and $policyType!=$POLICY_TYPE_PORT_POLICER">
        <xsl:variable name="numberOfFilterIndexInPolicy">
          <xsl:value-of select="count($policy_Info_map($policyName)/classifiers/filterIndexType)"/>
        </xsl:variable>
        <xsl:variable name="numberOfFilterIndex01InPolicy">
          <xsl:value-of select="count($policy_Info_map($policyName)/classifiers/filterIndexType[text()=$FILTER_INDEX_01])"/>
        </xsl:variable>
        <xsl:variable name="numberOfFilterIndex0InPolicy">
          <xsl:value-of select="count($policy_Info_map($policyName)/classifiers/filterIndexType[text()=$FILTER_INDEX_0])"/>
        </xsl:variable>
        <xsl:variable name="numberOfFilterIndex1InPolicy">
          <xsl:value-of select="count($policy_Info_map($policyName)/classifiers/filterIndexType[text()=$FILTER_INDEX_1])"/>
        </xsl:variable>
        <!-- check policy for rule 5 -->
        <xsl:if test="not($numberOfFilterIndexInPolicy=$numberOfFilterIndex01InPolicy or $numberOfFilterIndexInPolicy=$numberOfFilterIndex0InPolicy or $numberOfFilterIndexInPolicy=$numberOfFilterIndex1InPolicy)">
          <xsl:variable name="errorMessage">
            <xsl:value-of  select="'For all classifiers in a policy except CCL(not include policing), they can only use the same pbit or dei tag index. Policy name is '"/>
          </xsl:variable>
          <wrong-configuration-detected>
            <xsl:value-of  select="concat($errorMessage, $policyName, '.')"/>
          </wrong-configuration-detected>
        </xsl:if>

        <xsl:variable name="numberOfFilterTypeInPolicy">
          <xsl:value-of select="count($policy_Info_map($policyName)/classifiers/filterType)"/>
        </xsl:variable>
        <xsl:variable name="numberOfFilterPbitMarkingListInPolicy">
          <xsl:value-of select="count($policy_Info_map($policyName)/classifiers/filterType[text()=$FILTER_TYPE_PBIT_MARKING_LIST])"/>
        </xsl:variable>
        <xsl:variable name="numberOfFilterDeiMarkingListInPolicy">
          <xsl:value-of select="count($policy_Info_map($policyName)/classifiers/filterType[text()=$FILTER_TYPE_DEI_MARKING_LIST])"/>
        </xsl:variable>
        <xsl:variable name="numberOfFilterInPbitListInPolicy">
          <xsl:value-of select="count($policy_Info_map($policyName)/classifiers/filterType[text()=$FILTER_TYPE_IN_PBIT_LIST])"/>
        </xsl:variable>
        <xsl:variable name="numberOfFilterInDeiInPolicy">
          <xsl:value-of select="count($policy_Info_map($policyName)/classifiers/filterType[text()=$FILTER_TYPE_IN_DEI])"/>
        </xsl:variable>
        <!-- check policy for rule 6 -->
        <xsl:if test="not($numberOfFilterTypeInPolicy=$numberOfFilterPbitMarkingListInPolicy or $numberOfFilterTypeInPolicy=$numberOfFilterDeiMarkingListInPolicy or $numberOfFilterTypeInPolicy=$numberOfFilterInPbitListInPolicy or $numberOfFilterTypeInPolicy=$numberOfFilterInDeiInPolicy)">
          <xsl:variable name="errorMessage">
            <xsl:value-of  select="'For policies except CCL, all their classifiers must use the same pbit or dei filter type., in-dei, or dei-marking-list. Policy name is '"/>
          </xsl:variable>
          <wrong-configuration-detected>
            <xsl:value-of  select="concat($errorMessage, $policyName, '.')"/>
          </wrong-configuration-detected>
        </xsl:if>
      </xsl:if>

      <xsl:if test="$policyType=$POLICY_TYPE_CCL or $policyType=$POLICY_TYPE_PORT_POLICER">
        <xsl:variable name="isPolicingCfg">
          <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/isPolicingProfileCfg"/>
        </xsl:variable>
        <xsl:if test="string-length(normalize-space($isPolicingCfg))>0">
          <xsl:variable name="numberOfPreHandlingFilterIndexInPolicy">
            <xsl:value-of select="count($policy_Info_map($policyName)/classifiers/policingFilterIndexType)"/>
          </xsl:variable>
          <xsl:variable name="numberOfPreHandlingFilterIndex01InPolicy">
            <xsl:value-of select="count($policy_Info_map($policyName)/classifiers/policingFilterIndexType[text()=$FILTER_INDEX_01])"/>
          </xsl:variable>
          <xsl:variable name="numberOfPreHandlingFilterIndex0InPolicy">
            <xsl:value-of select="count($policy_Info_map($policyName)/classifiers/policingFilterIndexType[text()=$FILTER_INDEX_0])"/>
          </xsl:variable>
          <xsl:variable name="numberOfPreHandlingFilterIndex1InPolicy">
            <xsl:value-of select="count($policy_Info_map($policyName)/classifiers/policingFilterIndexType[text()=$FILTER_INDEX_1])"/>
          </xsl:variable>
          <!-- check policy for rule 5 -->
          <xsl:if test="not($numberOfPreHandlingFilterIndexInPolicy=$numberOfPreHandlingFilterIndex0InPolicy or $numberOfPreHandlingFilterIndexInPolicy=$numberOfPreHandlingFilterIndex1InPolicy)">
            <xsl:variable name="errorMessage">
              <xsl:value-of  select="'For all classifiers in a policy except CCL, they can only use the same pbit or dei tag index. Policy name is '"/>
            </xsl:variable>
            <wrong-configuration-detected>
              <xsl:value-of  select="concat($errorMessage, $policyName, '.')"/>
            </wrong-configuration-detected>
          </xsl:if>
        </xsl:if>
      </xsl:if>

      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!-- check vsi for rule 2/4/8/9/10/11/12/13/15 -->
  <xsl:template match="/cfg-ns:config/itf-ns:interfaces/itf-ns:interface[itf-ns:type='bbfift:vlan-sub-interface']">

    <xsl:copy>
      <xsl:copy-of select="@*"/>

      <xsl:variable name="vsiName">
        <xsl:value-of  select="current()/itf-ns:name"/>
      </xsl:variable>

      <xsl:variable name="ingressQosPolicyProfile">
        <xsl:value-of  select="current()/bbf-qos-pol:ingress-qos-policy-profile"/>
      </xsl:variable>

      <xsl:variable name="egressQosPolicyProfile">
        <xsl:value-of  select="current()/bbf-qos-pol:egress-qos-policy-profile"/>
      </xsl:variable>

      <xsl:if test="string-length(normalize-space($ingressQosPolicyProfile))>0">
        <xsl:variable name="ingressPolicyProfileInfo">
          <xsl:copy-of  select="$policy_profile_Info_map($ingressQosPolicyProfile)"/>
        </xsl:variable>

        <!-- check for rule 2 descoped
        <xsl:for-each select="$ingressPolicyProfileInfo/policyProfile/bbf-qos-pol:policy-list">
          <xsl:variable name="policyName">
            <xsl:value-of  select="current()/bbf-qos-pol:name"/>
          </xsl:variable>
          <xsl:variable name="policyType">
            <xsl:value-of  select="$policy_Info_map($policyName)/policyType"/>
          </xsl:variable>

          <xsl:variable name="isActionPbitMarkingList0">
            <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/isActionPbitMarkingList0"/>
          </xsl:variable>
          <xsl:variable name="isActionPbitMarkingList1">
            <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/isActionPbitMarkingList1"/>
          </xsl:variable>
          <xsl:variable name="isActionDeiMarkingList0">
            <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/isActionDeiMarkingList0"/>
          </xsl:variable>
          <xsl:variable name="isActionDeiMarkingList1">
            <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/isActionDeiMarkingList1"/>
          </xsl:variable>

          <xsl:variable name="isActionPbitDeiMarkinglistInPolicy">
            <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/isActionPbitOrDeiMarking"/>
          </xsl:variable>
          <xsl:variable name="isPolicingActionPbitDeiMarkinglistInPolicy">
            <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/isPolicingActionPbitOrDeiMarking"/>
          </xsl:variable>
          <xsl:variable name="positionOfPitDeiMarkingListPolicy">
            <xsl:if test="string-length(normalize-space($isActionPbitDeiMarkinglistInPolicy))>0 or string-length(normalize-space($isPolicingActionPbitDeiMarkinglistInPolicy))>0">
              <xsl:value-of select="position()"/>
            </xsl:if>
          </xsl:variable>

          <xsl:if test="string-length(normalize-space($positionOfPitDeiMarkingListPolicy))>0">
            <xsl:choose>
              <xsl:when test="$policyType=$POLICY_TYPE_CCL">
                <xsl:variable name="isMarkerHasActionPbitMarkingList0">
                  <xsl:iterate select="$ingressPolicyProfileInfo/policyProfile/bbf-qos-pol:policy-list">
                    <xsl:variable name="nameOfPolicy">
                      <xsl:value-of select="current()/bbf-qos-pol:name"/>
                    </xsl:variable>

                    <xsl:variable name="actionPbitMarkingList">
                      <xsl:value-of select="$policy_Info_map($nameOfPolicy)[policyType=$POLICY_TYPE_MARKER]/classifiers/isActionPbitMarkingList0"/>
                    </xsl:variable>
                    <xsl:if test="string-length(normalize-space($actionPbitMarkingList))>0">
                      <xsl:value-of  select="$actionPbitMarkingList"/>
                      <xsl:break/>
                    </xsl:if>
                  </xsl:iterate>
                </xsl:variable>

                <xsl:variable name="isMarkerHasActionPbitMarkingList1">
                  <xsl:iterate select="$ingressPolicyProfileInfo/policyProfile/bbf-qos-pol:policy-list">
                    <xsl:variable name="nameOfPolicy">
                      <xsl:value-of select="current()/bbf-qos-pol:name"/>
                    </xsl:variable>
                    <xsl:variable name="actionPbitMarkingList">
                      <xsl:value-of select="$policy_Info_map($nameOfPolicy)[policyType=$POLICY_TYPE_MARKER]/classifiers/isActionPbitMarkingList1"/>
                    </xsl:variable>
                    <xsl:if test="string-length(normalize-space($actionPbitMarkingList))>0">
                      <xsl:value-of  select="$actionPbitMarkingList"/>
                      <xsl:break/>
                    </xsl:if>
                  </xsl:iterate>
                </xsl:variable>

                <xsl:variable name="isMarkerHasActionDeiMarkingList0">
                  <xsl:iterate select="$ingressPolicyProfileInfo/policyProfile/bbf-qos-pol:policy-list">
                    <xsl:variable name="nameOfPolicy">
                      <xsl:value-of select="current()/bbf-qos-pol:name"/>
                    </xsl:variable>
                    <xsl:variable name="actionDeiMarkingList">
                      <xsl:value-of select="$policy_Info_map($nameOfPolicy)[policyType=$POLICY_TYPE_MARKER]/classifiers/isActionDeiMarkingList0"/>
                    </xsl:variable>
                    <xsl:if test="string-length(normalize-space($actionDeiMarkingList))>0">
                      <xsl:value-of  select="$actionDeiMarkingList"/>
                      <xsl:break/>
                    </xsl:if>
                  </xsl:iterate>
                </xsl:variable>

                <xsl:variable name="isMarkerHasActionDeiMarkingList1">
                  <xsl:iterate select="$ingressPolicyProfileInfo/policyProfile/bbf-qos-pol:policy-list">
                    <xsl:variable name="nameOfPolicy">
                      <xsl:value-of select="current()/bbf-qos-pol:name"/>
                    </xsl:variable>
                    <xsl:variable name="actionDeiMarkingList">
                      <xsl:value-of select="$policy_Info_map($nameOfPolicy)[policyType=$POLICY_TYPE_MARKER]/classifiers/isActionDeiMarkingList1"/>
                    </xsl:variable>
                    <xsl:if test="string-length(normalize-space($actionDeiMarkingList))>0">
                      <xsl:value-of  select="$actionDeiMarkingList"/>
                      <xsl:break/>
                    </xsl:if>
                  </xsl:iterate>
                </xsl:variable>

                <xsl:if test="string-length(normalize-space($isActionPbitDeiMarkinglistInPolicy))>0">
                  <xsl:variable name="isPolicingInPbitList0Cfg">
                    <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/isPolicingInPbitList0Cfg"/>
                  </xsl:variable>
                  <xsl:variable name="isPolicingInPbitList1Cfg">
                    <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/isPolicingInPbitList1Cfg"/>
                  </xsl:variable>
                  <xsl:variable name="isPolicingInDei0Cfg">
                    <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/isPolicingInDei0Cfg"/>
                  </xsl:variable>
                  <xsl:variable name="isPolicingInDei1Cfg">
                    <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/isPolicingInDei1Cfg"/>
                  </xsl:variable>

                  <xsl:if test="(not(string-length(normalize-space($isMarkerHasActionPbitMarkingList0))>0) and (string-length(normalize-space($isActionPbitMarkingList0))>0 and string-length(normalize-space($isPolicingInPbitList0Cfg))>0))
                             or (not(string-length(normalize-space($isMarkerHasActionPbitMarkingList1))>0) and (string-length(normalize-space($isActionPbitMarkingList1))>0 and string-length(normalize-space($isPolicingInPbitList1Cfg))>0))
                             or (not(string-length(normalize-space($isMarkerHasActionDeiMarkingList0))>0) and (string-length(normalize-space($isActionDeiMarkingList0))>0 and string-length(normalize-space($isPolicingInDei0Cfg))>0))
                             or (not(string-length(normalize-space($isMarkerHasActionDeiMarkingList1))>0) and (string-length(normalize-space($isActionDeiMarkingList1))>0 and string-length(normalize-space($isPolicingInDei1Cfg))>0))">
                    <xsl:variable name="errorMessage">
                      <xsl:value-of  select="'For ingress QoS profile of VSI, once a Pbit is marked by an action with pbit-marking-list, subsequent policies should only use the corresponding pbit-marking-list as a filter, except for CCL policies. Dei has the same restrictions. VSI name is '"/>
                    </xsl:variable>
                    <wrong-configuration-detected>
                      <xsl:value-of  select="concat($errorMessage,$vsiName, ', qos policy profile name is ', $ingressQosPolicyProfile, ', policy name is ', $policyName, '.')"/>
                    </wrong-configuration-detected>
                  </xsl:if>
                </xsl:if>

                <xsl:variable name="isPoilicingActionPbitMarkingList0">
                  <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/isPoilicingActionPbitMarkingList0"/>
                </xsl:variable>
                <xsl:variable name="isPoilicingActionPbitMarkingList1">
                  <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/isPoilicingActionPbitMarkingList1"/>
                </xsl:variable>
                <xsl:variable name="isPolicingActionDeiMarkingList0">
                  <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/isPolicingActionDeiMarkingList0"/>
                </xsl:variable>
                <xsl:variable name="isPolicingActionDeiMarkingList1">
                  <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/isPolicingActionDeiMarkingList1"/>
                </xsl:variable>

                <xsl:for-each select="$ingressPolicyProfileInfo/policyProfile/bbf-qos-pol:policy-list">
                  <xsl:variable name="positionOfCurrentPolicyInProfile">
                    <xsl:value-of  select="position()"/>
                  </xsl:variable>

                  <xsl:if test="$positionOfCurrentPolicyInProfile>$positionOfPitDeiMarkingListPolicy">
                    <xsl:variable name="currentPolicyName">
                      <xsl:value-of  select="current()/bbf-qos-pol:name"/>
                    </xsl:variable>
                    <xsl:variable name="currentPolicyType">
                      <xsl:value-of  select="$policy_Info_map($currentPolicyName)/policyType"/>
                    </xsl:variable>

                    <xsl:if test="$currentPolicyType!=$POLICY_TYPE_CCL">
                      <xsl:variable name="isInPbitList0Cfg">
                        <xsl:value-of  select="$policy_Info_map($currentPolicyName)/classifiers/isInPbitList0Cfg"/>
                      </xsl:variable>
                      <xsl:variable name="isInPbitList1Cfg">
                        <xsl:value-of  select="$policy_Info_map($currentPolicyName)/classifiers/isInPbitList1Cfg"/>
                      </xsl:variable>
                      <xsl:variable name="isInDei0Cfg">
                        <xsl:value-of  select="$policy_Info_map($currentPolicyName)/classifiers/isInDei0Cfg"/>
                      </xsl:variable>
                      <xsl:variable name="isInDei1Cfg">
                        <xsl:value-of  select="$policy_Info_map($currentPolicyName)/classifiers/isInDei1Cfg"/>
                      </xsl:variable>

                      <xsl:variable name="isPolicingInPbitList0Cfg">
                        <xsl:value-of  select="$policy_Info_map($currentPolicyName)/classifiers/isPolicingInPbitList0Cfg"/>
                      </xsl:variable>
                      <xsl:variable name="isPolicingInPbitList1Cfg">
                        <xsl:value-of  select="$policy_Info_map($currentPolicyName)/classifiers/isPolicingInPbitList1Cfg"/>
                      </xsl:variable>
                      <xsl:variable name="isPolicingInDei0Cfg">
                        <xsl:value-of  select="$policy_Info_map($currentPolicyName)/classifiers/isPolicingInDei0Cfg"/>
                      </xsl:variable>
                      <xsl:variable name="isPolicingInDei1Cfg">
                        <xsl:value-of  select="$policy_Info_map($currentPolicyName)/classifiers/isPolicingInDei1Cfg"/>
                      </xsl:variable>

                      <xsl:if test="(not(string-length(normalize-space($isMarkerHasActionPbitMarkingList0))>0) and ((string-length(normalize-space($isActionPbitMarkingList0))>0 or string-length(normalize-space($isPoilicingActionPbitMarkingList0))>0) and (string-length(normalize-space($isInPbitList0Cfg))>0 or string-length(normalize-space($isPolicingInPbitList0Cfg))>0)))
                                 or (not(string-length(normalize-space($isMarkerHasActionPbitMarkingList1))>0) and ((string-length(normalize-space($isActionPbitMarkingList1))>0 or string-length(normalize-space($isPoilicingActionPbitMarkingList1))>0) and (string-length(normalize-space($isInPbitList1Cfg))>0 or string-length(normalize-space($isPolicingInPbitList1Cfg))>0)))
                                 or (not(string-length(normalize-space($isMarkerHasActionDeiMarkingList0))>0) and ((string-length(normalize-space($isActionDeiMarkingList0))>0 or string-length(normalize-space($isPolicingActionDeiMarkingList0))>0) and (string-length(normalize-space($isInDei0Cfg))>0 or string-length(normalize-space($isPolicingInDei0Cfg))>0)))
                                 or (not(string-length(normalize-space($isMarkerHasActionDeiMarkingList1))>0) and ((string-length(normalize-space($isActionDeiMarkingList1))>0 or string-length(normalize-space($isPolicingActionDeiMarkingList1))>0) and (string-length(normalize-space($isInDei1Cfg))>0 or string-length(normalize-space($isPolicingInDei1Cfg))>0)))">
                        <xsl:variable name="errorMessage">
                          <xsl:value-of  select="'For ingress QoS profile of VSI, once a Pbit is marked by an action with pbit-marking-list, subsequent policies should only use the corresponding pbit-marking-list as a filter, except for CCL policies. Dei has the same restrictions. VSI name is '"/>
                        </xsl:variable>
                        <wrong-configuration-detected>
                          <xsl:value-of  select="concat($errorMessage,$vsiName, ', qos policy profile name is ', $ingressQosPolicyProfile, ', policy name is ', $currentPolicyName, '.')"/>
                        </wrong-configuration-detected>
                      </xsl:if>
                    </xsl:if>
                  </xsl:if>
                </xsl:for-each>
              </xsl:when>
              <xsl:when test="$policyType=$POLICY_TYPE_PORT_POLICER">
              </xsl:when>
              <xsl:otherwise>
                <xsl:for-each select="$ingressPolicyProfileInfo/policyProfile/bbf-qos-pol:policy-list">
                  <xsl:variable name="positionOfCurrentPolicyInProfile">
                    <xsl:value-of  select="position()"/>
                  </xsl:variable>

                  <xsl:if test="$positionOfCurrentPolicyInProfile>$positionOfPitDeiMarkingListPolicy">
                    <xsl:variable name="currentPolicyName">
                      <xsl:value-of  select="current()/bbf-qos-pol:name"/>
                    </xsl:variable>
                    <xsl:variable name="currentPolicyType">
                      <xsl:value-of  select="$policy_Info_map($currentPolicyName)/policyType"/>
                    </xsl:variable>

                    <xsl:variable name="isInPbitList0Cfg">
                      <xsl:value-of  select="$policy_Info_map($currentPolicyName)/classifiers/isInPbitList0Cfg"/>
                    </xsl:variable>
                    <xsl:variable name="isInPbitList1Cfg">
                      <xsl:value-of  select="$policy_Info_map($currentPolicyName)/classifiers/isInPbitList1Cfg"/>
                    </xsl:variable>
                    <xsl:variable name="isInDei0Cfg">
                      <xsl:value-of  select="$policy_Info_map($currentPolicyName)/classifiers/isInDei0Cfg"/>
                    </xsl:variable>
                    <xsl:variable name="isInDei1Cfg">
                      <xsl:value-of  select="$policy_Info_map($currentPolicyName)/classifiers/isInDei1Cfg"/>
                    </xsl:variable>

                    <xsl:variable name="isPolicingInPbitList0Cfg">
                      <xsl:value-of  select="$policy_Info_map($currentPolicyName)/classifiers/isPolicingInPbitList0Cfg"/>
                    </xsl:variable>
                    <xsl:variable name="isPolicingInPbitList1Cfg">
                      <xsl:value-of  select="$policy_Info_map($currentPolicyName)/classifiers/isPolicingInPbitList1Cfg"/>
                    </xsl:variable>
                    <xsl:variable name="isPolicingInDei0Cfg">
                      <xsl:value-of  select="$policy_Info_map($currentPolicyName)/classifiers/isPolicingInDei0Cfg"/>
                    </xsl:variable>
                    <xsl:variable name="isPolicingInDei1Cfg">
                      <xsl:value-of  select="$policy_Info_map($currentPolicyName)/classifiers/isPolicingInDei1Cfg"/>
                    </xsl:variable>

                    <xsl:choose>
                      <xsl:when test="$currentPolicyType=$POLICY_TYPE_CCL">
                        <xsl:if test="(string-length(normalize-space($isActionPbitMarkingList0))>0 and string-length(normalize-space($isPolicingInPbitList0Cfg))>0)
                                   or (string-length(normalize-space($isActionPbitMarkingList1))>0 and string-length(normalize-space($isPolicingInPbitList1Cfg))>0)
                                   or (string-length(normalize-space($isActionDeiMarkingList0))>0 and string-length(normalize-space($isPolicingInDei0Cfg))>0)
                                   or (string-length(normalize-space($isActionDeiMarkingList1))>0 and string-length(normalize-space($isPolicingInDei1Cfg))>0)">
                          <xsl:variable name="errorMessage">
                            <xsl:value-of  select="'For ingress QoS profile of VSI, once a Pbit is marked by an action with pbit-marking-list, subsequent policies should only use the corresponding pbit-marking-list as a filter, except for CCL policies. Dei has the same restrictions. VSI name is '"/>
                          </xsl:variable>
                          <wrong-configuration-detected>
                            <xsl:value-of  select="concat($errorMessage,$vsiName, ', qos policy profile name is ', $ingressQosPolicyProfile, ', policy name is ', $currentPolicyName, '.')"/>
                          </wrong-configuration-detected>
                        </xsl:if>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:if test="(string-length(normalize-space($isActionPbitMarkingList0))>0 and (string-length(normalize-space($isInPbitList0Cfg))>0 or string-length(normalize-space($isPolicingInPbitList0Cfg))>0))
                                   or (string-length(normalize-space($isActionPbitMarkingList1))>0 and (string-length(normalize-space($isInPbitList1Cfg))>0 or string-length(normalize-space($isPolicingInPbitList1Cfg))>0))
                                   or (string-length(normalize-space($isActionDeiMarkingList0))>0 and (string-length(normalize-space($isInDei0Cfg))>0 or string-length(normalize-space($isPolicingInDei0Cfg))>0))
                                   or (string-length(normalize-space($isActionDeiMarkingList1))>0 and (string-length(normalize-space($isInDei1Cfg))>0 or string-length(normalize-space($isPolicingInDei1Cfg))>0))">
                          <xsl:variable name="errorMessage">
                            <xsl:value-of  select="'For ingress QoS profile of VSI, once a Pbit is marked by an action with pbit-marking-list, subsequent policies should only use the corresponding pbit-marking-list as a filter, except for CCL policies. Dei has the same restrictions. VSI name is '"/>
                          </xsl:variable>
                          <wrong-configuration-detected>
                            <xsl:value-of  select="concat($errorMessage,$vsiName, ', qos policy profile name is ', $ingressQosPolicyProfile, ', policy name is ', $currentPolicyName, '.')"/>
                          </wrong-configuration-detected>
                        </xsl:if>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:if>
                </xsl:for-each>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </xsl:for-each> -->

        <!-- check for rule 4 -->
        <xsl:variable name="IndexTypeOfQueueColorPolicy">
          <xsl:iterate select="$ingressPolicyProfileInfo/policyProfile/bbf-qos-pol:policy-list">
            <xsl:variable name="nameOfPolicy">
              <xsl:value-of select="current()/bbf-qos-pol:name"/>
            </xsl:variable>
            <xsl:variable name="filterIndexType">
              <xsl:value-of select="$policy_Info_map($nameOfPolicy)[policyType=$POLICY_TYPE_QUEUE_COLOR]/classifiers/filterIndexType"/>
            </xsl:variable>
            <xsl:if test="string-length(normalize-space($filterIndexType))>0">
              <xsl:value-of  select="$filterIndexType"/>
              <xsl:break/>
            </xsl:if>
          </xsl:iterate>
        </xsl:variable>
        <xsl:variable name="IndexTypeOfSchedulerPolicy">
          <xsl:iterate select="$ingressPolicyProfileInfo/policyProfile/bbf-qos-pol:policy-list">
            <xsl:variable name="nameOfPolicy">
              <xsl:value-of select="current()/bbf-qos-pol:name"/>
            </xsl:variable>
            <xsl:variable name="filterIndexType">
              <xsl:value-of select="$policy_Info_map($nameOfPolicy)[policyType=$POLICY_TYPE_SCHEDULE]/classifiers/filterIndexType"/>
            </xsl:variable>
            <xsl:if test="string-length(normalize-space($filterIndexType))>0">
              <xsl:value-of  select="$filterIndexType"/>
              <xsl:break/>
            </xsl:if>
          </xsl:iterate>
        </xsl:variable>

        <xsl:if test="string-length(normalize-space($IndexTypeOfQueueColorPolicy))>0 and string-length(normalize-space($IndexTypeOfSchedulerPolicy))>0">
          <xsl:if test="$IndexTypeOfQueueColorPolicy!=$IndexTypeOfSchedulerPolicy">
            <xsl:variable name="errorMessage">
              <xsl:value-of  select="'For QoS ingress profile of VSI, scheduler and queue-color should use the same tag index when referring to pbit or dei. VSI name is '"/>
            </xsl:variable>
            <wrong-configuration-detected>
              <xsl:value-of  select="concat($errorMessage,$vsiName, ', qos policy profile name is ', $ingressQosPolicyProfile, '.')"/>
            </wrong-configuration-detected>
          </xsl:if>
        </xsl:if>

        <!-- check for rule 8/9 -->
        <xsl:variable name="vsiUsageType">
          <xsl:value-of  select="$vsi_Info_map($vsiName)/interfaceUsageType"/>
        </xsl:variable>
        <xsl:variable name="vsiFwdType">
          <xsl:value-of  select="$forwarder_Info_map($vsiName)/fwdType"/>
        </xsl:variable>

        <xsl:if test="$vsiUsageType=$USAGE_USER and ($vsiFwdType=$C_FORWARDER or $vsiFwdType=$SC_FORWARDER)">
          <xsl:variable name="hasMarkerPolicyInProfile">
            <xsl:iterate select="$ingressPolicyProfileInfo/policyProfile/bbf-qos-pol:policy-list">
              <xsl:variable name="nameOfPolicy">
                <xsl:value-of select="current()/bbf-qos-pol:name"/>
              </xsl:variable>
              <xsl:variable name="policyType">
                <xsl:value-of select="$policy_Info_map($nameOfPolicy)[policyType=$POLICY_TYPE_MARKER]/policyType"/>
              </xsl:variable>
              <xsl:if test="string-length(normalize-space($policyType))>0">
                <xsl:value-of  select="$policyType"/>
                <xsl:break/>
              </xsl:if>
            </xsl:iterate>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="not(string-length(normalize-space($hasMarkerPolicyInProfile))>0)">
              <xsl:for-each select="$ingressPolicyProfileInfo/policyProfile/bbf-qos-pol:policy-list">
                <xsl:variable name="filterType1InProfile"> 
                  <xsl:value-of  select="$policy_Info_map(current()/bbf-qos-pol:name)/classifiers/filterIndexType[text()=$FILTER_INDEX_1]"/>
                </xsl:variable>
                <xsl:variable name="filterType01InProfile">
                  <xsl:value-of  select="$policy_Info_map(current()/bbf-qos-pol:name)/classifiers/filterIndexType[text()=$FILTER_INDEX_01]"/>
                </xsl:variable>
                <xsl:if test="string-length(normalize-space($filterType1InProfile))>0 or string-length(normalize-space($filterType01InProfile))>0">
                  <xsl:variable name="errorMessage">
                    <xsl:value-of  select="'For ingress policies of user VSI which attached to a single or dual tag forwarder, the pbit and dei(no marker) filters have vlan tag reference restrictions. VSI name is '"/>
                  </xsl:variable>
                  <wrong-configuration-detected>
                    <xsl:value-of  select="concat($errorMessage,$vsiName, ', qos policy profile name is ', $ingressQosPolicyProfile, ', policy name is ', current()/bbf-qos-pol:name, '.')"/>
                  </wrong-configuration-detected>
                </xsl:if>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="$ingressPolicyProfileInfo/policyProfile/bbf-qos-pol:policy-list">
                <xsl:variable name="policyName">
                  <xsl:value-of  select="current()/bbf-qos-pol:name"/>
                </xsl:variable>
                <xsl:variable name="policyType">
                  <xsl:value-of  select="$policy_Info_map($policyName)/policyType"/>
                </xsl:variable>
                <xsl:variable name="filterType1InPolicy">
                  <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/filterIndexType[text()=$FILTER_INDEX_1]"/>
                </xsl:variable>
                <xsl:variable name="filterType01InPolicy">
                  <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/filterIndexType[text()=$FILTER_INDEX_01]"/>
                </xsl:variable>
                <xsl:choose>
                  <xsl:when test="$policyType=$POLICY_TYPE_MARKER">
                    <xsl:if test="string-length(normalize-space($filterType1InPolicy))>0 or string-length(normalize-space($filterType01InPolicy))>0">
                      <xsl:variable name="errorMessage">
                        <xsl:value-of  select="'For ingress policies of user VSI which attached to a single or dual tag forwarder, the pbit and dei(marker) filters have vlan tag reference restrictions. VSI name is '"/>
                      </xsl:variable>
                      <wrong-configuration-detected>
                        <xsl:value-of  select="concat($errorMessage,$vsiName, ', qos policy profile name is ', $ingressQosPolicyProfile, ', policy name is ', $policyName, '.')"/>
                      </wrong-configuration-detected>
                    </xsl:if>
                  </xsl:when>
                  <xsl:when test="$policyType=$POLICY_TYPE_CCL or $policyType=$POLICY_TYPE_PORT_POLICER">
                    <xsl:variable name="isActionPbitMarkingList0">
                      <xsl:iterate select="$ingressPolicyProfileInfo/policyProfile/bbf-qos-pol:policy-list">
                        <xsl:variable name="nameOfPolicy">
                          <xsl:value-of select="current()/bbf-qos-pol:name"/>
                        </xsl:variable>
                        <xsl:variable name="actionPbitMarkingList">
                          <xsl:value-of select="$policy_Info_map($nameOfPolicy)[policyType=$POLICY_TYPE_MARKER]/classifiers/isActionPbitMarkingList0"/>
                        </xsl:variable>
                        <xsl:if test="string-length(normalize-space($actionPbitMarkingList))>0">
                          <xsl:value-of  select="$actionPbitMarkingList"/>
                          <xsl:break/>
                        </xsl:if>
                      </xsl:iterate>
                    </xsl:variable>
                    <xsl:variable name="isActionPbitMarkingList1">
                      <xsl:iterate select="$ingressPolicyProfileInfo/policyProfile/bbf-qos-pol:policy-list">
                        <xsl:variable name="nameOfPolicy">
                          <xsl:value-of select="current()/bbf-qos-pol:name"/>
                        </xsl:variable>
                        <xsl:variable name="actionPbitMarkingList">
                          <xsl:value-of select="$policy_Info_map($nameOfPolicy)[policyType=$POLICY_TYPE_MARKER]/classifiers/isActionPbitMarkingList1"/>
                        </xsl:variable>
                        <xsl:if test="string-length(normalize-space($actionPbitMarkingList))>0">
                          <xsl:value-of  select="$actionPbitMarkingList"/>
                          <xsl:break/>
                        </xsl:if>
                      </xsl:iterate>
                    </xsl:variable>
                    <xsl:variable name="isActionDeiMarkingList0">
                      <xsl:iterate select="$ingressPolicyProfileInfo/policyProfile/bbf-qos-pol:policy-list">
                        <xsl:variable name="nameOfPolicy">
                          <xsl:value-of select="current()/bbf-qos-pol:name"/>
                        </xsl:variable>
                        <xsl:variable name="actionDeiMarkingList">
                          <xsl:value-of select="$policy_Info_map($nameOfPolicy)[policyType=$POLICY_TYPE_MARKER]/classifiers/isActionDeiMarkingList0"/>
                        </xsl:variable>
                        <xsl:if test="string-length(normalize-space($actionDeiMarkingList))>0">
                          <xsl:value-of  select="$actionDeiMarkingList"/>
                          <xsl:break/>
                        </xsl:if>
                      </xsl:iterate>
                    </xsl:variable>
                    <xsl:variable name="isActionDeiMarkingList1">
                      <xsl:iterate select="$ingressPolicyProfileInfo/policyProfile/bbf-qos-pol:policy-list">
                        <xsl:variable name="nameOfPolicy">
                          <xsl:value-of select="current()/bbf-qos-pol:name"/>
                        </xsl:variable>
                        <xsl:variable name="actionDeiMarkingList">
                          <xsl:value-of select="$policy_Info_map($nameOfPolicy)[policyType=$POLICY_TYPE_MARKER]/classifiers/isActionDeiMarkingList1"/>
                        </xsl:variable>
                        <xsl:if test="string-length(normalize-space($actionDeiMarkingList))>0">
                          <xsl:value-of  select="$actionDeiMarkingList"/>
                          <xsl:break/>
                        </xsl:if>
                      </xsl:iterate>
                    </xsl:variable>
                    <xsl:variable name="filterType0InMarkerPolicy">
                      <xsl:iterate select="$ingressPolicyProfileInfo/policyProfile/bbf-qos-pol:policy-list">
                        <xsl:variable name="nameOfPolicy">
                          <xsl:value-of select="current()/bbf-qos-pol:name"/>
                        </xsl:variable>
                        <xsl:variable name="filterIndexType">
                          <xsl:value-of select="$policy_Info_map($nameOfPolicy)[policyType=$POLICY_TYPE_MARKER]/classifiers/filterIndexType[text()=$FILTER_INDEX_0]"/>
                        </xsl:variable>
                        <xsl:if test="string-length(normalize-space($filterIndexType))>0">
                          <xsl:value-of  select="$filterIndexType"/>
                          <xsl:break/>
                        </xsl:if>
                      </xsl:iterate>
                    </xsl:variable>
                    <xsl:variable name="filterType1InMarkerPolicy">
                      <xsl:iterate select="$ingressPolicyProfileInfo/policyProfile/bbf-qos-pol:policy-list">
                        <xsl:variable name="nameOfPolicy">
                          <xsl:value-of select="current()/bbf-qos-pol:name"/>
                        </xsl:variable>
                        <xsl:variable name="filterIndexType">
                          <xsl:value-of select="$policy_Info_map($nameOfPolicy)[policyType=$POLICY_TYPE_MARKER]/classifiers/filterIndexType[text()=$FILTER_INDEX_1]"/>
                        </xsl:variable>
                        <xsl:if test="string-length(normalize-space($filterIndexType))>0">
                          <xsl:value-of  select="$filterIndexType"/>
                          <xsl:break/>
                        </xsl:if>
                      </xsl:iterate>
                    </xsl:variable>
                    <xsl:variable name="filterType01InMarkerPolicy">
                      <xsl:iterate select="$ingressPolicyProfileInfo/policyProfile/bbf-qos-pol:policy-list">
                        <xsl:variable name="nameOfPolicy">
                          <xsl:value-of select="current()/bbf-qos-pol:name"/>
                        </xsl:variable>
                        <xsl:variable name="filterIndexType">
                          <xsl:value-of select="$policy_Info_map($nameOfPolicy)[policyType=$POLICY_TYPE_MARKER]/classifiers/filterIndexType[text()=$FILTER_INDEX_01]"/>
                        </xsl:variable>
                        <xsl:if test="string-length(normalize-space($filterIndexType))>0">
                          <xsl:value-of  select="$filterIndexType"/>
                          <xsl:break/>
                        </xsl:if>
                      </xsl:iterate>
                    </xsl:variable>

                    <xsl:choose>
                      <xsl:when test="$vsiFwdType=$SC_FORWARDER
                                and (string-length(normalize-space($filterType0InMarkerPolicy))>0 and not(string-length(normalize-space($filterType1InMarkerPolicy))>0 or string-length(normalize-space($filterType01InMarkerPolicy))>0))
                                and ((string-length(normalize-space($isActionPbitMarkingList0))>0 and string-length(normalize-space($isActionPbitMarkingList1))>0) or (string-length(normalize-space($isActionDeiMarkingList0))>0 and string-length(normalize-space($isActionDeiMarkingList1))>0))">
                        <xsl:variable name="filterType1WithoutPolicing">
                          <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/filterIndexTypeWithoutPolicing[text()=$FILTER_INDEX_1]"/>
                        </xsl:variable>
                        <xsl:variable name="filterType01WithoutPolicing">
                          <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/filterIndexTypeWithoutPolicing[text()=$FILTER_INDEX_01]"/>
                        </xsl:variable>

                        <xsl:variable name="pbitMarkingListFilterType0InPolicingPreHandling">
                          <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/policingPbitMarkingListFilterIndexType[text()=$FILTER_INDEX_0]"/>
                        </xsl:variable>
                        <xsl:variable name="pbitMarkingListFilterType1InPolicingPreHandling">
                          <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/policingPbitMarkingListFilterIndexType[text()=$FILTER_INDEX_1]"/>
                        </xsl:variable>
                        <xsl:variable name="pbitMarkingListFilterType01InPolicingPreHandling">
                          <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/policingPbitMarkingListFilterIndexType[text()=$FILTER_INDEX_01]"/>
                        </xsl:variable>
                        <xsl:variable name="inPbitListFilterType0InPolicingPreHandling">
                          <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/policingInPbitListFilterIndexType[text()=$FILTER_INDEX_0]"/>
                        </xsl:variable>
                        <xsl:variable name="inPbitListFilterType1InPolicingPreHandling">
                          <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/policingInPbitListFilterIndexType[text()=$FILTER_INDEX_1]"/>
                        </xsl:variable>
                        <xsl:variable name="inPbitListFilterType01InPolicingPreHandling">
                          <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/policingInPbitListFilterIndexType[text()=$FILTER_INDEX_01]"/>
                        </xsl:variable>

                        <xsl:variable name="deiMarkingListFilterType0InPolicingPreHandling">
                          <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/policingDeiMarkingListFilterIndexType[text()=$FILTER_INDEX_0]"/>
                        </xsl:variable>
                        <xsl:variable name="deiMarkingListFilterType1InPolicingPreHandling">
                          <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/policingDeiMarkingListFilterIndexType[text()=$FILTER_INDEX_1]"/>
                        </xsl:variable>
                        <xsl:variable name="deiMarkingListFilterType01InPolicingPreHandling">
                          <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/policingDeiMarkingListFilterIndexType[text()=$FILTER_INDEX_01]"/>
                        </xsl:variable>
                        <xsl:variable name="inDeiFilterType0InPolicingPreHandling">
                          <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/policingInDeiFilterIndexType[text()=$FILTER_INDEX_0]"/>
                        </xsl:variable>
                        <xsl:variable name="inDeiFilterType1InPolicingPreHandling">
                          <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/policingInDeiFilterIndexType[text()=$FILTER_INDEX_1]"/>
                        </xsl:variable>
                        <xsl:variable name="inDeiFilterType01InPolicingPreHandling">
                          <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/policingInDeiFilterIndexType[text()=$FILTER_INDEX_01]"/>
                        </xsl:variable>

                        <xsl:variable name="filterType1InPolicingPreHandling">
                          <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/policingFilterIndexType[text()=$FILTER_INDEX_1]"/>
                        </xsl:variable>
                        <xsl:variable name="filterType01InPolicingPreHandling">
                          <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/policingFilterIndexType[text()=$FILTER_INDEX_01]"/>
                        </xsl:variable>

                        <xsl:if test="(string-length(normalize-space($filterType1WithoutPolicing))>0 or string-length(normalize-space($filterType01WithoutPolicing))>0)
                                   or (string-length(normalize-space($isActionPbitMarkingList0))>0 and string-length(normalize-space($isActionPbitMarkingList1))>0 and (string-length(normalize-space($pbitMarkingListFilterType0InPolicingPreHandling))>0 or string-length(normalize-space($pbitMarkingListFilterType01InPolicingPreHandling))>0 or string-length(normalize-space($inPbitListFilterType0InPolicingPreHandling))>0 or string-length(normalize-space($inPbitListFilterType01InPolicingPreHandling))>0))
                                   or (string-length(normalize-space($isActionDeiMarkingList0))>0 and string-length(normalize-space($isActionDeiMarkingList1))>0 and (string-length(normalize-space($deiMarkingListFilterType0InPolicingPreHandling))>0 or string-length(normalize-space($deiMarkingListFilterType01InPolicingPreHandling))>0 or string-length(normalize-space($inDeiFilterType0InPolicingPreHandling))>0 or string-length(normalize-space($inDeiFilterType01InPolicingPreHandling))>0))
                                   or (not(string-length(normalize-space($isActionPbitMarkingList0))>0 and string-length(normalize-space($isActionPbitMarkingList1))>0) and (string-length(normalize-space($pbitMarkingListFilterType1InPolicingPreHandling))>0 or string-length(normalize-space($pbitMarkingListFilterType01InPolicingPreHandling))>0 or string-length(normalize-space($inPbitListFilterType1InPolicingPreHandling))>0 or string-length(normalize-space($inPbitListFilterType01InPolicingPreHandling))>0))
                                   or (not(string-length(normalize-space($isActionDeiMarkingList0))>0 and string-length(normalize-space($isActionDeiMarkingList1))>0) and (string-length(normalize-space($deiMarkingListFilterType1InPolicingPreHandling))>0 or string-length(normalize-space($deiMarkingListFilterType01InPolicingPreHandling))>0 or string-length(normalize-space($inDeiFilterType1InPolicingPreHandling))>0 or string-length(normalize-space($inDeiFilterType01InPolicingPreHandling))>0))">

                          <xsl:variable name="errorMessage">
                            <xsl:value-of  select="'For ingress policies of user VSI which attached to a dual tag forwarder, the pbit and dei(ccl or port policer) filters have vlan tag reference restrictions. VSI name is '"/>
                          </xsl:variable>
                          <wrong-configuration-detected>
                            <xsl:value-of  select="concat($errorMessage,$vsiName, ', qos policy profile name is ', $ingressQosPolicyProfile, ', policy name is ', $policyName, '.')"/>
                          </wrong-configuration-detected>
                        </xsl:if>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:if test="string-length(normalize-space($filterType1InPolicy))>0 or string-length(normalize-space($filterType01InPolicy))>0">
                          <xsl:variable name="errorMessage">
                            <xsl:value-of  select="'For ingress policies of user VSI which attached to a single or dual tag forwarder, the pbit and dei(ccl or port policer) filters have vlan tag reference restrictions. VSI name is '"/>
                          </xsl:variable>
                          <wrong-configuration-detected>
                            <xsl:value-of  select="concat($errorMessage,$vsiName, ', qos policy profile name is ', $ingressQosPolicyProfile, ', policy name is ', $policyName, '.')"/>
                          </wrong-configuration-detected>
                        </xsl:if>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:when test="$policyType=$POLICY_TYPE_QUEUE_COLOR or $policyType=$POLICY_TYPE_SCHEDULE">
                    <xsl:if test="string-length(normalize-space($filterType1InPolicy))>0 or string-length(normalize-space($filterType01InPolicy))>0">
                      <xsl:variable name="errorMessage">
                        <xsl:value-of  select="'For ingress policies of user VSI which attached to a single or dual tag forwarder, the pbit and dei(queue-color or sheduler) filters have vlan tag reference restrictions. VSI name is '"/>
                      </xsl:variable>
                      <wrong-configuration-detected>
                        <xsl:value-of  select="concat($errorMessage,$vsiName, ', qos policy profile name is ', $ingressQosPolicyProfile, ', policy name is ', $policyName, '.')"/>
                      </wrong-configuration-detected>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>

      </xsl:if>

      <xsl:if test="string-length(normalize-space($egressQosPolicyProfile))>0">
        <xsl:variable name="egressPolicyProfileInfo">
          <xsl:copy-of  select="$policy_profile_Info_map($egressQosPolicyProfile)"/>
        </xsl:variable>
        <xsl:variable name="vsiUsageType">
          <xsl:value-of  select="$vsi_Info_map($vsiName)/interfaceUsageType"/>
        </xsl:variable>
        <xsl:variable name="vsiFwdType">
          <xsl:value-of  select="$forwarder_Info_map($vsiName)/fwdType"/>
        </xsl:variable>

        <xsl:for-each select="$egressPolicyProfileInfo/policyProfile/bbf-qos-pol:policy-list">
          <xsl:variable name="policyName">
            <xsl:value-of  select="current()/bbf-qos-pol:name"/>
          </xsl:variable>
          <xsl:variable name="policyType">
            <xsl:value-of  select="$policy_Info_map($policyName)/policyType"/>
          </xsl:variable>
          <!-- check for rule 10 descoped
          <xsl:if test="$vsiUsageType=$USAGE_USER">
            <xsl:variable name="isInPbitListInDeiCfg">
              <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/isInPbitListInDeiCfg"/>
            </xsl:variable>
            <xsl:variable name="isPolicingInPbitListInDeiCfg">
              <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/isPolicingInPbitListInDeiCfg"/>
            </xsl:variable>

            <xsl:if test="string-length(normalize-space($isInPbitListInDeiCfg))>0 or string-length(normalize-space($isPolicingInPbitListInDeiCfg))>0">
              <xsl:variable name="errorMessage">
                <xsl:value-of  select="'For egress policies of user VSI, they can not reference in-pbit or in-dei list. VSI name is '"/>
              </xsl:variable>
              <wrong-configuration-detected>
                <xsl:value-of  select="concat($errorMessage,$vsiName, ', qos policy profile name is ', $egressQosPolicyProfile, ', policy name is ', $policyName, '.')"/>
              </wrong-configuration-detected>
            </xsl:if>
          </xsl:if> -->

          <!-- check for rule 11 -->
          <xsl:if test="$vsiFwdType=$C_FORWARDER">
            <xsl:variable name="filterType1InProfile">
              <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/filterIndexType[text()=$FILTER_INDEX_1]"/>
            </xsl:variable>
            <xsl:variable name="filterType01InProfile">
              <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/filterIndexType[text()=$FILTER_INDEX_01]"/>
            </xsl:variable>

            <xsl:if test="string-length(normalize-space($filterType1InProfile))>0 or string-length(normalize-space($filterType01InProfile))>0">
              <xsl:variable name="errorMessage">
                <xsl:value-of  select="'For egress policies of user VSI which attached to a single tag forwarder, they can only reference outer vlan tag. VSI name is '"/>
              </xsl:variable>
              <wrong-configuration-detected>
                <xsl:value-of  select="concat($errorMessage,$vsiName, ', qos policy profile name is ', $egressQosPolicyProfile, ', policy name is ', $policyName, '.')"/>
              </wrong-configuration-detected>
            </xsl:if>
          </xsl:if>

          <!-- check for rule 12 -->
          <xsl:if test="$vsiUsageType=$USAGE_USER and $vsiFwdType=$SC_FORWARDER">
            <xsl:if test="$policyType!=$POLICY_TYPE_CCL">
              <xsl:variable name="filterType01InPolicy">
                <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/filterIndexType[text()=$FILTER_INDEX_01]"/>
              </xsl:variable>
              <xsl:if test="string-length(normalize-space($filterType01InPolicy))>0">
                <xsl:variable name="errorMessage">
                  <xsl:value-of  select="'For egress policies except CCL of user VSI which attached to a dual tag forwarder, they can only reference outer or inner vlan tag. VSI name is '"/>
                </xsl:variable>
                <wrong-configuration-detected>
                  <xsl:value-of  select="concat($errorMessage,$vsiName, ', qos policy profile name is ', $egressQosPolicyProfile, ', policy name is ', $policyName, '.')"/>
                </wrong-configuration-detected>
              </xsl:if>
            </xsl:if>
          </xsl:if>

          <!-- check for rule 15 -->
          <xsl:if test="$vsiFwdType=$SC_FORWARDER">
            <xsl:if test="$policyType=$POLICY_TYPE_CCL">
              <xsl:variable name="filterIndexType01InPolicy">
                <xsl:value-of  select="$policy_Info_map($policyName)/classifiers/filterIndexTypeWithoutPolicing[text()=$FILTER_INDEX_01]"/>
              </xsl:variable>
              <xsl:if test="string-length(normalize-space($filterIndexType01InPolicy))>0">
                <xsl:variable name="errorMessage">
                  <xsl:value-of  select="'For enhanced filters referenced by classifiers of egress qos CCL policy of user VSI which attached to a dual tag forwarder, they can not reference outer and inner tag at the same time. VSI name is '"/>
                </xsl:variable>
                <wrong-configuration-detected>
                  <xsl:value-of  select="concat($errorMessage,$vsiName, ', qos policy profile name is ', $egressQosPolicyProfile, ', policy name is ', $policyName, '.')"/>
                </wrong-configuration-detected>
              </xsl:if>
            </xsl:if>
          </xsl:if>
        </xsl:for-each>

         <!-- check for rule 13 -->
         <xsl:if test="$vsiUsageType=$USAGE_USER and $vsiFwdType=$SC_FORWARDER">
           <xsl:variable name="IndexTypeOfQueueColorPolicy">
             <xsl:iterate select="$egressPolicyProfileInfo/policyProfile/bbf-qos-pol:policy-list">
               <xsl:variable name="nameOfPolicy">
                 <xsl:value-of select="current()/bbf-qos-pol:name"/>
               </xsl:variable>
               <xsl:variable name="filterIndexType">
                 <xsl:value-of select="$policy_Info_map($nameOfPolicy)[policyType=$POLICY_TYPE_QUEUE_COLOR]/classifiers/filterIndexType"/>
               </xsl:variable>
               <xsl:if test="string-length(normalize-space($filterIndexType))>0">
                 <xsl:value-of  select="$filterIndexType"/>
                 <xsl:break/>
               </xsl:if>
             </xsl:iterate>
           </xsl:variable>
           <xsl:variable name="IndexTypeOfSchedulerPolicy">
             <xsl:iterate select="$egressPolicyProfileInfo/policyProfile/bbf-qos-pol:policy-list">
               <xsl:variable name="nameOfPolicy">
                 <xsl:value-of select="current()/bbf-qos-pol:name"/>
               </xsl:variable>
               <xsl:variable name="filterIndexType">
                 <xsl:value-of select="$policy_Info_map($nameOfPolicy)[policyType=$POLICY_TYPE_SCHEDULE]/classifiers/filterIndexType"/>
               </xsl:variable>
               <xsl:if test="string-length(normalize-space($filterIndexType))>0">
                 <xsl:value-of  select="$filterIndexType"/>
                 <xsl:break/>
               </xsl:if>
             </xsl:iterate>
           </xsl:variable>
           <xsl:if test="string-length(normalize-space($IndexTypeOfQueueColorPolicy))>0 and string-length(normalize-space($IndexTypeOfSchedulerPolicy))>0">
             <xsl:if test="$IndexTypeOfQueueColorPolicy!=$IndexTypeOfSchedulerPolicy">
              <xsl:variable name="errorMessage">
                <xsl:value-of  select="'For egress scheduler and queue color policies of user VSI which attached to a dual tag forwarder, they must reference the same vlan tag. VSI name is '"/>
              </xsl:variable>
              <wrong-configuration-detected>
                <xsl:value-of  select="concat($errorMessage,$vsiName, ', qos policy profile name is ', $egressQosPolicyProfile, '.')"/>
              </wrong-configuration-detected>
             </xsl:if>
           </xsl:if>
         </xsl:if>
      </xsl:if>

      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="getPolicyType">
    <xsl:param name="classifierName"/>
    <xsl:variable name="referencedEnhancdFilter">
      <xsl:value-of  select="/cfg-ns:config/bbf-qos-cls:classifiers/bbf-qos-cls:classifier-entry[bbf-qos-cls:name=$classifierName]/bbf-qos-enhfilt:enhanced-filter-name"/>
    </xsl:variable>

    <xsl:variable name="classifierAction">
      <xsl:value-of  select="/cfg-ns:config/bbf-qos-cls:classifiers/bbf-qos-cls:classifier-entry[bbf-qos-cls:name=$classifierName]/bbf-qos-cls:classifier-action-entry-cfg/child::*[local-name() = 'action-type']"/>
    </xsl:variable>

    <xsl:choose>
      <!-- type ccl -->
      <xsl:when test="string-length(normalize-space($referencedEnhancdFilter))>0">
        <xsl:value-of select="$POLICY_TYPE_CCL"/>
      </xsl:when>
      <xsl:when test="string-length(normalize-space($classifierAction))>0">
        <xsl:choose>
          <!-- type scheduler-->
          <xsl:when test="$classifierAction=$A_SCHEDULING_TRAFFIC_CLASS or $classifierAction=$A_SCHEDULING_TRAFFIC_CLASS_WITH_NS">
            <xsl:value-of select="$POLICY_TYPE_SCHEDULE"/>
          </xsl:when>
          <!-- type queue color -->
          <xsl:when test="$classifierAction=$A_BAC_COLOR">
            <xsl:value-of select="$POLICY_TYPE_QUEUE_COLOR"/>
          </xsl:when>
          <!-- type port-policer -->
          <xsl:when test="$classifierAction=$A_POLICING">
            <xsl:value-of select="$POLICY_TYPE_PORT_POLICER"/>
          </xsl:when>
          <!-- type count -->
          <xsl:when test="$classifierAction=$A_COUNT">
            <xsl:value-of select="$POLICY_TYPE_COUNT"/>
          </xsl:when>
          <!-- type marker -->
          <xsl:when test="$classifierAction=$A_PBIT_MARKING or $classifierAction=$A_PBIT_MARKING_WITH_NS or $classifierAction=$A_DEI_MARKING or $classifierAction=$A_DEI_MARKING_WITH_NS">
            <xsl:value-of select="$POLICY_TYPE_MARKER"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$POLICY_TYPE_UNKNOWN"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$POLICY_TYPE_UNKNOWN"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
