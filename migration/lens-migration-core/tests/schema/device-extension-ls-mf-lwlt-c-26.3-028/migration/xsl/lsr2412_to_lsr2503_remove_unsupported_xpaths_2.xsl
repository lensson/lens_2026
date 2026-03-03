<?xml version='1.0' encoding='utf-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
		        xmlns:nokia-dhcp-client="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-dhcp-client">

    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <!-- Remove /nokia-dhcp-client:dhcp-client -->
    <xsl:template match="nokia-dhcp-client:dhcp-client"/>

</xsl:stylesheet>
