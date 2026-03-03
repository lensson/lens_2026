<?xml version="1.0" ?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0"
>

<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
<xsl:strip-space elements="*"/>

<xsl:template name="element-name-value-ns">
    <xsl:param name="PREFIX"/>
    <xsl:param name="NAME"/>
    <xsl:param name="VAL"/>
    <xsl:param name="NS"/>
    <xsl:choose>
        <xsl:when test="contains($VAL,':')">
            <xsl:element name="{$PREFIX}:{$NAME}" namespace="{$NS}">
                <xsl:value-of select="$PREFIX"/><xsl:text>:</xsl:text><xsl:value-of select="substring-after($VAL,':')"/>
            </xsl:element>
        </xsl:when>
        <xsl:otherwise>
            <xsl:element name="{$NAME}" namespace="{$NS}">
                <xsl:apply-templates select="node()"/>
            </xsl:element>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- default rule -->
<!-- transform upstream-fec-indicator -->
<xsl:template match="*[contains(name(),'upstream-fec-indicator') and namespace-uri() = 'urn:broadband-forum-org:yang:bbf-xponinfra-augment-nodes' ]">
    <xsl:variable name="ns" select="namespace-uri(..)"/>
    <xsl:call-template name="element-name-value-ns">
        <xsl:with-param name="PREFIX">xponvani</xsl:with-param>
        <xsl:with-param name="NAME">upstream-fec</xsl:with-param>
        <xsl:with-param name="VAL"> <xsl:value-of select="."/></xsl:with-param>
        <xsl:with-param name="NS">  <xsl:value-of select="$ns"/></xsl:with-param>
    </xsl:call-template>
</xsl:template>

<!-- transform jitter-tolerance in traffic descriptor profile -->
<xsl:variable name="xponTrafficDesProfAug" select="string('http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-traffic-descriptor-profile-aug')"/>
<xsl:template match="*[contains(name(),'jitter-tolerance') and namespace-uri() = 'urn:broadband-forum-org:yang:bbf-xponinfra-augment-nodes' ]">
    <xsl:call-template name="element-name-value-ns">
        <xsl:with-param name="PREFIX">nokia-sdan-traffic-descriptor-profile-aug</xsl:with-param>
        <xsl:with-param name="NAME"><xsl:value-of select="local-name()"/></xsl:with-param>
        <xsl:with-param name="VAL"> <xsl:value-of select="."/></xsl:with-param>
        <xsl:with-param name="NS">  <xsl:value-of select="$xponTrafficDesProfAug"/></xsl:with-param>
    </xsl:call-template>
</xsl:template>

<!-- transform vani nodes -->
<xsl:variable name="xponVaniAug" select="string('http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-if-xponvani-aug')"/>
<xsl:template match="*[contains(name(),'onu-peak-data-rate-downstream') and namespace-uri() = 'urn:broadband-forum-org:yang:bbf-xponinfra-augment-nodes']">
    <xsl:call-template name="element-name-value-ns">
        <xsl:with-param name="PREFIX">nokia-sdan-if-xponvani-aug</xsl:with-param>
        <xsl:with-param name="NAME"><xsl:value-of select="local-name()"/></xsl:with-param>
        <xsl:with-param name="VAL"> <xsl:value-of select="."/></xsl:with-param>
        <xsl:with-param name="NS">  <xsl:value-of select="$xponVaniAug"/></xsl:with-param>
    </xsl:call-template>
</xsl:template>

<xsl:template match="*[contains(name(),'onu-name') and namespace-uri() = 'urn:broadband-forum-org:yang:bbf-xponinfra-augment-nodes']">
    <xsl:call-template name="element-name-value-ns">
        <xsl:with-param name="PREFIX">nokia-sdan-if-xponvani-aug</xsl:with-param>
        <xsl:with-param name="NAME"><xsl:value-of select="local-name()"/></xsl:with-param>
        <xsl:with-param name="VAL"> <xsl:value-of select="."/></xsl:with-param>
        <xsl:with-param name="NS">  <xsl:value-of select="$xponVaniAug"/></xsl:with-param>
    </xsl:call-template>
</xsl:template>

<xsl:template match="*[contains(name(),'ber-interval') and namespace-uri() = 'urn:broadband-forum-org:yang:bbf-xponinfra-augment-nodes']"/>

