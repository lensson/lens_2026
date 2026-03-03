This macro creates a vector of data profile for user side VSI.

Prerequisite:

* Service creation must be configured before vector of data profile created if dhcp,pppoe or dhcpv6 needed .

Input parameters:

* dhcpv4-allow-server-at-user-side: The configuration to allow exchanging DHCP messages with a DHCP server located at the user side instead of discarding them. This flag does not impact the processing of DHCP messages exchanged with a DHCP client at the user side.
* dhcpv4-profile-name: Name of the DHCPv4 profile
* dhcpv6-allow-server-at-user-side: The configuration to allow exchanging DHCP messages with a DHCP server located at the user side instead of discarding them. This flag does not impact the processing of DHCP messages exchanged with a DHCP client at the user side.
* dhcpv6-profile-name: Name of the DHCPv6 profile
* icmpv6-profile-name: Name of the icmpv6 profile
* interface-usage: the interface usage of userside vlan subinterface. Subtended-port support inherit
* ipv4-antispoofing: enable or disable IPv4 antispoofing
* ipv6-antispoofing: enable or disable IPv6 antispoofing
* l2cp-pass: The configuration to block or allow l2cp packets. It must be true for NNI VSI.
* learn-ip-from-dhcpv4: Control flag to learn IPv4 addresses from the DHCPv4 messages passing the VLAN sub-interface and assign them to the VLAN sub-interface. This setting requires that the ipv4-antispoofing  must be set to true
* learn-ip-from-dhcpv6: Control flag to learn IPv6 addresses from the DHCPv6 messages passing the VLAN sub-interface and assign them to the VLAN sub-interface. This setting requires that ipv6-antispoofing must be set to true
* max-anti-ip-address: The maximum number of IP addresses that is allowed on this VSI
* pppoe-allow-server-at-user-side: The configuration to allow exchanging PPPoE messages with a PPPoE server located at the user side instead of discarding them. This flag does not impact the processing of PPPoE messages exchanged with a PPPoE client at the user side.
* pppoe-profile-name: Name of the PPPOE profile
* vector-of-data-name: the name of this data vector profile

