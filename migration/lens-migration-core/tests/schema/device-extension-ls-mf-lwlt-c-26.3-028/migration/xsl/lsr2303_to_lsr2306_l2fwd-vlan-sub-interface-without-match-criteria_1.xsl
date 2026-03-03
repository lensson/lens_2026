<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:if="urn:ietf:params:xml:ns:yang:ietf-interfaces"
                xmlns:bbf-subif="urn:bbf:yang:bbf-sub-interfaces"
                xmlns:bbf-frameproc="urn:bbf:yang:bbf-frame-processing-profile"
                xmlns:bbf-vsi-vctr="urn:bbf:yang:bbf-vlan-sub-interface-vector"
                xmlns:bbf-subif-tag="urn:bbf:yang:bbf-sub-interface-tagging">

    <!--
        The match-criteria of VSI must be configured in atleast of the following 3 condifions
        1. Frame Processing Profile referred.
        2. Inline Frame Processing configured.
        3. Vector Profile attached.
    -->

    <xsl:template match="if:interfaces/if:interface[if:type='bbfift:vlan-sub-interface']/if:name">
       <xsl:if test="(not(../bbf-frameproc:frame-processing-profile-ref))
                      and (not(../bbf-subif:inline-frame-processing/bbf-subif:ingress-rule/bbf-subif:rule/bbf-subif:flexible-match/bbf-subif-tag:match-criteria))
                      and (not(../bbf-vsi-vctr:vector-profile))">
          <wrong-configuration-detected>The vlan-sub-interface:<xsl:value-of select="../if:name"/> has no match-criteria, migration is not successful.</wrong-configuration-detected>
       </xsl:if>

       <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:apply-templates/>
       </xsl:copy>

    </xsl:template>
</xsl:stylesheet>

