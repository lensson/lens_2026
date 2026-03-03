<?xml version="1.0" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:ipfix="urn:ietf:params:xml:ns:yang:ietf-ipfix-psamp">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    <xsl:param name="ipfix_ns" select="'urn:ietf:params:xml:ns:yang:ietf-ipfix-psamp'" />


   <!-- xsl rule to migrate an existing configured counter which has changed its xpath -->
   <xsl:template match="ipfix:ipfix/ipfix:cache/ipfix:permanentCache/ipfix:cacheLayout/ipfix:cacheField/ipfix:ieName">
       <xsl:choose>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/bbf-xpongemtcont-mounted:xpongemtcont-state/bbf-xpongemtcont-mounted:gemports/bbf-xpongemtcont-mounted:gemport/bbf-xpongemtcont-gemport-pm-mounted:performance/bbf-xpongemtcont-gemport-pm-mounted:intervals-15min/bbf-xpongemtcont-gemport-pm-mounted:history/bbf-xpongemtcont-gemport-pm-mounted:ani-side/nokia-xpongemtcont-gemport-pm-mounted:lost-ds-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/bbf-xpongemtcont-mounted:xpongemtcont-state/bbf-xpongemtcont-mounted:gemports/bbf-xpongemtcont-mounted:gemport/bbf-xpongemtcont-gemport-pm-mounted:performance/bbf-xpongemtcont-gemport-pm-mounted:intervals-15min/bbf-xpongemtcont-gemport-pm-mounted:history/bbf-xpongemtcont-gemport-pm-mounted:ani-side/nokia-xpongemtcont-gemport-pm-mounted:lost-in-frames</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/bbf-xpongemtcont-mounted:xpongemtcont-state/bbf-xpongemtcont-mounted:gemports/bbf-xpongemtcont-mounted:gemport/bbf-xpongemtcont-gemport-pm-mounted:performance/bbf-xpongemtcont-gemport-pm-mounted:intervals-15min/bbf-xpongemtcont-gemport-pm-mounted:history/bbf-xpongemtcont-gemport-pm-mounted:ani-side/nokia-xpongemtcont-gemport-pm-mounted:lost-us-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/bbf-xpongemtcont-mounted:xpongemtcont-state/bbf-xpongemtcont-mounted:gemports/bbf-xpongemtcont-mounted:gemport/bbf-xpongemtcont-gemport-pm-mounted:performance/bbf-xpongemtcont-gemport-pm-mounted:intervals-15min/bbf-xpongemtcont-gemport-pm-mounted:history/bbf-xpongemtcont-gemport-pm-mounted:ani-side/nokia-xpongemtcont-gemport-pm-mounted:lost-out-frames</xsl:text>
               </xsl:element>
           </xsl:when>
           <xsl:when test="./text()='/onu:onus/onu:onu/onu:root/bbf-xpongemtcont-mounted:xpongemtcont-state/bbf-xpongemtcont-mounted:gemports/bbf-xpongemtcont-mounted:gemport/bbf-xpongemtcont-gemport-pm-mounted:performance/bbf-xpongemtcont-gemport-pm-mounted:intervals-15min/bbf-xpongemtcont-gemport-pm-mounted:history/bbf-xpongemtcont-gemport-pm-mounted:ani-side/nokia-xpongemtcont-gemport-pm-mounted:misinserted-pkts'">
               <xsl:element name="ieName" namespace="{$ipfix_ns}">
                   <xsl:text>/onu:onus/onu:onu/onu:root/bbf-xpongemtcont-mounted:xpongemtcont-state/bbf-xpongemtcont-mounted:gemports/bbf-xpongemtcont-mounted:gemport/bbf-xpongemtcont-gemport-pm-mounted:performance/bbf-xpongemtcont-gemport-pm-mounted:intervals-15min/bbf-xpongemtcont-gemport-pm-mounted:history/bbf-xpongemtcont-gemport-pm-mounted:ani-side/nokia-xpongemtcont-gemport-pm-mounted:misinserted-frames</xsl:text>
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
                                      text()='/if:interfaces/if:interface/dot1x:pae/dot1x:virtual-port' or
                                      text()='/sys:system/dot1x:pae-system/dot1x:eapol-protocol-version' or
                                      text()='/lic-app:licensing-state/lic-app:features/lic-app:on-off-status'
                          ]
   ]"/>



   <!-- Delete cache if the count of the underlying ieNames equals to the count of ieNames that contain
                unsupported xpaths, i.e, not even 1 supported xpath is present in the cache. -->
   <xsl:template match="ipfix:ipfix/ipfix:cache[
                          count(./ipfix:permanentCache/ipfix:cacheLayout/ipfix:cacheField/ipfix:ieName) > 0 and
                          count(./ipfix:permanentCache/ipfix:cacheLayout/ipfix:cacheField/ipfix:ieName) =
                          count(./ipfix:permanentCache/ipfix:cacheLayout/ipfix:cacheField/ipfix:ieName[
                                      text()='/if:interfaces/if:interface/dot1x:pae/dot1x:virtual-port' or
                                      text()='/sys:system/dot1x:pae-system/dot1x:eapol-protocol-version' or
                                      text()='/lic-app:licensing-state/lic-app:features/lic-app:on-off-status'
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
                                      text()='/if:interfaces/if:interface/dot1x:pae/dot1x:virtual-port' or
                                      text()='/sys:system/dot1x:pae-system/dot1x:eapol-protocol-version' or
                                      text()='/lic-app:licensing-state/lic-app:features/lic-app:on-off-status'
                          ]))
   ]"/>




</xsl:stylesheet>