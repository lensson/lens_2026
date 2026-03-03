<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
xmlns:cfgNs="urn:ietf:params:xml:ns:netconf:base:1.0"
xmlns:if="urn:ietf:params:xml:ns:yang:ietf-interfaces"
xmlns:xpon="urn:bbf:yang:bbf-xpon"
>

<!-- Migration is required for "per-v-ani-expected" to "as-per-v-ani-expected" change -->
<xsl:template match="/cfgNs:config/if:interfaces/if:interface/xpon:channel-partition/xpon:authentication-method[. = 'per-v-ani-expected' ]">
    <xsl:element name="{local-name()}" namespace="{namespace-uri()}">
        <xsl:text>as-per-v-ani-expected</xsl:text>
    </xsl:element>
</xsl:template>

</xsl:stylesheet>
