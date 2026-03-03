<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:param name="cpuRateLimitNameSpace" select="'urn:bbf:yang:nokia-ingress-cpu-packets-rate-limit'"/>

    <!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <!--
      rate-limit-policy-name variable
    -->
    <xsl:variable name="add_cpu_rate_limit">
        <xsl:element name="default-ingress-cpu-packets-rate-limit" namespace="{$cpuRateLimitNameSpace}">
            <xsl:element name="interface-usage" namespace="{$cpuRateLimitNameSpace}">subtended-node-port</xsl:element>
            <xsl:element name="rate-limit-policy-name" namespace="{$cpuRateLimitNameSpace}">obcRateLimitPolForNNI</xsl:element>
        </xsl:element>
    </xsl:variable>

    <!--
      cpu_load_control_variable which include cpu_rate_limit
    -->
    <xsl:variable name="add_cpu_load_control">
        <xsl:element name="cpu-load-control-cfg" namespace="{$cpuRateLimitNameSpace}">
            <xsl:copy-of select="$add_cpu_rate_limit"/>
        </xsl:element>
    </xsl:variable>

    <!--
    if default-ingress-cpu-packets-rate-limit exist,  the  subtended-node-port cpu_rate_limit will be added as the cpu-load-control-cfg children element.
    -->
    <xsl:template match="/*/*[name() ='cpu-load-control-cfg'         and namespace-uri() = 'urn:bbf:yang:nokia-ingress-cpu-packets-rate-limit'         and parent::*[name() = 'config']         ]">
        <xsl:variable name="cpu_rate_limit-exist" select="child::*[name()='default-ingress-cpu-packets-rate-limit'] and descendant::*[text()='subtended-node-port'] "/>
        <xsl:choose>
            <xsl:when test="$cpu_rate_limit-exist">
                <xsl:copy>
                   <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
                    <xsl:copy-of select="$add_cpu_rate_limit"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
      if cpu-load-control-cfg not exist, cpu-load-control-cfg element which include NNI default rate limit will be added as the config children element
    -->
    <xsl:template match="/*[name()='config']">
        <xsl:variable name="cpu-load-control-cfg-exist" select="child::*[name()='cpu-load-control-cfg' and namespace-uri() = 'urn:bbf:yang:nokia-ingress-cpu-packets-rate-limit'] "/>
        <xsl:choose>
            <xsl:when test="$cpu-load-control-cfg-exist">
                <xsl:copy>
                   <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
                    <xsl:copy-of select="$add_cpu_load_control"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
