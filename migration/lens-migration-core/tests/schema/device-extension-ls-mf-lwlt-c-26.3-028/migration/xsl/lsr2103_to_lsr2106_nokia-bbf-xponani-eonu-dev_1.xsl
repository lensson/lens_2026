<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
				xmlns:xponaniNs="urn:bbf:yang:bbf-xponani-mounted"
>

    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

    <!-- default rule -->
    <xsl:template match="*">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
    </xsl:template>


    <!-- remove 'traffic-class' in 'multicast-gemport' -->
	<xsl:template match="xponaniNs:ani/xponaniNs:multicast-gemport/xponaniNs:traffic-class"/>

</xsl:stylesheet>