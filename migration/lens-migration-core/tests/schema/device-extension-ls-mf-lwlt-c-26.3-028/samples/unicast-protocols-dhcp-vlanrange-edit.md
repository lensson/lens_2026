This macro attaches an DHCPv4 Relay Agent profile with vlan range profile to an VLAN sub-interface.

Prerequisite:

* Applicable only when L2 DHCPv4 Relay Agent functionality is enabled
* VLAN sub-interface ingress-rule must have match-criteria as match-all when dhcpv4 vlan-range-profile is configured

Input parameters:

* cc-name: The name of CC sample
* ibridge-user-port-name: Ibridge user port name
* vlanrange-profile-name: Vlan range profile name reference to protocol

