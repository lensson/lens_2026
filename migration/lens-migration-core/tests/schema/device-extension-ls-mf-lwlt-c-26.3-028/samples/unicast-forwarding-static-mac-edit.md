This macro configures a static MAC-address on interface.

Prerequisites:

* The forwarding database should exist.
* The forwarder should exist.
* The forwarder port (network or user) should exist.

Input parameters:

* network-port-name: The name of the network VSI lower layer
* service-name: The name of the IBRIDGE (or) the IBRIDGE with user-to-user traffic enabled (or) the multiple uplink interfaces IBRIDGE (or) the multiple uplink interfaces IBRIDGE with user-to-user traffic enabled (or) the local cross-connect on the OLT (or) the remote cross-connect on the OLT
* static-mac-address: The mac address to be added to the interface
* user-port-name: The name of the local VLAN port on the OLT

