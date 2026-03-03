<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:onusNs="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount"
    xmlns:ifNs="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted"
    xmlns:qosNs="urn:bbf:yang:bbf-qos-policies-mounted"
    xmlns:clsNs="urn:bbf:yang:bbf-qos-classifiers-mounted"
>
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="var_onusNs">urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount</xsl:variable>
    <xsl:variable name="var_ifNs">urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted</xsl:variable>
    <xsl:variable name="var_qosNs">urn:bbf:yang:bbf-qos-policies-mounted</xsl:variable>
    <xsl:variable name="var_clsNs">urn:bbf:yang:bbf-qos-classifiers-mounted</xsl:variable>
    <!-- default rule -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    <xsl:template name="add-classifiers-untagged">
        <xsl:param name="sv_pbit"/>
        <xsl:element name="classifiers" namespace="{$var_qosNs}">
            <xsl:element name="name" namespace="{$var_qosNs}">pbit_marking_untag_write_pbit<xsl:value-of select="$sv_pbit"/></xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template name="add-classifiers-tagged-copy">
        <xsl:element name="classifiers" namespace="{$var_qosNs}">
            <xsl:element name="name" namespace="{$var_qosNs}">pbit_marking_copy_pbit0</xsl:element>
        </xsl:element>
        <xsl:element name="classifiers" namespace="{$var_qosNs}">
            <xsl:element name="name" namespace="{$var_qosNs}">pbit_marking_copy_pbit1</xsl:element>
        </xsl:element>
        <xsl:element name="classifiers" namespace="{$var_qosNs}">
            <xsl:element name="name" namespace="{$var_qosNs}">pbit_marking_copy_pbit2</xsl:element>
        </xsl:element>
        <xsl:element name="classifiers" namespace="{$var_qosNs}">
            <xsl:element name="name" namespace="{$var_qosNs}">pbit_marking_copy_pbit3</xsl:element>
        </xsl:element>
        <xsl:element name="classifiers" namespace="{$var_qosNs}">
            <xsl:element name="name" namespace="{$var_qosNs}">pbit_marking_copy_pbit4</xsl:element>
        </xsl:element>
        <xsl:element name="classifiers" namespace="{$var_qosNs}">
            <xsl:element name="name" namespace="{$var_qosNs}">pbit_marking_copy_pbit5</xsl:element>
        </xsl:element>
        <xsl:element name="classifiers" namespace="{$var_qosNs}">
            <xsl:element name="name" namespace="{$var_qosNs}">pbit_marking_copy_pbit6</xsl:element>
        </xsl:element>
        <xsl:element name="classifiers" namespace="{$var_qosNs}">
            <xsl:element name="name" namespace="{$var_qosNs}">pbit_marking_copy_pbit7</xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template name="add-classifiers-tagged-write">
        <xsl:param name="sv_pbit"/>
        <xsl:element name="classifiers" namespace="{$var_qosNs}">
            <xsl:element name="name" namespace="{$var_qosNs}">pbit_marking_tag_pbit0_write_pbit<xsl:value-of select="$sv_pbit"/></xsl:element>
        </xsl:element>
        <xsl:element name="classifiers" namespace="{$var_qosNs}">
            <xsl:element name="name" namespace="{$var_qosNs}">pbit_marking_tag_pbit1_write_pbit<xsl:value-of select="$sv_pbit"/></xsl:element>
        </xsl:element>
        <xsl:element name="classifiers" namespace="{$var_qosNs}">
            <xsl:element name="name" namespace="{$var_qosNs}">pbit_marking_tag_pbit2_write_pbit<xsl:value-of select="$sv_pbit"/></xsl:element>
        </xsl:element>
        <xsl:element name="classifiers" namespace="{$var_qosNs}">
            <xsl:element name="name" namespace="{$var_qosNs}">pbit_marking_tag_pbit3_write_pbit<xsl:value-of select="$sv_pbit"/></xsl:element>
        </xsl:element>
        <xsl:element name="classifiers" namespace="{$var_qosNs}">
            <xsl:element name="name" namespace="{$var_qosNs}">pbit_marking_tag_pbit4_write_pbit<xsl:value-of select="$sv_pbit"/></xsl:element>
        </xsl:element>
        <xsl:element name="classifiers" namespace="{$var_qosNs}">
            <xsl:element name="name" namespace="{$var_qosNs}">pbit_marking_tag_pbit5_write_pbit<xsl:value-of select="$sv_pbit"/></xsl:element>
        </xsl:element>
        <xsl:element name="classifiers" namespace="{$var_qosNs}">
            <xsl:element name="name" namespace="{$var_qosNs}">pbit_marking_tag_pbit6_write_pbit<xsl:value-of select="$sv_pbit"/></xsl:element>
        </xsl:element>
        <xsl:element name="classifiers" namespace="{$var_qosNs}">
            <xsl:element name="name" namespace="{$var_qosNs}">pbit_marking_tag_pbit7_write_pbit<xsl:value-of select="$sv_pbit"/></xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template name="add-classifiers-tc">
        <xsl:param name="sv_pbit"/>
        <xsl:param name="sv_tc"/>
        <xsl:element name="classifiers" namespace="{$var_qosNs}">
            <xsl:element name="name" namespace="{$var_qosNs}">pbit2tc_pbit<xsl:value-of select="$sv_pbit"/>_to_tc<xsl:value-of select="$sv_tc"/></xsl:element>
        </xsl:element>
    </xsl:template>


    <xsl:template match="*[name() = 'root' 
        and namespace-uri() = 'urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount'
        and parent::*[name() = 'onu']
    ]">
        <xsl:variable name="var_onu_name" select="ancestor::*[name() = 'onu']/child::*[name() = 'name']"/>
        <!--
