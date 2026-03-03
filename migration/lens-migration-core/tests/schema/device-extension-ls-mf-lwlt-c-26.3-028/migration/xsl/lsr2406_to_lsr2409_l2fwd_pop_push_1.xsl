<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:cfg-ns="urn:ietf:params:xml:ns:netconf:base:1.0"
                              xmlns:itf-ns="urn:ietf:params:xml:ns:yang:ietf-interfaces"
                              xmlns:map="http://www.w3.org/2005/xpath-functions/map"
                              xmlns:bbf-subif="urn:bbf:yang:bbf-sub-interfaces"
                              xmlns:bbf-qos-tm="urn:bbf:yang:bbf-qos-traffic-mngt"
                              xmlns:bbf-subif-tag="urn:bbf:yang:bbf-sub-interface-tagging"
                              xmlns:bbf-qos-pol-subif-rw="urn:bbf:yang:bbf-qos-policies-sub-itf-rewrite"
                              xmlns:nokia-queue-mon="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-qos-queue-monitoring"
                              xmlns:bbf-qos-sched="urn:bbf:yang:bbf-qos-enhanced-scheduling"
                              xmlns:nokia-queue-mon-ext="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-qos-queue-monitoring-extension"
                              xmlns:bbf-frameproc="urn:bbf:yang:bbf-frame-processing-profile"
                              xmlns:bbf-tm-ns="urn:bbf:yang:bbf-qos-traffic-mngt"
                              xmlns:bbf-scheduling-ns="urn:bbf:yang:bbf-qos-enhanced-scheduling"
                              xmlns:itf-type-ns="urn:bbf:yang:bbf-if-type"
                              xmlns:bbf-vsi-vctr="urn:bbf:yang:bbf-vlan-sub-interface-vector"
                              xmlns:bbf-vsi-vctr-fpp="urn:bbf:yang:bbf-vlan-sub-interface-vector-fpp"
                              xmlns:bbf-l2-fwd="urn:bbf:yang:bbf-l2-forwarding"
                              xmlns:bbf-xponift="urn:bbf:yang:bbf-xpon-if-type"
                              xmlns:nokia-qos-plc-ext="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-qos-policing-extension">
  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <xsl:variable name="INDEX_OUT_OF_RANGE" select="'INDEX_OUT_OF_RANGE'"/>
  <xsl:variable name="PARAMETER_VLAN_ID" select="'parameter-vlan-id'"/>
  <xsl:variable name="VLAN_ID_FROM_MATCH" select="'vlan-id-from-match'"/>
  <xsl:variable name="MAX_SIZE_OF_MONITORED_QUEUE_MVL" select="'36'"/>
  <xsl:variable name="MAX_SIZE_OF_MONITORED_QUEUE_BRUGAL" select="'48'"/>
  <xsl:variable name="MAX_SIZE_OF_L2_SCHEDULER_NODE" select="'512'"/>

  <xsl:variable name="MONITORED_QUEUE_NUMBER_OUT_OF_RANGE" select="'MONITORED_QUEUE_NUMBER_OUT_OF_RANGE'"/>
  <xsl:variable name="INTERFACE_TYPE_CHANNEL_PARTITION_WITH_PREFIX" select="'bbf-xponift:channel-partition'"/>
  <xsl:variable name="INTERFACE_TYPE_CHANNEL_PARTITION_WITHOUT_PREFIX" select="'channel-partition'"/>
  <xsl:variable name="ALIGNED_YES" select="'ALIGNED_YES'"/>

  <xsl:variable name="PRIORITY_TAGGED" select="'priority-tagged'"/>

  <xsl:variable name="L1_SCHEDULER_NODE_DIMENSION" select="128"/>
  <xsl:variable name="INTERFACE_TYPE_CT" select="'bbf-xponift:channel-partition'"/>
  <xsl:variable name="INTERFACE_TYPE_VSI" select="'bbfift:vlan-sub-interface'"/>
  <xsl:variable name="INTERFACE_TYPE_L2TERMINATION" select="'bbfift:l2-termination'"/>
  
  <xsl:variable name="TAG_POP" select="'TAG_POP'"/>
  <xsl:variable name="TAG_ALIGNED" select="'TAG_ALIGNED'"/>


  <xsl:variable name="vsiNameInForwarder_Info">
    <xsl:variable name="uniqueVsiNames">
      <xsl:for-each select ="/cfg-ns:config/bbf-l2-fwd:forwarding/bbf-l2-fwd:forwarders/bbf-l2-fwd:forwarder/bbf-l2-fwd:ports/bbf-l2-fwd:port/bbf-l2-fwd:sub-interface">
        <xsl:element name="vsiNameInForwarder">
          <xsl:element name="name">
            <xsl:value-of select="."/>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>
    </xsl:variable>
    <xsl:copy-of select="$uniqueVsiNames"/>
  </xsl:variable>
  <xsl:variable name="vsiNameInForwarder_Info_map" select="map:merge(for $elem in $vsiNameInForwarder_Info/vsiNameInForwarder return map{$elem/name : $elem})"/>

  <!-- collecting vsi info -->
  <xsl:variable name="vsi_Info">
    <xsl:for-each select ="/cfg-ns:config/itf-ns:interfaces/itf-ns:interface">
      <xsl:variable name="interfaceName">
        <xsl:value-of select="current()/itf-ns:name"/>
      </xsl:variable>

      <xsl:variable name="interfaceTypeL2Termination">
        <xsl:variable name="ItfType">
          <xsl:value-of select="current()/itf-ns:type"/>
        </xsl:variable>
        <xsl:if test="$ItfType = $INTERFACE_TYPE_L2TERMINATION">
          <xsl:value-of select="$ItfType"/>
        </xsl:if>
      </xsl:variable>

      <xsl:element name="vlanSubInterface">
        <xsl:element name="name">
          <xsl:value-of select="$interfaceName"/>
        </xsl:element>

        <xsl:if test="string-length(normalize-space($interfaceTypeL2Termination))>0">
          <xsl:element name="interfaceTypeL2Termination">
            <xsl:value-of select="$interfaceTypeL2Termination"/>
          </xsl:element>
        </xsl:if>
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

        <xsl:variable name="interfaceTypeL2">
          <xsl:iterate select="current()/bbf-l2-fwd:ports/bbf-l2-fwd:port/bbf-l2-fwd:sub-interface">
            <xsl:variable name="nameOfSubInterface">
              <xsl:value-of select="."/>
            </xsl:variable>
            <xsl:variable name="ItfTypeL2">
              <xsl:value-of select="$vsi_Info_map($nameOfSubInterface)/interfaceTypeL2Termination"/>
            </xsl:variable>
            <xsl:if test="string-length(normalize-space($ItfTypeL2))>0">
              <xsl:value-of  select="$ItfTypeL2"/>
              <xsl:break/>
            </xsl:if>
          </xsl:iterate>
        </xsl:variable>

        <xsl:element name="interfaceTypeL2">
          <xsl:value-of select="$interfaceTypeL2"/>
        </xsl:element>
      </xsl:element>
    </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="forwarder_Info_map" select="map:merge(for $elem in $forwarder_Info/forwarder/ports/port return map{$elem : $elem/../..})"/>

  <!-- collecting vsi vector info -->
  <xsl:variable name="vsiVector_Info">
    <xsl:for-each select ="/cfg-ns:config/bbf-vsi-vctr:vsi-vector-profiles/bbf-vsi-vctr:vsi-vector-profile">
      <xsl:variable name="frameProcessingProfileName">
        <xsl:value-of select="current()/bbf-vsi-vctr-fpp:frame-processing-profile-ref"/>
      </xsl:variable>
      <xsl:variable name="tag0">
        <xsl:value-of select="current()/bbf-vsi-vctr-fpp:tag-0/bbf-vsi-vctr-fpp:vlan-id"/>
      </xsl:variable>
      <xsl:variable name="tag1">
        <xsl:value-of select="current()/bbf-vsi-vctr-fpp:tag-1/bbf-vsi-vctr-fpp:vlan-id"/>
      </xsl:variable>

      <xsl:element name="vsiVector">
        <xsl:element name="name">
          <xsl:value-of select="current()/bbf-vsi-vctr:name"/>
        </xsl:element>

        <xsl:if test="string-length(normalize-space($frameProcessingProfileName))>0">
          <xsl:element name="frameName">
            <xsl:value-of select="$frameProcessingProfileName"/>
          </xsl:element>
        </xsl:if>

        <xsl:if test="string-length(normalize-space($tag0))>0">
          <xsl:element name="tag0">
            <xsl:value-of select="$tag0"/>
          </xsl:element>
        </xsl:if>
        <xsl:if test="string-length(normalize-space($tag1))>0">
          <xsl:element name="tag1">
            <xsl:value-of select="$tag1"/>
          </xsl:element>
        </xsl:if>
      </xsl:element>

    </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="vsi_vector_info_map" select="map:merge(for $elem in $vsiVector_Info/vsiVector return map{$elem/name : $elem})"/>

  <!-- collecting frame processing profile info -->
  <xsl:variable name="frameProcessing_Info">
    <xsl:for-each select ="/cfg-ns:config/bbf-frameproc:frame-processing-profiles/bbf-frameproc:frame-processing-profile">
      <xsl:variable name="untagged">
        <xsl:value-of select="current()/bbf-frameproc:match-criteria/bbf-frameproc:untagged"/>
      </xsl:variable>
      <xsl:variable name="tag0">
        <xsl:value-of select="current()/bbf-frameproc:match-criteria/bbf-frameproc:tag[bbf-frameproc:index='0']/bbf-frameproc:vlan-id"/>
      </xsl:variable>
      <xsl:variable name="tag1">
        <xsl:value-of select="current()/bbf-frameproc:match-criteria/bbf-frameproc:tag[bbf-frameproc:index='1']/bbf-frameproc:vlan-id"/>
      </xsl:variable>

      <xsl:variable name="popNumber">
        <xsl:value-of select="current()/bbf-frameproc:ingress-rewrite/bbf-frameproc:pop-tags"/>
      </xsl:variable>

      <xsl:variable name="pushTag0">
        <xsl:value-of select="current()/bbf-frameproc:egress-rewrite/bbf-frameproc:push-tag[bbf-frameproc:index='0']/bbf-frameproc:vlan-id"/>
      </xsl:variable>
      <xsl:variable name="pushTag1">
        <xsl:value-of select="current()/bbf-frameproc:egress-rewrite/bbf-frameproc:push-tag[bbf-frameproc:index='1']/bbf-frameproc:vlan-id"/>
      </xsl:variable>

      <xsl:variable name="isTagPop">
        <xsl:if test="(string-length(normalize-space($tag0))>0 and string-length(normalize-space($tag1))>0 and $popNumber='2')
                     or (string-length(normalize-space($tag0))>0 and (not(string-length(normalize-space($tag1))>0)) and $popNumber='1')
                     or (string-length(normalize-space($tag1))>0 and (not(string-length(normalize-space($tag0))>0))and $popNumber='1')
                     or (not(string-length(normalize-space($tag1))>0 or (string-length(normalize-space($tag0))>0)))">
          <xsl:value-of select="$TAG_POP"/>
        </xsl:if>
      </xsl:variable>

      <xsl:element name="frameProcessing">
        <xsl:element name="name">
          <xsl:value-of select="current()/bbf-frameproc:name"/>
        </xsl:element>

        <xsl:if test="string-length(normalize-space($untagged))>0">
          <xsl:element name="untagged">
            <xsl:value-of select="$untagged"/>
          </xsl:element>
        </xsl:if>
        <xsl:if test="string-length(normalize-space($tag0))>0">
          <xsl:element name="tag0">
            <xsl:value-of select="$tag0"/>
          </xsl:element>
        </xsl:if>
        <xsl:if test="string-length(normalize-space($tag1))>0">
          <xsl:element name="tag1">
            <xsl:value-of select="$tag1"/>
          </xsl:element>
        </xsl:if>

        <xsl:if test="string-length(normalize-space($popNumber))>0">
          <xsl:element name="popNumber">
            <xsl:value-of select="$popNumber"/>
          </xsl:element>
        </xsl:if>

        <xsl:if test="string-length(normalize-space($pushTag0))>0">
          <xsl:element name="pushTag0">
            <xsl:value-of select="$pushTag0"/>
          </xsl:element>
        </xsl:if>
        <xsl:if test="string-length(normalize-space($pushTag1))>0">
          <xsl:element name="pushTag1">
            <xsl:value-of select="$pushTag1"/>
          </xsl:element>
        </xsl:if>

        <xsl:if test="string-length(normalize-space($isTagPop))>0">
          <xsl:element name="isTagPop">
            <xsl:value-of select="$isTagPop"/>
          </xsl:element>
        </xsl:if>
      </xsl:element>

    </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="frame_processing_info_map" select="map:merge(for $elem in $frameProcessing_Info/frameProcessing return map{$elem/name : $elem})"/>

  <!-- caculating number of monitored queue-->
  <xsl:variable name="queueNumbers">
    <xsl:value-of select="count(/cfg-ns:config/itf-ns:interfaces/itf-ns:interface[itf-ns:type='bbf-xponift:channel-partition']/bbf-qos-tm:tm-root/nokia-queue-mon:queue-monitoring/nokia-queue-mon:enable-statistics[text()='true'])"/>
  </xsl:variable>


  <!-- check queue monitoring dimension and updating rule -->
  <xsl:template match="/cfg-ns:config/itf-ns:interfaces/itf-ns:interface[itf-ns:type='bbf-xponift:channel-partition']/bbf-qos-tm:tm-root/bbf-qos-sched:scheduler-node/nokia-queue-mon-ext:queue-monitoring/nokia-queue-mon-ext:enable-statistics">
    <xsl:variable name="currentPosition">
      <xsl:number count="nokia-queue-mon-ext:enable-statistics[text()='true']" level="any"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$queueNumbers + $currentPosition > $MAX_SIZE_OF_MONITORED_QUEUE_MVL">
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:value-of select="'false'"/>
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

  <!-- check index range for frame processing profile-->
  <xsl:template match="/cfg-ns:config/bbf-frameproc:frame-processing-profiles/bbf-frameproc:frame-processing-profile">
    <xsl:copy>
      <xsl:copy-of select="@*"/>

      <xsl:variable name="indexRangeCheck">
        <xsl:variable name="indexOfVlanTag">
          <xsl:value-of select="current()/bbf-frameproc:match-criteria/bbf-frameproc:tag[bbf-frameproc:index>1]"/>
        </xsl:variable>
        <xsl:variable name="indexOfCopyFromTagToMarkingListForTag">
          <xsl:value-of select="current()/bbf-frameproc:ingress-rewrite/bbf-frameproc:copy-from-tags-to-marking-list[bbf-frameproc:tag-index>1]"/>
        </xsl:variable>
        <xsl:variable name="indexOfCopyFromTagToMarkingListForPbit">
          <xsl:value-of select="current()/bbf-frameproc:ingress-rewrite/bbf-frameproc:copy-from-tags-to-marking-list[bbf-frameproc:pbit-marking-index>1]"/>
        </xsl:variable>
        <xsl:variable name="indexOfCopyFromTagToMarkingListForDei">
          <xsl:value-of select="current()/bbf-frameproc:ingress-rewrite/bbf-frameproc:copy-from-tags-to-marking-list[bbf-frameproc:dei-marking-index>1]"/>
        </xsl:variable>

        <xsl:variable name="indexOfPushTagForIndex">
          <xsl:value-of select="current()/bbf-frameproc:egress-rewrite/bbf-frameproc:push-tag[bbf-frameproc:index>1]"/>
        </xsl:variable>
        <xsl:variable name="indexOfPushTagForPbit">
          <xsl:value-of select="current()/bbf-frameproc:egress-rewrite/bbf-frameproc:push-tag[bbf-frameproc:pbit-marking-index>1]"/>
        </xsl:variable>
        <xsl:variable name="indexOfPushTagForDei">
          <xsl:value-of select="current()/bbf-frameproc:egress-rewrite/bbf-frameproc:push-tag[bbf-frameproc:dei-marking-index>1]"/>
        </xsl:variable>

        <xsl:if test="string-length(normalize-space($indexOfVlanTag))>0 or string-length(normalize-space($indexOfCopyFromTagToMarkingListForTag))>0 
                   or string-length(normalize-space($indexOfCopyFromTagToMarkingListForPbit))>0 or string-length(normalize-space($indexOfCopyFromTagToMarkingListForDei))>0
                   or string-length(normalize-space($indexOfPushTagForIndex))>0 or string-length(normalize-space($indexOfPushTagForPbit))>0
                   or string-length(normalize-space($indexOfPushTagForDei))>0">
          <xsl:value-of select="$INDEX_OUT_OF_RANGE"/>
        </xsl:if>
      </xsl:variable>

      <xsl:if test="string-length(normalize-space($indexRangeCheck))>0">
        <xsl:variable name="errorMessage">
          <xsl:value-of  select="'Index used in frame-processing-profile should only configure as 0 or 1. frame-processing-profile name is '"/>
        </xsl:variable>
        <wrong-configuration-detected>
          <xsl:value-of  select="concat($errorMessage,current()/bbf-frameproc:name, '.')"/>
        </wrong-configuration-detected>
      </xsl:if>

      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!-- deleting node mac-learning-failure-action -->
  <xsl:template match="/cfg-ns:config/itf-ns:interfaces/itf-ns:interface/bbf-l2-fwd:mac-learning">
    <xsl:variable name="numberOfNode">
      <xsl:value-of select="count(node())"/>
    </xsl:variable>

    <xsl:variable name="isNodeOfMacLearningFailureActionExist">
      <xsl:value-of select="current()/bbf-l2-fwd:mac-learning-failure-action"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$numberOfNode = '1' and string-length(normalize-space($isNodeOfMacLearningFailureActionExist)) > 0">
      </xsl:when>
      <xsl:otherwise>  
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:for-each select="current()/node()">
            <xsl:choose>
              <xsl:when test="local-name() = 'mac-learning-failure-action'">
              </xsl:when>
              <xsl:otherwise>
                <xsl:copy-of select="."/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </xsl:copy> 
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- checking and updating max-queue-size to ensure at least large than 9600 -->
  <xsl:template match="/cfg-ns:config/bbf-qos-tm:tm-profiles/bbf-qos-tm:bac-entry">
    <xsl:variable name="maxQueueSize">
      <xsl:value-of select="current()/bbf-qos-tm:max-queue-size"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="not(string-length(normalize-space($maxQueueSize))>0)">
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:for-each select="current()/node()">
            <xsl:choose>
              <xsl:when test="local-name() = 'name'">
                <xsl:copy-of select="."/>
                <xsl:element name="max-queue-size" namespace="urn:bbf:yang:bbf-qos-traffic-mngt">
                  <xsl:value-of select="9600"/>
                </xsl:element>
              </xsl:when>
              <xsl:otherwise>
                <xsl:copy-of select="."/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </xsl:copy>
      </xsl:when>
      <xsl:when test="$maxQueueSize &lt; 9600">
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:for-each select="current()/node()">
            <xsl:choose>
              <xsl:when test="local-name() = 'max-queue-size'">
                <xsl:element name="max-queue-size" namespace="urn:bbf:yang:bbf-qos-traffic-mngt">
                  <xsl:value-of select="9600"/>
                </xsl:element>
              </xsl:when>
              <xsl:otherwise>
                <xsl:copy-of select="."/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
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

  <!-- check pop/push and dimension rule -->
  <xsl:template match="/cfg-ns:config/itf-ns:interfaces/itf-ns:interface">
    <xsl:copy>
      <xsl:copy-of select="@*"/>

      <xsl:variable name="vsiName">
        <xsl:value-of select="current()/itf-ns:name"/>
      </xsl:variable>

      <xsl:variable name="interfaceType">
        <xsl:value-of select="current()/itf-ns:type"/>
      </xsl:variable>
      <xsl:variable name="interfaceTypeL2">
        <xsl:value-of  select="$forwarder_Info_map($vsiName)/interfaceTypeL2"/>
      </xsl:variable>
      <xsl:variable name="isVsiConfiguredInForwarder">
        <xsl:value-of  select="$vsiNameInForwarder_Info_map($vsiName)"/>
      </xsl:variable>


      <!-- check l2 scheduler node dimension -->
      <xsl:if test="$interfaceType=$INTERFACE_TYPE_CHANNEL_PARTITION_WITH_PREFIX or $interfaceType=$INTERFACE_TYPE_CHANNEL_PARTITION_WITHOUT_PREFIX">
        <xsl:variable name="numberOfL1SchedulerNode">
          <xsl:value-of select="count(current()/bbf-tm-ns:tm-root/bbf-scheduling-ns:child-scheduler-nodes)"/>
        </xsl:variable>
        <xsl:if test="$numberOfL1SchedulerNode > $L1_SCHEDULER_NODE_DIMENSION">
          <xsl:variable name="errorMessage">
            <xsl:value-of  select="'For the Layer 1 scheduler-node instance, it has exceeded the maximum number of Layer 1 scheduler-node instances per PON '"/>
          </xsl:variable>
          <wrong-configuration-detected>
            <xsl:value-of  select="concat($errorMessage, '(interface-channel-partition =', $vsiName, ', L1-scheduler-node-total =', $numberOfL1SchedulerNode, ', maximum =', $L1_SCHEDULER_NODE_DIMENSION,')')"/>
          </wrong-configuration-detected> 
        </xsl:if>

        <xsl:variable name="numberOfLevel2SchedulerNode">
          <xsl:value-of  select="count(current()/bbf-qos-tm:tm-root/bbf-qos-sched:scheduler-node/bbf-qos-sched:child-scheduler-nodes/bbf-qos-sched:name)"/>
        </xsl:variable>
        <xsl:if test="$numberOfLevel2SchedulerNode>$MAX_SIZE_OF_L2_SCHEDULER_NODE">
          <xsl:variable name="errorMessage">
            <xsl:value-of  select="'Level 2 scheduler node dimension reached, vsi name is '"/>
          </xsl:variable>
          <wrong-configuration-detected>
            <xsl:value-of  select="concat($errorMessage,$vsiName, '.')"/>
          </wrong-configuration-detected>
        </xsl:if>
      </xsl:if>

      <xsl:if test="$interfaceType = $INTERFACE_TYPE_VSI and string-length(normalize-space($isVsiConfiguredInForwarder))>0 and not(string-length(normalize-space($interfaceTypeL2))>0)">
        <xsl:variable name="frameProcessingProfileName">
          <xsl:value-of select="current()/bbf-frameproc:frame-processing-profile-ref"/>
        </xsl:variable>
        <xsl:variable name="vectorProfileName">
          <xsl:value-of select="current()/bbf-vsi-vctr:vector-profile"/>
        </xsl:variable>
        <xsl:variable name="isInlineFrameProcessingConfig">
          <xsl:value-of select="current()/bbf-subif:inline-frame-processing"/>
        </xsl:variable>

        <!-- check pop/push rule -->
        <xsl:choose>
          <xsl:when test="string-length(normalize-space($isInlineFrameProcessingConfig))>0">
            <xsl:variable name="inlinePushTag0">
              <xsl:value-of select="current()/bbf-subif:inline-frame-processing/bbf-subif:egress-rewrite/bbf-subif-tag:push-tag[bbf-subif-tag:index='0']/bbf-subif-tag:dot1q-tag/bbf-subif-tag:vlan-id"/>
            </xsl:variable>
            <xsl:variable name="inlinePushTag1">
              <xsl:value-of select="current()/bbf-subif:inline-frame-processing/bbf-subif:egress-rewrite/bbf-subif-tag:push-tag[bbf-subif-tag:index='1']/bbf-subif-tag:dot1q-tag/bbf-subif-tag:vlan-id"/>
            </xsl:variable>

            <xsl:variable name="inlineFrameProcessingInfoTable">
              <xsl:for-each select="current()/bbf-subif:inline-frame-processing/bbf-subif:ingress-rule/bbf-subif:rule">
                <xsl:variable name="untagged">
                    <xsl:value-of select="current()/bbf-subif:flexible-match/bbf-subif-tag:match-criteria/bbf-subif-tag:untagged"/>
                </xsl:variable>
                <xsl:variable name="tag0">
                  <xsl:value-of select="current()//bbf-subif:flexible-match/bbf-subif-tag:match-criteria/bbf-subif-tag:tag[bbf-subif-tag:index='0']/bbf-subif-tag:dot1q-tag/bbf-subif-tag:vlan-id"/>
                </xsl:variable>
                <xsl:variable name="tag1">
                  <xsl:value-of select="current()/bbf-subif:flexible-match/bbf-subif-tag:match-criteria/bbf-subif-tag:tag[bbf-subif-tag:index='1']/bbf-subif-tag:dot1q-tag/bbf-subif-tag:vlan-id"/>
                </xsl:variable>
                <xsl:variable name="popNumber">
                  <xsl:value-of select="current()/bbf-subif:ingress-rewrite/bbf-subif-tag:pop-tags"/>
                </xsl:variable>

                <xsl:variable name="isTagPop">
                  <xsl:if test="(string-length(normalize-space($tag0))>0 and string-length(normalize-space($tag1))>0 and $popNumber='2')
                               or (string-length(normalize-space($tag0))>0 and (not(string-length(normalize-space($tag1))>0)) and $popNumber='1')
                               or (string-length(normalize-space($tag1))>0 and (not(string-length(normalize-space($tag0))>0))and $popNumber='1')
                               or (not(string-length(normalize-space($tag1))>0 or (string-length(normalize-space($tag0))>0)))">
                    <xsl:value-of select="$TAG_POP"/>
                  </xsl:if>
                </xsl:variable>
                <xsl:variable name="isTagAligned">
                  <xsl:if test="($inlinePushTag0=$tag0 and $inlinePushTag1=$tag1)
                               or ($inlinePushTag0=$tag0 and $inlinePushTag1=$VLAN_ID_FROM_MATCH)
                               or ($inlinePushTag1=$tag1 and $inlinePushTag0=$VLAN_ID_FROM_MATCH)
                               or ($inlinePushTag0=$VLAN_ID_FROM_MATCH and $inlinePushTag1=$VLAN_ID_FROM_MATCH)
                               or ($tag0=$PRIORITY_TAGGED and $tag1=$PRIORITY_TAGGED)
                               or ($tag0=$PRIORITY_TAGGED and $tag1=$inlinePushTag1)
                               or ($tag1=$PRIORITY_TAGGED and $tag0=$inlinePushTag0)
                               or (string-length(normalize-space($untagged))>0 and not(string-length(normalize-space($tag0))>0 or (string-length(normalize-space($tag0))>0)))
                               or (string-length(normalize-space($untagged))>0 and not(string-length(normalize-space($inlinePushTag0))>0 and (string-length(normalize-space($inlinePushTag1))>0)))">
                    <xsl:value-of select="$TAG_ALIGNED"/>
                  </xsl:if>
                </xsl:variable>

                <xsl:element name="rule">
                  <xsl:element name="name">
                    <xsl:value-of select="current()/bbf-subif:name"/>
                  </xsl:element>
                  <xsl:if test="string-length(normalize-space($isTagPop))>0">
                    <xsl:element name="isTagPop">
                      <xsl:value-of select="$isTagPop"/>
                    </xsl:element>
                  </xsl:if>
                  <xsl:if test="string-length(normalize-space($isTagAligned))>0">
                    <xsl:element name="isTagAligned">
                      <xsl:value-of select="$isTagAligned"/>
                    </xsl:element>
                  </xsl:if>
                </xsl:element>
              </xsl:for-each>
            </xsl:variable>

            <!-- check pop -->
            <xsl:iterate select="$inlineFrameProcessingInfoTable/rule">
              <xsl:if test="not(string-length(normalize-space(current()/isTagPop))>0)">
                <xsl:variable name="errorMessage">
                  <xsl:value-of  select="'Invalid frame processing flow. All Vlan tags in match-criteria must be popped. VSI name is '"/>
                </xsl:variable>
                <wrong-configuration-detected>
                  <xsl:value-of  select="concat($errorMessage,$vsiName, '.')"/>
                </wrong-configuration-detected>
              </xsl:if>
            </xsl:iterate>

            <!-- check inline aligned about ingress match-criteria should align with egress-push -->
            <xsl:variable name="isAligned">
              <xsl:value-of  select="$inlineFrameProcessingInfoTable/rule[isTagAligned=$TAG_ALIGNED]/isTagAligned"/>
            </xsl:variable>
            <xsl:if test="not(string-length(normalize-space($isAligned))>0)">
              <xsl:variable name="errorMessage">
                <xsl:value-of  select="'Invalid frame processing flow. Vlan tags must be aligned between ingress match-criteria and egress-push. VSI name is '"/>
              </xsl:variable>
              <wrong-configuration-detected>
                <xsl:value-of  select="concat($errorMessage,$vsiName, '.')"/>
              </wrong-configuration-detected>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="pushTag0">
              <xsl:choose>
                <xsl:when test="string-length(normalize-space($frameProcessingProfileName))>0">
                  <xsl:value-of select="$frame_processing_info_map($frameProcessingProfileName)/pushTag0"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:if test="string-length(normalize-space($vectorProfileName))>0">
                    <xsl:variable name="frameProcessingProfileNameFromVector">
                      <xsl:value-of select="$vsi_vector_info_map($vectorProfileName)/frameName"/>
                    </xsl:variable>
		    
                    <xsl:if test="string-length(normalize-space($frameProcessingProfileNameFromVector))>0">
                      <xsl:value-of select="$frame_processing_info_map($frameProcessingProfileNameFromVector)/pushTag0"/>
                    </xsl:if>
                  </xsl:if>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <xsl:variable name="pushTag1">
              <xsl:choose>
                <xsl:when test="string-length(normalize-space($frameProcessingProfileName))>0">
                  <xsl:value-of select="$frame_processing_info_map($frameProcessingProfileName)/pushTag1"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:if test="string-length(normalize-space($vectorProfileName))>0">
                    <xsl:variable name="frameProcessingProfileNameFromVector">
                      <xsl:value-of select="$vsi_vector_info_map($vectorProfileName)/frameName"/>
                    </xsl:variable>
		    
                    <xsl:if test="string-length(normalize-space($frameProcessingProfileNameFromVector))>0">
                      <xsl:value-of select="$frame_processing_info_map($frameProcessingProfileNameFromVector)/pushTag1"/>
                    </xsl:if>
                  </xsl:if>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <xsl:variable name="untagged">
              <xsl:choose>
                <xsl:when test="string-length(normalize-space($frameProcessingProfileName))>0">
                  <xsl:value-of select="$frame_processing_info_map($frameProcessingProfileName)/untagged"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:if test="string-length(normalize-space($vectorProfileName))>0">
                    <xsl:variable name="frameProcessingProfileNameFromVector">
                      <xsl:value-of select="$vsi_vector_info_map($vectorProfileName)/frameName"/>
                    </xsl:variable>
              
                    <xsl:if test="string-length(normalize-space($frameProcessingProfileNameFromVector))>0">
                      <xsl:value-of select="$frame_processing_info_map($frameProcessingProfileNameFromVector)/untagged"/>
                    </xsl:if>
                  </xsl:if>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <xsl:variable name="tag0">
              <xsl:choose>
                <xsl:when test="string-length(normalize-space($frameProcessingProfileName))>0">
                  <xsl:variable name="tag0FromProfile">
                    <xsl:value-of select="$frame_processing_info_map($frameProcessingProfileName)/tag0"/>
                  </xsl:variable>
			  
                  <xsl:choose>
                    <xsl:when test="$tag0FromProfile=$PARAMETER_VLAN_ID">
                      <xsl:value-of select="current()/bbf-frameproc:tag-0/bbf-frameproc:vlan-id"/>
                    </xsl:when>
                    <xsl:when test="string-length(normalize-space($tag0FromProfile))>0">
                      <xsl:value-of select="$tag0FromProfile"/>
                    </xsl:when>
                  </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:if test="string-length(normalize-space($vectorProfileName))>0">
                    <xsl:variable name="frameProcessingProfileNameFromVector">
                      <xsl:value-of select="$vsi_vector_info_map($vectorProfileName)/frameName"/>
                    </xsl:variable>
			  
                    <xsl:if test="string-length(normalize-space($frameProcessingProfileNameFromVector))>0">
                      <xsl:variable name="tag0FromVector">
                        <xsl:value-of select="$frame_processing_info_map($frameProcessingProfileNameFromVector)/tag0"/>
                      </xsl:variable>
			  
                      <xsl:choose>
                        <xsl:when test="$tag0FromVector=$PARAMETER_VLAN_ID">
                          <xsl:value-of select="$vsi_vector_info_map($vectorProfileName)/tag0"/>
                        </xsl:when>
                        <xsl:when test="string-length(normalize-space($tag0FromVector))>0">
                          <xsl:value-of select="$tag0FromVector"/>
                        </xsl:when>
                      </xsl:choose>
                    </xsl:if>
                  </xsl:if>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <xsl:variable name="tag1">
              <xsl:choose>
                <xsl:when test="string-length(normalize-space($frameProcessingProfileName))>0">
                  <xsl:variable name="tag1FromProfile">
                    <xsl:value-of select="$frame_processing_info_map($frameProcessingProfileName)/tag1"/>
                  </xsl:variable>
              
                  <xsl:choose>
                    <xsl:when test="$tag1FromProfile=$PARAMETER_VLAN_ID">
                      <xsl:value-of select="current()/bbf-frameproc:tag-1/bbf-frameproc:vlan-id"/>
                    </xsl:when>
                    <xsl:when test="string-length(normalize-space($tag1FromProfile))>0">
                      <xsl:value-of select="$tag1FromProfile"/>
                    </xsl:when>
                  </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:if test="string-length(normalize-space($vectorProfileName))>0">
                    <xsl:variable name="frameProcessingProfileNameFromVector">
                      <xsl:value-of select="$vsi_vector_info_map($vectorProfileName)/frameName"/>
                    </xsl:variable>
		      
                    <xsl:if test="string-length(normalize-space($frameProcessingProfileNameFromVector))>0">
                      <xsl:variable name="tag1FromVector">
                        <xsl:value-of select="$frame_processing_info_map($frameProcessingProfileNameFromVector)/tag1"/>
                      </xsl:variable>
		      
                      <xsl:choose>
                        <xsl:when test="$tag1FromVector=$PARAMETER_VLAN_ID">
                          <xsl:value-of select="$vsi_vector_info_map($vectorProfileName)/tag1"/>
                        </xsl:when>
                        <xsl:when test="string-length(normalize-space($tag1FromVector))>0">
                          <xsl:value-of select="$tag1FromVector"/>
                        </xsl:when>
                      </xsl:choose>
                    </xsl:if>
                  </xsl:if>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <xsl:variable name="popNumber">
              <xsl:choose>
                <xsl:when test="string-length(normalize-space($frameProcessingProfileName))>0">
                  <xsl:value-of select="$frame_processing_info_map($frameProcessingProfileName)/popNumber"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:if test="string-length(normalize-space($vectorProfileName))>0">
                    <xsl:variable name="frameProcessingProfileNameFromVector">
                      <xsl:value-of select="$vsi_vector_info_map($vectorProfileName)/frameName"/>
                    </xsl:variable>

                    <xsl:if test="string-length(normalize-space($frameProcessingProfileNameFromVector))>0">
                      <xsl:value-of select="$frame_processing_info_map($frameProcessingProfileNameFromVector)/popNumber"/>
                    </xsl:if>
                  </xsl:if>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <xsl:variable name="isPop">
              <xsl:choose>
                <xsl:when test="string-length(normalize-space($frameProcessingProfileName))>0">
                  <xsl:value-of select="$frame_processing_info_map($frameProcessingProfileName)/isTagPop"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:if test="string-length(normalize-space($vectorProfileName))>0">
                    <xsl:variable name="frameProcessingProfileNameFromVector">
                      <xsl:value-of select="$vsi_vector_info_map($vectorProfileName)/frameName"/>
                    </xsl:variable>

                    <xsl:if test="string-length(normalize-space($frameProcessingProfileNameFromVector))>0">
                      <xsl:value-of select="$frame_processing_info_map($frameProcessingProfileNameFromVector)/isTagPop"/>
                    </xsl:if>
                  </xsl:if>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <!-- check -->
            <xsl:if test="not(string-length(normalize-space($isPop))>0)">
              <xsl:variable name="errorMessage">
                <xsl:value-of  select="'Invalid frame processing flow. All Vlan tags in match-criteria must be popped. VSI name is '"/>
              </xsl:variable>
              <wrong-configuration-detected>
                <xsl:value-of  select="concat($errorMessage,$vsiName, '.')"/>
              </wrong-configuration-detected>
            </xsl:if>

            <!-- check profile ingress match-criteria should align with egress-push -->
            <xsl:if test="not(($pushTag0=$tag0 and $pushTag1=$tag1)
                     or ($pushTag0=$tag0 and $pushTag1=$VLAN_ID_FROM_MATCH)
                     or ($pushTag1=$tag1 and $pushTag0=$VLAN_ID_FROM_MATCH)
                     or ($pushTag0=$VLAN_ID_FROM_MATCH and $pushTag1=$VLAN_ID_FROM_MATCH)
                     or ($tag0=$PRIORITY_TAGGED and $tag1=$PRIORITY_TAGGED)
                     or ($tag0=$PRIORITY_TAGGED and $tag1=$pushTag1)
                     or ($tag1=$PRIORITY_TAGGED and $tag0=$pushTag0)
                     or (string-length(normalize-space($untagged))>0 and not(string-length(normalize-space($tag0))>0 or (string-length(normalize-space($tag1))>0)))
                     or (string-length(normalize-space($untagged))>0 and not(string-length(normalize-space($pushTag0))>0 and (string-length(normalize-space($pushTag1))>0))))">
              <xsl:variable name="errorMessage">
                <xsl:value-of  select="'Invalid frame processing flow. Vlan tags must be aligned between ingress match-criteria and egress-push. VSI name is '"/>
              </xsl:variable>
              <wrong-configuration-detected>
                <xsl:value-of  select="concat($errorMessage,$vsiName, '.')"/>
              </wrong-configuration-detected>
            </xsl:if>

          </xsl:otherwise>
        </xsl:choose>

        <!-- check inline frame processing index -->
        <xsl:variable name="indexRangeCheck">
          <xsl:variable name="indexOfVlanTag">
            <xsl:value-of select="current()/bbf-subif:inline-frame-processing/bbf-subif:ingress-rule/bbf-subif:rule/bbf-subif:flexible-match/bbf-subif-tag:match-criteria/bbf-subif-tag:tag[bbf-subif-tag:index>1]"/>
          </xsl:variable>
          <xsl:variable name="indexOfCopyFromTagToMarkingList">
            <xsl:value-of select="current()/bbf-subif:inline-frame-processing/bbf-subif:ingress-rule/bbf-subif:rule/bbf-subif:ingress-rewrite/bbf-qos-pol-subif-rw:copy-from-tags-to-marking-list[bbf-qos-pol-subif-rw:tag-index>1 or bbf-qos-pol-subif-rw:pbit-marking-index>1 or bbf-qos-pol-subif-rw:dei-marking-index>1]"/>
          </xsl:variable>
          <xsl:variable name="indexOfPushTag">
            <xsl:value-of select="current()/bbf-subif:inline-frame-processing/bbf-subif:ingress-rule/bbf-subif:rule/bbf-subif:ingress-rewrite/bbf-subif-tag:push-tag[bbf-subif-tag:index>1]"/>
          </xsl:variable>

          <xsl:if test="string-length(normalize-space($indexOfVlanTag))>0 or string-length(normalize-space($indexOfCopyFromTagToMarkingList))>0 or string-length(normalize-space($indexOfPushTag))>0">
            <xsl:value-of select="$INDEX_OUT_OF_RANGE"/>
          </xsl:if>
        </xsl:variable>

        <xsl:if test="string-length(normalize-space($indexRangeCheck))>0">
          <xsl:variable name="errorMessage">
            <xsl:value-of  select="'Index used for inline-frame-processing should only configure as 0 or 1. vsi name is '"/>
          </xsl:variable>
          <wrong-configuration-detected>
            <xsl:value-of  select="concat($errorMessage,$vsiName, '.')"/>
          </wrong-configuration-detected>
        </xsl:if>

      </xsl:if>

      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>