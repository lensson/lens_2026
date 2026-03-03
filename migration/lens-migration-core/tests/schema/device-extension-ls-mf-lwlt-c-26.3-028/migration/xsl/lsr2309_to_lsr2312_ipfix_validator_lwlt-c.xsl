<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:nokiaLog="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-logging-app" >
     <xsl:strip-space elements="*"/>
     <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
 
     <xsl:template match="nokiaLog:applications/nokiaLog:enable-logging-for[nokiaLog:app-name = 'ipfix_validator_app']"/>
 
</xsl:stylesheet>
