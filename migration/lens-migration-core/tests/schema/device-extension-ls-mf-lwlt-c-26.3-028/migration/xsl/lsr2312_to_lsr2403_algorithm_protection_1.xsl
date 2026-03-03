<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dyncfg-ns="http://tail-f.com/ns/confd_dyncfg/1.0" version="1.0">

<!-- Remove not allowed values from ssh/algorithms -->

<!-- Define the list of valid values as a parameters -->
<xsl:param name="mac-valid-values" select="'hmac-md5,hmac-sha1,hmac-sha2-256,hmac-sha2-512,hmac-sha1-96,hmac-md5-96'"/>

<xsl:param name="encryption-valid-values" select="'aes128-ctr,aes192-ctr,aes256-ctr,aes128-cbc,aes256-cbc,3des-cbc'"/>

<xsl:param name="kex-valid-values" select="'diffie-hellman-group18-sha512,diffie-hellman-group14-sha256,diffie-hellman-group-exchange-sha256,diffie-hellman-group-exchange-sha1,diffie-hellman-group14-sha1,diffie-hellman-group1-sha1'"/>

<xsl:param name="serverHostKey-valid-values" select="'ssh-rsa,ssh-dss'"/>


<!-- mac element -->
<xsl:template match="dyncfg-ns:confdConfig/dyncfg-ns:ssh/dyncfg-ns:algorithms/dyncfg-ns:mac">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
<!-- Split the input value by comma and process each token -->
    <xsl:call-template name="split">
      <xsl:with-param name="text" select="."/>
      <xsl:with-param name="first" select="true()"/>
      <xsl:with-param name="valid-values" select="$mac-valid-values"/>
    </xsl:call-template>
  </xsl:copy>
</xsl:template>

<!-- encryption element -->
<xsl:template match="dyncfg-ns:confdConfig/dyncfg-ns:ssh/dyncfg-ns:algorithms/dyncfg-ns:encryption">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
<!-- Split the input value by comma and process each token -->
    <xsl:call-template name="split">
      <xsl:with-param name="text" select="."/>
      <xsl:with-param name="first" select="true()"/>
      <xsl:with-param name="valid-values" select="$encryption-valid-values"/>
    </xsl:call-template>
  </xsl:copy>
</xsl:template>

<!-- kex element -->
<xsl:template match="dyncfg-ns:confdConfig/dyncfg-ns:ssh/dyncfg-ns:algorithms/dyncfg-ns:kex">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
<!-- Split the input value by comma and process each token -->
    <xsl:call-template name="split">
      <xsl:with-param name="text" select="."/>
      <xsl:with-param name="first" select="true()"/>
      <xsl:with-param name="valid-values" select="$kex-valid-values"/>
    </xsl:call-template>
  </xsl:copy>
</xsl:template>

<!-- serverHostKey element -->
<xsl:template match="dyncfg-ns:confdConfig/dyncfg-ns:ssh/dyncfg-ns:algorithms/dyncfg-ns:serverHostKey">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
<!-- Split the input value by comma and process each token -->
    <xsl:call-template name="split">
      <xsl:with-param name="text" select="."/>
      <xsl:with-param name="first" select="true()"/>
      <xsl:with-param name="valid-values" select="$serverHostKey-valid-values"/>
    </xsl:call-template>
  </xsl:copy>
</xsl:template>



<!-- A template to split a text by comma process each token and remove not allowed values -->
  <xsl:template name="split">
    <xsl:param name="text"/>
    <xsl:param name="first"/>
    <xsl:param name="valid-values"/>

    <!-- Check if the text contains a comma if yes then it is not the last value -->
    <xsl:choose>
      <!-- If not last value -->
      <xsl:when test="contains($text, ',')">
        <xsl:variable name="token" select="substring-before($text, ',')"/>
        <!-- Check if the token is in the valid values list -->
        <xsl:if test="contains(concat(',', $valid-values, ','), concat(',', $token, ','))">
          <!-- If not first value add a comma -->
          <xsl:if test="not($first)">
            <xsl:text>,</xsl:text>
          </xsl:if>
          <xsl:value-of select="$token"/>
        </xsl:if>

        <!-- Recursively process the remaining text -->
          <xsl:call-template name="split">
            <xsl:with-param name="text" select="substring-after($text, ',')"/>
            <xsl:with-param name="first" select="not(contains(concat(',', $valid-values, ','), concat(',', $token, ','))) and $first"/>
            <xsl:with-param name="valid-values" select="$valid-values"/>
          </xsl:call-template>

      </xsl:when>
      <!-- If last value -->
      <xsl:otherwise>
        <xsl:if test="contains(concat(',', $valid-values, ','), concat(',', $text, ','))">
          <!-- If not first value add a comma -->
          <xsl:if test="not($first)">
            <xsl:text>,</xsl:text>
          </xsl:if>
          <xsl:value-of select="$text"/>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>
</xsl:stylesheet>
