<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0"
                xmlns:onuNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount"
                xmlns:systemNs="urn:ietf:params:xml:ns:yang:ietf-system-mounted"
>
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

<!-- default rule -->
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

<!-- remove system node -->
<!-- <xsl:template match="/tailf:config/onuNs:onus/onuNs:onu/onuNs:root/systemNs:system"/> -->

<xsl:template match="*[contains(name(),'system')
                    and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-system-mounted'
					and parent::*[contains(name(),'root')]
                    ]">
</xsl:template>

</xsl:stylesheet>

