<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:ks="urn:ietf:params:xml:ns:yang:ietf-keystore" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <!-- Remove all keystore configuration -->
    <xsl:template match="ks:keystore/ks:asymmetric-keys/ks:asymmetric-key[not(ks:name = 'factory-callhome-key')]"/>
</xsl:stylesheet>