<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:onusNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount" xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted" xmlns:bbfiftNs="urn:bbf:yang:bbf-if-type-mounted" xmlns:subitf="urn:bbf:yang:bbf-sub-interfaces-mounted" xmlns:subitf_tagging="urn:bbf:yang:bbf-sub-interface-tagging-mounted" version="1.0">

    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

    <!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <!-- dei-from-tag-index for single-tag and priority-tag -->
    <xsl:template match="*[contains(name(),'write-dei-0')        and namespace-uri() = 'urn:bbf:yang:bbf-sub-interface-tagging-mounted'        and ancestor::*[contains(name(),'ingress-rewrite')]        and ancestor::*[contains(name(),'interface')]        and ancestor::*[contains(name(),'onu')]     ]">
     <xsl:variable name="var_tag" select="../../../../subitf:flexible-match/subitf_tagging:match-criteria/subitf_tagging:tag/subitf_tagging:dot1q-tag/subitf_tagging:vlan-id"/>
        <xsl:choose>
            <xsl:when test="($var_tag &gt;=1 and $var_tag &lt;=4094) or $var_tag='priority-tagged'">
               <xsl:if test="contains(name(),'bbf-subif-tag-mounted')">
                  <xsl:element name="bbf-subif-tag-mounted:dei-from-tag-index" namespace="urn:bbf:yang:bbf-sub-interface-tagging-mounted">0</xsl:element>
               </xsl:if>
               <xsl:if test="not(contains(name(),'bbf-subif-tag-mounted'))">
                  <xsl:element name="dei-from-tag-index" namespace="urn:bbf:yang:bbf-sub-interface-tagging-mounted">0</xsl:element>
               </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

  <!-- write-dei-0 for untag -->
  <xsl:template match="*[contains(name(),'dei-from-tag-index')        and namespace-uri() = 'urn:bbf:yang:bbf-sub-interface-tagging-mounted'        and ancestor::*[contains(name(),'ingress-rewrite')]        and ancestor::*[contains(name(),'interface')]        and ancestor::*[contains(name(),'onu')]     ]">
     <xsl:variable name="var_untag" select="../../../../subitf:flexible-match/subitf_tagging:match-criteria/subitf_tagging:untagged"/>
        <xsl:choose>
           <xsl:when test="$var_untag">
              <xsl:if test="contains(name(),'bbf-subif-tag-mounted')">
                <xsl:element name="bbf-subif-tag-mounted:write-dei-0" namespace="urn:bbf:yang:bbf-sub-interface-tagging-mounted"/>
              </xsl:if>
              <xsl:if test="not(contains(name(),'bbf-subif-tag-mounted'))">
                <xsl:element name="write-dei-0" namespace="urn:bbf:yang:bbf-sub-interface-tagging-mounted"/>
              </xsl:if>
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
