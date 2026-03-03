Create multicast host port for multicast vpn.

* If ibridge-user-port-name is provided, the user-side interface named as it will be used.
* If ibridge-user-port-name is not provided, cc-name will be used for the user-side interface.

Prerequisites:

* The user-side interface must be created.
* The multicast vpn must be created.
* The multicast package must be created.

Input parameters:

* cc-name: Specifies the VLAN sub-interface on a host interface.
* ibridge-user-port-name: Specifies the VLAN sub-interface on a host interface.
* max-group-number: This attribute specifies the maximum number of dynamic multicast groups that may be replicated to the interface at any one time.
* multicast-package-name: The name of a multicast package.
* unmatched-join-processing-user-port-name: Specifies the VLAN sub-interface to be used when the multicast function needs knowledge on a related datapath.
* vpn-host-port-name: The name of a multicast host port.
* vpn-name: The name of a multicast vpn.

