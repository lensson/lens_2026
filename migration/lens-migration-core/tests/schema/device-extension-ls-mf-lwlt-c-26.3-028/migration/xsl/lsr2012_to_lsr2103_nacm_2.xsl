<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:newns="http://tail-f.com/ns/aaa/1.1" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    
 <xsl:param name="nacmNS" select="'urn:ietf:params:xml:ns:yang:ietf-netconf-acm'"/>
 <xsl:param name="tacmNS" select="'http://tail-f.com/yang/acm'"/>

<!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

<!-- Remove only the default rule-list as they are defined in the default xml files 
     'cap_nacm_admin_rules.xml' and 'cap_nacm_rules_common.xml' or the auto-generated
     xml file 'cap_nacm_profile_rules.xml' -->
<!-- Any rule-list which is created for operator by techsupport user should not be removed -->
   <xsl:template match="*[name() = 'rule' or name()='cmdrule']">
     <xsl:choose>
       <xsl:when test="(namespace-uri() = $nacmNS or namespace-uri() = $tacmNS) and ./preceding-sibling::*[name()='name'  and text()='admin-rule-list']">
       </xsl:when>
       <xsl:when test="(namespace-uri() = $nacmNS or namespace-uri() = $tacmNS) and ./preceding-sibling::*[name()='name'  and text()='techsupport-rule-list']">
       </xsl:when>
       <xsl:otherwise>
          <xsl:copy>
             <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
       </xsl:otherwise>
     </xsl:choose>
   </xsl:template>

   <xsl:template match="*[name() = 'rule-list']">
     <xsl:choose>
       <xsl:when test="namespace-uri() = $nacmNS and ./child::*[name()='name'  and text()='admin-read-only-list']">
       </xsl:when>
       <xsl:when test="namespace-uri() = $nacmNS and ./child::*[name()='name'  and text()='any-group']">
       </xsl:when>
       <xsl:when test="namespace-uri() = $nacmNS and ./child::*[name()='name'  and text()='default']">
       </xsl:when>
       <xsl:when test="namespace-uri() = $nacmNS and ./child::*[name()='name'  and text()='default-interfaces-list']">
       </xsl:when>
       <xsl:when test="namespace-uri() = $nacmNS and ./child::*[name()='name'  and (contains(text(), '-read-access-list') or contains(text(), '-config-access-list')  or contains(text(), '-exec-access-list'))]">
          <xsl:choose>
          <xsl:when test="./child::*[name()='name'  and (contains(text(), 'log') or contains(text(), 'transport')  or contains(text(), 'qos') or contains(text(), 'swm') or contains(text(), 'multicast')  or contains(text(), 'forwarding') or contains(text(), 'eqpt') or contains(text(), 'oam')  or contains(text(), 'alarms') or contains(text(), 'subscriber'))]">
          </xsl:when>
          <xsl:otherwise>
             <xsl:copy>
                <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
          </xsl:otherwise>
          </xsl:choose>
       </xsl:when>
       <xsl:otherwise>
          <xsl:copy>
             <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
       </xsl:otherwise>
     </xsl:choose>
   </xsl:template>

</xsl:stylesheet>
