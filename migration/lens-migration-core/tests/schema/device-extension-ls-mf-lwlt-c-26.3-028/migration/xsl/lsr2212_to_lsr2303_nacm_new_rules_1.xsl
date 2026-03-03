<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:acmns="urn:ietf:params:xml:ns:yang:ietf-netconf-acm">
  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<!-- Rule-list to deny access to netconf -->
  <xsl:variable name="cli-rule-list">
    <xsl:element name ="rule-list" namespace="urn:ietf:params:xml:ns:yang:ietf-netconf-acm">
      <xsl:element name ="name" namespace="urn:ietf:params:xml:ns:yang:ietf-netconf-acm">cli-only-rule-list</xsl:element>
      <xsl:element name ="group" namespace="urn:ietf:params:xml:ns:yang:ietf-netconf-acm">cli-only-group</xsl:element>
      <xsl:element name ="rule" namespace="urn:ietf:params:xml:ns:yang:ietf-netconf-acm">
        <xsl:element name ="name" namespace="urn:ietf:params:xml:ns:yang:ietf-netconf-acm">deny-netconf-access</xsl:element>
        <xsl:element name ="action" namespace="urn:ietf:params:xml:ns:yang:ietf-netconf-acm">deny</xsl:element>
        <xsl:element name ="context" namespace="http://tail-f.com/yang/acm">netconf</xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:variable>

<!-- Rule-list to deny access to cli -->
  <xsl:variable name="netconf-rule-list">
    <xsl:element name ="rule-list" namespace="urn:ietf:params:xml:ns:yang:ietf-netconf-acm">
      <xsl:element name ="name" namespace="urn:ietf:params:xml:ns:yang:ietf-netconf-acm">netconf-only-rule-list</xsl:element>
      <xsl:element name ="group" namespace="urn:ietf:params:xml:ns:yang:ietf-netconf-acm">netconf-only-group</xsl:element>
      <xsl:element name ="rule" namespace="urn:ietf:params:xml:ns:yang:ietf-netconf-acm">
        <xsl:element name ="name" namespace="urn:ietf:params:xml:ns:yang:ietf-netconf-acm">deny-cli-access</xsl:element>
        <xsl:element name ="action" namespace="urn:ietf:params:xml:ns:yang:ietf-netconf-acm">deny</xsl:element>
        <xsl:element name ="context" namespace="http://tail-f.com/yang/acm">cli</xsl:element>
      </xsl:element>
      <xsl:element name ="cmdrule" namespace="http://tail-f.com/yang/acm">
        <xsl:element name ="name" namespace="http://tail-f.com/yang/acm">deny-all-cli-cmd</xsl:element>
        <xsl:element name ="action" namespace="http://tail-f.com/yang/acm">deny</xsl:element>
        <xsl:element name ="context" namespace="http://tail-f.com/yang/acm">cli</xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:variable>

<!-- Add new rule-list elements above all rule-list elements -->
  <xsl:template match="acmns:rule-list[acmns:name='techsupport-rule-list']">
    <xsl:copy-of select="$netconf-rule-list"/>
    <xsl:copy-of select="$cli-rule-list"/>
    <xsl:copy-of select="." />
  </xsl:template>

<!-- default rule -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>

