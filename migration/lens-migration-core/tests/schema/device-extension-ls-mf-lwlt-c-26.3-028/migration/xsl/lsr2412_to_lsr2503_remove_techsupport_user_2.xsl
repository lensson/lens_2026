<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:nacm="urn:ietf:params:xml:ns:yang:ietf-netconf-acm"
                xmlns:nokia-aaa="http://www.nokia.com/Fixed-Networks/BBA/yang/nokia-aaa">

<!-- Match and exclude any "users/user" element with <name> equal to "techsupport" -->
  <xsl:template match="nokia-aaa:users/nokia-aaa:user[nokia-aaa:name='techsupport']">
    <!-- Do nothing, effectively removing the element from the output -->
  </xsl:template>

<!-- Exclude any "nacm/groups/group/user-name" element with value "techsupport" -->
  <xsl:template match="nacm:nacm/nacm:groups/nacm:group/nacm:user-name[text() = 'techsupport']">
    <!-- Do nothing, effectively removing the element from the output -->
  </xsl:template>

</xsl:stylesheet>