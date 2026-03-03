<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:param name="policiesNameSpace" select="'urn:bbf:yang:bbf-qos-policies'"/>

    <!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <!-- policy variable-->
    <xsl:variable name="add_nni_default_obc_policy">
        <xsl:element name="policy" namespace="{$policiesNameSpace}">
            <xsl:element name="name" namespace="{$policiesNameSpace}">obcRateLimitPolForNNI</xsl:element>
            <xsl:element name="classifiers" namespace="{$policiesNameSpace}">
                <xsl:element name="name" namespace="{$policiesNameSpace}">obcRateLimitClaForNNI</xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:variable>

    <!-- policies variable which include NNI policy-->
    <xsl:variable name="add_policyes">
        <xsl:element name="policies" namespace="{$policiesNameSpace}">
            <xsl:copy-of select="$add_nni_default_obc_policy"/>
        </xsl:element>
    </xsl:variable>

    <!--
    if policies exist,  the NNI policy which refer to NNI classifier-entry will be added as the policies children element.
    -->
    <xsl:template match="/*/*[name() ='policies'         and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies'         and parent::*[name() = 'config']         ]">
        <xsl:variable name="policy-exist" select="child::*[name()='policy'] and descendant::*[text()='obcRateLimitPolForNNI'] "/>
        <xsl:choose>
            <xsl:when test="$policy-exist">
                <xsl:copy>
                   <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
                    <xsl:copy-of select="$add_nni_default_obc_policy"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
      if policies not exist, the policies element which include NNI policy  will be added as the config children element
    -->
    <xsl:template match="/*[name()='config']">
        <xsl:variable name="policies-exist" select="child::*[name()='policies' and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies'] "/>
        <xsl:choose>
            <xsl:when test="$policies-exist">
                <xsl:copy>
                   <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
                    <xsl:copy-of select="$add_policyes"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
