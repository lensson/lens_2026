<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0"
	xmlns:onuNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount"
	xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted"
	xmlns:subIfNs="urn:bbf:yang:bbf-sub-interfaces-mounted"
	xmlns:xponIfTypeNs="urn:bbf:yang:bbf-xpon-if-type-mounted"
	xmlns:onusTemplateNs="http://www.nokia.com/Fixed-Networks/BBA/yang/onus-from-template"
	xmlns:templateCommonNs="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-template-common">

	<!-- auto-instantiate true to false -->
	<xsl:template match="/tailf:config/onuNs:onus/onuNs:onu[onuNs:usage = 'template-common:node-template-usage']/onuNs:root/ifNs:interfaces/ifNs:interface/onusTemplateNs:auto-instantiate">
		<xsl:variable name="lowIfName" select="../subIfNs:subif-lower-layer/subIfNs:interface"/>

		<xsl:choose>
			<xsl:when test="count(../../ifNs:interface[ifNs:name = $lowIfName]/*[local-name() = 'type' and text()= 'bbf-xponift-mounted:onu-v-enet']) = 1">
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:value-of select="'false'"/>
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

	<!-- auto-instantiate null to false -->
	<xsl:template match="/tailf:config/onuNs:onus/onuNs:onu[onuNs:usage = 'template-common:node-template-usage']/onuNs:root/ifNs:interfaces/ifNs:interface">
		<xsl:variable name="lowIfName" select="./subIfNs:subif-lower-layer/subIfNs:interface"/>
		<xsl:variable name="autoInstCount" select="count(./onusTemplateNs:auto-instantiate)"/>

		<xsl:choose>
			<xsl:when test="($autoInstCount = 0) and count(./../ifNs:interface[ifNs:name = $lowIfName]/*[local-name() = 'type' and text()= 'bbf-xponift-mounted:onu-v-enet']) = 1">
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:apply-templates/>
					<xsl:element name="auto-instantiate" xmlns="http://www.nokia.com/Fixed-Networks/BBA/yang/onus-from-template">false</xsl:element>
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
