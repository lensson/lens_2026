This macro configures static inband management IPv4 address, route and vlan.

Pre-condition:

The following default configuration must be available before inband IPv4 address, route and vlan can be configured.

*	Equipment configuration
*	Ethernet configuration for uplink.
*	Network VLAN sub interface sinband configured at network side on Uplink
*	L2-Termination interface inband-l2term configured at user side
*	IP interface inband defined as lower interface for l2-termination-interface inbandl2term.
*	inband-forwarder Forwarder configuration with the Network VLAN sub interface sinband and L2-Termination interface inband-l2term associated to it.

Procedure:

Configure inband management includes three steps as following.

*	Configure IP interface. In order to configure an IP interface, the type of the interface must be ipForward, and it must specify lower layer as user side l2-terminationinteface. The IP address of the IP interface is optional, it can be configured statically, or retrieved dynamically through DHCP client.
*	Configure Route. Route should be configured if destination host IP is not in the same network segment with the IP interface IP address. Destination-prefix and next-hop must be configured in the route.

On system start up, a default IP interface is created over the l2-termination-interface with default VLAN id 4093. This is used to make sure that the system can automatically learn a dynamic IP address through DHCP client for inband management after system startup, especially very important for PMA Discovery Call Home scenario.
To configure Static IP based Inband management, two related configurations are needed

* the IP interface
* the route

The IP interface can be configured statically, by modifying the inband interface which specifies the lower layer as user side l2-termination-interface. The IP address of the IP interface is optional in case of dynamic learnt.

Note: l2-termination-interface type is used for inband management. At System initialization, IP interface inband will be created on top of an l2termination-interface inband-l2term. l2-termination-interface inband-l2term will be associated to a network sub-interface sinband via Forwarder inbandforwarder.
Default entities inband interface and inband-forwarder forwarder cannot be deleted.

Input parameters:

* control-plane-protocol-name: The name of the control-plane protocol instance
* interface-name: Name of inband interface
* ipv4-address: Inband interface IPv4 address
* l2-term-interface: Name of l2 termination interface
* netmask: Subnet mask
* route-dest-prefix: IPv4 destination prefix
* route-next-hop: Route next-hop
* vlan-id: Vlan value
* vlan-sub-interface: Name of vlan sub-interface

