<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:onu="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount" xmlns:vcfg="urn:bbf:yang:bbf-voip-configuration-mounted" xmlns:rt="urn:ietf:params:xml:ns:yang:ietf-routing-mounted" xmlns:sys="urn:ietf:params:xml:ns:yang:ietf-system-mounted" xmlns:if="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted" xmlns:voip="urn:bbf:yang:bbf-sip-voip-mounted" xmlns:v4ur="urn:ietf:params:xml:ns:yang:ietf-ipv4-unicast-routing-mounted" version="1.0">

    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <!-- default rule -->
   <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:param name="v" select="'urn:bbf:yang:bbf-voip-configuration-mounted'"/>

    <!-- Delete unsupported node -->
    <xsl:template match="onu:onus/onu:onu/onu:root/if:interfaces/if:interface/if:ipv4/if:address/if:subnet/if:prefix-length"/>
    <xsl:template match="onu:onus/onu:onu/onu:root/rt:routing/rt:ribs"/>
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:subscription-profiles/voip:subscription-profile/voip:sip-event-package/voip:subscribe-method/voip:subscription-method"/>
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:feature-access-codes-profiles/voip:feature-access-codes-profile/voip:emergency-call-feature-access-codes"/>
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:media-forwarders/voip:media-forwarder/voip:download-characteristics/voip:ssh-public-key"/>
    <xsl:template match="rt:control-plane-protocol/rt:static-routes/v4ur:ipv4/v4ur:route/v4ur:next-hop/v4ur:next-hop-options/v4ur:simple-next-hop/v4ur:outgoing-interface"/>
    <xsl:template match="rt:control-plane-protocol/rt:static-routes/v4ur:ipv4/v4ur:route/v4ur:next-hop/v4ur:next-hop-options/v4ur:special-next-hop"/>
    <xsl:template match="rt:control-plane-protocol/rt:static-routes/v4ur:ipv4/v4ur:route/v4ur:next-hop/v4ur:next-hop-options/v4ur:next-hop-list"/>
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:digit-manipulation-rule-profiles"/>
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:pots-profiles/voip:tone-pattern-profiles"/>
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:pots-profiles/voip:ringing-pattern-profiles"/>
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:pots-profiles/voip:file-profiles"/>
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:pots-profiles/voip:clip-data-mode-profiles"/>
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:pots-profiles/voip:pots-uni-characteristics-profiles/voip:pots-uni-characteristics-profile/voip:alarm-control"/>
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-signaling/voip:voip-access-gateways/voip:voip-access-gateway/voip:vag-backup-site-first-hop-sip-servers"/>
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-signaling/voip:voip-access-gateways/voip:voip-access-gateway/voip:vag-prim-site-redundancy"/>
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-signaling/voip:voip-access-gateways/voip:voip-access-gateway/voip:vag-backup-site-redundancy"/>
    <xsl:template match="onu:onus/onu:onu/onu:root/sys:system/sys:ntp"/>

    <!-- If voip-access-gateway is configured,and there is no configuration-method leaf, add it and set default value to omci -->
    <xsl:template match="*[local-name()= 'voip-configuration-characteristics' and namespace-uri()='urn:bbf:yang:bbf-voip-configuration-mounted'          and not(./child::*[local-name()='configuration-method'])         and ../descendant::*[local-name()='voip-access-gateway' and namespace-uri()='urn:bbf:yang:bbf-sip-voip-mounted' and parent::*[local-name()='pots-interworking']]] ">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
<xsl:element name="configuration-method" namespace="{$v}">omci</xsl:element>
        </xsl:copy>
    </xsl:template>

    <!-- If voip-access-gateway is configured,and there is no parent node voip-configuration-characteristics, 
         add parent and child node,set configuration-method default value to omci -->
    <xsl:template match="*[local-name()='root' and  namespace-uri() = 'urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount'         and not(./child::*[local-name()='voip-configuration-characteristics'])         and ./descendant::*[local-name()='voip-access-gateway' and namespace-uri()='urn:bbf:yang:bbf-sip-voip-mounted' and parent::*[local-name()='pots-interworking']]]">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
<xsl:apply-templates/>
<xsl:element name="voip-configuration-characteristics" namespace="{$v}">
            <xsl:element name="configuration-method" namespace="{$v}">omci</xsl:element>
            </xsl:element>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
