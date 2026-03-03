<?xml version="1.0" ?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:frameproc="urn:bbf:yang:bbf-frame-processing-profile">

<!-- Add template to filter the frame processing profiles with match criteria-->
    <xsl:template match="frameproc:frame-processing-profiles/frameproc:frame-processing-profile[not(frameproc:match-criteria)]/frameproc:name">
        <!-- If any frame processing profile does not contain match criteria, fail the migration-->
        <wrong-configuration-detected>
            The Frame processing profile:<xsl:value-of select="../frameproc:name"/> does not contain match criteria, migration is not successful.
        </wrong-configuration-detected>

        <xsl:copy>
           <xsl:copy-of select="@*"/>
           <xsl:apply-templates/>
        </xsl:copy>

    </xsl:template>

</xsl:stylesheet>
