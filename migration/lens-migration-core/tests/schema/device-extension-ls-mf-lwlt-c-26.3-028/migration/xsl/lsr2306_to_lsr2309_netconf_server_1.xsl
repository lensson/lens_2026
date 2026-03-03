<?xml version="1.0" ?>
<xsl:stylesheet version="1.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:ncs="urn:ietf:params:xml:ns:yang:ietf-netconf-server">

  <!-- Rule： Delete not-supported config cert leaf -->
  <xsl:template match="ncs:netconf-server/ncs:call-home/ncs:netconf-client/ncs:endpoints/ncs:endpoint/ncs:tls/ncs:server-identity/ncs:local-definition/ncs:cert"/>

</xsl:stylesheet>
