Description:
This sample configures the VOIP SIP agent.

Prerequisite:
ONU device has to be created.

Input parameters:

* app-call-announce: call waiting features,allows to display the identity of second calling party
* app-call-fwd-indicate: Call presentation features
* app-call-hold: call processing features
* app-call-park: call processing features
* app-call-transfer: call processing features
* app-call-waiting: call waiting features
* app-caller-id-name: caller ID features
* app-caller-id-number: caller ID features
* app-calling-name: caller ID features
* app-calling-number: caller ID features
* app-dial-tone-delay-option: dial tone delay option.
* app-direct-connect-feature: direct connect feature
* app-direct-connect-uri: direct connect URI.
* app-emergency-call-originationg-hold: call processing features
* app-flash-on-emergency-call: call processing features
* app-mwi-spl-dialtone: Message waiting indication special dial tone
* app-mwi-visual-indi: Message waiting indication visual indication
* app-three-way-calling: call processing features
* cas-event: Enables or disables handling of channel-associated signaling (CAS) via RTP Tone events per IETF RFC 4733.
* dial-plan-critical-timeout: This attribute defines the critical dial timeout for digit map processing
* dial-plan-digit-map: a network dial plan table
* dial-plan-partial-timeout: This attribute defines the partial dial timeout for digit map processing
* dscp: DSCP for VOIP signaling packets
* dtmf-digit-duration: The duration of DTMF digits that may be generated towards the subscriber set.
* dtmf-digit-levels: The power level of DTMF digits that may be generated towards the subscriber set
* dtmf-mode: The processing of the DTMF and telephone event tones(rfc4733)
* feat-act-caller-id: Caller ID activate
* feat-act-dnd: Do not disturb activation
* feat-deact-caller-id: Caller ID deactivate
* feat-deact-dnd: Do not disturb deactivation
* file-name: File name
* ftp-server-address: Ftp server address
* jitter-target: Target value of jitter buffer
* max-jitter-buffer: Maximum buffer value of jitter buffer
* media-codec1st: This attribute specifies codec selection as defined by [IETF RFC 3551].
* media-codec2nd: This attribute specifies codec selection as defined by [IETF RFC 3551].
* media-codec3rd: This attribute specifies codec selection as defined by [IETF RFC 3551].
* media-codec4th: This attribute specifies codec selection as defined by [IETF RFC 3551].
* media-fax-mode: FAX-MODE
* media-pkt-period1st: This attribute specifies the packet period selection interval
* media-pkt-period2nd: This attribute specifies the packet period selection interval
* media-pkt-period3rd: This attribute specifies the packet period selection interval
* media-pkt-period4th: This attribute specifies the packet period selection interval
* media-silence1st: This attribute specifies whether silence suppression is on or off.
* media-silence2nd: This attribute specifies whether silence suppression is on or off.
* media-silence3rd: This attribute specifies whether silence suppression is on or off.
* media-silence4th: This attribute specifies whether silence suppression is on or off.
* onu-name: ONU name
* password: The authentication password for file transfer
* pstn-protocol-variant: Country code for the POTS line
* re-reg-head-start: This attribute specifies the time in seconds prior to timeout that causes the SIP agent to start the re-registration process
* realm: The authentication realm for file transfer
* reg-expire-time: This attribute specifies the SIP registration expiration time in seconds.
* registrar-proxy-address: proxyserv, outproxyserv and aor-host-prt
* release-timer: This parameter contains a release timer defined in seconds.
* rtp-dscp: DSCP for VOIP media packets
* rtp-dtmf-event: Enables or disables the handling of DTMF via RTP DTMF events per [IETF RFC 4733]
* rtp-local-port-min: This attribute defines the base UDP port that should be used by RTP for voice traffic
* uri-format: This attribute specifies the format of the URI in outgoing SIP messages
* user-name: User name for file transfer to be validated
* voip-echo-cancel: The Boolean value enabled specifies that echo cancellation is on; disenabled specifies off
* voip-hook-flash-max: This attribute defines the maximum duration recognized by the ONU as a switchhook flash
* voip-hook-flash-min: This attribute defines the minimum duration recognized by the ONU as a switchhook flash

