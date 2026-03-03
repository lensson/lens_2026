This macro configures IPv4 antispoofing parameters on the VLAN sub-interface.

Prerequisite:

* User VSI Service creation must be configured.

Input parameters:

* cc-name: The name of CC sample. In IBRIDGE senario, leave it empty
* enable-ipv4-security: If set to true, the system will perform source IPv4 address security checks on incoming packets on the VLAN sub-interface.
* ibridge-user-port-name: The name of IBRIDGE-USER-PORT sample. In CC senario, leave it empty
* ipv4-security-statistics: If set to true, IPv4 security check statistics on the VLAN sub-interface are collected.
* learn-addresses-from-dhcp: If set to true, the system will learn source IPv4 addresses from the DHCPv4 messages passing the VLAN sub-interface, and stores them in Antispoofing table of that VLAN sub-interface.
* max-address: Specifies the maximum number of IPv4 address (static and dynamic) allowed for VLAN sub-interfaces.

