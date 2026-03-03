This macro configures static IPv4 address, route and vlan for the secondary inband management interface.

Pre-condition:

The following default configuration must be available before IPv4 address, route and vlan can be configured.

*	Equipment configuration
*	Ethernet configuration for uplink.
*	Network VLAN sub interface sinband2 configured at network side on Uplink
*	L2-Termination interface inband2-l2term configured at user side
*	IP interface inband2 defined with lower interface the l2-termination-interface inband2-l2term.
*	inband2-forwarder Forwarder configuration with the Network VLAN sub interface sinband2 and L2-Termination interface inband2-l2term associated to it.
*	IP address and route of the primary inband should also be statically configured


Input parameters:

* control-plane-protocol-name: The name of the control-plane protocol instance
* interface-name: Name of secondary inband interface
* ipv4-address: Secondary inband interface IPv4 address
* l2-term-interface: Name of l2 termination interface
* netmask: Subnet mask
* route-dest-prefix: IPv4 destination prefix
* route-next-hop: Route next-hop
* vlan-id: Vlan value
* vlan-sub-interface: Name of vlan sub-interface

