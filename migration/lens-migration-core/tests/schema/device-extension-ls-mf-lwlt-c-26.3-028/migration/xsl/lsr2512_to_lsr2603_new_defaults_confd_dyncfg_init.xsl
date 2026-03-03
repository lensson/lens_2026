<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:confd_dyncfg="http://tail-f.com/ns/confd_dyncfg/1.0"
                              >

  <xsl:param name="confd-ns" select="'http://tail-f.com/ns/confd_dyncfg/1.0'" />

<!-- add parallelLogin in confdConfig/ssh if not there -->
<xsl:template match="confd_dyncfg:confdConfig/confd_dyncfg:ssh">
  <xsl:copy>
	  <xsl:copy-of select="@*"/>
	  <xsl:apply-templates/>
      <xsl:if test="not(./child::*[name()='parallelLogin'])">
        <xsl:element name="parallelLogin" namespace="{$confd-ns}"><xsl:text>true</xsl:text></xsl:element>
          <xsl:element name="rekeyLimit" namespace="{$confd-ns}">
            <xsl:element name="bytes" namespace="{$confd-ns}"><xsl:text>0</xsl:text></xsl:element>
            <xsl:element name="minutes" namespace="{$confd-ns}"><xsl:text>0</xsl:text></xsl:element>
          </xsl:element>
      </xsl:if>
  </xsl:copy>
</xsl:template>

<!-- add rcvPktSize in confdConfig/netconf/transport/ssh if not there -->
<xsl:template match="confd_dyncfg:confdConfig/confd_dyncfg:netconf/confd_dyncfg:transport/confd_dyncfg:ssh">
  <xsl:copy>
	  <xsl:copy-of select="@*"/>
	  <xsl:apply-templates/>
      <xsl:if test="not(./child::*[name()='rcvPktSize'])">
        <xsl:element name="rcvPktSize" namespace="{$confd-ns}"><xsl:text>4</xsl:text></xsl:element>
      </xsl:if>
      <xsl:if test="not(./child::*[name()='ncChunkSize'])">
        <xsl:element name="ncChunkSize" namespace="{$confd-ns}"><xsl:text>16384</xsl:text></xsl:element>
      </xsl:if>
  </xsl:copy>
</xsl:template>


<!-- remove AuditUsername "always" invalid value. -->
  <xsl:template match="confd_dyncfg:confdConfig/confd_dyncfg:aaa/confd_dyncfg:auditUserName" />

  <!-- remove sendDefaults value. -->
  <xsl:template match="confd_dyncfg:confdConfig/confd_dyncfg:netconf/confd_dyncfg:sendDefaults" />

  <!-- remove cli commit retry timeout value. -->
  <xsl:template match="confd_dyncfg:confdConfig/confd_dyncfg:cli/confd_dyncfg:commitRetryTimeout" />

  <!-- remove cli show log directory value. -->
  <xsl:template match="confd_dyncfg:confdConfig/confd_dyncfg:cli/confd_dyncfg:showLogDirectory" />

  <!-- remove cli showNedErrorAsInfo. -->
  <xsl:template match="confd_dyncfg:confdConfig/confd_dyncfg:cli/confd_dyncfg:showNedErrorAsInfo" />

  <!-- remove cli:useExposeNsPrefix and replace it with default value. -->
  <xsl:template match="confd_dyncfg:confdConfig/confd_dyncfg:cli/confd_dyncfg:useExposeNsPrefix" />

  <!-- remove cli:turboParser:reportNoExists and replace it with default value. -->
  <xsl:template match="confd_dyncfg:confdConfig/confd_dyncfg:cli/confd_dyncfg:turboParser/confd_dyncfg:reportNoExists" />
</xsl:stylesheet>
