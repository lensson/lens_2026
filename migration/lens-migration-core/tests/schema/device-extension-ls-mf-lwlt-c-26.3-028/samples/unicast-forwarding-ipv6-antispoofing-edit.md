This macro configures IPv6 antispoofing parameters on the VLAN sub-interface.

Prerequisite:

* User VSI Service creation must be configured.

Input parameters:

* cc-name: The name of CC sample. In IBRIDGE senario, leave it empty
* enable-ipv6-security: If set to true, the system will perform source IPv6 address security checks on incoming packets on the VLAN sub-interface.
* ibridge-user-port-name: The name of IBRIDGE-USER-PORT sample. In CC senario, leave it empty
* ipv6-security-statistics: If set to true, IPv6 security check statistics on the VLAN sub-interface are collected.
* learn-addresses-from-dhcpv6: If set to true, the system will learn source IPv6 addresses from the DHCPv6 messages passing the VLAN sub-interface, and stores them in Antispoofing table of that VLAN sub-interface.
* max-address: Specifies the maximum number of IPv6 address (static and dynamic) allowed for VLAN sub-interfaces.

