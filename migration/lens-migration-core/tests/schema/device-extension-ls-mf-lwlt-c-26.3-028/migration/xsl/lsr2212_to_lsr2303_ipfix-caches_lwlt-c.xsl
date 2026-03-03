<?xml version="1.0" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:ipfix="urn:ietf:params:xml:ns:yang:ietf-ipfix-psamp">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    <xsl:param name="ipfix_ns" select="'urn:ietf:params:xml:ns:yang:ietf-ipfix-psamp'" />
   <!-- default rule -->
   <xsl:template match="*">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>





   <!-- Delete cacheField if underlying ieName is set to an unsupported xpath -->
   <xsl:template match="ipfix:ipfix/ipfix:cache/ipfix:permanentCache/ipfix:cacheLayout/ipfix:cacheField[
                          ipfix:ieName[
                                      text()='/if:interfaces-state/if:interface/bbf-xponvani:v-ani/bbf-xponvani:onu-present-on-this-olt/bbf-xponvani:onu-present-on-this-channel-termination' or
                                      text()='/if:interfaces-state/if:interface/bbf-xponvani:v-ani/bbf-xponvani:onu-present-on-this-olt/bbf-xponvani:onu-present-on-this-channel-pair' or
                                      text()='/hw:hardware-state/hw:component/nokia-hw-ext:ont-serial-num-base' or
                                      text()='/hw:hardware-state/hw:component/nokia-hw-ext:fim' or
                                      text()='/hw:hardware-state/hw:component/nokia-hw-ext:factory-id ' or
                                      text()='/hw:hardware-state/hw:component/nokia-hw-ext:customer-serial-num' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state/hw-mounted:component/hw-mounted:software-rev' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state/hw-mounted:component/hw-mounted:state/hw-mounted:oper-state' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state/hw-mounted:component/hw-mounted:state/hw-mounted:admin-state' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state/hw-mounted:component/bbf-hw-xcvr-mounted:transceiver-link/bbf-hw-xcvr-mounted:diagnostics/bbf-hw-xcvr-mounted:tec-current' or
                                      text()='/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-if-pm:intervals-15min/bbf-if-pm:history/bbf-if-pm:in-unknown-protos' or
                                      text()='/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-if-pm:intervals-15min/bbf-if-pm:history/bbf-if-pm:in-errors' or
                                      text()='/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-if-pm:intervals-15min/bbf-if-pm:history/bbf-if-pm:out-errors' or
                                      text()='/bbf-mgmd:multicast-state/bbf-mgmd:mgmd/bbf-mgmd:multicast-vpn/bbf-mgmd:multicast-interface-to-host/bbf-mgmd:current-multicast-bw-delivered' or
                                      text()='/bbf-mgmd:multicast-state/bbf-mgmd:mgmd/bbf-mgmd:multicast-vpn/bbf-mgmd:multicast-interface-to-host/bbf-mgmd:multicast-rate-limit-exceeded-count' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-pppoe-ia:pppoe/bbf-pppoe-ia:in-error-packets-from-server' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-pppoe-ia:pppoe/bbf-pppoe-ia:in-packets-from-server' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-pppoe-ia:pppoe/bbf-pppoe-ia:out-packets-to-client' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-pppoe-ia:pppoe/bbf-pppoe-ia:vendor-specific-tag-removed-packets-to-client' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:upstream/bbf-icmpv6:router-solicitation/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:upstream/bbf-icmpv6:router-advertisement/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:upstream/bbf-icmpv6:neighbour-advertisement/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:upstream/bbf-icmpv6:neighbour-solicitation/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:upstream/bbf-icmpv6:router-redirect/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:upstream/bbf-icmpv6:multicast-listener-query/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:upstream/bbf-icmpv6:error-message/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:upstream/bbf-icmpv6:informational-message/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:upstream/bbf-icmpv6:invalid-message/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:downstream/bbf-icmpv6:router-solicitation/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:downstream/bbf-icmpv6:router-advertisement/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:downstream/bbf-icmpv6:neighbour-advertisement/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:downstream/bbf-icmpv6:neighbour-solicitation/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:downstream/bbf-icmpv6:router-redirect/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:downstream/bbf-icmpv6:multicast-listener-query/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:downstream/bbf-icmpv6:error-message/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:downstream/bbf-icmpv6:informational-message/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:downstream/bbf-icmpv6:invalid-message/bbf-icmpv6:forward-packets' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-$pon-pm-mounted:xpon/bbf-xpon-pm-mounted:utilization/bbf-xpon-pm-mounted:out-bytes-non-idle-xgem-frames' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-$pon-pm-mounted:xpon/bbf-xpon-pm-mounted:utilization/bbf-xpon-pm-mounted:in-bytes-non-idle-xgem-frames' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-$pon-pm-mounted:xpon/bbf-xpon-pm-mounted:lods/bbf-xpon-pm-mounted:total-events' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-$pon-pm-mounted:xpon/bbf-xpon-pm-mounted:lods/bbf-xpon-pm-mounted:restored/bbf-xpon-pm-mounted:operating-twdm' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-$pon-pm-mounted:xpon/bbf-xpon-pm-mounted:lods/bbf-xpon-pm-mounted:onu-reactivation/bbf-xpon-pm-mounted:no-sync-reacquired'
                          ]
   ]"/>



   <!-- Delete cache if the count of the underlying ieNames equals to the count of ieNames that contain
                unsupported xpaths, i.e, not even 1 supported xpath is present in the cache. -->
   <xsl:template match="ipfix:ipfix/ipfix:cache[
                          count(./ipfix:permanentCache/ipfix:cacheLayout/ipfix:cacheField/ipfix:ieName) > 0 and
                          count(./ipfix:permanentCache/ipfix:cacheLayout/ipfix:cacheField/ipfix:ieName) =
                          count(./ipfix:permanentCache/ipfix:cacheLayout/ipfix:cacheField/ipfix:ieName[
                                      text()='/if:interfaces-state/if:interface/bbf-xponvani:v-ani/bbf-xponvani:onu-present-on-this-olt/bbf-xponvani:onu-present-on-this-channel-termination' or
                                      text()='/if:interfaces-state/if:interface/bbf-xponvani:v-ani/bbf-xponvani:onu-present-on-this-olt/bbf-xponvani:onu-present-on-this-channel-pair' or
                                      text()='/hw:hardware-state/hw:component/nokia-hw-ext:ont-serial-num-base' or
                                      text()='/hw:hardware-state/hw:component/nokia-hw-ext:fim' or
                                      text()='/hw:hardware-state/hw:component/nokia-hw-ext:factory-id ' or
                                      text()='/hw:hardware-state/hw:component/nokia-hw-ext:customer-serial-num' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state/hw-mounted:component/hw-mounted:software-rev' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state/hw-mounted:component/hw-mounted:state/hw-mounted:oper-state' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state/hw-mounted:component/hw-mounted:state/hw-mounted:admin-state' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state/hw-mounted:component/bbf-hw-xcvr-mounted:transceiver-link/bbf-hw-xcvr-mounted:diagnostics/bbf-hw-xcvr-mounted:tec-current' or
                                      text()='/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-if-pm:intervals-15min/bbf-if-pm:history/bbf-if-pm:in-unknown-protos' or
                                      text()='/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-if-pm:intervals-15min/bbf-if-pm:history/bbf-if-pm:in-errors' or
                                      text()='/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-if-pm:intervals-15min/bbf-if-pm:history/bbf-if-pm:out-errors' or
                                      text()='/bbf-mgmd:multicast-state/bbf-mgmd:mgmd/bbf-mgmd:multicast-vpn/bbf-mgmd:multicast-interface-to-host/bbf-mgmd:current-multicast-bw-delivered' or
                                      text()='/bbf-mgmd:multicast-state/bbf-mgmd:mgmd/bbf-mgmd:multicast-vpn/bbf-mgmd:multicast-interface-to-host/bbf-mgmd:multicast-rate-limit-exceeded-count' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-pppoe-ia:pppoe/bbf-pppoe-ia:in-error-packets-from-server' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-pppoe-ia:pppoe/bbf-pppoe-ia:in-packets-from-server' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-pppoe-ia:pppoe/bbf-pppoe-ia:out-packets-to-client' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-pppoe-ia:pppoe/bbf-pppoe-ia:vendor-specific-tag-removed-packets-to-client' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:upstream/bbf-icmpv6:router-solicitation/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:upstream/bbf-icmpv6:router-advertisement/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:upstream/bbf-icmpv6:neighbour-advertisement/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:upstream/bbf-icmpv6:neighbour-solicitation/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:upstream/bbf-icmpv6:router-redirect/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:upstream/bbf-icmpv6:multicast-listener-query/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:upstream/bbf-icmpv6:error-message/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:upstream/bbf-icmpv6:informational-message/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:upstream/bbf-icmpv6:invalid-message/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:downstream/bbf-icmpv6:router-solicitation/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:downstream/bbf-icmpv6:router-advertisement/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:downstream/bbf-icmpv6:neighbour-advertisement/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:downstream/bbf-icmpv6:neighbour-solicitation/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:downstream/bbf-icmpv6:router-redirect/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:downstream/bbf-icmpv6:multicast-listener-query/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:downstream/bbf-icmpv6:error-message/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:downstream/bbf-icmpv6:informational-message/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:downstream/bbf-icmpv6:invalid-message/bbf-icmpv6:forward-packets' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-$pon-pm-mounted:xpon/bbf-xpon-pm-mounted:utilization/bbf-xpon-pm-mounted:out-bytes-non-idle-xgem-frames' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-$pon-pm-mounted:xpon/bbf-xpon-pm-mounted:utilization/bbf-xpon-pm-mounted:in-bytes-non-idle-xgem-frames' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-$pon-pm-mounted:xpon/bbf-xpon-pm-mounted:lods/bbf-xpon-pm-mounted:total-events' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-$pon-pm-mounted:xpon/bbf-xpon-pm-mounted:lods/bbf-xpon-pm-mounted:restored/bbf-xpon-pm-mounted:operating-twdm' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-$pon-pm-mounted:xpon/bbf-xpon-pm-mounted:lods/bbf-xpon-pm-mounted:onu-reactivation/bbf-xpon-pm-mounted:no-sync-reacquired'
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
                                      text()='/if:interfaces-state/if:interface/bbf-xponvani:v-ani/bbf-xponvani:onu-present-on-this-olt/bbf-xponvani:onu-present-on-this-channel-termination' or
                                      text()='/if:interfaces-state/if:interface/bbf-xponvani:v-ani/bbf-xponvani:onu-present-on-this-olt/bbf-xponvani:onu-present-on-this-channel-pair' or
                                      text()='/hw:hardware-state/hw:component/nokia-hw-ext:ont-serial-num-base' or
                                      text()='/hw:hardware-state/hw:component/nokia-hw-ext:fim' or
                                      text()='/hw:hardware-state/hw:component/nokia-hw-ext:factory-id ' or
                                      text()='/hw:hardware-state/hw:component/nokia-hw-ext:customer-serial-num' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state/hw-mounted:component/hw-mounted:software-rev' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state/hw-mounted:component/hw-mounted:state/hw-mounted:oper-state' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state/hw-mounted:component/hw-mounted:state/hw-mounted:admin-state' or
                                      text()='/onu:onus/onu:onu/onu:root/hw-mounted:hardware-state/hw-mounted:component/bbf-hw-xcvr-mounted:transceiver-link/bbf-hw-xcvr-mounted:diagnostics/bbf-hw-xcvr-mounted:tec-current' or
                                      text()='/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-if-pm:intervals-15min/bbf-if-pm:history/bbf-if-pm:in-unknown-protos' or
                                      text()='/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-if-pm:intervals-15min/bbf-if-pm:history/bbf-if-pm:in-errors' or
                                      text()='/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-if-pm:intervals-15min/bbf-if-pm:history/bbf-if-pm:out-errors' or
                                      text()='/bbf-mgmd:multicast-state/bbf-mgmd:mgmd/bbf-mgmd:multicast-vpn/bbf-mgmd:multicast-interface-to-host/bbf-mgmd:current-multicast-bw-delivered' or
                                      text()='/bbf-mgmd:multicast-state/bbf-mgmd:mgmd/bbf-mgmd:multicast-vpn/bbf-mgmd:multicast-interface-to-host/bbf-mgmd:multicast-rate-limit-exceeded-count' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-pppoe-ia:pppoe/bbf-pppoe-ia:in-error-packets-from-server' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-pppoe-ia:pppoe/bbf-pppoe-ia:in-packets-from-server' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-pppoe-ia:pppoe/bbf-pppoe-ia:out-packets-to-client' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-pppoe-ia:pppoe/bbf-pppoe-ia:vendor-specific-tag-removed-packets-to-client' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:upstream/bbf-icmpv6:router-solicitation/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:upstream/bbf-icmpv6:router-advertisement/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:upstream/bbf-icmpv6:neighbour-advertisement/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:upstream/bbf-icmpv6:neighbour-solicitation/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:upstream/bbf-icmpv6:router-redirect/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:upstream/bbf-icmpv6:multicast-listener-query/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:upstream/bbf-icmpv6:error-message/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:upstream/bbf-icmpv6:informational-message/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:upstream/bbf-icmpv6:invalid-message/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:downstream/bbf-icmpv6:router-solicitation/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:downstream/bbf-icmpv6:router-advertisement/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:downstream/bbf-icmpv6:neighbour-advertisement/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:downstream/bbf-icmpv6:neighbour-solicitation/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:downstream/bbf-icmpv6:router-redirect/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:downstream/bbf-icmpv6:multicast-listener-query/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:downstream/bbf-icmpv6:error-message/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:downstream/bbf-icmpv6:informational-message/bbf-icmpv6:forward-packets' or
                                      text()='/if:interfaces-state/if:interface/if:statistics/bbf-icmpv6:icmpv6-stats/bbf-icmpv6:downstream/bbf-icmpv6:invalid-message/bbf-icmpv6:forward-packets' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-$pon-pm-mounted:xpon/bbf-xpon-pm-mounted:utilization/bbf-xpon-pm-mounted:out-bytes-non-idle-xgem-frames' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-$pon-pm-mounted:xpon/bbf-xpon-pm-mounted:utilization/bbf-xpon-pm-mounted:in-bytes-non-idle-xgem-frames' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-$pon-pm-mounted:xpon/bbf-xpon-pm-mounted:lods/bbf-xpon-pm-mounted:total-events' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-$pon-pm-mounted:xpon/bbf-xpon-pm-mounted:lods/bbf-xpon-pm-mounted:restored/bbf-xpon-pm-mounted:operating-twdm' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-$pon-pm-mounted:xpon/bbf-xpon-pm-mounted:lods/bbf-xpon-pm-mounted:onu-reactivation/bbf-xpon-pm-mounted:no-sync-reacquired'
                          ]))
   ]"/>




</xsl:stylesheet>