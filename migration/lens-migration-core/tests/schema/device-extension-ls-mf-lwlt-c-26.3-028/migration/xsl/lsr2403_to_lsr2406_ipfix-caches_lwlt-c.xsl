<?xml version="1.0" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:ipfix="urn:ietf:params:xml:ns:yang:ietf-ipfix-psamp">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    <xsl:param name="ipfix_ns" select="'urn:ietf:params:xml:ns:yang:ietf-ipfix-psamp'" />


   <!-- xsl rule to migrate an existing configured counter which has changed its xpath -->
   <xsl:template match="ipfix:ipfix/ipfix:cache/ipfix:permanentCache/ipfix:cacheLayout/ipfix:cacheField/ipfix:ieName">
       <xsl:choose>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/if:statistics/nokia-add-stats:in-dropped-bytes'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/if:statistics/nokia-itfstat:in-dropped-bytes</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/if:statistics/nokia-add-stats:out-dropped-bytes'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/if:statistics/nokia-itfstat:out-dropped-bytes</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/if:statistics/nokia-itfpktcnt:in-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/if:statistics/bbf-if-ctrs:in-pkts</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/if:statistics/nokia-itfpktcnt:out-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/if:statistics/bbf-if-ctrs:out-pkts</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:otherwise>
               <xsl:copy>
                   <xsl:copy-of select="@*"/>
                   <xsl:apply-templates/>
               </xsl:copy>
           </xsl:otherwise>
        </xsl:choose>
   </xsl:template>



   <!-- Delete cacheField if underlying ieName is set to an unsupported xpath -->
   <xsl:template match="ipfix:ipfix/ipfix:cache/ipfix:permanentCache/ipfix:cacheLayout/ipfix:cacheField[
                          ipfix:ieName[
                                      text()='/hw:hardware-state/hw:component/bbf-cpu-rs:cpu-processor-data/bbf-cpu-rs:task-counts' or
                                      text()='/hw:hardware-state/hw:component/bbf-cpu-rs:cpu-processor-data/bbf-cpu-rs:number-of-active-sessions' or
                                      text()='/hw:hardware-state/hw:component/bbf-cpu-rs:cpu-processor-data/bbf-cpu-rs:task-counts/bbf-cpu-rs:total-tasks' or
                                      text()='/hw:hardware-state/hw:component/bbf-cpu-rs:cpu-processor-data/bbf-cpu-rs:task-counts/bbf-cpu-rs:running-tasks' or
                                      text()='/hw:hardware-state/hw:component/bbf-cpu-rs:cpu-processor-data/bbf-cpu-rs:task-counts/bbf-cpu-rs:sleeping-tasks' or
                                      text()='/hw:hardware-state/hw:component/bbf-cpu-rs:cpu-processor-data/bbf-cpu-rs:task-counts/bbf-cpu-rs:stopped-tasks' or
                                      text()='/hw:hardware-state/hw:component/bbf-cpu-rs:cpu-processor-data/bbf-cpu-rs:task-counts/bbf-cpu-rs:zombie-tasks' or
                                      text()='/bbf-mgmd:multicast-state' or
                                      text()='/bbf-mgmd:multicast-state/bbf-mgmd:mgmd' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/eth-mounted:Ethernet' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/nokia-sdan-if-mounted:all-unis' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/nokia-sdan-if-mounted:all-unis/nokia-sdan-if-mounted:ethernet' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/nokia-sdan-if-mounted:all-unis/nokia-sdan-if-mounted:ethernet/nokia-interfaces-performance-management-mounted:performance' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/nokia-sdan-if-mounted:all-unis/nokia-sdan-if-mounted:ethernet/nokia-interfaces-performance-management-mounted:performance/nokia-interfaces-performance-management-mounted:intervals-15min' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state/hw-mounted:component/bbf-sim-mounted:software' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state/hw-mounted:component/bbf-sim-mounted:software/bbf-sim-mounted:software/bbf-sim-mounted:revisions' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state/hw-mounted:component/nokia-cpu-pm-mgnt-mounted:performance' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state/hw-mounted:component/nokia-cpu-pm-mgnt-mounted:performance/nokia-cpu-pm-mgnt-mounted:intervals-15min' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state/hw-mounted:component/nokia-cpu-pm-mgnt-mounted:performance/nokia-cpu-pm-mgnt-mounted:intervals-24hr' or
                                      text()='/onu:onus/onu:onu/onu:root/bbf-sip-voip-mounted:pots-interworking-nodes-state' or
                                      text()='/onu:onus/onu:onu/onu:root/bbf-sip-voip-mounted:pots-interworking-nodes-state/bbf-sip-voip-mounted:pots-interworking/nokia-voice-pm-mounted:performance' or
                                      text()='/onu:onus/onu:onu/onu:root/bbf-sip-voip-mounted:pots-interworking-nodes-state/bbf-sip-voip-mounted:pots-interworking/nokia-voice-pm-mounted:performance/nokia-voice-pm-mounted:intervals-15min' or
                                      text()='/onu:onus/onu:onu/onu:root/bbf-xpongemtcont-mounted:xpongemtcont-state' or
                                      text()='/onu:onus/onu:onu/onu:root/bbf-xpongemtcont-mounted:xpongemtcont-state/bbf-xpongemtcont-mounted:gemports' or
                                      text()='/onu:onus/onu:onu/onu:root/bbf-xpongemtcont-mounted:xpongemtcont-state/bbf-xpongemtcont-mounted:gemports/bbf-xpongemtcont-mounted:gemport/bbf-xpongemtcont-gemport-pm-mounted:performance' or
                                      text()='/onu:onus/onu:onu/onu:root/bbf-xpongemtcont-mounted:xpongemtcont-state/bbf-xpongemtcont-mounted:gemports/bbf-xpongemtcont-mounted:gemport/bbf-xpongemtcont-gemport-pm-mounted:performance/bbf-xpongemtcont-gemport-pm-mounted:intervals-15min' or
                                      text()='/dot1q-cfm:cfm/dot1q-cfm:maintenance-group/dot1q-cfm:mep/nokia-cfm-loopback:loopback-transmit-session' or
                                      text()='/hw:hardware-state' or
                                      text()='/hw:hardware-state/hw:component/hw:state' or
                                      text()='/hw:hardware-state/hw:component/bbf-hw-xcvr:transceiver' or
                                      text()='/hw:hardware-state/hw:component/bbf-hw-xcvr:transceiver/bbf-hw-xcvr:identifiers-and-codes' or
                                      text()='/hw:hardware-state/hw:component/bbf-hw-xcvr:transceiver/bbf-hw-xcvr:identifiers-and-codes/bbf-hw-xcvr:compliance-codes' or
                                      text()='/hw:hardware-state/hw:component/bbf-hw-xcvr:transceiver-link' or
                                      text()='/if:interfaces-state' or
                                      text()='/if:interfaces-state/if:interface/bbf-if-pm:performance' or
                                      text()='/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-if-pm:intervals-15min' or
                                      text()='/if:interfaces-state/if:interface/bbf-xpon:channel-pair' or
                                      text()='/if:interfaces-state/if:interface/bbf-xpon:channel-termination' or
                                      text()='/if:interfaces-state/if:interface/bbf-xponvani:v-ani' or
                                      text()='/if:interfaces-state/if:interface/eth:Ethernet' or
                                      text()='/if:interfaces-state/if:interface/ip:ipv4' or
                                      text()='/if:interfaces-state/if:interface/ip:ipv6' or
                                      text()='/if:interfaces-state/if:interface/nokia-dot1x-ext:pae' or
                                      text()='/if:interfaces-state/if:interface/nokia-itf-tm:speed-monitoring' or
                                      text()='/if:interfaces-state/if:interface/nokia-queue-mon:tm-root' or
                                      text()='/if:interfaces-state/if:interface/nokia-queue-mon:tm-root/nokia-queue-mon:queue/nokia-queue-mon:performance' or
                                      text()='/if:interfaces-state/if:interface/nokia-queue-mon:tm-root/nokia-queue-mon:queue/nokia-queue-mon:performance/nokia-queue-mon:intervals-15min' or
                                      text()='/if:interfaces-state/if:interface/nokia-queue-mon:tm-root/nokia-queue-mon-ext:scheduler-node/nokia-queue-mon-ext:queue/nokia-queue-mon-ext:performance' or
                                      text()='/if:interfaces-state/if:interface/nokia-queue-mon:tm-root/nokia-queue-mon-ext:scheduler-node/nokia-queue-mon-ext:queue/nokia-queue-mon-ext:performance/nokia-queue-mon-ext:intervals-15min' or
                                      text()='/sys:system-state' or
                                      text()='/sys:system-state/sys:platform' or
                                      text()='/sys:system-state/nokia-ietf-system-aug:ntp-state' or
                                      text()='/lic-app:licensing-state'
                          ]
   ]"/>



   <!-- Delete cache if the count of the underlying ieNames equals to the count of ieNames that contain
                unsupported xpaths, i.e, not even 1 supported xpath is present in the cache. Also add 
                exporting process name to the each valid cache -->
   <xsl:variable name="exp">
             <xsl:value-of select="//*[ local-name() = 'name' and parent::*[local-name() = 'exportingProcess'] ]"/>
   </xsl:variable>
   <xsl:template match="ipfix:ipfix/ipfix:cache">
       <xsl:if test = "not(count(./ipfix:permanentCache/ipfix:cacheLayout/ipfix:cacheField/ipfix:ieName) > 0 and
                          count(./ipfix:permanentCache/ipfix:cacheLayout/ipfix:cacheField/ipfix:ieName) =
                          count(./ipfix:permanentCache/ipfix:cacheLayout/ipfix:cacheField/ipfix:ieName[
                                      text()='/hw:hardware-state/hw:component/bbf-cpu-rs:cpu-processor-data/bbf-cpu-rs:task-counts' or
                                      text()='/hw:hardware-state/hw:component/bbf-cpu-rs:cpu-processor-data/bbf-cpu-rs:number-of-active-sessions' or
                                      text()='/hw:hardware-state/hw:component/bbf-cpu-rs:cpu-processor-data/bbf-cpu-rs:task-counts/bbf-cpu-rs:total-tasks' or
                                      text()='/hw:hardware-state/hw:component/bbf-cpu-rs:cpu-processor-data/bbf-cpu-rs:task-counts/bbf-cpu-rs:running-tasks' or
                                      text()='/hw:hardware-state/hw:component/bbf-cpu-rs:cpu-processor-data/bbf-cpu-rs:task-counts/bbf-cpu-rs:sleeping-tasks' or
                                      text()='/hw:hardware-state/hw:component/bbf-cpu-rs:cpu-processor-data/bbf-cpu-rs:task-counts/bbf-cpu-rs:stopped-tasks' or
                                      text()='/hw:hardware-state/hw:component/bbf-cpu-rs:cpu-processor-data/bbf-cpu-rs:task-counts/bbf-cpu-rs:zombie-tasks' or
                                      text()='/bbf-mgmd:multicast-state' or
                                      text()='/bbf-mgmd:multicast-state/bbf-mgmd:mgmd' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/eth-mounted:Ethernet' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/nokia-sdan-if-mounted:all-unis' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/nokia-sdan-if-mounted:all-unis/nokia-sdan-if-mounted:ethernet' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/nokia-sdan-if-mounted:all-unis/nokia-sdan-if-mounted:ethernet/nokia-interfaces-performance-management-mounted:performance' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/nokia-sdan-if-mounted:all-unis/nokia-sdan-if-mounted:ethernet/nokia-interfaces-performance-management-mounted:performance/nokia-interfaces-performance-management-mounted:intervals-15min' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state/hw-mounted:component/bbf-sim-mounted:software' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state/hw-mounted:component/bbf-sim-mounted:software/bbf-sim-mounted:software/bbf-sim-mounted:revisions' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state/hw-mounted:component/nokia-cpu-pm-mgnt-mounted:performance' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state/hw-mounted:component/nokia-cpu-pm-mgnt-mounted:performance/nokia-cpu-pm-mgnt-mounted:intervals-15min' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state/hw-mounted:component/nokia-cpu-pm-mgnt-mounted:performance/nokia-cpu-pm-mgnt-mounted:intervals-24hr' or
                                      text()='/onu:onus/onu:onu/onu:root/bbf-sip-voip-mounted:pots-interworking-nodes-state' or
                                      text()='/onu:onus/onu:onu/onu:root/bbf-sip-voip-mounted:pots-interworking-nodes-state/bbf-sip-voip-mounted:pots-interworking/nokia-voice-pm-mounted:performance' or
                                      text()='/onu:onus/onu:onu/onu:root/bbf-sip-voip-mounted:pots-interworking-nodes-state/bbf-sip-voip-mounted:pots-interworking/nokia-voice-pm-mounted:performance/nokia-voice-pm-mounted:intervals-15min' or
                                      text()='/onu:onus/onu:onu/onu:root/bbf-xpongemtcont-mounted:xpongemtcont-state' or
                                      text()='/onu:onus/onu:onu/onu:root/bbf-xpongemtcont-mounted:xpongemtcont-state/bbf-xpongemtcont-mounted:gemports' or
                                      text()='/onu:onus/onu:onu/onu:root/bbf-xpongemtcont-mounted:xpongemtcont-state/bbf-xpongemtcont-mounted:gemports/bbf-xpongemtcont-mounted:gemport/bbf-xpongemtcont-gemport-pm-mounted:performance' or
                                      text()='/onu:onus/onu:onu/onu:root/bbf-xpongemtcont-mounted:xpongemtcont-state/bbf-xpongemtcont-mounted:gemports/bbf-xpongemtcont-mounted:gemport/bbf-xpongemtcont-gemport-pm-mounted:performance/bbf-xpongemtcont-gemport-pm-mounted:intervals-15min' or
                                      text()='/dot1q-cfm:cfm/dot1q-cfm:maintenance-group/dot1q-cfm:mep/nokia-cfm-loopback:loopback-transmit-session' or
                                      text()='/hw:hardware-state' or
                                      text()='/hw:hardware-state/hw:component/hw:state' or
                                      text()='/hw:hardware-state/hw:component/bbf-hw-xcvr:transceiver' or
                                      text()='/hw:hardware-state/hw:component/bbf-hw-xcvr:transceiver/bbf-hw-xcvr:identifiers-and-codes' or
                                      text()='/hw:hardware-state/hw:component/bbf-hw-xcvr:transceiver/bbf-hw-xcvr:identifiers-and-codes/bbf-hw-xcvr:compliance-codes' or
                                      text()='/hw:hardware-state/hw:component/bbf-hw-xcvr:transceiver-link' or
                                      text()='/if:interfaces-state' or
                                      text()='/if:interfaces-state/if:interface/bbf-if-pm:performance' or
                                      text()='/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-if-pm:intervals-15min' or
                                      text()='/if:interfaces-state/if:interface/bbf-xpon:channel-pair' or
                                      text()='/if:interfaces-state/if:interface/bbf-xpon:channel-termination' or
                                      text()='/if:interfaces-state/if:interface/bbf-xponvani:v-ani' or
                                      text()='/if:interfaces-state/if:interface/eth:Ethernet' or
                                      text()='/if:interfaces-state/if:interface/ip:ipv4' or
                                      text()='/if:interfaces-state/if:interface/ip:ipv6' or
                                      text()='/if:interfaces-state/if:interface/nokia-dot1x-ext:pae' or
                                      text()='/if:interfaces-state/if:interface/nokia-itf-tm:speed-monitoring' or
                                      text()='/if:interfaces-state/if:interface/nokia-queue-mon:tm-root' or
                                      text()='/if:interfaces-state/if:interface/nokia-queue-mon:tm-root/nokia-queue-mon:queue/nokia-queue-mon:performance' or
                                      text()='/if:interfaces-state/if:interface/nokia-queue-mon:tm-root/nokia-queue-mon:queue/nokia-queue-mon:performance/nokia-queue-mon:intervals-15min' or
                                      text()='/if:interfaces-state/if:interface/nokia-queue-mon:tm-root/nokia-queue-mon-ext:scheduler-node/nokia-queue-mon-ext:queue/nokia-queue-mon-ext:performance' or
                                      text()='/if:interfaces-state/if:interface/nokia-queue-mon:tm-root/nokia-queue-mon-ext:scheduler-node/nokia-queue-mon-ext:queue/nokia-queue-mon-ext:performance/nokia-queue-mon-ext:intervals-15min' or
                                      text()='/sys:system-state' or
                                      text()='/sys:system-state/sys:platform' or
                                      text()='/sys:system-state/nokia-ietf-system-aug:ntp-state' or
                                      text()='/lic-app:licensing-state'
                          ]))">
           <xsl:choose>
            <xsl:when test="./ipfix:exportingProcess">
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
            <xsl:copy>
                <xsl:copy-of select="@*"/>
                <xsl:apply-templates/>
                <xsl:if test="string-length($exp) > 0">
                    <exportingProcess xmlns="urn:ietf:params:xml:ns:yang:ietf-ipfix-psamp">
                        <xsl:value-of select="$exp"/>
                    </exportingProcess>
                </xsl:if>
            </xsl:copy>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
    </xsl:template>


   <!-- xsl rule to remove ipfix elements -->
   <xsl:template match="ipfix:ipfix[
                          count(./ipfix:randomize-data-collection) = 0 and
                          count(./ipfix:ipfix-exporting-enable) = 0 and
                          count(./exportingProcess) = 0 and
                          (count(./ipfix:cache) = 0 or
                          count(./ipfix:cache/ipfix:permanentCache/ipfix:cacheLayout/ipfix:cacheField/ipfix:ieName) > 0 and
                          count(./ipfix:cache/ipfix:permanentCache/ipfix:cacheLayout/ipfix:cacheField/ipfix:ieName) = count(./ipfix:cache/ipfix:permanentCache/ipfix:cacheLayout/ipfix:cacheField/ipfix:ieName[
                                      text()='/hw:hardware-state/hw:component/bbf-cpu-rs:cpu-processor-data/bbf-cpu-rs:task-counts' or
                                      text()='/hw:hardware-state/hw:component/bbf-cpu-rs:cpu-processor-data/bbf-cpu-rs:number-of-active-sessions' or
                                      text()='/hw:hardware-state/hw:component/bbf-cpu-rs:cpu-processor-data/bbf-cpu-rs:task-counts/bbf-cpu-rs:total-tasks' or
                                      text()='/hw:hardware-state/hw:component/bbf-cpu-rs:cpu-processor-data/bbf-cpu-rs:task-counts/bbf-cpu-rs:running-tasks' or
                                      text()='/hw:hardware-state/hw:component/bbf-cpu-rs:cpu-processor-data/bbf-cpu-rs:task-counts/bbf-cpu-rs:sleeping-tasks' or
                                      text()='/hw:hardware-state/hw:component/bbf-cpu-rs:cpu-processor-data/bbf-cpu-rs:task-counts/bbf-cpu-rs:stopped-tasks' or
                                      text()='/hw:hardware-state/hw:component/bbf-cpu-rs:cpu-processor-data/bbf-cpu-rs:task-counts/bbf-cpu-rs:zombie-tasks' or
                                      text()='/bbf-mgmd:multicast-state' or
                                      text()='/bbf-mgmd:multicast-state/bbf-mgmd:mgmd' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/eth-mounted:Ethernet' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/nokia-sdan-if-mounted:all-unis' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/nokia-sdan-if-mounted:all-unis/nokia-sdan-if-mounted:ethernet' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/nokia-sdan-if-mounted:all-unis/nokia-sdan-if-mounted:ethernet/nokia-interfaces-performance-management-mounted:performance' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/nokia-sdan-if-mounted:all-unis/nokia-sdan-if-mounted:ethernet/nokia-interfaces-performance-management-mounted:performance/nokia-interfaces-performance-management-mounted:intervals-15min' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state/hw-mounted:component/bbf-sim-mounted:software' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state/hw-mounted:component/bbf-sim-mounted:software/bbf-sim-mounted:software/bbf-sim-mounted:revisions' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state/hw-mounted:component/nokia-cpu-pm-mgnt-mounted:performance' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state/hw-mounted:component/nokia-cpu-pm-mgnt-mounted:performance/nokia-cpu-pm-mgnt-mounted:intervals-15min' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state/hw-mounted:component/nokia-cpu-pm-mgnt-mounted:performance/nokia-cpu-pm-mgnt-mounted:intervals-24hr' or
                                      text()='/onu:onus/onu:onu/onu:root/bbf-sip-voip-mounted:pots-interworking-nodes-state' or
                                      text()='/onu:onus/onu:onu/onu:root/bbf-sip-voip-mounted:pots-interworking-nodes-state/bbf-sip-voip-mounted:pots-interworking/nokia-voice-pm-mounted:performance' or
                                      text()='/onu:onus/onu:onu/onu:root/bbf-sip-voip-mounted:pots-interworking-nodes-state/bbf-sip-voip-mounted:pots-interworking/nokia-voice-pm-mounted:performance/nokia-voice-pm-mounted:intervals-15min' or
                                      text()='/onu:onus/onu:onu/onu:root/bbf-xpongemtcont-mounted:xpongemtcont-state' or
                                      text()='/onu:onus/onu:onu/onu:root/bbf-xpongemtcont-mounted:xpongemtcont-state/bbf-xpongemtcont-mounted:gemports' or
                                      text()='/onu:onus/onu:onu/onu:root/bbf-xpongemtcont-mounted:xpongemtcont-state/bbf-xpongemtcont-mounted:gemports/bbf-xpongemtcont-mounted:gemport/bbf-xpongemtcont-gemport-pm-mounted:performance' or
                                      text()='/onu:onus/onu:onu/onu:root/bbf-xpongemtcont-mounted:xpongemtcont-state/bbf-xpongemtcont-mounted:gemports/bbf-xpongemtcont-mounted:gemport/bbf-xpongemtcont-gemport-pm-mounted:performance/bbf-xpongemtcont-gemport-pm-mounted:intervals-15min' or
                                      text()='/dot1q-cfm:cfm/dot1q-cfm:maintenance-group/dot1q-cfm:mep/nokia-cfm-loopback:loopback-transmit-session' or
                                      text()='/hw:hardware-state' or
                                      text()='/hw:hardware-state/hw:component/hw:state' or
                                      text()='/hw:hardware-state/hw:component/bbf-hw-xcvr:transceiver' or
                                      text()='/hw:hardware-state/hw:component/bbf-hw-xcvr:transceiver/bbf-hw-xcvr:identifiers-and-codes' or
                                      text()='/hw:hardware-state/hw:component/bbf-hw-xcvr:transceiver/bbf-hw-xcvr:identifiers-and-codes/bbf-hw-xcvr:compliance-codes' or
                                      text()='/hw:hardware-state/hw:component/bbf-hw-xcvr:transceiver-link' or
                                      text()='/if:interfaces-state' or
                                      text()='/if:interfaces-state/if:interface/bbf-if-pm:performance' or
                                      text()='/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-if-pm:intervals-15min' or
                                      text()='/if:interfaces-state/if:interface/bbf-xpon:channel-pair' or
                                      text()='/if:interfaces-state/if:interface/bbf-xpon:channel-termination' or
                                      text()='/if:interfaces-state/if:interface/bbf-xponvani:v-ani' or
                                      text()='/if:interfaces-state/if:interface/eth:Ethernet' or
                                      text()='/if:interfaces-state/if:interface/ip:ipv4' or
                                      text()='/if:interfaces-state/if:interface/ip:ipv6' or
                                      text()='/if:interfaces-state/if:interface/nokia-dot1x-ext:pae' or
                                      text()='/if:interfaces-state/if:interface/nokia-itf-tm:speed-monitoring' or
                                      text()='/if:interfaces-state/if:interface/nokia-queue-mon:tm-root' or
                                      text()='/if:interfaces-state/if:interface/nokia-queue-mon:tm-root/nokia-queue-mon:queue/nokia-queue-mon:performance' or
                                      text()='/if:interfaces-state/if:interface/nokia-queue-mon:tm-root/nokia-queue-mon:queue/nokia-queue-mon:performance/nokia-queue-mon:intervals-15min' or
                                      text()='/if:interfaces-state/if:interface/nokia-queue-mon:tm-root/nokia-queue-mon-ext:scheduler-node/nokia-queue-mon-ext:queue/nokia-queue-mon-ext:performance' or
                                      text()='/if:interfaces-state/if:interface/nokia-queue-mon:tm-root/nokia-queue-mon-ext:scheduler-node/nokia-queue-mon-ext:queue/nokia-queue-mon-ext:performance/nokia-queue-mon-ext:intervals-15min' or
                                      text()='/sys:system-state' or
                                      text()='/sys:system-state/sys:platform' or
                                      text()='/sys:system-state/nokia-ietf-system-aug:ntp-state' or
                                      text()='/lic-app:licensing-state'
                          ]))
   ]"/>




</xsl:stylesheet>