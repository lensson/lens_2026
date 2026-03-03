<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:bbf="urn:bbf:yang:bbf-qos-classifiers"
                xmlns="urn:bbf:yang:bbf-qos-classifiers"
                exclude-result-prefixes="bbf">

  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

  <!-- Identity template: copy everything by default -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!--
    Rule 1 & 2: Rename high-priority-classifier to priority-high-class
    and change its traffic class from 1 to 0
  -->
  <xsl:template match="bbf:classifier-entry[bbf:name='high-priority-classifier']">
    <classifier-entry>
      <!-- Rename -->
      <name>priority-high-class</name>

      <!-- Copy description -->
      <xsl:apply-templates select="bbf:description"/>

      <!-- Modify classifier-action-entry-cfg -->
      <classifier-action-entry-cfg>
        <xsl:apply-templates select="bbf:classifier-action-entry-cfg/bbf:action-type"/>
        <!-- Change traffic class from 1 to 0 -->
        <scheduling-traffic-class>0</scheduling-traffic-class>
      </classifier-action-entry-cfg>
    </classifier-entry>
  </xsl:template>

  <!--
    Rule 4: Delete best-effort-classifier
    Match but don't output anything
  -->
  <xsl:template match="bbf:classifier-entry[bbf:name='best-effort-classifier']">
    <!-- Deleted - no output -->
  </xsl:template>

  <!--
    Rule 3: Rebuild classifiers container to add medium-priority-classifier
  -->
  <xsl:template match="bbf:classifiers">
    <classifiers>
      <xsl:copy-of select="@*"/>

      <!-- 1. Process high-priority-classifier (will be renamed to priority-high-class) -->
      <xsl:apply-templates select="bbf:classifier-entry[bbf:name='high-priority-classifier']"/>

      <!-- 2. Add new medium-priority-classifier -->
      <classifier-entry>
        <name>medium-priority-classifier</name>
        <description>Classifier for medium priority traffic with P-bit 4 and 5</description>
        <classifier-action-entry-cfg>
          <action-type>scheduling-traffic-class</action-type>
          <scheduling-traffic-class>2</scheduling-traffic-class>
        </classifier-action-entry-cfg>
      </classifier-entry>

      <!-- 3. Process low-priority-classifier (unchanged) -->
      <xsl:apply-templates select="bbf:classifier-entry[bbf:name='low-priority-classifier']"/>

      <!-- Note: best-effort-classifier is skipped (deleted by rule 4) -->
    </classifiers>
  </xsl:template>

</xsl:stylesheet>
