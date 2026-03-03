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
                                      text()='/if:interfaces-state/if:interface/bbf-xponvani:v-ani/bbf-xponvani:onu-id' or
                                      text()='/ipfix:ipfix/ipfix:exportingProcess/ipfix:destination/ipfix:tcpExporter/ipfix:transportSession/ipfix:sourceAddress' or
                                      text()='/ipfix:ipfix/ipfix:exportingProcess/ipfix:destination/ipfix:tcpExporter/ipfix:transportSession/ipfix:template/ipfix:observationDomainId'
                          ]
   ]"/>



   <!-- Delete cache if the count of the underlying ieNames equals to the count of ieNames that contain
                unsupported xpaths, i.e, not even 1 supported xpath is present in the cache. -->
   <xsl:template match="ipfix:ipfix/ipfix:cache[
                          count(./ipfix:permanentCache/ipfix:cacheLayout/ipfix:cacheField/ipfix:ieName) > 0 and
                          count(./ipfix:permanentCache/ipfix:cacheLayout/ipfix:cacheField/ipfix:ieName) =
                          count(./ipfix:permanentCache/ipfix:cacheLayout/ipfix:cacheField/ipfix:ieName[
                                      text()='/if:interfaces-state/if:interface/bbf-xponvani:v-ani/bbf-xponvani:onu-id' or
                                      text()='/ipfix:ipfix/ipfix:exportingProcess/ipfix:destination/ipfix:tcpExporter/ipfix:transportSession/ipfix:sourceAddress' or
                                      text()='/ipfix:ipfix/ipfix:exportingProcess/ipfix:destination/ipfix:tcpExporter/ipfix:transportSession/ipfix:template/ipfix:observationDomainId'
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
                                      text()='/if:interfaces-state/if:interface/bbf-xponvani:v-ani/bbf-xponvani:onu-id' or
                                      text()='/ipfix:ipfix/ipfix:exportingProcess/ipfix:destination/ipfix:tcpExporter/ipfix:transportSession/ipfix:sourceAddress' or
                                      text()='/ipfix:ipfix/ipfix:exportingProcess/ipfix:destination/ipfix:tcpExporter/ipfix:transportSession/ipfix:template/ipfix:observationDomainId'
                          ]))
   ]"/>




</xsl:stylesheet>