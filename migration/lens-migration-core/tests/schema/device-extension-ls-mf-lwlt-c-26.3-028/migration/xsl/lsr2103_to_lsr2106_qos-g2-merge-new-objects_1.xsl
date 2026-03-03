<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:onusNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount"
    xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted"
    xmlns:qosNs="urn:bbf:yang:bbf-qos-policies-mounted"
    xmlns:clsNs="urn:bbf:yang:bbf-qos-classifiers-mounted"
>
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="var_onusNs">urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount</xsl:variable>
    <xsl:variable name="var_ifNs">urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted</xsl:variable>
    <xsl:variable name="var_qosNs">urn:bbf:yang:bbf-qos-policies-mounted</xsl:variable>
    <xsl:variable name="var_clsNs">urn:bbf:yang:bbf-qos-classifiers-mounted</xsl:variable>
    <!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>


    <xsl:template match="*[name() = 'classifiers'
        and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers-mounted'
        and parent::*[name() = 'root']
    ]">
        <xsl:variable name="ns" select="namespace-uri()"/>
        <xsl:element name="classifiers" namespace="{$ns}">
            <xsl:copy-of select="child::*"/>
            <xsl:variable name="var_onu_name" select="../../child::*[name() = 'name']"/>
            <xsl:for-each select="../clsNs:classifiers-new/clsNs:classifier-entry">
                <xsl:variable name="var_cls_name" select="child::*[name() = 'name']"/>
                <xsl:variable name="var_policy" select="../../qosNs:policies-new/qosNs:policy/qosNs:classifiers/child::*[name() = 'name' and text()=$var_cls_name]"/>
                <xsl:if test="$var_policy">
                    <xsl:copy-of select="."/>
                </xsl:if>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    <!--
  <xsl:template match="*[name() = 'classifiers-new']">
    <xsl:choose>
      <xsl:when test="namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers-mounted'
                 and parent::*[name() = 'root']
      ">
        <xsl:variable name="ns" select="namespace-uri()"/>

        <xsl:element name="classifiers" namespace="{$ns}">
			<xsl:apply-templates select="node()|@*"/>
        </xsl:element>
      </xsl:when>

      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
      </xsl:otherwise>

    </xsl:choose>
  </xsl:template>
-->

    <xsl:template match="*[name() = 'policies'
        and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies-mounted'
        and parent::*[name() = 'root']
    ]">
        <xsl:variable name="ns" select="namespace-uri()"/>
        <xsl:element name="policies" namespace="{$ns}">
            <xsl:copy-of select="child::*"/>
            <xsl:copy-of select="../qosNs:policies-new/child::*"/>
        </xsl:element>
    </xsl:template>



    <xsl:template match="*[name() = 'qos-policy-profiles'
        and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies-mounted'
        and parent::*[name() = 'root']
    ]">
        <xsl:variable name="ns" select="namespace-uri()"/>
        <xsl:element name="qos-policy-profiles" namespace="{$ns}">
            <xsl:copy-of select="child::*"/>
            <xsl:copy-of select="../qosNs:qos-policy-profiles-new/child::*"/>
        </xsl:element>
    </xsl:template>


    <xsl:template match="*[name() = 'classifiers-new'
        and namespace-uri() = 'urn:bbf:yang:bbf-qos-classifiers-mounted'
        and parent::*[name() = 'root']
    ]">
    </xsl:template>

    <xsl:template match="*[name() = 'policies-new'
        and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies-mounted'
        and parent::*[name() = 'root']
    ]">
    </xsl:template>

    <xsl:template match="*[name() = 'qos-policy-profiles-new'
        and namespace-uri() = 'urn:bbf:yang:bbf-qos-policies-mounted'
        and parent::*[name() = 'root']
    ]">
    </xsl:template>

</xsl:stylesheet>
