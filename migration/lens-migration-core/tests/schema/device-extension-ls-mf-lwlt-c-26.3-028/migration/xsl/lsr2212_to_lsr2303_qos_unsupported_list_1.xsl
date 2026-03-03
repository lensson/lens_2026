<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:bbf-qos-enhfilt="urn:bbf:yang:bbf-qos-enhanced-filters" version="1.0">

  <!-- Migration Script for BBN-96114 Qos Modules - Unsupported leafs -->
  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

  <!-- default rule -->
  <xsl:template match="*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!-- Delete unsupported nodes under
    /bbf-qos-cls:classifiers/bbf-qos-cls:classifier-entry
    /bbf-qos-cls:match-criteria/nokia-qos-filt:other-protocol
  -->
  <xsl:template match="*[         local-name() = 'other-protocol'         and namespace-uri() = 'http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-qos-filters-ext'         and parent::*[name() = 'match-criteria' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']         and ancestor::*[name() = 'classifier-entry' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']         and ancestor::*[name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']     ]">
  </xsl:template>

  <!-- Delete unsupported nodes under
    /bbf-qos-cls:classifiers/bbf-qos-cls:classifier-entry/bbf-qos-filt:filter
  -->
  <xsl:template match="*[         local-name() = 'filter' and namespace-uri() = 'urn:bbf:yang:bbf-qos-filters'         and parent::*[name() = 'classifier-entry' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']         and ancestor::*[name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']     ]">
  </xsl:template>

  <!-- Delete unsupported nodes under
    /bbf-qos-cls:classifiers/bbf-qos-cls:classifier-entry
    /bbf-qos-cls:classifier-action-entry-cfg/bbf-qos-cls:dscp-marking-cfg
  -->
  <xsl:template match="*[     local-name() = 'classifier-action-entry-cfg' and namespace-uri() ='urn:bbf:yang:bbf-qos-classifiers'     and (child::*[local-name() = 'action-type' and current() = 'dscp-marking'] or child::*[local-name() = 'dscp-marking-cfg'])     and parent::*[local-name() = 'classifier-entry' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']     and ancestor::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']    ]">
  </xsl:template>

  <!-- Delete unsupported nodes under
    /bbf-qos-filt:filters/bbf-qos-filt:filter
  -->
  <xsl:template match="*[         local-name() = 'filter' and namespace-uri() = 'urn:bbf:yang:bbf-qos-filters'         and parent::*[name() = 'filters' and namespace-uri() = 'urn:bbf:yang:bbf-qos-filters']     ]">
  </xsl:template>

  <!-- Delete unsupported nodes under
    /bbf-qos-plc:policing-profiles/bbf-qos-plc:policing-profile/bbf-qos-plc:hierarchical-policing
  -->
  <xsl:template match="*[         local-name() = 'hierarchical-policing' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policing'         and parent::*[name() = 'policing-profile' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policing']         and ancestor::*[name() = 'policing-profiles' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policing']     ]">
  </xsl:template>

  <!-- Delete unsupported nodes under
    /if:interfaces/if:interface/bbf-qos-tm:tm-root/bbf-qos-tm:queue/bbf-qos-tm:pre-emption
  -->
  <xsl:template match="*[         local-name() = 'pre-emption' and namespace-uri() = 'urn:bbf:yang:bbf-qos-traffic-mngt'         and parent::*[name() = 'queue' and namespace-uri() = 'urn:bbf:yang:bbf-qos-traffic-mngt']         and ancestor::*[name() = 'tm-root' and namespace-uri() = 'urn:bbf:yang:bbf-qos-traffic-mngt']         and ancestor::*[name() = 'interface' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']         and ancestor::*[name() = 'interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']     ]">
  </xsl:template>

  <!-- Delete unsupported nodes under
    /if:interfaces/if:interface/bbf-qos-tm:tm-root/bbf-qos-sched:scheduler-node/bbf-qos-sched:queue/bbf-qos-sched:pre-emption
  -->
  <xsl:template match="*[         local-name() = 'pre-emption' and namespace-uri() = 'urn:bbf:yang:bbf-qos-enhanced-scheduling'         and parent::*[name() = 'queue' and namespace-uri() = 'urn:bbf:yang:bbf-qos-enhanced-scheduling']         and ancestor::*[name() = 'scheduler-node' and namespace-uri() = 'urn:bbf:yang:bbf-qos-enhanced-scheduling']         and ancestor::*[name() = 'tm-root' and namespace-uri() = 'urn:bbf:yang:bbf-qos-traffic-mngt']         and ancestor::*[name() = 'interface' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']         and ancestor::*[name() = 'interfaces' and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces']     ]">
  </xsl:template>


  <!--
  /bbf-qos-cls:classifiers/bbf-qos-cls:classifier-entry/bbf-qos-cls:filter-method
  /bbf-qos-cls:inline/bbf-qos-cls:match-criteria/bbf-qos-cls:dscp-range
  -->
  <xsl:template match="*[     local-name() = 'dscp-range' and normalize-space(text()) != 'any'     and parent::*[local-name() = 'match-criteria']     and ancestor::*[local-name() = 'classifier-entry']     and ancestor::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']   ]">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
<xsl:value-of select="'any'"/>
    </xsl:copy>
  </xsl:template>

  <!--
    /bbf-qos-cls:classifiers/bbf-qos-cls:classifier-entry/bbf-qos-cls:filter-method
    /bbf-qos-cls:inline/bbf-qos-cls:match-criteria/bbf-qos-cls:protocols
    /bbf-qos-cls:protocol/bbf-qos-cls:protocol
  -->
  <xsl:template match="*[     local-name() = 'protocol' and normalize-space(text()) != 'igmp'     and parent::*[local-name() = 'match-criteria']     and ancestor::*[local-name() = 'classifier-entry']     and ancestor::*[local-name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']   ]">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
<xsl:value-of select="'igmp'"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>
