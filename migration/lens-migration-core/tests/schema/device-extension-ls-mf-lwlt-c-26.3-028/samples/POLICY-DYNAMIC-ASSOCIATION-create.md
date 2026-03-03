This macro enables a VLAN sub-interface for dynamic qos policy association through 802.1x COA.

Pre-condition:

* VLAN sub-interface should exist with interface-usage as user-port.
* VLAN sub-interface should be enabled for dynamic forwarder association through 802.1x COA.
* VLAN sub-interface should not be statically associated with ingress-qos-policy-profile.
* VLAN sub-interface should not be statically associated with egress-qos-policy-profile.

Input parameters:

* policy-association-control: The identity reference to the association-control in qos-policy-dynamic-association container.
* vsi-interface-name: The name of the VLAN sub-interface to configure qos-policy-dynamic-association.

