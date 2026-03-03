This macro configures static IPv4 address, route for the inter-shelf management interface.

Pre-condition:

The following default configuration must be available before IPv4 address, route can be configured.

*	Equipment configuration
*	Ethernet configuration for uplink.
*	Network VLAN sub interface sinband2 configured at network side on Uplink
*	L2-Termination interface inter-shelf-l2term configured at user side
*	IP interface inter-shelf defined with lower interface the l2-termination-interface inter-shelf-l2term.
*	inter-shelf-forwarder Forwarder configuration with the Network VLAN sub interface sub-inter-shelf and L2-Termination interface inter-shelf-l2term associated to it.


Input parameters:

* control-plane-protocol-name: The name of the control-plane protocol instance
* interface-name: Name of inter-shelf interface
* ipv4-address: Inter-shelf interface IPv4 address
* netmask: Subnet mask
* route-dest-prefix: IPv4 destination prefix
* route-next-hop: Route next-hop

