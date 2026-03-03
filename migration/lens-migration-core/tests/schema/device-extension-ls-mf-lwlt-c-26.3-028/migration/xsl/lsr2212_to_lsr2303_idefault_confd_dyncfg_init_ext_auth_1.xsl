<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dyncfg-ns="http://tail-f.com/ns/confd_dyncfg/1.0" version="1.0">
<xsl:strip-space elements="*"/>
<xsl:output method="xml" indent="yes"/>

<!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

<!-- add external authentication parameters and authentication order -->
<xsl:template match="dyncfg-ns:confdConfig/dyncfg-ns:aaa">
  <xsl:copy>
        <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
<xsl:if test="not(./child::dyncfg-ns:externalAuthentication)">
            <xsl:element name="externalAuthentication" namespace="{namespace-uri()}">
              <xsl:element name="enabled" namespace="{namespace-uri()}"><xsl:text>true</xsl:text></xsl:element>
              <xsl:element name="includeExtra" namespace="{namespace-uri()}"><xsl:text>true</xsl:text></xsl:element>
              <xsl:element name="executable" namespace="{namespace-uri()}">
                <xsl:text>/etc/confd/radius_external_auth_start.sh</xsl:text>
              </xsl:element>
            </xsl:element>
        </xsl:if>
        <xsl:if test="not(./child::dyncfg-ns:authOrder)">
          <xsl:element name="authOrder" namespace="{namespace-uri()}">
            <xsl:text>externalAuthentication localAuthentication</xsl:text>
          </xsl:element>
        </xsl:if>
  </xsl:copy>
</xsl:template>

<!-- add external authentication missing parameters  -->
<xsl:template match="dyncfg-ns:confdConfig/dyncfg-ns:aaa/dyncfg-ns:externalAuthentication">
  <xsl:copy>
        <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
<xsl:if test="not(./child::dyncfg-ns:enabled)">
          <xsl:element name="enabled" namespace="{namespace-uri()}"><xsl:text>true</xsl:text></xsl:element>
        </xsl:if>
        <xsl:if test="not(./child::dyncfg-ns:includeExtra)">
          <xsl:element name="includeExtra" namespace="{namespace-uri()}"><xsl:text>true</xsl:text></xsl:element>
        </xsl:if>
        <xsl:if test="not(./child::dyncfg-ns:executable)">
          <xsl:element name="executable" namespace="{namespace-uri()}">
            <xsl:text>/etc/confd/radius_external_auth_start.sh</xsl:text>
          </xsl:element>
        </xsl:if>
  </xsl:copy>
</xsl:template>

<!-- change authentication order parameters -->
<xsl:template match="dyncfg-ns:confdConfig/dyncfg-ns:aaa/dyncfg-ns:authOrder[not(node() = 'externalAuthentication localAuthentication')]">
              <xsl:element name="authOrder" namespace="{namespace-uri()}">
                <xsl:text>externalAuthentication localAuthentication</xsl:text>
              </xsl:element>
</xsl:template>

<!-- change externalAuthentication enabled to true -->
<xsl:template match="dyncfg-ns:confdConfig/dyncfg-ns:aaa/dyncfg-ns:externalAuthentication/dyncfg-ns:enabled[node() = 'false']">
		    <xsl:element name="enabled" namespace="{namespace-uri()}"><xsl:text>true</xsl:text></xsl:element>
</xsl:template>

<!-- change externalAuthentication includeExtra to true -->
<xsl:template match="dyncfg-ns:confdConfig/dyncfg-ns:aaa/dyncfg-ns:externalAuthentication/dyncfg-ns:includeExtra[node() = 'false']">
		    <xsl:element name="includeExtra" namespace="{namespace-uri()}"><xsl:text>true</xsl:text></xsl:element>
</xsl:template>

<!-- change externalAuthentication executable to appropriate script -->
<xsl:template match="dyncfg-ns:confdConfig/dyncfg-ns:aaa/dyncfg-ns:externalAuthentication/dyncfg-ns:executable[not(node() = '/etc/confd/radius_external_auth_start.sh')]">
		          <xsl:element name="executable" namespace="{namespace-uri()}">
                <xsl:text>/etc/confd/radius_external_auth_start.sh</xsl:text>
              </xsl:element>
</xsl:template>

</xsl:stylesheet>
