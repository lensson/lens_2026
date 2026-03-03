Create multicast network port for multicast vpn.

* If mc-vlan is provided, a network interface will be create in this macro.
* If mc-vlan is not provided, the network interface associated with ibridge-name will be used.

Prerequisites:

* The ibridge must be created if mc-vlan is empty.
* The multicast vpn must be created.

Input parameters:

* ibridge-name: The name of ibridge to be used.
* mc-vlan: The VLAN-ID used to create a network interface.
* network-policy-profile-name: The policy profile used for network side.
* network-port-name: The name of network VSI lower layer.
* network-port-proxy-ipv4-address: The IP address to be used as source IP address.
* vpn-name: The name of a multicast vpn.
* vpn-network-port-name: The name of a multicast network port.