/child::*[name()='ingress-qos-policy-profile' and text()=$var_name]/../descendant::*[name()='untagged']"
/cfgNs:config/onusNs:onus/onusNs:onu/child::*[name()='name' and text()=$var_onu_name]/../onusNs:root/qosNs:qos-policy-profiles-new/qosNs:policy-profile/qosNs:name
	-->
        <xsl:element name="root" namespace="{$var_onusNs}">
            <xsl:element name="policies-new" namespace="{$var_qosNs}">
                <xsl:for-each select="../onusNs:root/qosNs:qos-policy-profiles-new/qosNs:policy-profile">
                    <xsl:variable name="var_name" select="child::*[name() = 'mig_tmp_name']"/>
                    <xsl:variable name="var_type" select="child::*[name() = 'mig_tmp_type']"/>
                    <xsl:variable name="var_police_count" select="child::*[name() = 'mig_tmp_police_count']"/>
                    <xsl:variable name="var_pbit_untagged" select="child::*[name() = 'mig_tmp_pbit_untagged']"/>
                    <xsl:variable name="var_pbit_tagged" select="child::*[name() = 'mig_tmp_pbit_tagged']"/>
                    <xsl:variable name="var_first_policy_name" select="child::*[name() = 'policy-list'][1]/child::*[name() = 'name']"/>
                    <xsl:element name="policy" namespace="{$var_qosNs}">
                        <xsl:element name="name" namespace="{$var_qosNs}"><xsl:value-of select="$var_name"/>_pbit</xsl:element>
                        <!--
	<xsl:element name="first_one" namespace="{$var_qosNs}"></xsl:element>
-->

                        <xsl:if test=" '1.1'=$var_type
                            or '1.2'=$var_type
                            or '2.1'=$var_type
                        ">
                            <xsl:choose>
                                <xsl:when test="1=$var_police_count">
                                    <xsl:element name="untagged_pbit" namespace="{$var_qosNs}">
                                        <xsl:value-of select="$var_pbit_untagged"/>
                                    </xsl:element>
                                    <xsl:call-template name="add-classifiers-untagged">
                                        <xsl:with-param name="sv_pbit">
                                            <xsl:value-of select="$var_pbit_untagged"/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:variable name="var_first_policy" select="../../qosNs:policies/qosNs:policy/child::*[name() = 'name' and text()=$var_first_policy_name]/.."/>
                                    <!--
				<xsl:element name="var_first_policy" namespace="{$var_qosNs}"><xsl:value-of select="$var_first_policy"/></xsl:element>
-->
                                    <xsl:copy-of select="$var_first_policy/child::*[name()='classifiers']"/>
                                    <xsl:element name="untagged_dcsp" namespace="{$var_qosNs}">
                                        <!--
					<xsl:for-each select="$var_first_policy/qosNs:classifiers/qosNs:name">
<xsl:variable name="var_classifier_name" select="."/>

<xsl:variable name="var_classifier" select="../../../../clsNs:classifiers/clsNs:classifier-entry/child::*[name() = 'name' and text()=$var_classifier_name]"/>

<xsl:variable name="var_dscp_range" select="$var_classifier/../descendant::*[name()='dscp-range']"/>
<xsl:variable name="var_dscp_pbit"  select="$var_classifier/../clsNs:classifier-action-entry-cfg/descendant::*[name()='pbit-value']"/>

						<xsl:element name="cn" namespace="{$var_qosNs}">
							<xsl:element name="name" namespace="{$var_qosNs}"><xsl:value-of select="$var_classifier_name"/></xsl:element>
							<xsl:element name="range" namespace="{$var_qosNs}"><xsl:value-of select="$var_dscp_range"/></xsl:element>
							<xsl:element name="pbit" namespace="{$var_qosNs}"><xsl:value-of select="$var_dscp_pbit"/></xsl:element>
						</xsl:element>

					</xsl:for-each>
-->
                                    </xsl:element>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                        <xsl:if test=" '1.2'=$var_type
                            or '1.3'=$var_type
                        ">
                            <xsl:element name="tagged_copy" namespace="{$var_qosNs}"/>
                            <xsl:call-template name="add-classifiers-tagged-copy"/>
                        </xsl:if>
                        <xsl:if test=" '2.1'=$var_type
                            or '2.2'=$var_type
                        ">
                            <xsl:element name="tagged_pbit" namespace="{$var_qosNs}">
                                <xsl:value-of select="$var_pbit_tagged"/>
                            </xsl:element>
                            <xsl:call-template name="add-classifiers-tagged-write">
                                <xsl:with-param name="sv_pbit">
                                    <xsl:value-of select="$var_pbit_tagged"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:element>
                    <xsl:element name="policy" namespace="{$var_qosNs}">
                        <xsl:element name="name" namespace="{$var_qosNs}"><xsl:value-of select="$var_name"/>_tc</xsl:element>
                        <xsl:for-each select="./qosNs:mig_tmp_classifiers/qosNs:soure_classifier">
                            <xsl:variable name="var_tc" select="child::*[name() = 'tc']"/>
                            <xsl:for-each select="./qosNs:pbit-value/qosNs:item">
                                <!--
			<xsl:element name="tc_pbit" namespace="{$var_qosNs}"><xsl:value-of select="."/></xsl:element>
			<xsl:element name="tc_tc" namespace="{$var_qosNs}"><xsl:value-of select="$var_tc"/></xsl:element>
-->
                                <xsl:call-template name="add-classifiers-tc">
                                    <xsl:with-param name="sv_pbit">
                                        <xsl:value-of select="."/>
                                    </xsl:with-param>
                                    <xsl:with-param name="sv_tc">
                                        <xsl:value-of select="$var_tc"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:for-each>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
            <xsl:copy-of select="child::*"/>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
