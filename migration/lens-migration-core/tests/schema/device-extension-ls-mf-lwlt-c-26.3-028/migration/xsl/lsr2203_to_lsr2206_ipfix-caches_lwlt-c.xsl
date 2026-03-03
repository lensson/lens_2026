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


   <!-- xsl rule to migrate an existing configured counter which has changed its xpath -->
   <xsl:template match="ipfix:ipfix/ipfix:cache/ipfix:permanentCache/ipfix:cacheLayout/ipfix:cacheField/ipfix:ieName">
       <xsl:choose>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/if:statistics/nokia-xpon-stats:pon-stats'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/if:statistics/nokia-xpon-stats:xpon</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/if:statistics/nokia-xpon-stats:pon-stats/nokia-xpon-stats:in-total-drop-bytes'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/if:statistics/nokia-add-stats:in-dropped-bytes</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/if:statistics/nokia-xpon-stats:pon-stats/nokia-xpon-stats:out-total-drop-bytes'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/if:statistics/nokia-add-stats:out-dropped-bytes</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/if:statistics/nokia-xpon-stats:pon-stats/nokia-xpon-stats:incidental-broadcast-gem-port-bytes'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/if:statistics/nokia-xpon-stats:xpon/nokia-xpon-stats:out-incidental-broadcast-gem-port-bytes</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/if:statistics/nokia-xpon-stats:pon-stats/nokia-xpon-stats:incidental-broadcast-gem-port-packets'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/if:statistics/nokia-xpon-stats:xpon/nokia-xpon-stats:out-incidental-broadcast-gem-port-packets</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/if:statistics/nokia-xpon-stats:pon-stats/nokia-xpon-stats:incidental-broadcast-gem-port-drop-bytes'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/if:statistics/nokia-xpon-stats:xpon/nokia-xpon-stats:out-incidental-broadcast-gem-port-dropped-bytes</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/if:statistics/nokia-xpon-stats:pon-stats/nokia-xpon-stats:incidental-broadcast-gem-port-drop-packets'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/if:statistics/nokia-xpon-stats:xpon/nokia-xpon-stats:out-incidental-broadcast-gem-port-dropped-packets</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/if:statistics/nokia-xpon-stats:pon-stats/nokia-xpon-stats:multicast-gem-port-bytes'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/if:statistics/nokia-xpon-stats:xpon/nokia-xpon-stats:out-multicast-gem-port-bytes</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/if:statistics/nokia-xpon-stats:pon-stats/nokia-xpon-stats:multicast-gem-port-packets'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/if:statistics/nokia-xpon-stats:xpon/nokia-xpon-stats:out-multicast-gem-port-packets</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/if:statistics/nokia-xpon-stats:pon-stats/nokia-xpon-stats:multicast-gem-port-drop-bytes'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/if:statistics/nokia-xpon-stats:xpon/nokia-xpon-stats:out-multicast-gem-port-dropped-bytes</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/if:statistics/nokia-xpon-stats:pon-stats/nokia-xpon-stats:multicast-gem-port-drop-packets'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/if:statistics/nokia-xpon-stats:xpon/nokia-xpon-stats:out-multicast-gem-port-dropped-packets</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/if:statistics/nokia-xpon-stats:pon-stats/nokia-xpon-stats:out-unicast-gem-port-bytes'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/if:statistics/nokia-xpon-stats:xpon/nokia-xpon-stats:out-unicast-gem-port-bytes</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/if:statistics/nokia-xpon-stats:pon-stats/nokia-xpon-stats:out-unicast-gem-port-packets'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/if:statistics/nokia-xpon-stats:xpon/nokia-xpon-stats:out-unicast-gem-port-packets</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/if:statistics/nokia-xpon-stats:pon-stats/nokia-xpon-stats:out-unicast-gem-port-drop-bytes'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/if:statistics/nokia-xpon-stats:xpon/nokia-xpon-stats:out-unicast-gem-port-dropped-bytes</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/if:statistics/nokia-xpon-stats:pon-stats/nokia-xpon-stats:out-unicast-gem-port-drop-packets'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/if:statistics/nokia-xpon-stats:xpon/nokia-xpon-stats:out-unicast-gem-port-dropped-packets</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/hw:hardware-state/hw:component/bbf-hw-xcvr:transceiver-link/bbf-hw-xcvr:diagnostics/xponinfraAug:rssi-onu/xponinfraAug:detected-serial-number'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/hw:hardware-state/hw:component/bbf-hw-xcvr:transceiver-link/bbf-hw-xcvr:diagnostics/nokia-sdan-hws-xcvr-diagnostics-aug:rssi-onu/nokia-sdan-hws-xcvr-diagnostics-aug:detected-serial-number</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/hw:hardware-state/hw:component/bbf-hw-xcvr:transceiver-link/bbf-hw-xcvr:diagnostics/xponinfraAug:rssi-onu/xponinfraAug:rssi'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/hw:hardware-state/hw:component/bbf-hw-xcvr:transceiver-link/bbf-hw-xcvr:diagnostics/nokia-sdan-hws-xcvr-diagnostics-aug:rssi-onu/nokia-sdan-hws-xcvr-diagnostics-aug:rssi</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/hw:hardware-state/hw:component/bbf-hw-xcvr:transceiver-link/bbf-hw-xcvr:diagnostics/xponinfraAug:rssi-onu/xponinfraAug:v-ani-ref'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/hw:hardware-state/hw:component/bbf-hw-xcvr:transceiver-link/bbf-hw-xcvr:diagnostics/nokia-sdan-hws-xcvr-diagnostics-aug:rssi-onu/nokia-sdan-hws-xcvr-diagnostics-aug:v-ani-ref</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-xpon:channel-termination/bbf-xpon-onu-states:onus-present-on-local-channel-termination/bbf-xpon-onu-states:onu/xponinfraAug:detected-upstream-rate'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-xpon:channel-termination/bbf-xpon-onu-s:onus-present-on-local-channel-termination/bbf-xpon-onu-s:onu/nokia-sdan-xpon-onu-state-aug:detected-upstream-rate</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-xpon:channel-termination/bbf-xpon-onu-states:onus-present-on-local-channel-termination/bbf-xpon-onu-states:onu/bbf-xpon-onu-states:detected-serial-number'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-xpon:channel-termination/bbf-xpon-onu-s:onus-present-on-local-channel-termination/bbf-xpon-onu-s:onu/bbf-xpon-onu-s:detected-serial-number</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-xpon:channel-termination/bbf-xpon-onu-states:onus-present-on-local-channel-termination/bbf-xpon-onu-states:onu/bbf-xpon-onu-states:onu-state'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-xpon:channel-termination/bbf-xpon-onu-s:onus-present-on-local-channel-termination/bbf-xpon-onu-s:onu/bbf-xpon-onu-s:onu-presence-state</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-xpon:channel-termination/bbf-xpon-onu-states:onus-present-on-local-channel-termination/bbf-xpon-onu-states:onu/bbf-xpon-onu-states:onu-id'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-xpon:channel-termination/bbf-xpon-onu-s:onus-present-on-local-channel-termination/bbf-xpon-onu-s:onu/bbf-xpon-onu-s:onu-id</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-xpon:channel-termination/bbf-xpon-onu-states:onus-present-on-local-channel-termination/bbf-xpon-onu-states:onu/bbf-xpon-onu-states:detected-registration-id'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-xpon:channel-termination/bbf-xpon-onu-s:onus-present-on-local-channel-termination/bbf-xpon-onu-s:onu/bbf-xpon-onu-s:detected-registration-id</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-xpon:channel-termination/bbf-xpon-onu-states:onus-present-on-local-channel-termination/bbf-xpon-onu-states:onu/bbf-xpon-onu-states:v-ani-ref'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-xpon:channel-termination/bbf-xpon-onu-s:onus-present-on-local-channel-termination/bbf-xpon-onu-s:onu/bbf-xpon-onu-s:v-ani-ref</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-xpon:channel-termination/bbf-xpon-onu-states:onus-present-on-local-channel-termination/bbf-xpon-onu-states:onu/bbf-xpon-onu-states:onu-detected-datetime'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-xpon:channel-termination/bbf-xpon-onu-s:onus-present-on-local-channel-termination/bbf-xpon-onu-s:onu/bbf-xpon-onu-s:onu-detected-datetime</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-xpon:channel-termination/bbf-xpon-onu-states:onus-present-on-local-channel-termination/bbf-xpon-onu-states:onu/bbf-xpon-onu-states:onu-state-last-change'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-xpon:channel-termination/bbf-xpon-onu-s:onus-present-on-local-channel-termination/bbf-xpon-onu-s:onu/bbf-xpon-onu-s:onu-state-last-change</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-xponcommon-pm:xpon-fec-pm/bbf-xponcommon-pm:intervals-15min/bbf-xponcommon-pm:number-of-intervals'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-if-pm:intervals-15min/bbf-if-pm:number-of-intervals</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-xponcommon-pm:xpon-fec-pm/bbf-xponcommon-pm:intervals-15min/bbf-xponcommon-pm:non-valid-intervals'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-if-pm:intervals-15min/bbf-if-pm:non-valid-intervals</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-xponcommon-pm:xpon-fec-pm/bbf-xponcommon-pm:intervals-15min/bbf-xponcommon-pm:history/bbf-xponcommon-pm:interval-number'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-if-pm:intervals-15min/bbf-if-pm:history/bbf-if-pm:interval-number</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-xponcommon-pm:xpon-fec-pm/bbf-xponcommon-pm:intervals-15min/bbf-xponcommon-pm:history/bbf-xponcommon-pm:measured-time'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-if-pm:intervals-15min/bbf-if-pm:history/bbf-if-pm:measured-time</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-xponcommon-pm:xpon-fec-pm/bbf-xponcommon-pm:intervals-15min/bbf-xponcommon-pm:history/bbf-xponcommon-pm:invalid-data-flag'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-if-pm:intervals-15min/bbf-if-pm:history/bbf-if-pm:invalid-data-flag</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-xponcommon-pm:xpon-fec-pm/bbf-xponcommon-pm:intervals-15min/bbf-xponcommon-pm:history/bbf-xponcommon-pm:time-stamp'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-if-pm:intervals-15min/bbf-if-pm:history/bbf-if-pm:time-stamp</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-xponcommon-pm:xpon-fec-pm/bbf-xponcommon-pm:intervals-15min/bbf-xponcommon-pm:history/bbf-xponcommon-pm:corrected-bytes'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-if-pm:intervals-15min/bbf-if-pm:history/bbf-xpon-pm:xpon/bbf-xpon-pm:phy/bbf-xpon-pm:corrected-fec-bytes</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-xponcommon-pm:xpon-fec-pm/bbf-xponcommon-pm:intervals-15min/bbf-xponcommon-pm:history/bbf-xponcommon-pm:corrected-code-words'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-if-pm:intervals-15min/bbf-if-pm:history/bbf-xpon-pm:xpon/bbf-xpon-pm:phy/bbf-xpon-pm:corrected-fec-codewords</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-xponcommon-pm:xpon-fec-pm/bbf-xponcommon-pm:intervals-15min/bbf-xponcommon-pm:history/bbf-xponcommon-pm:uncorrectable-code-words'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-if-pm:intervals-15min/bbf-if-pm:history/bbf-xpon-pm:xpon/bbf-xpon-pm:phy/bbf-xpon-pm:uncorrectable-fec-codewords</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-xponcommon-pm:xpon-fec-pm/bbf-xponcommon-pm:intervals-15min/bbf-xponcommon-pm:history/bbf-xponcommon-pm:total-code-words'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-if-pm:intervals-15min/bbf-if-pm:history/bbf-xpon-pm:xpon/bbf-xpon-pm:phy/bbf-xpon-pm:in-fec-codewords</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-xponcommon-pm:xpon-fec-pm/bbf-xponcommon-pm:intervals-15min/bbf-xponcommon-pm:history/bbf-xponcommon-pm:fec-seconds'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-if-pm:intervals-15min/bbf-if-pm:history/bbf-xpon-pm:xpon/bbf-xpon-pm:phy/bbf-xpon-pm:fec-seconds</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-xponcommon-pm:xpon-bip-pm/bbf-xponcommon-pm:intervals-15min/bbf-xponcommon-pm:history/bbf-xponcommon-pm:received-bip32-prot-words'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-if-pm:intervals-15min/bbf-if-pm:history/bbf-xpon-pm:xpon/bbf-xpon-pm:phy/bbf-xpon-pm:in-bip-protected-words</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-xponcommon-pm:xpon-bip-pm/bbf-xponcommon-pm:intervals-15min/bbf-xponcommon-pm:history/bbf-xponcommon-pm:received-bip32-errors'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-if-pm:intervals-15min/bbf-if-pm:history/bbf-xpon-pm:xpon/bbf-xpon-pm:phy/bbf-xpon-pm:in-bip-errors</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-xponcommon-pm:xpon-bip-pm/bbf-xponcommon-pm:intervals-15min/bbf-xponcommon-pm:number-of-intervals'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-if-pm:intervals-15min/bbf-if-pm:number-of-intervals</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-xponcommon-pm:xpon-bip-pm/bbf-xponcommon-pm:intervals-15min/bbf-xponcommon-pm:non-valid-intervals'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-if-pm:intervals-15min/bbf-if-pm:non-valid-intervals</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-xponcommon-pm:xpon-bip-pm/bbf-xponcommon-pm:intervals-15min/bbf-xponcommon-pm:history/bbf-xponcommon-pm:interval-number'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-if-pm:intervals-15min/bbf-if-pm:history/bbf-if-pm:interval-number</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-xponcommon-pm:xpon-bip-pm/bbf-xponcommon-pm:intervals-15min/bbf-xponcommon-pm:history/bbf-xponcommon-pm:measured-time'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-if-pm:intervals-15min/bbf-if-pm:history/bbf-if-pm:measured-time</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-xponcommon-pm:xpon-bip-pm/bbf-xponcommon-pm:intervals-15min/bbf-xponcommon-pm:history/bbf-xponcommon-pm:invalid-data-flag'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-if-pm:intervals-15min/bbf-if-pm:history/bbf-if-pm:invalid-data-flag</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-xponcommon-pm:xpon-bip-pm/bbf-xponcommon-pm:intervals-15min/bbf-xponcommon-pm:history/bbf-xponcommon-pm:time-stamp'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-if-pm:intervals-15min/bbf-if-pm:history/bbf-if-pm:time-stamp</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-xponvani:v-ani/bbf-xponvani:onu-tuned-on-this-olt/bbf-xponvani:onu-tuned-on-this-channel-pair'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-xponvani:v-ani/bbf-xponvani:onu-present-on-this-olt/bbf-xponvani:onu-present-on-this-channel-pair</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-xponvani:v-ani/bbf-xponvani:onu-tuned-on-this-olt/bbf-xponvani:onu-tuned-on-this-channel-termination'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-xponvani:v-ani/bbf-xponvani:onu-present-on-this-olt/bbf-xponvani:onu-present-on-this-channel-termination</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-xponvani:v-ani/bbf-xponvani-onu-states:onu-state'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-xponvani:v-ani/bbf-xponvani:onu-presence-state</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-xponvani:v-ani/xponinfraAug:detected-serial-number'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-xponvani:v-ani/bbf-xponvani:onu-present-on-this-olt/bbf-xponvani:detected-serial-number</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-xponvani:v-ani/xponinfraAug:detected-registration-id'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-xponvani:v-ani/bbf-xponvani:onu-present-on-this-olt/bbf-xponvani:detected-registration-id</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-xpon:channel-termination/bbf-xpon-onu-states:onus-present-on-local-channel-termination/bbf-xpon-onu-states:onu/xponinfraAug:fiber-distance'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-xponvani:v-ani/bbf-xponvani:onu-present-on-this-olt/bbf-xponvani:onu-fiber-distance</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-xpon:channel-group/bbf-xpon:downstream-wavelength-already-allocated/bbf-xpon:downstream-wavelength'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-xpon:channel-group/bbf-xpon:allocated-downstream-wavelengths/bbf-xpon:wavelength</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-xpon:channel-termination/bbf-xpon-onu-states:onus-present-on-local-channel-termination/bbf-xpon-onu-states:onu'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-xpon:channel-termination/bbf-xpon-onu-s:onus-present-on-local-channel-termination/bbf-xpon-onu-s:onu</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-xponvani:v-ani/bbf-xponvani:onu-tuned-on-this-olt'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-xponvani:v-ani/bbf-xponvani:onu-present-on-this-olt</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-xpon:channel-group/bbf-xpon:downstream-wavelength-already-allocated'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-xpon:channel-group/bbf-xpon:allocated-downstream-wavelengths</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-xponcommon-pm-mounted:xpon-fec-pm/bbf-xponcommon-pm-mounted:intervals-15min/bbf-xponcommon-pm-mounted:number-of-intervals'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:number-of-intervals</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-xponcommon-pm-mounted:xpon-fec-pm/bbf-xponcommon-pm-mounted:intervals-15min/bbf-xponcommon-pm-mounted:non-valid-intervals'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:non-valid-intervals</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-xponcommon-pm-mounted:xpon-fec-pm/bbf-xponcommon-pm-mounted:intervals-15min/bbf-xponcommon-pm-mounted:history/bbf-xponcommon-pm-mounted:interval-number'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-if-pm-mounted:interval-number</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-xponcommon-pm-mounted:xpon-fec-pm/bbf-xponcommon-pm-mounted:intervals-15min/bbf-xponcommon-pm-mounted:history/bbf-xponcommon-pm-mounted:measured-time'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-if-pm-mounted:measured-time</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-xponcommon-pm-mounted:xpon-fec-pm/bbf-xponcommon-pm-mounted:intervals-15min/bbf-xponcommon-pm-mounted:history/bbf-xponcommon-pm-mounted:invalid-data-flag'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-if-pm-mounted:invalid-data-flag</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-xponcommon-pm-mounted:xpon-fec-pm/bbf-xponcommon-pm-mounted:intervals-15min/bbf-xponcommon-pm-mounted:history/bbf-xponcommon-pm-mounted:time-stamp'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-if-pm-mounted:time-stamp</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-xponcommon-pm-mounted:xpon-fec-pm/bbf-xponcommon-pm-mounted:intervals-15min/bbf-xponcommon-pm-mounted:history/bbf-xponcommon-pm-mounted:corrected-bytes'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-xpon-pm-mounted:xpon/bbf-xpon-pm-mounted:phy/bbf-xpon-pm-mounted:corrected-fec-bytes</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-xponcommon-pm-mounted:xpon-fec-pm/bbf-xponcommon-pm-mounted:intervals-15min/bbf-xponcommon-pm-mounted:history/bbf-xponcommon-pm-mounted:corrected-code-words'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-xpon-pm-mounted:xpon/bbf-xpon-pm-mounted:phy/bbf-xpon-pm-mounted:corrected-fec-codewords</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-xponcommon-pm-mounted:xpon-fec-pm/bbf-xponcommon-pm-mounted:intervals-15min/bbf-xponcommon-pm-mounted:history/bbf-xponcommon-pm-mounted:uncorrectable-code-words'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-xpon-pm-mounted:xpon/bbf-xpon-pm-mounted:phy/bbf-xpon-pm-mounted:uncorrectable-fec-codewords</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-xponcommon-pm-mounted:xpon-fec-pm/bbf-xponcommon-pm-mounted:intervals-15min/bbf-xponcommon-pm-mounted:history/bbf-xponcommon-pm-mounted:total-code-words'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-xpon-pm-mounted:xpon/bbf-xpon-pm-mounted:phy/bbf-xpon-pm-mounted:in-fec-codewords</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-xponcommon-pm-mounted:xpon-fec-pm/bbf-xponcommon-pm-mounted:intervals-15min/bbf-xponcommon-pm-mounted:history/bbf-xponcommon-pm-mounted:fec-seconds'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-xpon-pm-mounted:xpon/bbf-xpon-pm-mounted:phy/bbf-xpon-pm-mounted:fec-seconds</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-xponcommon-pm-mounted:xpon-bip-pm/bbf-xponcommon-pm-mounted:intervals-15min/bbf-xponcommon-pm-mounted:history/bbf-xponcommon-pm-mounted:received-bip32-prot-words'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-xpon-pm-mounted:xpon/bbf-xpon-pm-mounted:phy/bbf-xpon-pm-mounted:in-bip-protected-words</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-xponcommon-pm-mounted:xpon-bip-pm/bbf-xponcommon-pm-mounted:intervals-15min/bbf-xponcommon-pm-mounted:history/bbf-xponcommon-pm-mounted:received-bip32-errors'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-xpon-pm-mounted:xpon/bbf-xpon-pm-mounted:phy/bbf-xpon-pm-mounted:in-bip-errors</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-xponcommon-pm-mounted:xpon-bip-pm/bbf-xponcommon-pm-mounted:intervals-15min/bbf-xponcommon-pm-mounted:number-of-intervals'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:number-of-intervals</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-xponcommon-pm-mounted:xpon-bip-pm/bbf-xponcommon-pm-mounted:intervals-15min/bbf-xponcommon-pm-mounted:non-valid-intervals'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:non-valid-intervals</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-xponcommon-pm-mounted:xpon-bip-pm/bbf-xponcommon-pm-mounted:intervals-15min/bbf-xponcommon-pm-mounted:history/bbf-xponcommon-pm-mounted:interval-number'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-if-pm-mounted:interval-number</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-xponcommon-pm-mounted:xpon-bip-pm/bbf-xponcommon-pm-mounted:intervals-15min/bbf-xponcommon-pm-mounted:history/bbf-xponcommon-pm-mounted:measured-time'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-if-pm-mounted:measured-time</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-xponcommon-pm-mounted:xpon-bip-pm/bbf-xponcommon-pm-mounted:intervals-15min/bbf-xponcommon-pm-mounted:history/bbf-xponcommon-pm-mounted:invalid-data-flag'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-if-pm-mounted:invalid-data-flag</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-xponcommon-pm-mounted:xpon-bip-pm/bbf-xponcommon-pm-mounted:intervals-15min/bbf-xponcommon-pm-mounted:history/bbf-xponcommon-pm-mounted:time-stamp'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-if-pm-mounted:time-stamp</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-xponcommon-pm-mounted:xpon-fec-pm/bbf-xponcommon-pm-mounted:intervals-15min/bbf-xponcommon-pm-mounted:history'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-xpon-pm-mounted:xpon/bbf-xpon-pm-mounted:phy</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-xponcommon-pm-mounted:xpon-bip-pm/bbf-xponcommon-pm-mounted:intervals-15min/bbf-xponcommon-pm-mounted:history'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-xpon-pm-mounted:xpon/bbf-xpon-pm-mounted:phy</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-xponcommon-pm:xpon-bip-pm/bbf-xponcommon-pm:intervals-15min/bbf-xponcommon-pm:history'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-if-pm:intervals-15min/bbf-if-pm:history/bbf-xpon-pm:xpon/bbf-xpon-pm:phy</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-xponcommon-pm:xpon-fec-pm/bbf-xponcommon-pm:intervals-15min/bbf-xponcommon-pm:history'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-if-pm:intervals-15min/bbf-if-pm:history/bbf-xpon-pm:xpon/bbf-xpon-pm:phy</xsl:text>
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
                                      text()='/if:interfaces-state/if:interface/bbf-xpon:channel-termination/bbf-xpon:channel-termination-hw-port-ref' or
                                      text()='/hw:hardware-state/hw:component/hw:state/hw:state-last-changed'
                          ]
   ]"/>



   <!-- Delete cache if the count of the underlying ieNames equals to the count of ieNames that contain
                unsupported xpaths, i.e, not even 1 supported xpath is present in the cache. -->
   <xsl:template match="ipfix:ipfix/ipfix:cache[
                          count(./ipfix:permanentCache/ipfix:cacheLayout/ipfix:cacheField/ipfix:ieName) > 0 and
                          count(./ipfix:permanentCache/ipfix:cacheLayout/ipfix:cacheField/ipfix:ieName) =
                          count(./ipfix:permanentCache/ipfix:cacheLayout/ipfix:cacheField/ipfix:ieName[
                                      text()='/if:interfaces-state/if:interface/bbf-xpon:channel-termination/bbf-xpon:channel-termination-hw-port-ref' or
                                      text()='/hw:hardware-state/hw:component/hw:state/hw:state-last-changed'
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
                                      text()='/if:interfaces-state/if:interface/bbf-xpon:channel-termination/bbf-xpon:channel-termination-hw-port-ref' or
                                      text()='/hw:hardware-state/hw:component/hw:state/hw:state-last-changed'
                          ]))
   ]"/>




</xsl:stylesheet>