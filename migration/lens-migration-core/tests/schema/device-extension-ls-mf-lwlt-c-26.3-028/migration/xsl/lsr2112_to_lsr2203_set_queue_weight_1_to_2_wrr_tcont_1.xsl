<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0" xmlns:onuNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount" xmlns:bbf-xpongemtcont="urn:bbf:yang:bbf-xpongemtcont-mounted" version="1.0">
	<xsl:strip-space elements="*"/>
	<xsl:output method="xml" indent="yes"/>
	<!-- default rule -->
	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>
	<xsl:param name="replace" select="'2'"/>
	<!-- modify desired weight nodes -->
	<xsl:template match="bbf-xpongemtcont:tconts-config/bbf-xpongemtcont:tcont/bbf-xpongemtcont:tm-root">
		<xsl:choose>
			<xsl:when test="count(child::bbf-xpongemtcont:queue) = 1">
				<xsl:copy>
					<xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="child::bbf-xpongemtcont:queue[1]/bbf-xpongemtcont:priority/text() != child::bbf-xpongemtcont:queue[2]/bbf-xpongemtcont:priority/text()">
						<xsl:copy>
							<xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy>
							<xsl:copy-of select="@*"/>
<xsl:for-each select="current()/bbf-xpongemtcont:queue">
								<xsl:choose>
									<xsl:when test="current()/bbf-xpongemtcont:weight/text() = 1">
										<xsl:copy>
											<xsl:copy-of select="@*"/>
<xsl:apply-templates select="current()/bbf-xpongemtcont:local-queue-id"/>
<xsl:apply-templates select="current()/bbf-xpongemtcont:priority"/>
<xsl:for-each select="current()/bbf-xpongemtcont:weight">
												<xsl:call-template name="weight_replace"/>
											</xsl:for-each>
										</xsl:copy>
									</xsl:when>
									<xsl:otherwise>
										<xsl:copy>
											<xsl:copy-of select="@*"/>
<xsl:apply-templates select="current()/bbf-xpongemtcont:local-queue-id"/>
<xsl:apply-templates select="current()/bbf-xpongemtcont:priority"/>
<xsl:apply-templates select="current()/bbf-xpongemtcont:weight"/>
</xsl:copy>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
							<xsl:for-each select="current()/bbf-xpongemtcont:tc-id-2-queue-id-mapping-profile-name">
								<xsl:copy>
									<xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
							</xsl:for-each>
						</xsl:copy>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="weight_replace">
		<xsl:copy>
			<xsl:value-of select="$replace"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
