<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0"
                              xmlns:onus-from-template="http://www.nokia.com/Fixed-Networks/BBA/yang/onus-from-template"
                              xmlns:onu="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount">

<!-- remove unsupported nodes -->
<xsl:template match="onu:onus/onu:onu/onus-from-template:template-parameters/onus-from-template:interfaces/onus-from-template:interface/onus-from-template:continuous-accumulation-enable"/>

</xsl:stylesheet>
