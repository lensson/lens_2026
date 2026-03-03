<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:onu="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount" xmlns:voip="urn:bbf:yang:bbf-sip-voip-mounted" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    <!-- default rule -->
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:param name="v" select="'urn:bbf:yang:bbf-sip-voip-mounted'"/>

    <xsl:template match="onu:onus/onu:onu/onu:root/voip:pots-profiles/voip:pots-uni-characteristics-profiles/voip:pots-uni-characteristics-profile/voip:jitter-target">
    <xsl:choose>
        <xsl:when test="text()&lt;'0'">
          <xsl:element name="jitter-target" namespace="{$v}">0</xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="onu:onus/onu:onu/onu:root/voip:pots-profiles/voip:pots-uni-characteristics-profiles/voip:pots-uni-characteristics-profile/voip:max-jitter-buffer">
    <xsl:choose>
        <xsl:when test="text()&lt;'0'">
          <xsl:element name="max-jitter-buffer" namespace="{$v}">0</xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="onu:onus/onu:onu/onu:root/voip:pots-profiles/voip:pots-uni-characteristics-profiles/voip:pots-uni-characteristics-profile/voip:dtmf-digit-levels">
    <xsl:choose>
        <xsl:when test="text()='-1' or text()='-2'">
          <xsl:element name="dtmf-digit-levels" namespace="{$v}">0</xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="onu:onus/onu:onu/onu:root/voip:pots-profiles/voip:pots-uni-characteristics-profiles/voip:pots-uni-characteristics-profile/voip:dmtf-digit-duration">
    <xsl:element name="dtmf-digit-duration" namespace="{$v}">
        <xsl:value-of select="text()"/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
