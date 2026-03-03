<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
xmlns:cfgNs="urn:ietf:params:xml:ns:netconf:base:1.0"
xmlns:xpon="urn:bbf:yang:bbf-xpon">

    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <!-- Rule 1: remove xpon multicast-gemports. -->
    <xsl:template match="/cfgNs:config/xpon:xpon/xpon:multicast-gemports"/>

</xsl:stylesheet>
