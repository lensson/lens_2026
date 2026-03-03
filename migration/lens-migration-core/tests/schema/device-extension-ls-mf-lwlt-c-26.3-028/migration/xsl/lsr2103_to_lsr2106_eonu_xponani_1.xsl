<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0"
                xmlns:onuNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount"
                xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted"
                xmlns:aniNs="urn:bbf:yang:bbf-xponani-mounted"
>
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

<!-- default rule -->
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

<!-- remove ani node -->
<!--<xsl:template match="/onuNs:onus/onuNs:onu/onuNs:root/ifNs:interfaces/ifNs:interface/aniNs:ani/aniNs:upstream-fec-indicator"/> -->
<!--<xsl:template match="/tailf:config/onuNs:onus/onuNs:onu/onuNs:root/ifNs:interfaces/ifNs:interface/aniNs:ani/aniNs:mgnt-gemport-aes-indicator"/> -->
<!--<xsl:template match="/tailf:config/onuNs:onus/onuNs:onu/onuNs:root/ifNs:interfaces/ifNs:interface/aniNs:ani/aniNs:onu-id"/> -->


<xsl:template match="*[contains(name(),'upstream-fec-indicator')
                    and namespace-uri() = 'urn:bbf:yang:bbf-xponani-mounted'
					and parent::*[contains(name(),'ani')]
                    ]">
</xsl:template>

<xsl:template match="*[contains(name(),'mgnt-gemport-aes-indicator')
                    and namespace-uri() = 'urn:bbf:yang:bbf-xponani-mounted'
					and parent::*[contains(name(),'ani')]
                    ]">
</xsl:template>

<xsl:template match="*[contains(name(),'onu-id')
                    and namespace-uri() = 'urn:bbf:yang:bbf-xponani-mounted'
					and parent::*[contains(name(),'ani')]
                    ]">
</xsl:template>

</xsl:stylesheet>


