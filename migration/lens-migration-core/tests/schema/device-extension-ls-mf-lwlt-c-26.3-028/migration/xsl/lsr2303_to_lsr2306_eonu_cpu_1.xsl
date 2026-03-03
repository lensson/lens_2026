<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:onuNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount" xmlns:hardwareNs="urn:ietf:params:xml:ns:yang:ietf-hardware-mounted" version="1.0">

  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" indent="yes"/>

  <!-- Replace CPU Parent name from board-name to chassis-name -->
  <xsl:template match="//onuNs:onus/onuNs:onu/onuNs:root/hardwareNs:hardware/hardwareNs:component[normalize-space(hardwareNs:class)='ianahw:cpu']/hardwareNs:parent">
      <!-- Save the name of the current parent of the CPU, as well as the name of its own parent -->
      <!-- For instance: Save the name of the CPU's parent (in this case, "board"), and the name of the parent's parent (in this case, "Chassis") -->

      <xsl:variable name="ParentName"> <xsl:value-of select="../hardwareNs:parent[normalize-space(.)]"/></xsl:variable>
      <xsl:variable name="BoardParent"> <xsl:value-of select="../../hardwareNs:component[hardwareNs:name = $ParentName]/hardwareNs:parent"/></xsl:variable>

      <!-- Save the Board's Parent - Chassis to CPU Parent-->
      <xsl:copy>
          <xsl:copy-of select="@*"/>
<xsl:value-of select="$BoardParent"/>
      </xsl:copy>

  </xsl:template>

</xsl:stylesheet>
