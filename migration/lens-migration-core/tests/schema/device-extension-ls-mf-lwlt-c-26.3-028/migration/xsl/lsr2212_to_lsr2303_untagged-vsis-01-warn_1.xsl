<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:cfgNs="urn:ietf:params:xml:ns:netconf:base:1.0"
    >
  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" indent="yes"/>

  <!-- default rule -->
  <xsl:template match="*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!--Handle nodes added by a1 script. -->
  <xsl:template match="//untagged-rule-on-subif-lower-layer">
    <xsl:variable name="this-lower-layer">
      <xsl:value-of select="lower-layer"/>
    </xsl:variable>
    <xsl:variable name="num-vsis-with-untagged-rule">
      <xsl:value-of select="count(//untagged-rule-on-subif-lower-layer[lower-layer=$this-lower-layer])"/>
    </xsl:variable>
    <xsl:if test="$num-vsis-with-untagged-rule > 1">
      <wrong-configuration-detected>
        This VSI has untagged match rule (via <xsl:value-of select="via"/>).
        There are <xsl:value-of select="$num-vsis-with-untagged-rule"/> VSIs on lower-layer <xsl:value-of select="$this-lower-layer"/> with untagged match rules.
        Only one untagged match rule is permitted on a given lower interface.
      </wrong-configuration-detected>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
