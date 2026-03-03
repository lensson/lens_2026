<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:cfgNs="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:bbfXpon="urn:bbf:yang:bbf-xpon" xmlns:bbfGem="urn:bbf:yang:bbf-xpongemtcont" xmlns:bbfIfPortRef="urn:bbf:yang:bbf-interface-port-reference" xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces" version="1.0" exclude-result-prefixes="bbfGem bbfIfPortRef bbfXpon cfgNs ifNs">

<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
<xsl:strip-space elements="*"/>

<!-- default rule -->
<xsl:template match="node()|@*">
    <xsl:copy>
        <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
</xsl:template>


<!-- loop characters in string and change each char to ascii code -->
<xsl:template name="for-loop-char-to-ascii">
    <xsl:param name="i"/>
    <xsl:param name="count"/>
    <xsl:variable name="vApos">'</xsl:variable>
    <xsl:if test="$i != $count">
        <xsl:variable name="sub_str" select="substring(text(), $i, 1)"/>
        <xsl:choose>
            <xsl:when test="$sub_str = ' '">
                <xsl:value-of select="string('20')"/>
            </xsl:when>
            <xsl:when test="$sub_str = '!'">
                <xsl:value-of select="string('21')"/>
            </xsl:when>
            <xsl:when test="$sub_str = '&quot;'">
                <xsl:value-of select="string('22')"/>
            </xsl:when>
            <xsl:when test="$sub_str = '#'">
                <xsl:value-of select="string('23')"/>
            </xsl:when>
            <xsl:when test="$sub_str = '$'">
                <xsl:value-of select="string('24')"/>
            </xsl:when>
            <xsl:when test="$sub_str = '%'">
                <xsl:value-of select="string('25')"/>
            </xsl:when>
            <xsl:when test="$sub_str = '&amp;'">
                <xsl:value-of select="string('26')"/>
            </xsl:when>
            <xsl:when test="$sub_str = $vApos">
                <xsl:value-of select="string('27')"/>
            </xsl:when>
            <xsl:when test="$sub_str = '('">
                <xsl:value-of select="string('28')"/>
            </xsl:when>
            <xsl:when test="$sub_str = ')'">
                <xsl:value-of select="string('29')"/>
            </xsl:when>
            <xsl:when test="$sub_str = '*'">
                <xsl:value-of select="string('2A')"/>
            </xsl:when>
            <xsl:when test="$sub_str = '+'">
                <xsl:value-of select="string('2B')"/>
            </xsl:when>
            <xsl:when test="$sub_str = ','">
                <xsl:value-of select="string('2C')"/>
            </xsl:when>
            <xsl:when test="$sub_str = '-'">
                <xsl:value-of select="string('2D')"/>
            </xsl:when>
            <xsl:when test="$sub_str = '.'">
                <xsl:value-of select="string('2E')"/>
            </xsl:when>
            <xsl:when test="$sub_str = '/'">
                <xsl:value-of select="string('2F')"/>
            </xsl:when>
            <xsl:when test="$sub_str = '0'">
                <xsl:value-of select="string('30')"/>
            </xsl:when>
            <xsl:when test="$sub_str = '1'">
                <xsl:value-of select="string('31')"/>
            </xsl:when>
            <xsl:when test="$sub_str = '2'">
                <xsl:value-of select="string('32')"/>
            </xsl:when>
            <xsl:when test="$sub_str = '3'">
                <xsl:value-of select="string('33')"/>
            </xsl:when>
            <xsl:when test="$sub_str = '4'">
                <xsl:value-of select="string('34')"/>
            </xsl:when>
            <xsl:when test="$sub_str = '5'">
                <xsl:value-of select="string('35')"/>
            </xsl:when>
            <xsl:when test="$sub_str = '6'">
                <xsl:value-of select="string('36')"/>
            </xsl:when>
            <xsl:when test="$sub_str = '7'">
                <xsl:value-of select="string('37')"/>
            </xsl:when>
            <xsl:when test="$sub_str = '8'">
                <xsl:value-of select="string('38')"/>
            </xsl:when>
            <xsl:when test="$sub_str = '9'">
                <xsl:value-of select="string('39')"/>
            </xsl:when>
            <xsl:when test="$sub_str = ':'">
                <xsl:value-of select="string('3A')"/>
            </xsl:when>
            <xsl:when test="$sub_str = ';'">
                <xsl:value-of select="string('3B')"/>
            </xsl:when>
            <xsl:when test="$sub_str = '&lt;'">
                <xsl:value-of select="string('3C')"/>
            </xsl:when>
            <xsl:when test="$sub_str = '='">
                <xsl:value-of select="string('3D')"/>
            </xsl:when>
            <xsl:when test="$sub_str = '&gt;'">
                <xsl:value-of select="string('3E')"/>
            </xsl:when>
            <xsl:when test="$sub_str = '?'">
                <xsl:value-of select="string('3F')"/>
            </xsl:when>
            <xsl:when test="$sub_str = '@'">
                <xsl:value-of select="string('40')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'A'">
                <xsl:value-of select="string('41')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'B'">
                <xsl:value-of select="string('42')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'C'">
                <xsl:value-of select="string('43')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'D'">
                <xsl:value-of select="string('44')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'E'">
                <xsl:value-of select="string('45')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'F'">
                <xsl:value-of select="string('46')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'G'">
                <xsl:value-of select="string('47')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'H'">
                <xsl:value-of select="string('48')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'I'">
                <xsl:value-of select="string('49')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'J'">
                <xsl:value-of select="string('4A')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'K'">
                <xsl:value-of select="string('4B')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'L'">
                <xsl:value-of select="string('4C')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'M'">
                <xsl:value-of select="string('4D')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'N'">
                <xsl:value-of select="string('4E')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'O'">
                <xsl:value-of select="string('4F')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'P'">
                <xsl:value-of select="string('50')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'Q'">
                <xsl:value-of select="string('51')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'R'">
                <xsl:value-of select="string('52')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'S'">
                <xsl:value-of select="string('53')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'T'">
                <xsl:value-of select="string('54')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'U'">
                <xsl:value-of select="string('55')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'V'">
                <xsl:value-of select="string('56')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'W'">
                <xsl:value-of select="string('57')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'X'">
                <xsl:value-of select="string('58')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'Y'">
                <xsl:value-of select="string('59')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'Z'">
                <xsl:value-of select="string('5A')"/>
            </xsl:when>
            <xsl:when test="$sub_str = '['">
                <xsl:value-of select="string('5B')"/>
            </xsl:when>
            <xsl:when test="$sub_str = '\'">
                <xsl:value-of select="string('5C')"/>
            </xsl:when>
            <xsl:when test="$sub_str = ']'">
                <xsl:value-of select="string('5D')"/>
            </xsl:when>
            <xsl:when test="$sub_str = '^'">
                <xsl:value-of select="string('5E')"/>
            </xsl:when>
            <xsl:when test="$sub_str = '_'">
                <xsl:value-of select="string('5F')"/>
            </xsl:when>
            <xsl:when test="$sub_str = '`'">
                <xsl:value-of select="string('60')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'a'">
                <xsl:value-of select="string('61')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'b'">
                <xsl:value-of select="string('62')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'c'">
                <xsl:value-of select="string('63')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'd'">
                <xsl:value-of select="string('64')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'e'">
                <xsl:value-of select="string('65')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'f'">
                <xsl:value-of select="string('66')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'g'">
                <xsl:value-of select="string('67')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'h'">
                <xsl:value-of select="string('68')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'i'">
                <xsl:value-of select="string('69')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'j'">
                <xsl:value-of select="string('6A')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'k'">
                <xsl:value-of select="string('6B')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'l'">
                <xsl:value-of select="string('6C')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'm'">
                <xsl:value-of select="string('6D')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'n'">
                <xsl:value-of select="string('6E')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'o'">
                <xsl:value-of select="string('6F')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'p'">
                <xsl:value-of select="string('70')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'q'">
                <xsl:value-of select="string('71')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'r'">
                <xsl:value-of select="string('72')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 's'">
                <xsl:value-of select="string('73')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 't'">
                <xsl:value-of select="string('74')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'u'">
                <xsl:value-of select="string('75')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'v'">
                <xsl:value-of select="string('76')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'w'">
                <xsl:value-of select="string('77')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'x'">
                <xsl:value-of select="string('78')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'y'">
                <xsl:value-of select="string('79')"/>
            </xsl:when>
            <xsl:when test="$sub_str = 'z'">
                <xsl:value-of select="string('7A')"/>
            </xsl:when>
            <xsl:when test="$sub_str = '{'">
                <xsl:value-of select="string('7B')"/>
            </xsl:when>
            <xsl:when test="$sub_str = '|'">
                <xsl:value-of select="string('7C')"/>
            </xsl:when>
            <xsl:when test="$sub_str = '}'">
                <xsl:value-of select="string('7D')"/>
            </xsl:when>
            <xsl:when test="$sub_str = '~'">
                <xsl:value-of select="string('7E')"/>
            </xsl:when>
        </xsl:choose>
    </xsl:if>
    <xsl:if test="$i != $count">
        <xsl:call-template name="for-loop-char-to-ascii">
            <xsl:with-param name="i">
                <xsl:value-of select="$i + 1"/>
            </xsl:with-param>
            <xsl:with-param name="count">
                <xsl:value-of select="$count"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:if>
