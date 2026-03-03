<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:onusNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount" xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted" xmlns:qosNs="urn:bbf:yang:bbf-qos-policies-mounted" xmlns:bbfinf="urn:bbf:yang:bbf-sub-interfaces-mounted" version="1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>
    <!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="*[name() = 'interface']">
        <xsl:choose>
      <xsl:when test="namespace-uri() = 'urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted'                   and parent::*[name() = 'interfaces']                  and child::*[name()='type'] ='bbfift-mounted:vlan-sub-interface'                  and child::*[name()='ingress-qos-policy-profile']       ">
                <xsl:variable name="ns" select="namespace-uri()"/>
                <xsl:variable name="val_policy_profile" select="child::*[name()='ingress-qos-policy-profile']"/>
                <xsl:variable name="val_count_policy_list" select="count(../../qosNs:qos-policy-profiles/qosNs:policy-profile/child::*[name()='name' and text()=$val_policy_profile]/../qosNs:policy-list/qosNs:name)"/>
                <xsl:variable name="val_pbit_bbb" select="./bbfinf:inline-frame-processing/descendant::*[name()='untagged']/../../../descendant::*[name()='write-pbit']"/>
                <xsl:variable name="val_pbit_ddd" select="./bbfinf:inline-frame-processing/descendant::*[name()='tag']/../../../../descendant::*[name()='write-pbit']"/>
        <xsl:variable name="val_pbit_untagged" select="child::*[name()='inline-frame-processing'] and descendant::*[name()='flexible-match']              and descendant::*[name()='untagged'] and descendant::*[name()='write-pbit-0']"/>
        <xsl:variable name="val_pbit_tagged" select="child::*[name()='inline-frame-processing'] and descendant::*[name()='flexible-match']              and descendant::*[name()='tag'] and descendant::*[name()='write-pbit-0']"/>
                <xsl:variable name="val_untagged" select="child::*[name()='inline-frame-processing'] and descendant::*[name()='flexible-match'] and descendant::*[name()='untagged']"/>
                <xsl:variable name="val_tagged" select="child::*[name()='inline-frame-processing'] and descendant::*[name()='flexible-match'] and descendant::*[name()='tag']"/>
                <!--xsl:variable name="val_pbitfrom_tag" select="child::*[name()='inline-frame-processing'] and descendant::*[name()='ingress-rewrite'] and descendant::*[name()='pbit-from-tag-index']"/-->
                <xsl:variable name="val_pbitfrom_tag" select="./bbfinf:inline-frame-processing/descendant::*[name()='ingress-rewrite']/../../descendant::*[name()='pbit-from-tag-index']"/>
                <xsl:element name="interface" namespace="{$ns}">
                    <!--xsl:if test=" $val_count_policy_list = 1 "-->
                    <xsl:if test="($val_untagged) and (not ($val_tagged))">
                        <xsl:element name="mig_tmp_type" namespace="{$ns}">1.1</xsl:element>
                        <xsl:choose>
                            <xsl:when test="$val_pbit_untagged">
                                <xsl:element name="mig_tmp_untagged-write-pbit" namespace="{$ns}">0</xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="mig_tmp_untagged-write-pbit" namespace="{$ns}">
                                    <xsl:value-of select="$val_pbit_bbb"/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:element name="mig_count_policy_list" namespace="{$ns}">
                            <xsl:value-of select="$val_count_policy_list"/>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="($val_untagged) and ($val_tagged)">
                        <xsl:if test="($val_pbitfrom_tag)">
                            <xsl:element name="mig_tmp_type" namespace="{$ns}">1.2</xsl:element>
                            <xsl:choose>
                                <xsl:when test="$val_pbit_untagged">
                                    <xsl:element name="mig_tmp_untagged-write-pbit" namespace="{$ns}">0</xsl:element>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:element name="mig_tmp_untagged-write-pbit" namespace="{$ns}">
                                        <xsl:value-of select="$val_pbit_bbb"/>
                                    </xsl:element>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:element name="mig_count_policy_list" namespace="{$ns}">
                                <xsl:value-of select="$val_count_policy_list"/>
                            </xsl:element>
                        </xsl:if>
                    </xsl:if>
                    <xsl:if test="(not ($val_untagged)) and ($val_tagged)">
                        <xsl:if test="($val_pbitfrom_tag)">
                            <xsl:element name="mig_tmp_type" namespace="{$ns}">1.3</xsl:element>
                            <xsl:element name="mig_count_policy_list" namespace="{$ns}">
                                <xsl:value-of select="$val_count_policy_list"/>
                            </xsl:element>
                        </xsl:if>
                    </xsl:if>
                    <xsl:if test="($val_untagged) and ($val_tagged)">
                        <xsl:if test="(not ($val_pbitfrom_tag))">
                            <xsl:choose>
                                <xsl:when test="(val_pbit_tagged) or ($val_pbit_ddd)">
                                    <xsl:element name="mig_tmp_type" namespace="{$ns}">2.1</xsl:element>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:element name="mig_tmp_type" namespace="{$ns}">1.1</xsl:element>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="$val_pbit_untagged">
                                    <xsl:element name="mig_tmp_untagged-write-pbit" namespace="{$ns}">0</xsl:element>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:element name="mig_tmp_untagged-write-pbit" namespace="{$ns}">
                                        <xsl:value-of select="$val_pbit_bbb"/>
                                    </xsl:element>
                                </xsl:otherwise>
                            </xsl:choose>
                        <xsl:if test="(val_pbit_tagged) or ($val_pbit_ddd)">
                            <xsl:choose>
                                <xsl:when test="$val_pbit_tagged">
                                    <xsl:element name="mig_tmp_tagged-write-pbit" namespace="{$ns}">0</xsl:element>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:element name="mig_tmp_tagged-write-pbit" namespace="{$ns}">
                                        <xsl:value-of select="$val_pbit_ddd"/>
                                    </xsl:element>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                            <xsl:element name="mig_count_policy_list" namespace="{$ns}">
                                <xsl:value-of select="$val_count_policy_list"/>
                            </xsl:element>
                        </xsl:if>
                    </xsl:if>
                    <xsl:if test="(not ($val_untagged)) and ($val_tagged)">
                        <xsl:if test="(not ($val_pbitfrom_tag)) and ((val_pbit_tagged) or ($val_pbit_ddd))">
                            <xsl:element name="mig_tmp_type" namespace="{$ns}">2.2</xsl:element>
                            <xsl:choose>
                                <xsl:when test="$val_pbit_tagged">
                                    <xsl:element name="mig_tmp_tagged-write-pbit" namespace="{$ns}">0</xsl:element>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:element name="mig_tmp_tagged-write-pbit" namespace="{$ns}">
                                        <xsl:value-of select="$val_pbit_ddd"/>
                                    </xsl:element>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:element name="mig_count_policy_list" namespace="{$ns}">
                                <xsl:value-of select="$val_count_policy_list"/>
                            </xsl:element>
                        </xsl:if>
                    </xsl:if>
                    <!--/xsl:if-->
                    <xsl:apply-templates select="node()|@*"/>
                    <!-- <xsl:when test="not($val_tca_value111)">  -->
                </xsl:element>
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
