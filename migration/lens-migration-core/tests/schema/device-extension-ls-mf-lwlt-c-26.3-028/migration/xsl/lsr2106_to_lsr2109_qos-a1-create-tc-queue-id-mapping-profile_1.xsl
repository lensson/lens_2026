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

    <xsl:template match="*[name() = 'tm-profiles'         and namespace-uri() = 'urn:bbf:yang:bbf-qos-traffic-mngt'     ]">

        <xsl:variable name="has_8queues" select="descendant::*[name() = 'name'][text() = 'DEFAULT_TC_TO_8Queues']"/>
        <xsl:variable name="profile_node" select="child::*[name() = 'tc-id-2-queue-id-mapping-profile']"/>
        <xsl:variable name="not_profile_node" select="child::*[name() != 'tc-id-2-queue-id-mapping-profile']"/>

        <xsl:variable name="new_profile_node">
            <xsl:element xmlns="urn:bbf:yang:bbf-qos-traffic-mngt" name="tc-id-2-queue-id-mapping-profile" namespace="urn:bbf:yang:bbf-qos-traffic-mngt">
                <name>DEFAULT_TC_TO_8Queues</name>
                <mapping-entry>
                    <traffic-class-id>0</traffic-class-id>
                    <local-queue-id>0</local-queue-id>
                </mapping-entry>
                <mapping-entry>
                    <traffic-class-id>1</traffic-class-id>
                    <local-queue-id>1</local-queue-id>
                </mapping-entry>
                <mapping-entry>
                    <traffic-class-id>2</traffic-class-id>
                    <local-queue-id>2</local-queue-id>
                </mapping-entry>
                <mapping-entry>
                    <traffic-class-id>3</traffic-class-id>
                    <local-queue-id>3</local-queue-id>
                </mapping-entry>
                <mapping-entry>
                    <traffic-class-id>4</traffic-class-id>
                    <local-queue-id>4</local-queue-id>
                </mapping-entry>
                <mapping-entry>
                    <traffic-class-id>5</traffic-class-id>
                    <local-queue-id>5</local-queue-id>
                </mapping-entry>
                <mapping-entry>
                    <traffic-class-id>6</traffic-class-id>
                    <local-queue-id>6</local-queue-id>
                </mapping-entry>
                <mapping-entry>
                    <traffic-class-id>7</traffic-class-id>
                    <local-queue-id>7</local-queue-id>
                </mapping-entry>
            </xsl:element>
        </xsl:variable>


        <xsl:choose>
            <xsl:when test="$has_8queues">
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:copy-of select="$profile_node"/>
                    <xsl:copy-of select="$new_profile_node"/>
                    <xsl:copy-of select="$not_profile_node"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>
</xsl:stylesheet>
