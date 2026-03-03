<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:cfgNs="urn:ietf:params:xml:ns:netconf:base:1.0"
                              xmlns:if="urn:ietf:params:xml:ns:yang:ietf-interfaces"
                              xmlns:xponaug="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-if-xpon-aug"
                              xmlns:xpon="urn:bbf:yang:bbf-xpon"
                              xmlns:ctns="urn:broadband-forum-org:yang:nokia-sdan-xpon-channel-termination"
                              >

    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    <xsl:variable name="ct_xpath" select="/cfgNs:config/if:interfaces/if:interface/xpon:channel-termination"/>
    <xsl:variable name="typebdata_xpath" select="$ct_xpath/xponaug:channel-termination-type-b-pon-location-data"/>

  <!-- Delete meant-for-type-b-primary-role, slot-id, port-id, gpon-pon-id, xgs-pon-id, host-id-of-primary-side
       for interfaces whose laser-on-by-default is changed to true by rule 7 -->
    <!--xsl:template priority="3" match="
    $ct_xpath/xpon:meant-for-type-b-primary-role[
                                     ../xpon:channel-termination-type='bbf-xpon-types:ngpon2-ptp' or
                                     ../xpon:channel-termination-type='bbf-xpon-types:ngpon2-twdm' or
                                     ../xpon:channel-termination-type='nokia-sdan-xpon-types:twentyfivegs' or
                                     ../xpon:channel-termination-type='nokia-sdan-hspon-types:hs-pon'] |
    $typebdata_xpath/xponaug:slot-id[
                                     ../../xpon:channel-termination-type='bbf-xpon-types:ngpon2-ptp' or
                                     ../../xpon:channel-termination-type='bbf-xpon-types:ngpon2-twdm' or
                                     ../../xpon:channel-termination-type='nokia-sdan-xpon-types:twentyfivegs' or
                                     ../../xpon:channel-termination-type='nokia-sdan-hspon-types:hs-pon'] |
    $typebdata_xpath/xponaug:port-id[
                                     ../../xpon:channel-termination-type='bbf-xpon-types:ngpon2-ptp' or
                                     ../../xpon:channel-termination-type='bbf-xpon-types:ngpon2-twdm' or
                                     ../../xpon:channel-termination-type='nokia-sdan-xpon-types:twentyfivegs' or
                                     ../../xpon:channel-termination-type='nokia-sdan-hspon-types:hs-pon'] |
    $typebdata_xpath/xponaug:gpon-pon-id[
                                     ../../xpon:channel-termination-type='bbf-xpon-types:ngpon2-ptp' or
                                     ../../xpon:channel-termination-type='bbf-xpon-types:ngpon2-twdm' or
                                     ../../xpon:channel-termination-type='nokia-sdan-xpon-types:twentyfivegs' or
                                     ../../xpon:channel-termination-type='nokia-sdan-hspon-types:hs-pon'] |
    $typebdata_xpath/xponaug:xgs-pon-id[
                                     ../../xpon:channel-termination-type='bbf-xpon-types:ngpon2-ptp' or
                                     ../../xpon:channel-termination-type='bbf-xpon-types:ngpon2-twdm' or
                                     ../../xpon:channel-termination-type='nokia-sdan-xpon-types:twentyfivegs' or
                                     ../../xpon:channel-termination-type='nokia-sdan-hspon-types:hs-pon'] |
    $typebdata_xpath/xponaug:access-node-id[
                                     ../../xpon:channel-termination-type='bbf-xpon-types:ngpon2-ptp' or
                                     ../../xpon:channel-termination-type='bbf-xpon-types:ngpon2-twdm' or
                                     ../../xpon:channel-termination-type='nokia-sdan-xpon-types:twentyfivegs' or
                                     ../../xpon:channel-termination-type='nokia-sdan-hspon-types:hs-pon'] |
    $ct_xpath/ctns:host-id-of-primary-side[
                                     ../xpon:channel-termination-type='bbf-xpon-types:ngpon2-ptp' or
                                     ../xpon:channel-termination-type='bbf-xpon-types:ngpon2-twdm' or
                                     ../xpon:channel-termination-type='nokia-sdan-xpon-types:twentyfivegs' or
                                     ../xpon:channel-termination-type='nokia-sdan-hspon-types:hs-pon'] "/ to be added -->

    <!-- Rule 7: 1. Must be true for NGPON2, 25GPON, or 50GPON case
                 2. Must be true for DFMB-C<-->
  <xsl:template  match="$ct_xpath/xponaug:laser-on-by-default[
                                     ../xpon:channel-termination-type='bbf-xpon-types:ngpon2-ptp' or
                                     ../xpon:channel-termination-type='bbf-xpon-types:ngpon2-twdm' or
                                     ../xpon:channel-termination-type='nokia-sdan-xpon-types:twentyfivegs' or
                                     ../xpon:channel-termination-type='nokia-sdan-hspon-types:hs-pon']">
  <xsl:element name="laser-on-by-default" namespace="{namespace-uri()}">true</xsl:element>
  </xsl:template>

  <!-- Delete meant-for-type-b-primary-role, slot-id, port-id, gpon-pon-id, xgs-pon-id, host-id-of-primary-side
       for interfaces whose laser-on-by-default is set to true by default -->
  <!--xsl:template priority="2" match="
    $ct_xpath/xpon:meant-for-type-b-primary-role[  ../xponaug:laser-on-by-default='true' ] |
    $typebdata_xpath/xponaug:slot-id[  ../../xponaug:laser-on-by-default='true' ] |
    $typebdata_xpath/xponaug:port-id[  ../../xponaug:laser-on-by-default='true' ] |
    $typebdata_xpath/xponaug:gpon-pon-id[  ../../xponaug:laser-on-by-default='true' ] |
    $typebdata_xpath/xponaug:xgs-pon-id[  ../../xponaug:laser-on-by-default='true' ] |
    $typebdata_xpath/xponaug:access-node-id[  ../../xponaug:laser-on-by-default='true' ] |
    $ct_xpath/ctns:host-id-of-primary-side[  ../xponaug:laser-on-by-default='true' ]"/ to be added -->

  <!-- Delete slot-id, port-id, gpon-pon-id, xgs-pon-id, host-id-of-primary-side
       for interfaces whose meant-for-type-b-primary-role is set to true by default -->
  <!--xsl:template priority="1" match="
   $typebdata_xpath/xponaug:slot-id[  ../../xpon:meant-for-type-b-primary-role='true' ] |
   $typebdata_xpath/xponaug:port-id[  ../../xpon:meant-for-type-b-primary-role='true' ] |
   $typebdata_xpath/xponaug:gpon-pon-id[  ../../xpon:meant-for-type-b-primary-role='true' ] |
   $typebdata_xpath/xponaug:xgs-pon-id[  ../../xpon:meant-for-type-b-primary-role='true' ] |
   $typebdata_xpath/xponaug:access-node-id[  ../../xpon:meant-for-type-b-primary-role='true' ] |
   $ct_xpath/ctns:host-id-of-primary-side[  ../xpon:meant-for-type-b-primary-role='true' ]"/ to be added -->

  </xsl:stylesheet>
