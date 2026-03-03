
* This macro creates/modifies IPv4 multicast VPN.

Prerequisites:

* The multicast vpn profile must exist.
* The network interface for unmatched reports is required only when unmatched membership report processing is configured as snoop-or-proxy.

Input parameters:

* channel-rate-for-unmatched-multicast-channel: The bandwidth of the unconfigured multicast channel to be used at CAC in kilobits per sec.
* network-interface-for-unmatched-reports: Identifies the multicast network interface for multicast group addresses for which there is no specific configuration.  It is the interface that is used to send MGMD reports, and inherent it is also the interface from which the system will receive the related multicast packets.
* unmatched-membership-report-processing: Specifies the IPv4 multicast vpn behaviour when the system receives a membership report message for a multicast channel for which there is no explicit configuration in the multicast-channel list.
* user-side-proxy-ipv4-address: Specifies the IP address to be used as source IP address in membership query messages.
* vpn-name: The name of a multicast vpn.
* vpn-profile-name: The name of a multicast proxy profile.

