<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:onu="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount" xmlns:ietf-mounted="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted" xmlns:xponani-mounted="urn:bbf:yang:bbf-xponani-mounted" xmlns:bbf-xponift-mounted="urn:bbf:yang:bbf-xpon-if-type-mounted" version="1.0">
    <xsl:output method="xml" encoding="utf-8" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <!-- This is the identity transform -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>


    <!-- change node gemports-config to node gemports. gemports-config is in 2 places:
         1. onus/onu/root/gemports-config                      ->   onus/onu/root/xpongemtcont/gemports
         2. onus/onu/root/template-parameters/gemports-config  -> onus/onu/root/template-parameters/gemports
        -->
    <xsl:template match="*[name() = 'gemports-config']">
        <xsl:choose>
            <xsl:when test="namespace-uri() = 'http://www.nokia.com/Fixed-Networks/BBA/yang/onus-from-template'">
                <xsl:element name="gemports" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/onus-from-template">
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- change gemport leaf itf-ref to interfaces -->
    <xsl:template match="*[name() = 'itf-ref' and parent::*[name() = 'gemport']]">
        <xsl:choose>
            <xsl:when test="namespace-uri() = 'urn:bbf:yang:bbf-xpongemtcont-mounted'">
                <xsl:element name="interface" namespace="urn:bbf:yang:bbf-xpongemtcont-mounted">
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- change node tconts-config to node tconts. tconts-config is in 2 places:
         1. onus/onu/root/tconts-config                      ->   onus/onu/root/xpongemtcont/tconts
         2. onus/onu/root/template-parameters/tconts-config  -> onus/onu/root/template-parameters/tconts
        -->
    <xsl:template match="*[name() = 'tconts-config']">
        <xsl:choose>
            <xsl:when test="namespace-uri() = 'http://www.nokia.com/Fixed-Networks/BBA/yang/onus-from-template'">
                <xsl:element name="tconts" namespace="http://www.nokia.com/Fixed-Networks/BBA/yang/onus-from-template">
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- change node bbf-xponani-ani-body-mounted:ani-config-data/upstream-fec-indicator to upstream-fec-->
    <xsl:template match="*[name() = 'upstream-fec-indicator']">
        <xsl:choose>
            <xsl:when test="namespace-uri() = 'urn:bbf:yang:bbf-xponani-mounted'">
                <xsl:element name="upstream-fec" namespace="urn:bbf:yang:bbf-xponani-mounted">
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- change node bbf-xponani-ani-body-mounted:ani-config-data/mgnt-gemport-aes-indicator to management-gemport-aes-indicator-->
    <xsl:template match="*[name() = 'mgnt-gemport-aes-indicator']">
        <xsl:choose>
            <xsl:when test="namespace-uri() = 'urn:bbf:yang:bbf-xponani-mounted'">
                <xsl:element name="management-gemport-aes-indicator" namespace="urn:bbf:yang:bbf-xponani-mounted">
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>




    <!-- change namespace tm-root  recursively from: 'urn:bbf:yang:bbf-xpongemtcont-mounted' to: 'urn:bbf:yang:bbf-xpongemtcont-qos-mounted' -->
    <xsl:param name="sourceNamespace" select="'urn:bbf:yang:bbf-xpongemtcont-mounted'"/>
    <xsl:param name="targetNamespace" select="'urn:bbf:yang:bbf-xpongemtcont-qos-mounted'"/>

    <xsl:template match="node() | @*" name="identity">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*">
        <xsl:choose>
            <xsl:when test="namespace-uri() = $sourceNamespace and ./ancestor-or-self::*[name()='tm-root']">
                <xsl:element name="{name()}" namespace="{$targetNamespace}">
                    <xsl:apply-templates select="node() | @*"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="identity"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="*[ name() = 'root' ]">
        <root xmlns="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount">
            <xsl:for-each select="child::*">
                <xsl:choose>
                    <xsl:when test="name() = 'gemports-config' and namespace-uri() = 'urn:bbf:yang:bbf-xpongemtcont-mounted'">
                        <xsl:element name="xpongemtcont" namespace="urn:bbf:yang:bbf-xpongemtcont-mounted">
                            <xsl:element name="gemports" namespace="urn:bbf:yang:bbf-xpongemtcont-mounted">
                                <xsl:apply-templates select="node()|@*"/>
                            </xsl:element>
                            <xsl:for-each select="following-sibling::* | preceding-sibling::*">
                                <xsl:if test="name() = 'tconts-config'">
                                    <xsl:element name="tconts" namespace="urn:bbf:yang:bbf-xpongemtcont-mounted">
                                        <xsl:apply-templates select="node()|@*"/>
                                    </xsl:element>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="name() = 'tconts-config'">
                    </xsl:when>
                    <xsl:when test="name() = 'traffic-descriptor-profiles'">
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy>
                            <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </root>
    </xsl:template>

    <xsl:template match="*[(name() = 'gemports-config' or name() = 'tconts-config' or name()='traffic-descriptor-profiles') and namespace-uri() = 'urn:bbf:yang:bbf-xpongemtcont-mounted']"/>


    <!-- delete onu-v-enet note-->
    <xsl:template match="onu:onus/onu:onu/onu:root/ietf-mounted:interfaces/ietf-mounted:interface/xponani-mounted:onu-v-enet"/>
    <!-- delete onu-v-vrefpoint note-->
    <xsl:template match="onu:onus/onu:onu/onu:root/ietf-mounted:interfaces/ietf-mounted:interface/xponani-mounted:onu-v-vrefpoint"/>

    <xsl:template match="//ietf-mounted:interface/ietf-mounted:type">
        <xsl:choose>
            <xsl:when test="text() =  'bbf-xponift-mounted:onu-v-enet'">
                <!-- copy type note -->
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>

                <!-- create new  onu-v-enet/ani with corrct ani name note -->
                <onu-v-enet xmlns="urn:bbf:yang:bbf-xponani-mounted">
                    <ani>
                        <xsl:value-of select=" ../../ietf-mounted:interface/ietf-mounted:type[text() = 'bbf-xponift-mounted:ani']/../ietf-mounted:name "/>
                    </ani>
                </onu-v-enet>

            </xsl:when>
            <xsl:when test="text() =  'bbf-xponift-mounted:onu-v-vrefpoint'">
                <!-- copy type note -->
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>

                <!-- create new onu-v-vrefpoint/related-onu with corrct ani name note -->
                <onu-v-vrefpoint xmlns="urn:bbf:yang:bbf-xponani-mounted">
                    <related-onu>
                        <xsl:value-of select=" ../../ietf-mounted:interface/ietf-mounted:type[text() = 'bbf-xponift-mounted:ani']/../ietf-mounted:name "/>
                    </related-onu>
                </onu-v-vrefpoint>

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
