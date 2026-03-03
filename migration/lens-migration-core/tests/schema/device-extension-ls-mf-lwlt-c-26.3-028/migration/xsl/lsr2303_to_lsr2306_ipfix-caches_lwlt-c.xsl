<?xml version="1.0" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:ipfix="urn:ietf:params:xml:ns:yang:ietf-ipfix-psamp">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    <xsl:param name="ipfix_ns" select="'urn:ietf:params:xml:ns:yang:ietf-ipfix-psamp'" />


   <!-- xsl rule to migrate an existing configured counter which has changed its xpath -->
   <xsl:template match="ipfix:ipfix/ipfix:cache/ipfix:permanentCache/ipfix:cacheLayout/ipfix:cacheField/ipfix:ieName">
       <xsl:choose>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:in-64-octets-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/nokia-interfaces-performance-management-mounted:in-64-octets-pkts</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:out-64-octets-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/nokia-interfaces-performance-management-mounted:out-64-octets-pkts</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:in-65-to-127-octets-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/nokia-interfaces-performance-management-mounted:in-65-to-127-octets-pkts</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:out-65-to-127-octets-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/nokia-interfaces-performance-management-mounted:out-65-to-127-octets-pkts</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:in-128-to-255-octets-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/nokia-interfaces-performance-management-mounted:in-128-to-255-octets-pkts</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:out-128-to-255-octets-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/nokia-interfaces-performance-management-mounted:out-128-to-255-octets-pkts</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:in-256-to-511-octets-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/nokia-interfaces-performance-management-mounted:in-256-to-511-octets-pkts</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:out-256-to-511-octets-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/nokia-interfaces-performance-management-mounted:out-256-to-511-octets-pkts</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:in-512-to-1023-octets-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/nokia-interfaces-performance-management-mounted:in-512-to-1023-octets-pkts</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:out-512-to-1023-octets-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/nokia-interfaces-performance-management-mounted:out-512-to-1023-octets-pkts</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:in-1024-to-1518-octets-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/nokia-interfaces-performance-management-mounted:in-1024-to-1518-octets-pkts</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:out-1024-to-1518-octets-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/nokia-interfaces-performance-management-mounted:out-1024-to-1518-octets-pkts</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:in-drop-events'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/nokia-interfaces-performance-management-mounted:in-drop-events</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:out-drop-events'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/nokia-interfaces-performance-management-mounted:out-drop-events</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:in-total-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/nokia-interfaces-performance-management-mounted:in-total-pkts</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:out-total-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/nokia-interfaces-performance-management-mounted:out-total-pkts</xsl:text>
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
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:out-crc-errored-pkts' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:out-undersize-pkts' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:out-oversize-pkts'
                          ]
   ]"/>



   <!-- Delete cache if the count of the underlying ieNames equals to the count of ieNames that contain
                unsupported xpaths, i.e, not even 1 supported xpath is present in the cache. -->
   <xsl:template match="ipfix:ipfix/ipfix:cache[
                          count(./ipfix:permanentCache/ipfix:cacheLayout/ipfix:cacheField/ipfix:ieName) > 0 and
                          count(./ipfix:permanentCache/ipfix:cacheLayout/ipfix:cacheField/ipfix:ieName) =
                          count(./ipfix:permanentCache/ipfix:cacheLayout/ipfix:cacheField/ipfix:ieName[
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:out-crc-errored-pkts' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:out-undersize-pkts' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:out-oversize-pkts'
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
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:out-crc-errored-pkts' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:out-undersize-pkts' or
                                      text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:out-oversize-pkts'
                          ]))
   ]"/>




</xsl:stylesheet>