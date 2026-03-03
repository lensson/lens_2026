<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:onuNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount" xmlns:hardwareNs="urn:ietf:params:xml:ns:yang:ietf-hardware-mounted" version="1.0">

    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

    <!-- Verify if the board reference has no other references, and if so, remove the board component -->
    <xsl:template match="//onuNs:onus/onuNs:onu/onuNs:root/hardwareNs:hardware/hardwareNs:component">

        <!-- Collect class and name information -->
        <xsl:variable name="type"> <xsl:value-of select="normalize-space(./hardwareNs:class)"/></xsl:variable>
        <xsl:variable name="boardName"><xsl:value-of select="normalize-space(./hardwareNs:name)"/></xsl:variable>
        
        <!-- Refer if it has anything, other than ianahw:cpu -->
        <xsl:variable name="otherRef"> <xsl:value-of select="../hardwareNs:component[normalize-space(./hardwareNs:parent)=$boardName and normalize-space(./hardwareNs:class) != 'ianahw:cpu']"/></xsl:variable>

        <!-- Copy only if there is no other reference-->
        <xsl:if test="$otherRef != '' or $type != 'bbf-hwt:board'">
            <xsl:copy>
                <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