</xsl:template>

<!-- change default value of node raman-mitigation -->
<xsl:template match="*[name() = 'raman-mitigation']">
    <xsl:choose>
        <xsl:when test="text() = 'raman_none' and namespace-uri()='urn:bbf:yang:bbf-xpon'">
            <xsl:element name="raman-mitigation" namespace="urn:bbf:yang:bbf-xpon">
                <xsl:text>raman-none</xsl:text>
            </xsl:element>
        </xsl:when>
        <xsl:when test="text() = 'raman_miller' and namespace-uri()='urn:bbf:yang:bbf-xpon'">
            <xsl:element name="raman-mitigation" namespace="urn:bbf:yang:bbf-xpon">
                <xsl:text>raman-miller</xsl:text>
            </xsl:element>
        </xsl:when>
        <xsl:when test="text() = 'raman_8b10b' and namespace-uri()='urn:bbf:yang:bbf-xpon'">
            <xsl:element name="raman-mitigation" namespace="urn:bbf:yang:bbf-xpon">
                <xsl:text>raman-8b10b</xsl:text>
            </xsl:element>
        </xsl:when>
        <xsl:otherwise>
            <xsl:element name="raman-mitigation" namespace="urn:bbf:yang:bbf-xpon">
                <xsl:apply-templates select="node()|@*"/>
            </xsl:element>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- change param length to 5 chars of node system-id in channel-group -->
