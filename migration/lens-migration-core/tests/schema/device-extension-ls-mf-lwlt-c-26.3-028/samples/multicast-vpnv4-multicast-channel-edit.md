
* This macro creates/modifies a IPv4 multicast channel for a created package.

Prerequisites:

* The multicast VPN must exist.
* The multicast package name must exist.
* The multicast network interface must exist.

Input parameters:

* channel-rate: The bandwidth of the multicast channel to be used at CAC in kilobits per second.
* group-ipv4-address: The group IP address of the multicast channel.
* group-ipv4-address-end: A group-address-end is valid and then the configuration is for all the group addresses starting from group-address up to and including the group-address-end.
* multicast-channel-name: The name of a multicast channel.
* multicast-package-name: The name of a multicast package.
* source-ipv4-address: The source IP address of the multicast channel.
* vpn-name: The name of a IPv4 multicast vpn.
* vpn-network-interface-name: The name of a multicast network interface.