<!-- transform xpon nodes -->
<xsl:variable name="xponAug" select="string('http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-if-xpon-aug')"/>
<xsl:template match="*[contains(name(),'specific-polling-period') and namespace-uri() = 'urn:broadband-forum-org:yang:bbf-xponinfra-augment-nodes']">
    <xsl:call-template name="element-name-value-ns">
        <xsl:with-param name="PREFIX">nokia-sdan-if-xpon-aug</xsl:with-param>
        <xsl:with-param name="NAME"><xsl:value-of select="local-name()"/></xsl:with-param>
        <xsl:with-param name="VAL"> <xsl:value-of select="."/></xsl:with-param>
        <xsl:with-param name="NS">  <xsl:value-of select="$xponAug"/></xsl:with-param>
    </xsl:call-template>
</xsl:template>

<xsl:template match="*[contains(name(),'laser-on-by-default') and namespace-uri() = 'urn:broadband-forum-org:yang:bbf-xponinfra-augment-nodes']">
    <xsl:call-template name="element-name-value-ns">
        <xsl:with-param name="PREFIX">nokia-sdan-if-xpon-aug</xsl:with-param>
        <xsl:with-param name="NAME"><xsl:value-of select="local-name()"/></xsl:with-param>
        <xsl:with-param name="VAL"> <xsl:value-of select="."/></xsl:with-param>
        <xsl:with-param name="NS">  <xsl:value-of select="$xponAug"/></xsl:with-param>
    </xsl:call-template>
</xsl:template>

<xsl:template match="*[contains(name(),'ber-tca-profile') and name(..) = 'interface' and namespace-uri() = 'urn:broadband-forum-org:yang:bbf-xponinfra-augment-nodes']">
    <!--xsl:element name="ber-tca-profile" namespace="{$xponAug}">
        <xsl:value-of select="."/>
    </xsl:element-->
</xsl:template>

<xsl:param name="sourceNS" select="'urn:broadband-forum-org:yang:bbf-xponinfra-augment-nodes'" />
<xsl:param name="xponAugNS" select="'http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-sdan-if-xpon-aug'" />

<xsl:template name="xponAugNS">
    <xsl:copy>
        <xsl:apply-templates select="node() | @*"/>
    </xsl:copy>
</xsl:template>

<xsl:template match="*[name() = 'channel-pair']">
    <xsl:element name="channel-pair" xmlns="urn:bbf:yang:bbf-xpon">
        <xsl:for-each select="child::*">
            <xsl:choose>
                <xsl:when test="namespace-uri() = $sourceNS">
                    <xsl:choose>
                        <xsl:when test="local-name() = 'onu-enable-disable-ploam-condition'">
                            <xsl:element name="nokia-sdan-if-xpon-aug:{local-name()}" namespace="{$xponAugNS}">
                                <xsl:apply-templates select="node()|@*"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:variable name="cfgValue" select="text()"/>
                            <xsl:choose>
                                <xsl:when test="contains($cfgValue,':')">
                                    <xsl:element name="nokia-sdan-if-xpon-aug:{local-name()}" namespace="{$xponAugNS}">
                                        <xsl:text>nokia-sdan-if-xpon-aug:</xsl:text><xsl:value-of select="substring-after($cfgValue,':')"/>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:element name="{local-name()}" namespace="{$xponAugNS}">
                                        <xsl:apply-templates select="node()"/>
                                    </xsl:element>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="xponAugNS"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:variable name="tcaProf" select="../*[contains(name(),'ber-tca-profile') and namespace-uri()='urn:broadband-forum-org:yang:bbf-xponinfra-augment-nodes']"/>
        <xsl:if test="$tcaProf != ''">
            <xsl:element name="ber-tca-profile" namespace="{$xponAug}">
                <xsl:value-of select="$tcaProf"/>
        </xsl:element>
        </xsl:if>
    </xsl:element>
</xsl:template>

<!--xsl:template match="*[name() = 'channel-termination-type-b-pon-location-data' and name(..) = 'channel-termination']">
    <xsl:element name="channel-termination" namespace="{$xponAug}">
        <xsl:value-of select="."/>
    </xsl:element>
</xsl:template-->

<!--xsl:template match="*[name() = 'onu-enable-disable-ploam-condition' and name(..) = 'channel-pair']">
    <xsl:element name="onu-enable-disable-ploam-condition" namespace="{$xponAug}">
            <xsl:apply-templates select="node()|@*"/>
    </xsl:element>