<xsl:template match="*[name() = 'system-id']">
    <xsl:variable name="ns" select="namespace-uri()"/>
    <xsl:choose>
        <xsl:when test="parent::*[name() = 'channel-group']">
            <xsl:element name="system-id" namespace="urn:bbf:yang:bbf-xpon">
                <xsl:variable name="new-id" select="substring(text(), 1, 5)"/>
                <xsl:value-of select="$new-id"/>
            </xsl:element>
        </xsl:when>
        <xsl:otherwise>
            <xsl:element name="system-id" namespace="{$ns}">
                <xsl:value-of select="text()"/>
            </xsl:element>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>


<!-- change node fec-downstream to node downstream-fec -->
<xsl:template match="*[name() = 'fec-downstream']">
    <xsl:element name="downstream-fec" namespace="urn:bbf:yang:bbf-xpon">
        <xsl:apply-templates select="node()|@*"/>
    </xsl:element>
</xsl:template>

<!-- change node max-differential-xpon-distance to node maximum-differential-xpon-distance -->
<xsl:template match="*[name() = 'max-differential-xpon-distance']">
    <xsl:element name="maximum-differential-xpon-distance" namespace="urn:bbf:yang:bbf-xpon">
        <xsl:apply-templates select="node()|@*"/>
    </xsl:element>
