<?xml version='1.0' encoding='utf-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	            xmlns:if="urn:ietf:params:xml:ns:yang:ietf-interfaces"
		        xmlns:nokia-mvlan-ti="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-mgntvlan-termination-itf">

    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <!-- Remove interfaces of type l2-termination-interface and also any other interface that may reference these -->
    <xsl:variable name="names-to-remove">
        <xsl:for-each select="//if:interface[if:type='nokia-mvlan-ti:l2-termination-interface']/if:name">
            <name><xsl:value-of select="."/></name>
        </xsl:for-each>
    </xsl:variable>

    <xsl:template match="if:interfaces/if:interface[if:type='nokia-mvlan-ti:l2-termination-interface']"/>

    <xsl:template match="if:interface">
        <xsl:variable name="current-interface" select="."/>
        <xsl:choose>
            <xsl:when test="some $name in $names-to-remove/name satisfies contains($current-interface, $name)">
                <!-- Do nothing, effectively removing the node -->
            </xsl:when>
            <xsl:otherwise>
		<xsl:copy>
		   <xsl:copy-of select="@*"/>
                   <xsl:apply-templates/>
		</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
