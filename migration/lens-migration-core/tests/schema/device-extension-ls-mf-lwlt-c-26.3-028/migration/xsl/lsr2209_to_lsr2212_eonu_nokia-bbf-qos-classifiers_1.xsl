<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:onu="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount" version="1.0" exclude-result-prefixes="onu">
  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" indent="yes"/>
  
  <!-- default rule -->
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- set filter-operation to match-all-filter when not there -->
  <xsl:template xmlns:bbf-qos-cls-mounted="urn:bbf:yang:bbf-qos-classifiers-mounted" match="//onu:onus/onu:onu/onu:root/bbf-qos-cls-mounted:classifiers/bbf-qos-cls-mounted:classifier-entry[not(bbf-qos-cls-mounted:filter-operation)]/bbf-qos-cls-mounted:name">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
    <bbf-qos-cls-mounted:filter-operation xmlns:bbf-qos-cls-mounted="urn:bbf:yang:bbf-qos-classifiers-mounted">bbf-qos-cls-mounted:match-all-filter</bbf-qos-cls-mounted:filter-operation>
  </xsl:template>
  
  <!-- update filter-operation from match-any-filter to match-all-filter -->
  <xsl:template xmlns:bbf-qos-cls-mounted="urn:bbf:yang:bbf-qos-classifiers-mounted" match="//onu:onus/onu:onu/onu:root/bbf-qos-cls-mounted:classifiers/bbf-qos-cls-mounted:classifier-entry/bbf-qos-cls-mounted:filter-operation[contains(text(),'match-any-filter')]">
    <xsl:element xmlns:bbf-qos-cls-mounted="urn:bbf:yang:bbf-qos-classifiers-mounted" name="filter-operation" namespace="urn:bbf:yang:bbf-qos-classifiers-mounted"><xsl:copy-of select="namespace::*"/>bbf-qos-cls-mounted:match-all-filter</xsl:element>
  </xsl:template>
</xsl:stylesheet>