</xsl:template>

<!-- change node ictp-config to node ictp -->
<!-- add merged node xpon and xpongemtcont follow 'hardware' node -->
<!-- change node proxy-name to node name -->
<xsl:template match="*[name() = 'proxy-name']">
    <xsl:choose>
        <xsl:when test="namespace-uri() = 'urn:bbf:yang:bbf-xpon' and parent::*[name() = 'proxy']">
            <xsl:element name="name" namespace="urn:bbf:yang:bbf-xpon">
                <xsl:apply-templates select="node()|@*"/>
            </xsl:element>
        </xsl:when>
        <xsl:otherwise>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>


<!-- change node proxy-host to node host -->
<xsl:template match="*[name() = 'proxy-host']">
    <xsl:choose>
        <xsl:when test="namespace-uri() = 'urn:bbf:yang:bbf-xpon' and parent::*[name() = 'proxy']">
            <xsl:element name="host" namespace="urn:bbf:yang:bbf-xpon">
                <xsl:apply-templates select="node()|@*"/>
            </xsl:element>
        </xsl:when>
        <xsl:otherwise>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>


<!-- move node laser-on-by-default to bbf-xponinfra-augment-nodes.yang -->
<xsl:template match="*[name() = 'laser-on-by-default']">
    <xsl:element name="laser-on-by-default" namespace="urn:broadband-forum-org:yang:bbf-xponinfra-augment-nodes">
        <xsl:apply-templates select="node()|@*"/>
    </xsl:element>
</xsl:template>


<!-- remove node channel-termination-hw-port-ref -->
<xsl:template match="*[name() = 'channel-termination-hw-port-ref']">
</xsl:template>


<!-- remove node gpon-pon-id-odn-class -->
<xsl:template match="*[name() = 'gpon-pon-id-odn-class']">
</xsl:template>


<!-- remove node tm-root from OLT tcont -->
<xsl:template match="*[name() = 'tm-root']">
    <xsl:choose>
        <xsl:when test="namespace-uri() = 'urn:bbf:yang:bbf-xpongemtcont' and parent::*[name() = 'tcont'] and ancestor::*[name() = 'tconts-config']">
        </xsl:when>
        <xsl:otherwise>
            <xsl:copy>
                <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>


<!-- translate node gpon-pon-id to hexadecimal number -->
<xsl:template match="*[name() = 'gpon-pon-id']">
    <xsl:variable name="ns" select="namespace-uri()"/>
    <xsl:element name="gpon-pon-id" namespace="{$ns}">
        <xsl:call-template name="for-loop-char-to-ascii">
            <xsl:with-param name="i">1</xsl:with-param>
            <xsl:with-param name="count">8</xsl:with-param>
        </xsl:call-template>
    </xsl:element>
</xsl:template>


<!-- translate node expected-registration-id to hexadecimal number -->
<xsl:template match="*[name() = 'expected-registration-id']">
    <xsl:element name="expected-registration-id" namespace="urn:bbf:yang:bbf-xponvani">
        <xsl:call-template name="for-loop-char-to-ascii">
            <xsl:with-param name="i">1</xsl:with-param>
            <xsl:with-param name="count">37</xsl:with-param>
        </xsl:call-template>
    </xsl:element>
</xsl:template>


<!-- change node parent-ref to node channel-partition -->
<xsl:template match="*[name() = 'parent-ref']">
    <xsl:choose>
        <xsl:when test="namespace-uri() = 'urn:bbf:yang:bbf-xponvani' and parent::*[name() = 'v-ani']">
            <xsl:element name="channel-partition" namespace="urn:bbf:yang:bbf-xponvani">
                <xsl:apply-templates select="node()|@*"/>
            </xsl:element>
        </xsl:when>
        <!--xsl:otherwise>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:otherwise-->
    </xsl:choose>
