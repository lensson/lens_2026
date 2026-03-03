<?xml version="1.0"?>


<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:onu="urn:bbf:params:xml:ns:yang:bbf-fiber-onu-emulated-mount"
                              xmlns:itf="urn:ietf:params:xml:ns:yang:ietf-interfaces-mounted"
                              xmlns:ipaug="urn:ietf:params:xml:ns:yang:nokia-ip-aug-mounted"
                              xmlns:vcfg="urn:bbf:yang:bbf-voip-configuration-mounted"
                              xmlns:voip="urn:bbf:yang:bbf-sip-voip-mounted">

    <xsl:strip-space elements="*" />
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <!-- default rule -->
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*" />
        </xsl:copy>
    </xsl:template>

    <!-- remove unsupported nodes -->
    <xsl:template match="onu:onus/onu:onu/onu:root/itf:interfaces/itf:interface/ipaug:ip-if-identification" />
    <xsl:template match="onu:onus/onu:onu/onu:root/itf:interfaces/itf:interface/voip:phys-voice-itf/voip:pptp-pots-uni/voip:pptp-pots-connection-type" />
    <xsl:template match="onu:onus/onu:onu/onu:root/vcfg:voip-configuration-characteristics" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:media-forwarders/voip:media-forwarder/voip:download-characteristics" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:media-forwarders/voip:media-forwarder/voip:file-download-method" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:media-forwarders/voip:media-forwarder/voip:file-name" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:media-forwarders/voip:media-forwarder/voip:media-path-mtu" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:media-forwarders/voip:media-forwarder/voip:media-x-connect/voip:media-connection-type" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:media-forwarders/voip:media-forwarder/voip:media-x-connect/voip:media-dscp-mark" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:media-forwarders/voip:media-forwarder/voip:media-x-connect/voip:vbd-profile" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:media-forwarders/voip:media-forwarder/voip:network-element-name" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:media-forwarders/voip:media-forwarder/voip:rfc4733-payload-type" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:media-forwarders/voip:media-forwarder/voip:statistics" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:media-profiles/voip:media-codec-profiles/voip:media-codec-profile/voip:codec-packetization-time-5th-order" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:media-profiles/voip:media-codec-profiles/voip:media-codec-profile/voip:codec-selection-5th-order" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:media-profiles/voip:media-codec-profiles/voip:media-codec-profile/voip:silence-suppression-5th-order" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:media-profiles/voip:media-voice-band-data-profiles" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:media-profiles/voip:media-voice-call-profiles/voip:media-voice-call-profile/voip:asymmetrical-rtp-rtcp" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:media-profiles/voip:media-voice-call-profiles/voip:media-voice-call-profile/voip:initial-call-jitter-buffer" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:media-profiles/voip:media-voice-call-profiles/voip:media-voice-call-profile/voip:maximum-call-jitter-buffer" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:media-profiles/voip:media-voice-call-profiles/voip:media-voice-call-profile/voip:minimum-call-jitter-buffer" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:media-profiles/voip:media-voice-call-profiles/voip:media-voice-call-profile/voip:voice-call-activity-detection" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:media-profiles/voip:media-voice-call-profiles/voip:media-voice-call-profile/voip:voice-to-t38-switch-same-port" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:pots-profiles/voip:pots-uni-characteristics-profiles/voip:pots-uni-characteristics-profile/voip:analog-subscriber-characteristics" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:pots-profiles/voip:pots-uni-characteristics-profiles/voip:pots-uni-characteristics-profile/voip:automatic-gain-control-enabled" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:pots-profiles/voip:pots-uni-characteristics-profiles/voip:pots-uni-characteristics-profile/voip:feeding-current" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:pots-profiles/voip:pots-uni-characteristics-profiles/voip:pots-uni-characteristics-profile/voip:feeding-voltage" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:pots-profiles/voip:pots-uni-characteristics-profiles/voip:pots-uni-characteristics-profile/voip:loss-of-softswitch" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:pots-profiles/voip:pots-uni-characteristics-profiles/voip:pots-uni-characteristics-profile/voip:transmission-path" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:dialplan-digitmap-profiles/voip:dialplan-digitmap-profile/voip:dialplan-characteristics/voip:sip-digitmap-match-mode" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:dialplan-digitmap-profiles/voip:dialplan-digitmap-profile/voip:dialplan-characteristics/voip:sip-digitmap-partial-match" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:dialplan-digitmap-profiles/voip:dialplan-digitmap-profile/voip:dialplan-characteristics/voip:sip-pre-dialing-timer" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:feature-access-codes-profiles/voip:feature-access-codes-profile/voip:attended-call-transfer-feature-access-codes/voip:service-deactivation-code" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:feature-access-codes-profiles/voip:feature-access-codes-profile/voip:attended-call-transfer-feature-access-codes/voip:service-interrogation-code" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:feature-access-codes-profiles/voip:feature-access-codes-profile/voip:call-hold-feature-access-codes/voip:service-deactivation-code" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:feature-access-codes-profiles/voip:feature-access-codes-profile/voip:call-hold-feature-access-codes/voip:service-interrogation-code" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:feature-access-codes-profiles/voip:feature-access-codes-profile/voip:call-park-access-codes" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:feature-access-codes-profiles/voip:feature-access-codes-profile/voip:call-park-feature-access-codes/voip:service-deactivation-code" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:feature-access-codes-profiles/voip:feature-access-codes-profile/voip:call-park-feature-access-codes/voip:service-interrogation-code" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:feature-access-codes-profiles/voip:feature-access-codes-profile/voip:call-waiting-feature-access-codes" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:feature-access-codes-profiles/voip:feature-access-codes-profile/voip:callerid-feature-access-codes/voip:service-interrogation-code" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:feature-access-codes-profiles/voip:feature-access-codes-profile/voip:cancel-cw-feature-access-codes/voip:service-deactivation-code" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:feature-access-codes-profiles/voip:feature-access-codes-profile/voip:cancel-cw-feature-access-codes/voip:service-interrogation-code" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:feature-access-codes-profiles/voip:feature-access-codes-profile/voip:do-not-disturb-feature-access-codes/voip:service-interrogation-code" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:feature-access-codes-profiles/voip:feature-access-codes-profile/voip:hotline-feature-access-codes" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:feature-access-codes-profiles/voip:feature-access-codes-profile/voip:three-way-call-feature-access-codes" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:feature-access-codes-profiles/voip:feature-access-codes-profile/voip:unattended-call-transfer-feature-access-codes/voip:service-deactivation-code" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:feature-access-codes-profiles/voip:feature-access-codes-profile/voip:unattended-call-transfer-feature-access-codes/voip:service-interrogation-code" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:feature-access-codes-profiles/voip:feature-access-codes-profile/voip:warmline-feature-access-codes" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:sip-protocol-data-profiles" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:sip-registerchar-profiles/voip:sip-registerchar-profile/voip:re-register-min-precursory-start-time" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:sip-registerchar-profiles/voip:sip-registerchar-profile/voip:register-dispersion-interval" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:sip-registerchar-profiles/voip:sip-registerchar-profile/voip:register-retry-interval" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:sip-registerchar-profiles/voip:sip-registerchar-profile/voip:register-uri" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:subscription-profiles/voip:subscription-profile/voip:sip-event-package/voip:subscribe-method/voip:subscription-chars" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:supplementary-services-profiles/voip:supplementary-services-profile/voip:call-hold/voip:ch-timer" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:supplementary-services-profiles/voip:supplementary-services-profile/voip:call-hold/voip:hold-resume-method" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:supplementary-services-profiles/voip:supplementary-services-profile/voip:call-hold/voip:reject-response" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:supplementary-services-profiles/voip:supplementary-services-profile/voip:call-hold/voip:SDP-setting" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:supplementary-services-profiles/voip:supplementary-services-profile/voip:call-waiting/voip:cancel-cw-sasc" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:supplementary-services-profiles/voip:supplementary-services-profile/voip:call-waiting/voip:cw-timer" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:supplementary-services-profiles/voip:supplementary-services-profile/voip:call-waiting/voip:reject-response" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:supplementary-services-profiles/voip:supplementary-services-profile/voip:direct-connect-service" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-profiles/voip:supplementary-services-profiles/voip:supplementary-services-profile/voip:Three-party-conference/voip:conference-uri" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-signaling/voip:sip-server-pools/voip:sip-server-pool/voip:sip-servers/voip:admin-state" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-signaling/voip:sip-server-pools/voip:sip-server-pool/voip:sip-servers/voip:sip-server-address/voip:domain" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-signaling/voip:sip-server-pools/voip:sip-server-pool/voip:sip-servers/voip:sip-server-address/voip:fully-qualified-domain/voip:fqdn-priority" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-signaling/voip:sip-server-pools/voip:sip-server-pool/voip:sip-servers/voip:sip-server-address/voip:fully-qualified-domain/voip:fqdn-transport-protocol-priority" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-signaling/voip:sip-server-pools/voip:sip-server-pool/voip:sip-servers/voip:sip-server-address/voip:fully-qualified-domain/voip:fqdn-weight" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-signaling/voip:sip-server-pools/voip:sip-server-pool/voip:sip-servers/voip:sip-server-address/voip:ip/voip:ip-priority" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-signaling/voip:sip-server-pools/voip:sip-server-pool/voip:sip-servers/voip:sip-server-address/voip:ip/voip:ip-transport-protocol-priority" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-signaling/voip:sip-server-pools/voip:sip-server-pool/voip:sip-servers/voip:sip-server-address/voip:ip/voip:ip-weight" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-signaling/voip:sip-server-pools/voip:sip-server-pool/voip:sip-servers/voip:sip-server-address/voip:service-record" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-signaling/voip:sip-terminations/voip:sip-termination/voip:global-directory-number" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-signaling/voip:sip-terminations/voip:sip-termination/voip:sip-uni-pani-header-line-id" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-signaling/voip:sip-user-agents/voip:sip-user-agent/voip:sip-protocol-data-profile" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-signaling/voip:sip-user-agents/voip:sip-user-agent/voip:sip-ua-transport-protocol-priority/voip:sip-ua-transport-tcp-max-idle-time" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-signaling/voip:voicemail-servers" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-signaling/voip:voip-access-gateways/voip:voip-access-gateway/voip:admin-state" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-signaling/voip:voip-access-gateways/voip:voip-access-gateway/voip:sip-service-profile" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-signaling/voip:voip-access-gateways/voip:voip-access-gateway/voip:vag-first-hop-sip-server-validation" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-signaling/voip:voip-access-gateways/voip:voip-access-gateway/voip:voicemail-server" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-signaling/voip:voip-service-gateways/voip:voip-service-gateway/voip:digit-sending-mode" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-signaling/voip:voip-service-gateways/voip:voip-service-gateway/voip:dtmf-sip-info" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-signaling/voip:voip-service-gateways/voip:voip-service-gateway/voip:overlap-dialing" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-signaling/voip:voip-service-gateways/voip:voip-service-gateway/voip:release-timer" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-signaling/voip:voip-service-gateways/voip:voip-service-gateway/voip:sip-response-table" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-signaling/voip:voip-service-gateways/voip:voip-service-gateway/voip:vsg-contact-address" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-signaling/voip:voip-service-gateways/voip:voip-service-gateway/voip:vsg-phone-number" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-signaling/voip:voip-service-providers/voip:voip-service-provider/voip:admin-state" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-signaling/voip:voip-service-providers/voip:voip-service-provider/voip:dynamic-payload-type" />
    <xsl:template match="onu:onus/onu:onu/onu:root/voip:sip-signaling/voip:voip-service-providers/voip:voip-service-provider/voip:release-mode" />

</xsl:stylesheet>