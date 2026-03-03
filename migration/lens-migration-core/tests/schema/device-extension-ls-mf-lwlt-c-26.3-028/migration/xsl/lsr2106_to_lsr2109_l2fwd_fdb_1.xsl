<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:tailf="http://tail-f.com/ns/config/1.0"
xmlns:fdbnsp="urn:bbf:yang:bbf-l2-forwarding">
<xsl:output omit-xml-declaration="yes" indent="yes"/>
<xsl:strip-space elements="*"/>

<xsl:key name="fdb-name" match="fdbnsp:mac-learning" use="fdbnsp:forwarding-database"/>

<xsl:template match="node()|@*">
    <xsl:copy>
        <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
</xsl:template>

<xsl:template match="/">
   <xsl:choose>
      <xsl:when test="tailf:config/fdbnsp:forwarding/fdbnsp:forwarders/fdbnsp:forwarder/fdbnsp:mac-learning[not(generate-id() = generate-id(key('fdb-name',fdbnsp:forwarding-database)[1]))]">
       <xsl:comment> Error-log: Migration failed. More than one forwarder attached to same FDB </xsl:comment>
       <xsl:apply-templates select="@* | node()"/>
      </xsl:when>
      <xsl:otherwise>
       <xsl:apply-templates select="@* | node()"/>
      </xsl:otherwise>
   </xsl:choose>
</xsl:template>
</xsl:stylesheet>

