This macro removes the VLAN sub-interface.

Prerequisite: 

* VLAN sub-interface shall not be referenced from any other object, 
  e.g. from another interface, from a forwarder, ...

Input parameters:

* network-inner-vlan-id: Inner VLAN-id of the network interface. This argument will be ignored if network-outer-vlan-id is not provided.
* network_user-interface: Name of the network (or) user interface.
* network_user-is-match-all: Needs to be set to true when the VLAN sub-interface is configured to match all traffic. Example, the user VLAN sub-interface in a CC tunnel forwarder.
* network_user-outer-vlan-id: Outer VLAN-id of the network (or) user interface. If this argument is not provided, untagged will be the default.

