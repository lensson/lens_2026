This macro retrieves the configuration data of the VLAN sub-interface.

Prerequisite:

No prerequisites.

Input parameters:

* detailed-output: Provides detailed information of all the VLAN sub-interfaces in the system when enabled and only the interface names when disabled if the above arguments are not given. Retrieves interface names having lower layer interface as the provided interface if VLAN details (VLAN-id, untagged status) are not given and detailed-output is disabled.
* network-inner-vlan-id: Inner VLAN-id of the network interface. This argument will be ignored if network-outer-vlan-id is not provided.
* network_user-interface: Name of the network (or) user interface.
* network_user-is-match-all: Needs to be set to true when the VLAN sub-interface is configured to match all traffic. Example, the user VLAN sub-interface in a CC tunnel forwarder.
* network_user-is-untagged: Indicates if the network (or) user interface is untagged.
* network_user-outer-vlan-id: Outer VLAN-id of the network (or) user interface.

