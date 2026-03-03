<?xml version="1.0" ?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0"
xmlns:cfgNs="urn:ietf:params:xml:ns:netconf:base:1.0"
xmlns:bbfXpon="urn:bbf:yang:bbf-xpon"
xmlns:bbfGem="urn:bbf:yang:bbf-xpongemtcont"
xmlns:bbfIfPortRef="urn:bbf:yang:bbf-interface-port-reference"
xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces"
exclude-result-prefixes="bbfGem bbfIfPortRef bbfXpon cfgNs ifNs">

<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
<xsl:strip-space elements="*"/>

<!-- default rule -->
<xsl:template match="node()|@*">
    <xsl:copy>
        <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
</xsl:template>

<xsl:template match="*[(local-name() = 'ictp-config' or local-name() = 'multicast-gemports-config' or local-name() = 'multicast-distribution-set-config' or
    local-name() = 'wavelength-profiles') and namespace-uri() = 'urn:bbf:yang:bbf-xpon' and parent::*[local-name()!='xpon']]"/>
<xsl:template match="*[(local-name() = 'gemports-config' or local-name() = 'tconts-config' or local-name() = 'traffic-descriptor-profiles') and
    namespace-uri() = 'urn:bbf:yang:bbf-xpongemtcont' and parent::*[local-name()!='xpongemtcont']]"/>

</xsl:stylesheet>
