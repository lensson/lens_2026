This macro performs the DHCPv4 Client session simulation start action.

Prerequisite:

* The dhcpv4-client-simulator session interface needs to be configured.

Input parameters:

* client-mac: MAC address of the Client
* inner-vlan-pbit-value: The pbit-value to be inserted in the PBIT field of the inner VLAN tag of the outgoing DHCP packets
* interface: The user vlan-sub-interface on which the dhcp client simulation is to be performed
* mac-address: Configures the MAC address as the unique client identifier
* option-60: The Vendor class identifier (option 60) is used by DHCP clients to optionally identify the vendor type and configuration of a DHCP client
* outer-vlan-pbit-value: The pbit-value to be inserted in the PBIT field of the outer VLAN tag of the outgoing DHCP packets
* string: Configures a string as the unique client identifier
* time-out: The time interval within which the simulated DHCP Client test session is expected to be bound

