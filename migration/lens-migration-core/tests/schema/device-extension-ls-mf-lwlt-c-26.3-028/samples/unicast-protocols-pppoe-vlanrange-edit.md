This macro attaches the PPPoE Intermediate Agent profile with vlan range to an VLAN sub-interface.

Prerequisite:

* Applicable only when PPPoE Intermediate Agent is enabled.

* VLAN sub-interface ingress-rule must have match-criteria as match-all when PPPoE Intermediate Agent vlan-range-profile is configured.

Input parameters:

* cc-name: The name of CC sample
* ibridge-user-port-name: Ibridge user port name
* vlanrange-profile-name: Vlan range profile name reference to protocol

