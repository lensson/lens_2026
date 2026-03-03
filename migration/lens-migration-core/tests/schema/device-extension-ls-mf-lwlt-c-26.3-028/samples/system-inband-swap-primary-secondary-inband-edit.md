This macro swaps the inband tag and the control protocol name between the primary and secondary inband (i.e., old primary becomes secondary and old secondary becomes primary).

Pre-condition:

*	There should be statically configured IP addresses and routes for both primary and secondary inband.


Input parameters:

* new-default-control-plane-protocol-name: The name of the control-plane protocol of the existing non-default route, i.e., new default route
* new-primary-inband-interface-name: Name of existing secondary inband interface, i.e., new primary inband interface
* old-default-control-plane-protocol-name: The name of the control-plane protocol of the existing default route
* old-primary-inband-interface-name: Name of existing primary inband interface
* tag-value: Tagging of secondary inband interface

