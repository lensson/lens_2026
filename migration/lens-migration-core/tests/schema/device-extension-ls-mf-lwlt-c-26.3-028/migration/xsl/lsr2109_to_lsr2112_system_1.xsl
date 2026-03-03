<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml"  indent="yes"/>

    <!-- Default rule: copy -->
    <xsl:template match="*">
        <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <!--
        Special rule for system/authentication subtree: do nothing, effectively
        removing it.
        Not using absolute paths to match, in order to avoid problems with
        change of namespaces during offline migration.
    -->
    <xsl:template match="*[name() = 'authentication'
        and namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-system'
        and parent::*[name() = 'system']]"/>
</xsl:stylesheet>