</xsl:template>


<!-- change node preferred-chanpair to node preferred-channel-pair -->
<xsl:template match="*[name() = 'preferred-chanpair']">
    <xsl:choose>
        <xsl:when test="namespace-uri() = 'urn:bbf:yang:bbf-xponvani' and parent::*[name() = 'v-ani']">
            <xsl:element name="preferred-channel-pair" namespace="urn:bbf:yang:bbf-xponvani">
                <xsl:apply-templates select="node()|@*"/>
            </xsl:element>
        </xsl:when>
        <!--xsl:otherwise>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:otherwise-->
    </xsl:choose>
</xsl:template>


<!-- change node protection-chanpair to node protection-channel-pair -->
<xsl:template match="*[name() = 'protection-chanpair']">
    <xsl:choose>
        <xsl:when test="namespace-uri() = 'urn:bbf:yang:bbf-xponvani' and parent::*[name() = 'v-ani']">
            <xsl:element name="protection-channel-pair" namespace="urn:bbf:yang:bbf-xponvani">
                <xsl:apply-templates select="node()|@*"/>
            </xsl:element>
        </xsl:when>
        <!--xsl:otherwise>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:otherwise-->
    </xsl:choose>
</xsl:template>

<!-- change node /bbf-xpongemtcont:tconts-config to node /bbf-xpongemtcont:xpongemtcont/bbf-xpongemtcont:tconts-->

<!-- change the usage of node /traffic-descriptor-profiles/traffic-descriptor-profile/assured-bandwidth -->
<xsl:template match="*[name() = 'assured-bandwidth']">
    <xsl:variable name="ns" select="namespace-uri()"/>
    <xsl:variable name="assureBand" select="number(text())"/>
    <xsl:variable name="fixBand" select="../bbfGem:fixed-bandwidth"/>
    <xsl:choose>
        <xsl:when test="namespace-uri() = 'urn:bbf:yang:bbf-xpongemtcont' and parent::*[name() = 'traffic-descriptor-profile']">
            <xsl:element name="assured-bandwidth" namespace="{$ns}">
                <xsl:number value="$assureBand - $fixBand"/>
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

<!-- change node /bbf-xpongemtcont:traffic-descriptor-profiles to node /bbf-xpongemtcont:xpongemtcont/bbf-xpongemtcont:traffic-descriptor-profiles-->

<!-- change node /bbf-xpon:multicast-gemports-config to node /bbf-xpon:xpon/bbf-xpon:multicast-gemports-->

<!-- change node /bbf-xpongemtcont:itf-ref to node /bbf-xpongemtcont:interface-->
<xsl:template match="*[name() = 'itf-ref']">
    <xsl:choose>
        <xsl:when test="namespace-uri() = 'urn:bbf:yang:bbf-xpongemtcont' and parent::*[name() = 'gemport']">
            <xsl:element name="interface" namespace="urn:bbf:yang:bbf-xpongemtcont">
                <xsl:value-of select="text()"/>
            </xsl:element>
        </xsl:when>
        <xsl:when test="namespace-uri() = 'urn:bbf:yang:bbf-xpon' and parent::*[name() = 'multicast-gemport']">
            <xsl:element name="interface" namespace="urn:bbf:yang:bbf-xpon">
                <xsl:value-of select="text()"/>
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


<!-- change node /bbf-xpon:multicast-gemports-config/multicast-sets to /bbf-xpon:xpon/bbf-xpon:multicast-gemports/multicast-set -->
<xsl:template match="*[name() = 'multicast-sets']">
    <xsl:choose>
        <xsl:when test="namespace-uri() = 'urn:bbf:yang:bbf-xpon' and parent::*[name() = 'multicast-distribution-set-config']">
            <xsl:element name="multicast-set" namespace="urn:bbf:yang:bbf-xpon">
                <xsl:apply-templates select="node()|@*"/>
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

