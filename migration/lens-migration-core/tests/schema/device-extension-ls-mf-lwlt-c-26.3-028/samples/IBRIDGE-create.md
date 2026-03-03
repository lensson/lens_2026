This macro configures an N:1-VLAN Forwarder and attaches it to the network interface.

* a network VLAN sub-interface is created.
* an N:1 VLAN Forwarder is created and the VLAN sub-interface is attached to this Forwarder.
* a forwarding database is created.
* a network vLAN frame processing profile is created.
* a user VLAN frame processing profile is created.

Pre-condition:

* the referenced network interface must exist.
* the forwarding profiles referenced by the N:1-VLAN Forwarder must exist
(by default the split-horizon-profile named "no-user-to-user-communication",
the flooding-policies-profile named "drop_all")

Note for arp-security:

* Only apply-layer2-forwarding and secured-with-fallback-to-layer2 can be configured.
* When apply-layer2-forwarding is configured, arp relay is disabled. Downstream ARP broadcast packets are forwarded according to forwarding rules configured for the forwarder. For subtended-node-ports (in case it is supported), flooding of ARP broadcast packets should always be allowed.
* When secured-with-fallback-to-layer2, arp relay is enabled. System forwards the ARP message to the VSI whose IP address(es) and/or subnet(s) match. In case no VSI can be found, following forwarding rules shall be applied:
    1. For user ports connected to local subscribers: drop the packet.
    2. For subtended-node-ports (in case it is supported): flooding the packet to subtended nodes (whether to drop it will be left to the subtended node to decide).

Input parameters:

* aging-timer-fwd-database: Configures aging-timer on forwarder_database
* arp-security: Configures ARP security. If set to apply-layer2-forwarding, downstream ARP broadcast packets are forwarded according to forwarding rules configured for the forwarder. If set to secured-with-fallback-to-layer2, downstream ARP broadcast packet is forwarded to one of the ports of the forwarder based on the target protocol address available in the payload of the ARP packet. If no such port can be identified then the packet is forwarded according to forwarding rules configured for the forwarder.
* flooding-profile-name: 
* i-vlan-id: Inner VLAN ID at network side, it's optional
* ibridge-name: the name of the IBRIDGE
* interface-usage: the interface-usage of network VSI
* mac-conflict: enable or disabel mac conflict
* max-number-mac-addresses-fwd-database: Configures max-number-mac on forearder_database
* network-port-name: the name of network VSI lower layer
* network-vsi-egress-qos-policy-profile: Qos policy profile for downstream traffic at egress network side.
* network-vsi-ingress-qos-policy-profile: The qos policy profile for upstream traffic at ingress network side.
* o-vlan-id: Outer VLAN ID at network side
* split-horizon-profile-name: the name of user defined split horizon profile

