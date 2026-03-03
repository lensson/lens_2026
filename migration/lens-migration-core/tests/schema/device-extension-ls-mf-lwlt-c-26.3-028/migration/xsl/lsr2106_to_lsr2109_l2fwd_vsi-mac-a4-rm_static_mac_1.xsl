<?xml version="1.0" ?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:tailf="urn:ietf:params:xml:ns:netconf:base:1.0"
xmlns:bbf-l2-fwd="urn:bbf:yang:bbf-l2-forwarding"
xmlns:ietf-interfaces="urn:ietf:params:xml:ns:yang:ietf-interfaces"
xmlns:address-list ="urn:ief:address:list"
xmlns:port-temp-nms="urn:params:port:temp">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
<xsl:strip-space elements="*"/>

<!-- default rule -->

<xsl:template match="node()|@*">
	<xsl:copy>
	<xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
</xsl:template>


<!--Keep All the Mac address present in List of each interface after Step1 and Step2 and remove the rest . Keep the mac which does not have any interface or forwarders too-->

<xsl:key name="vsi-mac" match="address-list:stat-mac" use="concat(../../ietf-interfaces:name,'|',address-list:fdb-name,'|', address-list:mac-address)"/>


<xsl:template match="/tailf:config/bbf-l2-fwd:forwarding/bbf-l2-fwd:forwarding-databases/bbf-l2-fwd:forwarding-database/bbf-l2-fwd:static-mac-address">
    <xsl:choose>
        <xsl:when test="bbf-l2-fwd:static-forwarder-port-ref and bbf-l2-fwd:static-forwarder-port-ref/bbf-l2-fwd:port">
			<xsl:if test = "(key('vsi-mac',concat(bbf-l2-fwd:static-forwarder-port-ref/port-temp-nms:port-temp, '|', ../bbf-l2-fwd:name ,'|', bbf-l2-fwd:mac-address)))">
			    <xsl:copy>
                    <xsl:copy-of select="@*"/>
                    <xsl:apply-templates/>
                </xsl:copy>
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