<!-- change node /bbf-xpon:multicast-gemports-config to node /bbf-xpon:xpon/bbf-xpon:multicast-gemports-->

<!-- change node /bbf-xpon:wavelength-profiles to node /bbf-xpon:xpon/bbf-xpon:wavelength-profiles-->


<!-- Add mandatory node channel-termination-type to channel-termination-->
<xsl:template match="ifNs:interfaces/ifNs:interface/bbfXpon:channel-termination/bbfXpon:channel-pair-ref">
    <xsl:variable name="cpRef" select="text()"/>
    <xsl:element name="channel-pair-ref" namespace="urn:bbf:yang:bbf-xpon">
        <xsl:apply-templates select="node()|@*"/>
    </xsl:element>

    <!-- if channel-termination-type is existing, keep the original configuraion, otherwise copy value from channel-pair-type and generate the node -->
    <xsl:choose>
        <xsl:when test="current()/../bbfXpon:channel-termination-type">
        </xsl:when>
        <xsl:otherwise>
            <xsl:variable name="cptype" select="/cfgNs:config/ifNs:interfaces/ifNs:interface/child::*[name()='name' and text()=$cpRef]/../bbfXpon:channel-pair/bbfXpon:channel-pair-type"/>
            <xsl:choose>
                <xsl:when test="$cptype = 'bbf-xpon-types:ngpon2-twdm'">
                    <channel-termination-type xmlns:bbf-xpon-types="urn:bbf:yang:bbf-xpon-types" xmlns="urn:bbf:yang:bbf-xpon">bbf-xpon-types:ngpon2-twdm</channel-termination-type>
                </xsl:when>
                <xsl:when test="$cptype = 'bbf-xpon-types:ngpon2-ptp'">
                    <channel-termination-type xmlns:bbf-xpon-types="urn:bbf:yang:bbf-xpon-types" xmlns="urn:bbf:yang:bbf-xpon">bbf-xpon-types:ngpon2-ptp</channel-termination-type>
                </xsl:when>
                <xsl:when test="$cptype = 'bbf-xpon-types:xgs'">
                    <channel-termination-type xmlns:bbf-xpon-types="urn:bbf:yang:bbf-xpon-types" xmlns="urn:bbf:yang:bbf-xpon">bbf-xpon-types:xgs</channel-termination-type>
                </xsl:when>
                <xsl:when test="$cptype = 'bbf-xpon-types:xgpon'">
                    <channel-termination-type xmlns:bbf-xpon-types="urn:bbf:yang:bbf-xpon-types" xmlns="urn:bbf:yang:bbf-xpon">bbf-xpon-types:xgpon</channel-termination-type>
                </xsl:when>
                <xsl:when test="$cptype = 'bbf-xpon-types:gpon'">
                    <channel-termination-type xmlns:bbf-xpon-types="urn:bbf:yang:bbf-xpon-types" xmlns="urn:bbf:yang:bbf-xpon">bbf-xpon-types:gpon</channel-termination-type>
                </xsl:when>
                <xsl:when test="$cptype = 'nokia-sdan-xpon-types:twentyfivegs'">
                    <channel-termination-type xmlns:nokia-sdan-xpon-types="urn:broadband-forum-org:yang:nokia-sdan-xpon-types" xmlns="urn:bbf:yang:bbf-xpon">nokia-sdan-xpon-types:twentyfivegs</channel-termination-type>
                </xsl:when>

            </xsl:choose>
        </xsl:otherwise>
    </xsl:choose>

</xsl:template>


