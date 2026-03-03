<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:dyncfg-ns="http://tail-f.com/ns/confd_dyncfg/1.0">

<!-- Remove not allowed values from ssh/algorithms -->

<!-- Define the list of valid values as a parameters -->
<xsl:param name="mac-valid-values_" select="'hmac-sha2-256,hmac-sha2-512'"/>

<xsl:param name="encryption-valid-values_" select="'aes128-ctr,aes192-ctr,aes256-ctr'"/>

<xsl:param name="kex-valid-values_" select="'diffie-hellman-group18-sha512,diffie-hellman-group14-sha256,diffie-hellman-group-exchange-sha256'"/>

<xsl:param name="serverHostKey-valid-values_" select="'ssh-rsa,ssh-dss'"/>

<!-- Check if <algorithms> have all elements and create any missing elements with default values -->
<xsl:template match="dyncfg-ns:confdConfig/dyncfg-ns:ssh/dyncfg-ns:algorithms">
  <xsl:copy>
            <xsl:copy-of select="@*"/>

            <!-- Check if serverHostKey element exists -->
            <xsl:if test="not(dyncfg-ns:serverHostKey)">
                <!-- Create serverHostKey with a standard value -->
                <xsl:element name ="serverHostKey" namespace="{namespace-uri()}"><xsl:value-of select="$serverHostKey-valid-values_"/></xsl:element>
            </xsl:if>

            <!-- Pass through existing serverHostKey if it exists -->
            <xsl:apply-templates select="dyncfg-ns:serverHostKey"/>

            <!-- Check if kex element exists -->
            <xsl:if test="not(dyncfg-ns:kex)">
                <!-- Create kex with a standard value -->
                <xsl:element name ="kex" namespace="{namespace-uri()}"><xsl:value-of select="$kex-valid-values_"/></xsl:element>
            </xsl:if>

            <!-- Pass through existing kex if it exists -->
            <xsl:apply-templates select="dyncfg-ns:kex"/>

            <!-- Check if encryption element exists -->
            <xsl:if test="not(dyncfg-ns:encryption)">
                <!-- Create encryption with a standard value -->
                <xsl:element name ="encryption" namespace="{namespace-uri()}"><xsl:value-of select="$encryption-valid-values_"/></xsl:element>
            </xsl:if>

            <!-- Pass through existing encryption if it exists -->
            <xsl:apply-templates select="dyncfg-ns:encryption"/>

            <!-- Check if mac element exists -->
            <xsl:if test="not(dyncfg-ns:mac)">
                <!-- Create mac with a standard value -->
                <xsl:element name ="mac" namespace="{namespace-uri()}"><xsl:value-of select="$mac-valid-values_"/></xsl:element>
            </xsl:if>

            <!-- Pass through existing mac if it exists -->
            <xsl:apply-templates select="dyncfg-ns:mac"/>

            <xsl:apply-templates select="*[not(self::dyncfg-ns:serverHostKey or self::dyncfg-ns:kex or self::dyncfg-ns:encryption or self::dyncfg-ns:mac)]"/>
        </xsl:copy>
    </xsl:template>


<!-- mac element -->

<!-- Remove invalid not supported and unsecure values from <mac> -->
<xsl:template match="dyncfg-ns:confdConfig/dyncfg-ns:ssh/dyncfg-ns:algorithms/dyncfg-ns:mac">
  <xsl:choose>
    <xsl:when test="string-length(normalize-space(.)) = 0">
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
        <xsl:value-of select="$mac-valid-values_"/>
      </xsl:copy>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="mac_result">
        <!-- Call checkAndRemove template -->
        <xsl:call-template name="checkAndRemove">
          <xsl:with-param name="text" select="."/>
          <xsl:with-param name="first" select="true()"/>
          <xsl:with-param name="valid-values" select="$mac-valid-values_"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:if test="string-length(normalize-space($mac_result)) = 0">
          <xsl:value-of select="$mac-valid-values_"/>
        </xsl:if>
        <xsl:if test="$mac_result">
          <xsl:value-of select="$mac_result"/>
        </xsl:if>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- encryption element -->

<!-- Remove invalid not supported and unsecure values from <encryption> -->
<xsl:template match="dyncfg-ns:confdConfig/dyncfg-ns:ssh/dyncfg-ns:algorithms/dyncfg-ns:encryption">
  <xsl:choose>
    <xsl:when test="string-length(normalize-space(.)) = 0">
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
        <xsl:value-of select="$encryption-valid-values_"/>
      </xsl:copy>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="encryption_result">
        <!-- Call checkAndRemove template -->
        <xsl:call-template name="checkAndRemove">
          <xsl:with-param name="text" select="."/>
          <xsl:with-param name="first" select="true()"/>
          <xsl:with-param name="valid-values" select="$encryption-valid-values_"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:if test="string-length(normalize-space($encryption_result)) = 0">
          <xsl:value-of select="$encryption-valid-values_"/>
        </xsl:if>
        <xsl:if test="$encryption_result">
          <xsl:value-of select="$encryption_result"/>
        </xsl:if>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- kex element -->

<!-- Remove invalid not supported and unsecure values from <kex> -->
<xsl:template match="dyncfg-ns:confdConfig/dyncfg-ns:ssh/dyncfg-ns:algorithms/dyncfg-ns:kex">
  <xsl:choose>
    <xsl:when test="string-length(normalize-space(.)) = 0">
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
        <xsl:value-of select="$kex-valid-values_"/>
      </xsl:copy>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="kex_result">
        <!-- Call checkAndRemove template -->
        <xsl:call-template name="checkAndRemove">
          <xsl:with-param name="text" select="."/>
          <xsl:with-param name="first" select="true()"/>
          <xsl:with-param name="valid-values" select="$kex-valid-values_"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:if test="string-length(normalize-space($kex_result)) = 0">
          <xsl:value-of select="$kex-valid-values_"/>
        </xsl:if>
        <xsl:if test="$kex_result">
          <xsl:value-of select="$kex_result"/>
        </xsl:if>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- serverHostKey element -->

<!-- Remove invalid not supported and unsecure values from <serverHostKey> -->
<xsl:template match="dyncfg-ns:confdConfig/dyncfg-ns:ssh/dyncfg-ns:algorithms/dyncfg-ns:serverHostKey">
  <xsl:choose>
    <xsl:when test="string-length(normalize-space(.)) = 0">
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
        <xsl:value-of select="$serverHostKey-valid-values_"/>
      </xsl:copy>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="serverHostKey_result">
        <!-- Call checkAndRemove template -->
        <xsl:call-template name="checkAndRemove">
          <xsl:with-param name="text" select="."/>
          <xsl:with-param name="first" select="true()"/>
          <xsl:with-param name="valid-values" select="$serverHostKey-valid-values_"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:if test="string-length(normalize-space($serverHostKey_result)) = 0">
          <xsl:value-of select="$serverHostKey-valid-values_"/>
        </xsl:if>
        <xsl:if test="$serverHostKey_result">
          <xsl:value-of select="$serverHostKey_result"/>
        </xsl:if>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- A helper template to split a text by comma, process each token and remove not allowed values -->
  <xsl:template name="checkAndRemove">
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
          <xsl:call-template name="checkAndRemove">
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