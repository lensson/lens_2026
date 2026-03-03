<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:onusNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount" xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted" xmlns:qosNs="urn:bbf:yang:bbf-qos-policies-mounted" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>
    <!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="*[name() = 'pbit-value']">
        <xsl:choose>
            <xsl:when test="namespace-uri() = 'urn:bbf:yang:bbf-qos-policies-mounted'                 and parent::*[name() = 'soure_classifier']             ">
                <xsl:variable name="ns" select="namespace-uri()"/>
                <xsl:choose>
                    <xsl:when test="string-length(text()) &gt; 1">
                        <xsl:element name="pbit-value" namespace="{$ns}">
                            <xsl:call-template name="tokenize">
                                <xsl:with-param name="text" select="text()"/>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="pbit-value" namespace="{$ns}">
                            <xsl:value-of select="text()"/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="tokenize">
        <xsl:param name="text"/>
        <xsl:param name="delimiter" select="','"/>
        <xsl:variable name="token" select="substring-before($text, $delimiter) "/>
        <xsl:variable name="ns" select="'urn:bbf:yang:bbf-qos-policies-mounted'"/>
        <xsl:choose>
            <xsl:when test="contains($token,'-') or $token =''">
                <xsl:variable name="btestvalue" select="substring-before($token, '-')"/>
                <xsl:variable name="atestvalue" select="substring-after($token, '-')"/>
                <xsl:if test=" (0 &gt;= number($btestvalue)) and (0 &lt;= number($atestvalue))">
                    <xsl:element name="item" namespace="{$ns}">
                        <xsl:value-of select="0"/>
                    </xsl:element>
                </xsl:if>
                <xsl:if test=" (1 &gt;= number($btestvalue)) and (1 &lt;= number($atestvalue))">
                    <xsl:element name="item" namespace="{$ns}">
                        <xsl:value-of select="1"/>
                    </xsl:element>
                </xsl:if>
                <xsl:if test=" (2 &gt;= number($btestvalue)) and (2 &lt;= number($atestvalue))">
                    <xsl:element name="item" namespace="{$ns}">
                        <xsl:value-of select="2"/>
                    </xsl:element>
                </xsl:if>
                <xsl:if test=" (3 &gt;= number($btestvalue)) and (3 &lt;= number($atestvalue))">
                    <xsl:element name="item" namespace="{$ns}">
                        <xsl:value-of select="3"/>
                    </xsl:element>
                </xsl:if>
                <xsl:if test=" (4 &gt;= number($btestvalue)) and (4 &lt;= number($atestvalue))">
                    <xsl:element name="item" namespace="{$ns}">
                        <xsl:value-of select="4"/>
                    </xsl:element>
                </xsl:if>
                <xsl:if test=" (5 &gt;= number($btestvalue)) and (5 &lt;= number($atestvalue))">
                    <xsl:element name="item" namespace="{$ns}">
                        <xsl:value-of select="5"/>
                    </xsl:element>
                </xsl:if>
                <xsl:if test=" (6 &gt;= number($btestvalue)) and (6 &lt;= number($atestvalue))">
                    <xsl:element name="item" namespace="{$ns}">
                        <xsl:value-of select="6"/>
                    </xsl:element>
                </xsl:if>
                <xsl:if test=" (7 &gt;= number($btestvalue)) and (7 &lt;= number($atestvalue))">
                    <xsl:element name="item" namespace="{$ns}">
                        <xsl:value-of select="7"/>
                    </xsl:element>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="item" namespace="{$ns}">
                    <xsl:value-of select="$token"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:variable name="next" select="substring-after($text, $delimiter)"/>
        <xsl:if test="$next">
            <!-- recursive call -->
            <xsl:call-template name="tokenize">
                <xsl:with-param name="text" select="$next"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