</xsl:template-->

<xsl:template match="node() | @*">
    <xsl:choose>
        <xsl:when test="namespace-uri() = $sourceNS">
            <xsl:element namespace="{$xponAugNS}" name="{local-name()}">
                <xsl:variable name="cfgValue" select="text()"/>
                <xsl:choose>
                    <xsl:when test="contains($cfgValue,':')">
                        <xsl:text>nokia-sdan-if-xpon-aug:</xsl:text><xsl:value-of select="substring-after($cfgValue,':')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="node()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="xponAugNS"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- add other xpon augment transformation -->

<!-- transform xcvr-diagnostics nodes -->
<!-- may not need transformation for readonly nodes -->

<!-- transform xpon-onu-states nodes -->
<!-- may not need transformation for readonly nodes -->

<!-- transformation rule for module bbf-xponinfra-augment -->
<xsl:template match="*[name() = 'rule']">
    <xsl:for-each select=".">
        <xsl:variable name="NAME">
            <xsl:value-of select="*[name() = 'name']"/>
        </xsl:variable>
        <xsl:variable name="ns" select="namespace-uri(..)"/>
        <xsl:choose>
            <xsl:when test="$NAME = 'bbf-xponinfra-augment-nodes-read'">
                <xsl:element name="rule" namespace="{$ns}">
                    <xsl:element name="name" namespace="{$ns}">nokia-sdan-hws-xcvr-diagnostics-aug-read</xsl:element>
                    <xsl:element name="module-name" namespace="{$ns}">nokia-sdan-hws-xcvr-diagnostics-aug</xsl:element>
                    <xsl:element name="path" namespace="{$ns}">*</xsl:element>
                    <xsl:element name="access-operations" namespace="{$ns}">read</xsl:element>
                    <xsl:element name="action" namespace="{$ns}">permit</xsl:element>
                    <!--xsl:element name="context" namespace="http://tail-f.com/yang/acm">*</xsl:element-->
                </xsl:element>

                <xsl:element name="rule" namespace="{$ns}">
                    <xsl:element name="name" namespace="{$ns}">nokia-sdan-if-xponvani-aug-read</xsl:element>
                    <xsl:element name="module-name" namespace="{$ns}">nokia-sdan-if-xponvani-aug</xsl:element>
                    <xsl:element name="path" namespace="{$ns}">*</xsl:element>
                    <xsl:element name="access-operations" namespace="{$ns}">read</xsl:element>
                    <xsl:element name="action" namespace="{$ns}">permit</xsl:element>
                    <!--xsl:element name="context" namespace="http://tail-f.com/yang/acm">*</xsl:element-->
                </xsl:element>

                <xsl:element name="rule" namespace="{$ns}">
                    <xsl:element name="name" namespace="{$ns}">nokia-sdan-if-xpon-aug-read</xsl:element>
                    <xsl:element name="module-name" namespace="{$ns}">nokia-sdan-if-xpon-aug</xsl:element>
                    <xsl:element name="path" namespace="{$ns}">*</xsl:element>
                    <xsl:element name="access-operations" namespace="{$ns}">read</xsl:element>
                    <xsl:element name="action" namespace="{$ns}">permit</xsl:element>
                    <!--xsl:element name="context" namespace="http://tail-f.com/yang/acm">*</xsl:element-->
                </xsl:element>

                <xsl:element name="rule" namespace="{$ns}">
                    <xsl:element name="name" namespace="{$ns}">nokia-sdan-traffic-descriptor-profile-aug-read</xsl:element>
                    <xsl:element name="module-name" namespace="{$ns}">nokia-sdan-traffic-descriptor-profile-aug</xsl:element>
                    <xsl:element name="path" namespace="{$ns}">*</xsl:element>
                    <xsl:element name="access-operations" namespace="{$ns}">read</xsl:element>
                    <xsl:element name="action" namespace="{$ns}">permit</xsl:element>
                    <!--xsl:element name="context" namespace="http://tail-f.com/yang/acm">*</xsl:element-->
                </xsl:element>

                <xsl:element name="rule" namespace="{$ns}">
                    <xsl:element name="name" namespace="{$ns}">nokia-sdan-xpon-onu-state-aug-read</xsl:element>
                    <xsl:element name="module-name" namespace="{$ns}">nokia-sdan-xpon-onu-state-aug</xsl:element>
                    <xsl:element name="path" namespace="{$ns}">*</xsl:element>
                    <xsl:element name="access-operations" namespace="{$ns}">read</xsl:element>
                    <xsl:element name="action" namespace="{$ns}">permit</xsl:element>
                    <!--xsl:element name="context" namespace="http://tail-f.com/yang/acm">*</xsl:element-->
                </xsl:element>
            </xsl:when>
            <xsl:when test="$NAME = 'bbf-xponinfra-augment-nodes-config'">
                <xsl:element name="rule" namespace="{$ns}">
                    <xsl:element name="name" namespace="{$ns}">nokia-sdan-hws-xcvr-diagnostics-aug-config</xsl:element>
                    <xsl:element name="module-name" namespace="{$ns}">nokia-sdan-hws-xcvr-diagnostics-aug</xsl:element>
                    <xsl:element name="path" namespace="{$ns}">*</xsl:element>
                    <xsl:element name="access-operations" namespace="{$ns}">create read update delete</xsl:element>
                    <xsl:element name="action" namespace="{$ns}">permit</xsl:element>
                    <!--xsl:element name="context" namespace="http://tail-f.com/yang/acm">*</xsl:element-->
                </xsl:element>

                <xsl:element name="rule" namespace="{$ns}">
                    <xsl:element name="name" namespace="{$ns}">nokia-sdan-if-xponvani-aug-config</xsl:element>
                    <xsl:element name="module-name" namespace="{$ns}">nokia-sdan-if-xponvani-aug</xsl:element>
                    <xsl:element name="path" namespace="{$ns}">*</xsl:element>
                    <xsl:element name="access-operations" namespace="{$ns}">create read update delete</xsl:element>
                    <xsl:element name="action" namespace="{$ns}">permit</xsl:element>
                    <!--xsl:element name="context" namespace="http://tail-f.com/yang/acm">*</xsl:element-->
                </xsl:element>

                <xsl:element name="rule" namespace="{$ns}">
                    <xsl:element name="name" namespace="{$ns}">nokia-sdan-if-xpon-aug-config</xsl:element>
                    <xsl:element name="module-name" namespace="{$ns}">nokia-sdan-if-xpon-aug</xsl:element>
                    <xsl:element name="path" namespace="{$ns}">*</xsl:element>
                    <xsl:element name="access-operations" namespace="{$ns}">create read update delete</xsl:element>
                    <xsl:element name="action" namespace="{$ns}">permit</xsl:element>
                    <!--xsl:element name="context" namespace="http://tail-f.com/yang/acm">*</xsl:element-->
                </xsl:element>

                <xsl:element name="rule" namespace="{$ns}">
                    <xsl:element name="name" namespace="{$ns}">nokia-sdan-traffic-descriptor-profile-aug-config</xsl:element>
                    <xsl:element name="module-name" namespace="{$ns}">nokia-sdan-traffic-descriptor-profile-aug</xsl:element>
                    <xsl:element name="path" namespace="{$ns}">*</xsl:element>
                    <xsl:element name="access-operations" namespace="{$ns}">create read update delete</xsl:element>
                    <xsl:element name="action" namespace="{$ns}">permit</xsl:element>
                    <!--xsl:element name="context" namespace="http://tail-f.com/yang/acm">*</xsl:element-->
                </xsl:element>

                <xsl:element name="rule" namespace="{$ns}">
                    <xsl:element name="name" namespace="{$ns}">nokia-sdan-xpon-onu-state-aug-config</xsl:element>
                    <xsl:element name="module-name" namespace="{$ns}">nokia-sdan-xpon-onu-state-aug</xsl:element>
                    <xsl:element name="path" namespace="{$ns}">*</xsl:element>
                    <xsl:element name="access-operations" namespace="{$ns}">create read update delete</xsl:element>
                    <xsl:element name="action" namespace="{$ns}">permit</xsl:element>
                    <!--xsl:element name="context" namespace="http://tail-f.com/yang/acm">*</xsl:element-->
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="rule" namespace="{$ns}">
                    <xsl:apply-templates select="node()|@*"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:for-each>
</xsl:template>
</xsl:stylesheet>
