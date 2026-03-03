<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:param name="classifierNameSpace" select="'urn:bbf:yang:bbf-qos-classifiers'"/>

    <!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <!-- classifier-entry variable-->
    <xsl:variable name="add_classifier-entry">
        <xsl:element name="classifier-entry" namespace="{$classifierNameSpace}">
            <xsl:element name="name" namespace="{$classifierNameSpace}">obcRateLimitClaForNNI</xsl:element>
            <xsl:element name="filter-operation" namespace="{$classifierNameSpace}">match-all-filter</xsl:element>
            <xsl:element name="match-criteria" namespace="{$classifierNameSpace}">
                <xsl:element name="match-all" namespace="{$classifierNameSpace}"/>
            </xsl:element>
            <xsl:element name="classifier-action-entry-cfg" namespace="{$classifierNameSpace}">
                <action-type xmlns:bbf-qos-rc="urn:bbf:yang:bbf-qos-rate-control" xmlns="urn:bbf:yang:bbf-qos-classifiers">bbf-qos-rc:rate-limit-frames</action-type>
                <xsl:element name="rate-limit-frames" namespace="urn:bbf:yang:bbf-qos-rate-control">
                    <xsl:element name="rate" namespace="urn:bbf:yang:bbf-qos-rate-control">256</xsl:element>
                    <xsl:element name="burst-size" namespace="urn:bbf:yang:bbf-qos-rate-control">512</xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:variable>

    <!-- classifier variable which include NNI classifier-entry-->
    <xsl:variable name="add_classifiers">
        <xsl:element name="classifiers" namespace="{$classifierNameSpace}">
            <xsl:copy-of select="$add_classifier-entry"/>
        </xsl:element>
    </xsl:variable>

    <!--
    if classifiers exist,  the obcRateLimitClaForNNI classifier-entry will be added as the classifiers children element.
    -->
    <xsl:template match="*[name() = 'classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers']">
        <xsl:variable name="classifier-entry-exist" select="child::*[name()='classifier-entry'] and descendant::*[text()='obcRateLimitClaForNNI']"/>
        <xsl:choose>
            <xsl:when test="$classifier-entry-exist">
                <xsl:copy>
                   <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
                    <xsl:copy-of select="$add_classifier-entry"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
      if classifiers not exist, classifiers element which include obcRateLimitClaForNNI classifier-entry will be added as the config children element
    -->
    <xsl:template match="/*[name()='config']">
        <xsl:variable name="classifiers-exist" select="child::*[name()='classifiers' and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers'] "/>
        <xsl:choose>
            <xsl:when test="$classifiers-exist">
                <xsl:copy>
                   <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
                    <xsl:copy-of select="$add_classifiers"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