<!-- Limit the string length to 64 for ictp proxy-name -->
<xsl:template match="*[name() = 'proxy-name']">
    <xsl:variable name="nameCut" select="substring(text(), 1, 64)"/>
    <xsl:choose>
        <xsl:when test="namespace-uri() = 'urn:bbf:yang:bbf-xpon' and parent::*[name() = 'proxy'] and ancestor::*[name() = 'all-ictp-proxies-all-channel-groups']">
            <xsl:element name="name" namespace="urn:bbf:yang:bbf-xpon">
                <xsl:value-of select="$nameCut"/>
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


<!-- Limit the string length to 64 for some node name -->
<xsl:template match="*[name() = 'name']">
    <xsl:variable name="nameCut" select="substring(text(), 1, 64)"/>
    <xsl:choose>
        <xsl:when test="namespace-uri() = 'urn:bbf:yang:bbf-xpon' and parent::*[name() = 'wavelength-profile'] and ancestor::*[name() = 'wavelength-profiles']">
            <xsl:element name="name" namespace="urn:bbf:yang:bbf-xpon">
                <xsl:value-of select="$nameCut"/>
            </xsl:element>
        </xsl:when>

        <xsl:when test="namespace-uri() = 'urn:bbf:yang:bbf-xpongemtcont' and parent::*[name() = 'tcont'] and ancestor::*[name() = 'tconts-config']">
            <xsl:element name="name" namespace="urn:bbf:yang:bbf-xpongemtcont">
                <xsl:value-of select="$nameCut"/>
            </xsl:element>
        </xsl:when>

        <xsl:when test="namespace-uri() = 'urn:bbf:yang:bbf-xpon' and parent::*[name() = 'multicast-gemport'] and ancestor::*[name() = 'multicast-gemports-config']">
            <xsl:element name="name" namespace="urn:bbf:yang:bbf-xpon">
                <xsl:value-of select="$nameCut"/>
            </xsl:element>
        </xsl:when>

        <xsl:when test="namespace-uri() = 'urn:bbf:yang:bbf-xpon' and parent::*[name() = 'multicast-sets'] and ancestor::*[name() = 'multicast-distribution-set-config']">
            <xsl:element name="name" namespace="urn:bbf:yang:bbf-xpon">
                <xsl:value-of select="$nameCut"/>
            </xsl:element>
        </xsl:when>

        <xsl:when test="namespace-uri() = 'urn:bbf:yang:bbf-xpongemtcont' and parent::*[name() = 'gemport'] and ancestor::*[name() = 'gemports-config']">
            <xsl:element name="name" namespace="urn:bbf:yang:bbf-xpongemtcont">
                <xsl:value-of select="$nameCut"/>
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

<!-- Change mode upstream-fec-indicator to upstream-fec -->
<xsl:template match="*[name() = 'upstream-fec-indicator']">
    <xsl:choose>
        <xsl:when test="namespace-uri() = 'urn:broadband-forum-org:yang:bbf-xponinfra-augment-nodes' and parent::*[name() = 'v-ani']">
            <xsl:element name="upstream-fec" namespace="urn:bbf:yang:bbf-xponvani">
                <xsl:apply-templates select="node()|@*"/>
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

<!-- Add mandatory node port-layer-if to channel-termination-->
<xsl:template match="ifNs:interfaces/ifNs:interface/bbfXpon:channel-termination">
    <xsl:copy>
        <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>

    <!-- if port-layer-if is existing, keep the original configuraion, otherwise copy value from channel-termination-hw-port-ref and generate the node -->
    <xsl:choose>
        <xsl:when test="current()/../bbfIfPortRef:port-layer-if">
        </xsl:when>
        <xsl:otherwise>
            <xsl:variable name="hwPortRef" select="current()/bbfXpon:channel-termination-hw-port-ref"/>
            <!--xsl:value-of select="$hwPortRef"/-->
            <xsl:element name="port-layer-if" namespace="urn:bbf:yang:bbf-interface-port-reference">
                <xsl:value-of select="$hwPortRef"/>
            </xsl:element>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- Special handling for 'adxs:identifier' in vobs/dsl/yang/fans/sharding-config.xml-->
