This macro attaches the DHCPv6 Relay Agent profile with vlan range to an interface.

Prerequisite:

* Applicable only when DHCPv6 Relay Agent is enabled
* VLAN sub-interface ingress-rule must have match-criteria as match-all when dhcpv6 vlan-range-profile is configured


Input parameters:

* cc-name: The name of CC sample
* ibridge-user-port-name: Ibridge user port name
* vlanrange-profile-name: Vlan range profile name reference to protocol

