<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:cfgNs="urn:ietf:params:xml:ns:netconf:base:1.0"
    xmlns:portRef="urn:bbf:yang:bbf-interface-port-reference"
    xmlns:tcont="urn:bbf:yang:bbf-xpongemtcont"
    xmlns:if="urn:ietf:params:xml:ns:yang:ietf-interfaces"
    xmlns:ift="urn:bbf:yang:bbf-xpon-if-type"
    xmlns:xponaug="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-if-xpon-aug"
    xmlns:xpon="urn:bbf:yang:bbf-xpon"
    xmlns:ctns="urn:broadband-forum-org:yang:nokia-sdan-xpon-channel-termination"
    >

  <xsl:template match="/cfgNs:config/if:interfaces/if:interface/if:link-up-down-trap-enable
                         [../if:type = 'bbf-xponift:channel-group' or
                          ../if:type = 'bbf-xponift:channel-partition' or
                          ../if:type = 'bbf-xponift:channel-pair' or
                          ../if:type = 'bbf-xponift:channel-termination' or
                          ../if:type = 'bbf-xponift:v-ani' or
                          ../if:type = 'bbf-xponift:olt-v-enet'
                         ]
                      "/>

  <!-- Rule 1: It isn't applicable for channel-group, channel-partition, channel-pair, v-ani, olt-v-enet. -->
  <!--delete port-layer-if when itf is channelgrp/partition/pair/v-ani/v-enet. -->
  <xsl:template match="/cfgNs:config/if:interfaces/if:interface/portRef:port-layer-if[../if:type='bbf-xponift:channel-pair' or
                                             ../if:type='bbf-xponift:channel-partition' or
                                             ../if:type='bbf-xponift:channel-group' or
                                             ../if:type='bbf-xponift:olt-v-enet' or
                                             ../if:type='bbf-xponift:v-ani']"/>

  <!--Rule 2: delete statistics when itf is channelgrp/partition/pair/termination. -->
  <!--xsl:template match="*[local-name()='statistics' and namespace-uri()='http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-interfaces-statistics']">
      <xsl:variable name='itfType'><xsl:value-of select="../*[local-name()='type']"/></xsl:variable>
      <xsl:choose>
          <xsl:when test="$itfType='bbf-xponift:channel-pair'"/>
          <xsl:when test="$itfType='bbf-xponift:channel-partition'"/>
          <xsl:when test="$itfType='bbf-xponift:channel-group'"/>
          <xsl:when test="$itfType='bbf-xponift:channel-termination'"/>
          <xsl:otherwise>
              <xsl:copy>
                  <xsl:copy-of select="@*"/>
                  <xsl:apply-templates/>
              </xsl:copy>
          </xsl:otherwise>
      </xsl:choose>
  </xsl:template-->


</xsl:stylesheet>
