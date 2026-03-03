<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cfgNs="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:onu="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount" xmlns:if-mounted="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted" xmlns:bbf-xpongemtcont-mounted="urn:bbf:yang:bbf-xpongemtcont-mounted" xmlns:template-common="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-template-common" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

<!-- remove gemport-id when it is configured in template -->
<xsl:template match="/cfgNs:config/onu:onus/onu:onu[onu:usage = 'template-common:node-template-usage']/onu:root/bbf-xpongemtcont-mounted:xpongemtcont/bbf-xpongemtcont-mounted:gemports/bbf-xpongemtcont-mounted:gemport/bbf-xpongemtcont-mounted:gemport-id"/>

<!-- gemport-id is mandatory in non-template, so remove gemport when gemport-id isn't configured -->
<xsl:template match="/cfgNs:config/onu:onus/onu:onu[onu:usage = 'template-common:node-actual-usage' or not(onu:usage)]/onu:root/bbf-xpongemtcont-mounted:xpongemtcont/bbf-xpongemtcont-mounted:gemports/bbf-xpongemtcont-mounted:gemport">
    <xsl:if test="bbf-xpongemtcont-mounted:gemport-id/text()">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
    </xsl:if>
</xsl:template>

</xsl:stylesheet>
