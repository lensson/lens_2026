Delete multicast network port.

* Delete multicast network port for multicast vpn.
* If mc-vlan is provided, the network interface associated will be deleted in this macro.

Prerequisites:

* The multicast vpn must exist.
* The multicast network port must exist.

Input parameters:

* mc-vlan: The VLAN-ID used to delete the associated network interface.
* vpn-name: The name of a multicast vpn.
* vpn-network-port-name: The name of a multicast network port.

