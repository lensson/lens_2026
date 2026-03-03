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
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/nokia-interfaces-performance-management-mounted:in-crc-errored-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/bbf-eth-pm-mounted:in-pkts-errors-fcs</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/nokia-interfaces-performance-management-mounted:in-undersize-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/bbf-eth-pm-mounted:in-undersize-pkts</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/nokia-interfaces-performance-management-mounted:in-oversize-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/bbf-eth-pm-mounted:in-giant-pkts</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/nokia-interfaces-performance-management-mounted:in-drop-events'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:in-drop-events</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/nokia-interfaces-performance-management-mounted:in-total-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:in-total-pkts</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/nokia-interfaces-performance-management-mounted:in-64-octets-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:in-64-octets-pkts</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/nokia-interfaces-performance-management-mounted:in-65-to-127-octets-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:in-65-to-127-octets-pkts</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/nokia-interfaces-performance-management-mounted:in-128-to-255-octets-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:in-128-to-255-octets-pkts</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/nokia-interfaces-performance-management-mounted:in-256-to-511-octets-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:in-256-to-511-octets-pkts</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/nokia-interfaces-performance-management-mounted:in-512-to-1023-octets-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:in-512-to-1023-octets-pkts</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/nokia-interfaces-performance-management-mounted:in-1024-to-1518-octets-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:in-1024-to-1518-octets-pkts</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/nokia-interfaces-performance-management-mounted:out-drop-events'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:out-drop-events</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/nokia-interfaces-performance-management-mounted:out-total-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:out-total-pkts</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/nokia-interfaces-performance-management-mounted:out-crc-errored-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:out-crc-errored-pkts</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/nokia-interfaces-performance-management-mounted:out-undersize-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:out-undersize-pkts</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/nokia-interfaces-performance-management-mounted:out-oversize-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:out-oversize-pkts</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/nokia-interfaces-performance-management-mounted:out-64-octets-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:out-64-octets-pkts</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/nokia-interfaces-performance-management-mounted:out-65-to-127-octets-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:out-65-to-127-octets-pkts</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/nokia-interfaces-performance-management-mounted:out-128-to-255-octets-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:out-128-to-255-octets-pkts</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/nokia-interfaces-performance-management-mounted:out-256-to-511-octets-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:out-256-to-511-octets-pkts</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/nokia-interfaces-performance-management-mounted:out-512-to-1023-octets-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:out-512-to-1023-octets-pkts</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/nokia-interfaces-performance-management-mounted:out-1024-to-1518-octets-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/if-mounted:interfaces-state/if-mounted:interface/bbf-if-pm-mounted:performance/bbf-if-pm-mounted:intervals-15min/bbf-if-pm-mounted:history/bbf-eth-pm-mounted:ethernet/nokia-interfaces-performance-management-mounted:out-1024-to-1518-octets-pkts</xsl:text>
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











</xsl:stylesheet>