This macro will enable/disable remove macs at remote uni down of the given OLT-V-ENET interface.

Prerequisite:

* VENET-INTERFACE-NAME
* Mac-learning should be enabled on this interface.
* Uni-name should be configured on this interface.

Note:

* Enabling this parameter removes the dynamically learnt mac entries of the given OLT-V-ENET interface, if remote uni is down.

Input parameters:

* remove-mac-addresses-from-uni: Not setting the variable defaults the value to be 'false'. Setting this parameter to 'true' would trigger the flush FDB for the dynamically learnt MACs on this VENET port, if the remote UNI goes down.
* venet-interface-name: Name of the user interface.

