<?xml version="1.0"?>


<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:onu="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount"
                              xmlns:voip="urn:bbf:yang:bbf-sip-voip-mounted">

    <xsl:strip-space elements="*" />
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <!-- default rule -->
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*" />
        </xsl:copy>
    </xsl:template>

    <!-- remove unsupported nodes -->
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:supplementary-services-profiles/voip:supplementary-services-profile/voip:do-not-disturb" />

</xsl:stylesheet>
