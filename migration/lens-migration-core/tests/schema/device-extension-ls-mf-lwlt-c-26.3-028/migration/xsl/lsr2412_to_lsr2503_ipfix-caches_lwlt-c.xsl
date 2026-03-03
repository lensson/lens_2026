<?xml version="1.0" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:ipfix="urn:ietf:params:xml:ns:yang:ietf-ipfix-psamp">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    <xsl:param name="ipfix_ns" select="'urn:ietf:params:xml:ns:yang:ietf-ipfix-psamp'" />





   <!-- Delete cacheField if underlying ieName is set to an unsupported xpath -->
   <xsl:template match="ipfix:ipfix/ipfix:cache/ipfix:permanentCache/ipfix:cacheLayout/ipfix:cacheField[
                          ipfix:ieName[
                                      text()='/bbf-mgmd:multicast-state/bbf-mgmd:mgmd/bbf-mgmd:multicast-vpn' or
                                      text()='/bbf-l2-fwd:forwarding-state' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/nokia-sdan-if-mounted:all-unis/nokia-sdan-if-mounted:ethernet/nokia-interfaces-performance-management-mounted:performance/nokia-interfaces-performance-management-mounted:intervals-15min/nokia-interfaces-performance-management-mounted:history' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state/hw-mounted:component' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state/hw-mounted:component/bbf-sim-mounted:software/bbf-sim-mounted:software' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state/hw-mounted:component/bbf-sim-mounted:software/bbf-sim-mounted:software/bbf-sim-mounted:revisions/bbf-sim-mounted:revision' or
                                      text()='/onu:onus/onu:onu/onu:root/bbf-sip-voip-mounted:pots-interworking-nodes-state/bbf-sip-voip-mounted:pots-interworking' or
                                      text()='/onu:onus/onu:onu/onu:root/bbf-xpongemtcont-mounted:xpongemtcont-state/bbf-xpongemtcont-mounted:gemports/bbf-xpongemtcont-mounted:gemport' or
                                      text()='/hw:hardware-state/hw:component' or
                                      text()='/if:interfaces-state/if:interface' or
                                      text()='/if:interfaces-state/if:interface/bbf-qos-pol-s:qos-policies' or
                                      text()='/if:interfaces-state/if:interface/ip:ipv4/ip:address' or
                                      text()='/if:interfaces-state/if:interface/ip:ipv6/ip:address' or
                                      text()='/if:interfaces-state/if:interface/nokia-itf-tm:speed-monitoring/nokia-itf-tm:data' or
                                      text()='/if:interfaces-state/if:interface/nokia-itf-tm:speed-monitoring/nokia-itf-tm:data/nokia-itf-tm:history' or
                                      text()='/if:interfaces-state/if:interface/nokia-itf-tm:speed-monitoring/nokia-itf-tm:data/nokia-itf-tm:history/nokia-itf-tm:top-utilized-child-interfaces' or
                                      text()='/if:interfaces-state/if:interface/nokia-queue-mon:tm-root/nokia-queue-mon:queue' or
                                      text()='/if:interfaces-state/if:interface/nokia-queue-mon:tm-root/nokia-queue-mon-ext:scheduler-node' or
                                      text()='/if:interfaces-state/if:interface/nokia-queue-mon:tm-root/nokia-queue-mon-ext:scheduler-node/nokia-queue-mon-ext:queue' or
                                      text()='/sys:system-state/nokia-radius:radius-statistics' or
                                      text()='/sys:system-state/nokia-ietf-system-aug:ntp-state/nokia-ietf-system-aug:peer' or
                                      text()='/lic-app:licensing-state/lic-app:features'
                          ]
   ]"/>



   <!-- Delete cache if the count of the underlying ieNames equals to the count of ieNames that contain
                unsupported xpaths, i.e, not even 1 supported xpath is present in the cache. -->
   <xsl:template match="ipfix:ipfix/ipfix:cache[
                          count(./ipfix:permanentCache/ipfix:cacheLayout/ipfix:cacheField/ipfix:ieName) > 0 and
                          count(./ipfix:permanentCache/ipfix:cacheLayout/ipfix:cacheField/ipfix:ieName) =
                          count(./ipfix:permanentCache/ipfix:cacheLayout/ipfix:cacheField/ipfix:ieName[
                                      text()='/bbf-mgmd:multicast-state/bbf-mgmd:mgmd/bbf-mgmd:multicast-vpn' or
                                      text()='/bbf-l2-fwd:forwarding-state' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/nokia-sdan-if-mounted:all-unis/nokia-sdan-if-mounted:ethernet/nokia-interfaces-performance-management-mounted:performance/nokia-interfaces-performance-management-mounted:intervals-15min/nokia-interfaces-performance-management-mounted:history' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state/hw-mounted:component' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state/hw-mounted:component/bbf-sim-mounted:software/bbf-sim-mounted:software' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state/hw-mounted:component/bbf-sim-mounted:software/bbf-sim-mounted:software/bbf-sim-mounted:revisions/bbf-sim-mounted:revision' or
                                      text()='/onu:onus/onu:onu/onu:root/bbf-sip-voip-mounted:pots-interworking-nodes-state/bbf-sip-voip-mounted:pots-interworking' or
                                      text()='/onu:onus/onu:onu/onu:root/bbf-xpongemtcont-mounted:xpongemtcont-state/bbf-xpongemtcont-mounted:gemports/bbf-xpongemtcont-mounted:gemport' or
                                      text()='/hw:hardware-state/hw:component' or
                                      text()='/if:interfaces-state/if:interface' or
                                      text()='/if:interfaces-state/if:interface/bbf-qos-pol-s:qos-policies' or
                                      text()='/if:interfaces-state/if:interface/ip:ipv4/ip:address' or
                                      text()='/if:interfaces-state/if:interface/ip:ipv6/ip:address' or
                                      text()='/if:interfaces-state/if:interface/nokia-itf-tm:speed-monitoring/nokia-itf-tm:data' or
                                      text()='/if:interfaces-state/if:interface/nokia-itf-tm:speed-monitoring/nokia-itf-tm:data/nokia-itf-tm:history' or
                                      text()='/if:interfaces-state/if:interface/nokia-itf-tm:speed-monitoring/nokia-itf-tm:data/nokia-itf-tm:history/nokia-itf-tm:top-utilized-child-interfaces' or
                                      text()='/if:interfaces-state/if:interface/nokia-queue-mon:tm-root/nokia-queue-mon:queue' or
                                      text()='/if:interfaces-state/if:interface/nokia-queue-mon:tm-root/nokia-queue-mon-ext:scheduler-node' or
                                      text()='/if:interfaces-state/if:interface/nokia-queue-mon:tm-root/nokia-queue-mon-ext:scheduler-node/nokia-queue-mon-ext:queue' or
                                      text()='/sys:system-state/nokia-radius:radius-statistics' or
                                      text()='/sys:system-state/nokia-ietf-system-aug:ntp-state/nokia-ietf-system-aug:peer' or
                                      text()='/lic-app:licensing-state/lic-app:features'
                          ])
   ]"/>


   <!-- xsl rule to remove ipfix elements -->
   <xsl:template match="ipfix:ipfix[
                          count(./ipfix:randomize-data-collection) = 0 and
                          count(./ipfix:ipfix-exporting-enable) = 0 and
                          count(./exportingProcess) = 0 and
                          (count(./ipfix:cache) = 0 or
                          count(./ipfix:cache/ipfix:permanentCache/ipfix:cacheLayout/ipfix:cacheField/ipfix:ieName) > 0 and
                          count(./ipfix:cache/ipfix:permanentCache/ipfix:cacheLayout/ipfix:cacheField/ipfix:ieName) = count(./ipfix:cache/ipfix:permanentCache/ipfix:cacheLayout/ipfix:cacheField/ipfix:ieName[
                                      text()='/bbf-mgmd:multicast-state/bbf-mgmd:mgmd/bbf-mgmd:multicast-vpn' or
                                      text()='/bbf-l2-fwd:forwarding-state' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/nokia-sdan-if-mounted:all-unis/nokia-sdan-if-mounted:ethernet/nokia-interfaces-performance-management-mounted:performance/nokia-interfaces-performance-management-mounted:intervals-15min/nokia-interfaces-performance-management-mounted:history' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state/hw-mounted:component' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state/hw-mounted:component/bbf-sim-mounted:software/bbf-sim-mounted:software' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state/hw-mounted:component/bbf-sim-mounted:software/bbf-sim-mounted:software/bbf-sim-mounted:revisions/bbf-sim-mounted:revision' or
                                      text()='/onu:onus/onu:onu/onu:root/bbf-sip-voip-mounted:pots-interworking-nodes-state/bbf-sip-voip-mounted:pots-interworking' or
                                      text()='/onu:onus/onu:onu/onu:root/bbf-xpongemtcont-mounted:xpongemtcont-state/bbf-xpongemtcont-mounted:gemports/bbf-xpongemtcont-mounted:gemport' or
                                      text()='/hw:hardware-state/hw:component' or
                                      text()='/if:interfaces-state/if:interface' or
                                      text()='/if:interfaces-state/if:interface/bbf-qos-pol-s:qos-policies' or
                                      text()='/if:interfaces-state/if:interface/ip:ipv4/ip:address' or
                                      text()='/if:interfaces-state/if:interface/ip:ipv6/ip:address' or
                                      text()='/if:interfaces-state/if:interface/nokia-itf-tm:speed-monitoring/nokia-itf-tm:data' or
                                      text()='/if:interfaces-state/if:interface/nokia-itf-tm:speed-monitoring/nokia-itf-tm:data/nokia-itf-tm:history' or
                                      text()='/if:interfaces-state/if:interface/nokia-itf-tm:speed-monitoring/nokia-itf-tm:data/nokia-itf-tm:history/nokia-itf-tm:top-utilized-child-interfaces' or
                                      text()='/if:interfaces-state/if:interface/nokia-queue-mon:tm-root/nokia-queue-mon:queue' or
                                      text()='/if:interfaces-state/if:interface/nokia-queue-mon:tm-root/nokia-queue-mon-ext:scheduler-node' or
                                      text()='/if:interfaces-state/if:interface/nokia-queue-mon:tm-root/nokia-queue-mon-ext:scheduler-node/nokia-queue-mon-ext:queue' or
                                      text()='/sys:system-state/nokia-radius:radius-statistics' or
                                      text()='/sys:system-state/nokia-ietf-system-aug:ntp-state/nokia-ietf-system-aug:peer' or
                                      text()='/lic-app:licensing-state/lic-app:features'
                          ]))
   ]"/>




</xsl:stylesheet>