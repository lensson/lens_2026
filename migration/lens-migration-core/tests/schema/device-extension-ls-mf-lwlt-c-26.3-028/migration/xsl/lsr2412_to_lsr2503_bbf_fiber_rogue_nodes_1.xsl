<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:cfgNs="urn:ietf:params:xml:ns:netconf:base:1.0"
                              xmlns:if="urn:ietf:params:xml:ns:yang:ietf-interfaces"
                              xmlns:xpon="urn:bbf:yang:bbf-xpon"
                              xmlns:rogueNs="urn:broadband-forum-org:yang:bbf-fiber-rogue-nodes"  
                              xmlns:map="http://www.w3.org/2005/xpath-functions/map">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <xsl:variable name="rogue_prof_stuck_laser_on">
        <xsl:variable name="rogue_prof_names">
            <xsl:for-each select ="/cfgNs:config/rogueNs:rogue-test-profile/rogueNs:test-type[contains(text(),'stuck-laser-on')]">
                <xsl:element name="rogue_prof">
                    <xsl:element name="name">
                        <xsl:value-of select="current()/../rogueNs:name"/>
                    </xsl:element>
                </xsl:element>
            </xsl:for-each>
        </xsl:variable>
        <xsl:copy-of select="$rogue_prof_names"/>
    </xsl:variable>

    <xsl:variable name="rogue_prof_name_map" select="map:merge(for $elem in $rogue_prof_stuck_laser_on/rogue_prof return map{$elem/name : $elem})"/>

    <!-- Rule1: remove background-rogue-test which test type is pattern or start-trigger is not pon-los -->
    <xsl:template match="/cfgNs:config/if:interfaces/if:interface/xpon:channel-termination/rogueNs:background-rogue-test">
        <xsl:variable name="rogue_test_profile">
            <xsl:value-of select="./rogueNs:rogue-test-profile-ref"/>
        </xsl:variable>
        <xsl:variable name="is_prof_stuck_laser_on">
            <xsl:value-of  select="$rogue_prof_name_map($rogue_test_profile)"/>
        </xsl:variable>
        <xsl:variable name="start_trigger">
            <xsl:value-of select="./rogueNs:start-trigger"/>
        </xsl:variable>
        <!--
        <xsl:message terminate="no">
            <xsl:text>profile name is: </xsl:text>
            <xsl:value-of select="$rogue_test_profile"/>
            <xsl:text> is_prof_stuck_laser_on is: </xsl:text>
            <xsl:value-of select="$is_prof_stuck_laser_on"/>
            <xsl:text> start trigger is: </xsl:text>
            <xsl:value-of select="$start_trigger"/>
        </xsl:message>
        -->
        <xsl:if test= "string-length(normalize-space($is_prof_stuck_laser_on))>0 and contains($start_trigger,'pon-los')">
            <xsl:copy>
                <xsl:copy-of select="@*"/>
                <xsl:apply-templates/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>

    <!-- Rule2: remove pattern rogue-test-profile -->
    <xsl:template match="/cfgNs:config/rogueNs:rogue-test-profile[child::rogueNs:test-type[contains(text(),'pattern')]]">
    </xsl:template>

</xsl:stylesheet>
