This macro attaches the DHCPv6 Relay Agent profile to VLAN sub-interface.

Prerequisite:

* DHCPv6 Relay Agent profile should be configured
* Service must be configured

Input parameters:

* cc-name: The name of CC sample
* dhcpv6-profile-name: Name of the DHCPv6 Relay Agent profile
* enable: Enable DHCPv6 Relay Agent  when configured as true
* ibridge-user-port-name: Ibridge user port name
* trusted-port: It marks the client-facing interface as trusted for the DHCPv6 Relay Agent message and it is discarded for untrusted

