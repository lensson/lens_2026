<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dyncfg-ns="http://tail-f.com/ns/confd_dyncfg/1.0"
>
    <xsl:strip-space elements="*" />
    <xsl:output method="xml" indent="yes" />

   <!-- change stream NETCONF maxFiles to 10 -->

    <xsl:template
        match="dyncfg-ns:confdConfig/dyncfg-ns:notifications/dyncfg-ns:eventStreams/dyncfg-ns:stream[dyncfg-ns:name='NETCONF']/dyncfg-ns:builtinReplayStore/dyncfg-ns:maxFiles">
        <xsl:element name="maxFiles" namespace="http://tail-f.com/ns/confd_dyncfg/1.0">
            <xsl:text>10</xsl:text>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
