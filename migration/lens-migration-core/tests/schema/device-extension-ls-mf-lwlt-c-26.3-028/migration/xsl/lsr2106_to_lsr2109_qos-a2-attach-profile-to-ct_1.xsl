<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

    <!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*[name() = 'tm-root'         and namespace-uri() = 'urn:bbf:yang:bbf-qos-traffic-mngt'         and parent::*[name() = 'interface']         and ancestor::*[name() = 'interfaces']     ]">
        <xsl:variable name="has_default_tc_id_profile" select="child::*[name()='tc-id-2-queue-id-mapping-profile-name']"/>

        <xsl:variable name="not_in_channel_partition" select="not(preceding-sibling::*[local-name() = 'type'][text() = 'channel-partition' or text()='bbf-xponift:channel-partition' ] or following-sibling::*[local-name() = 'type'][namespace-uri() = 'urn:bbf:yang:bbf-xpon-if-type'][text() = 'channel-partition' or text()='bbf-xponift:channel-partition'])"/>

        <xsl:choose>
            <xsl:when test="$has_default_tc_id_profile or $not_in_channel_partition">
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:element name="tc-id-2-queue-id-mapping-profile-name" namespace="urn:bbf:yang:bbf-qos-traffic-mngt">DEFAULT_TC_TO_8Queues</xsl:element>
                    <xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
