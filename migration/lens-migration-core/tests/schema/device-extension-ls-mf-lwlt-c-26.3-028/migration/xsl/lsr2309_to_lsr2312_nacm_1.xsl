<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:nacm="urn:ietf:params:xml:ns:yang:ietf-netconf-acm"
                              xmlns:tacm="http://tail-f.com/yang/acm"
                              >
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    
<!-- Remove only the default rule-list as they are defined in the default xml files
     'cap_nacm_admin_rules.xml' and 'cap_nacm_rules_common.xml' or the auto-generated
     xml file 'cap_nacm_profile_rules.xml' -->
<!-- Any rule-list which is created for operator by techsupport user should not be removed -->
   <xsl:template match="nacm:nacm/nacm:rule-list[ nacm:name = 'admin-rule-list' or
                                                 nacm:name = 'techsupport-rule-list' or
                                                 nacm:name = 'netconf-only-rule-list' or
                                                 nacm:name = 'cli-only-rule-list'
                                                 ]/nacm:rule"/>

   <xsl:template match="nacm:nacm/nacm:rule-list[ nacm:name = 'admin-rule-list' or
                                                 nacm:name = 'techsupport-rule-list' or
                                                 nacm:name = 'netconf-only-rule-list' or
                                                 nacm:name = 'cli-only-rule-list'
                                                 ]/tacm:cmdrule"/>


   <xsl:template match="nacm:nacm/nacm:rule-list[ nacm:name[ text()='admin-read-only-list' or
                                                             text()='any-group' or
                                                             text()='default' or
                                                             text()='vcli-rule-list' or
                                                             text()='default-interfaces-list' or
                                                             ( (contains(text(), '-read-access-list') or
                                                               contains(text(), '-config-access-list') or
                                                               contains(text(), '-exec-access-list') ) and
                                                               ( contains(text(), 'log') or
                                                                 contains(text(), 'transport') or
                                                                 contains(text(), 'qos') or
                                                                 contains(text(), 'swm') or
                                                                 contains(text(), 'multicast') or
                                                                 contains(text(), 'forwarding') or
                                                                 contains(text(), 'eqpt') or
                                                                 contains(text(), 'oam') or
                                                                 contains(text(), 'alarms') or
                                                                 contains(text(), 'subscriber')))]]"/>



</xsl:stylesheet>
