This macro retrieves the xpon interface state data that is used when exporting flow counters via IPFIX.

* This macro is applicable only for user VLAN sub-interface.
* If subscriber profile is not attached to the user VLAN sub-interface, the remote-id attribute will be empty.

Prerequisite:

* Service must be configured.

Input parameters:

* cc-name: The name of the local cross-connect on the OLT.
* ibridge-user-port-name: The name of the local VLAN port on the OLT. In case ibridge-user-port-name and cc-name are given, ibridge-user-port-name will take precedence.

