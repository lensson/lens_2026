<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:lic-app="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-licensing-app"  >
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <xsl:template match="lic-app:licensing[not(./node()[not(self::lic-app:cde-feature or self::lic-app:cde-features)])]"/>
    <xsl:template match="lic-app:cde-features"/>
    <xsl:template match="lic-app:cde-feature"/>
</xsl:stylesheet>