<xsl:template match="*[name()='adxs:identifier']">
    <xsl:choose>
        <xsl:when test="text() = 'bbf-xpon:multicast-gemports-config/multicast-gemport/name'">
            <xsl:copy>
                <xsl:copy-of select="@*"/>
<xsl:text>bbf-xpon:xpon/bbf-xpon:multicast-gemports/multicast-gemport/name</xsl:text>
            </xsl:copy>
        </xsl:when>
        <xsl:when test="text() = 'bbf-xpongemtcont:gemports-config/gemport/name'">
            <xsl:copy>
                <xsl:copy-of select="@*"/>
<xsl:text>bbf-xpongemtcont:xpongemtcont/gemports/gemport/name</xsl:text>
            </xsl:copy>
        </xsl:when>
        <xsl:when test="text() = 'bbf-xpongemtcont:tconts-config/tcont/name'">
            <xsl:copy>
                <xsl:copy-of select="@*"/>
<xsl:text>bbf-xpongemtcont:xpongemtcont/tconts/tcont/name</xsl:text>
            </xsl:copy>
        </xsl:when>
        <xsl:otherwise>
            <xsl:copy>
                <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- Special handling for 'adxs:parent-forest-type' in vobs/dsl/yang/fans/sharding-config.xml-->
<xsl:template match="*[name()='adxs:parent-forest-type']">
    <xsl:choose>
        <xsl:when test="text() = 'ietf-interfaces:interfaces'">
            <xsl:copy>
                <xsl:copy-of select="@*"/>
<xsl:text>ietf-interfaces:interfaces/ietf-interfaces:interface/ietf-interfaces:name</xsl:text>
            </xsl:copy>
        </xsl:when>
        <xsl:when test="text() = 'bbf-l2-forwarding:forwarding/bbf-l2-forwarding:forwarders/bbf-l2-forwarding:forwarder/bbf-l2-forwarding:ports'">
            <xsl:copy>
                <xsl:copy-of select="@*"/>
<xsl:text>bbf-l2-forwarding:forwarding/bbf-l2-forwarding:forwarders/bbf-l2-forwarding:forwarder/bbf-l2-forwarding:ports/bbf-l2-forwarding:port/bbf-l2-forwarding:name</xsl:text>
            </xsl:copy>
        </xsl:when>
        <xsl:otherwise>
            <xsl:copy>
                <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- Special handling for 'adxs:expression' in vobs/dsl/yang/fans/sharding-config.xml-->
<xsl:template match="*[name()='adxs:expression']">
    <xsl:choose>
        <xsl:when test="text() = 'bbf-xpongemtcont:itf-ref'">
            <xsl:copy>
                <xsl:copy-of select="@*"/>
<xsl:text>bbf-xpongemtcont:interface</xsl:text>
            </xsl:copy>
        </xsl:when>
        <xsl:when test="text() = 'bbf-xpon:itf-ref'">
            <xsl:copy>
                <xsl:copy-of select="@*"/>
<xsl:text>bbf-xpon:interface</xsl:text>
            </xsl:copy>
        </xsl:when>
        <xsl:when test="text() = 'bbf-xponvani:v-ani/parent-ref'">
            <xsl:copy>
                <xsl:copy-of select="@*"/>
<xsl:text>bbf-xponvani:v-ani/channel-partition</xsl:text>
            </xsl:copy>
        </xsl:when>
        <xsl:otherwise>
            <xsl:copy>
                <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- Special handling for 'adxs:attribute' in vobs/dsl/yang/fans/sharding-config.xml-->
<xsl:template match="*[name()='adxs:attribute']">
    <xsl:choose>
        <xsl:when test="text() = 'bbf-xpon:channel-termination/channel-termination-hw-port-ref'">
            <xsl:copy>
                <xsl:copy-of select="@*"/>
<xsl:text>ietf-interfaces:interfaces/interface/bbf-interface-port-reference:port-layer-if</xsl:text>
            </xsl:copy>
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
