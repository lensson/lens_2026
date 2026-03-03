<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ncs="urn:ietf:params:xml:ns:yang:ietf-netconf-server">

    <!-- Template to match and clear the content of cert-to-name, including attributes -->
    <xsl:template match="ncs:netconf-server/ncs:call-home/ncs:netconf-client/ncs:endpoints/ncs:endpoint/ncs:tls/ncs:client-auth/ncs:cert-maps/ncs:cert-to-name">
    </xsl:template>

</xsl:stylesheet>
