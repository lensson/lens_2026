<?xml version="1.0" ?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:if="urn:ietf:params:xml:ns:yang:ietf-interfaces"
  xmlns:dot1x="urn:ieee:std:802.1X:yang:ieee802-dot1x"
  xmlns:nokia-dyn-auth-types="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-radius-dynamic-authorization-types"
  xmlns:nokia-dyn-auth-ext="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-802-dot1x-ext-dynamic-authorization"
  exclude-result-prefixes="if dot1x nokia-dyn-auth-ext">

  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <!-- Replace the target element -->
  <xsl:template match="nokia-dyn-auth-ext:dynamic-auth-control">
    <dynamic-auth-control xmlns="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-802-dot1x-ext-dynamic-authorization"
                          xmlns:nokia-dyn-auth-types="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-radius-dynamic-authorization-types">
      <xsl:text>nokia-dyn-auth-types:dynamic-auth-enable-coa-and-dm</xsl:text>
    </dynamic-auth-control>
  </xsl:template>

</xsl:stylesheet>

