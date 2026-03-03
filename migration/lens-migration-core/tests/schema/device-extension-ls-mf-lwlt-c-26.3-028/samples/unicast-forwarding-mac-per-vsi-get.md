This macro retrieves the MAC address learned on a VLAN sub-interface.

Prerequisite:

* No prerequisite.

Note: When this macro is executed with the name of the VLAN sub-interface along with/without the name of service to retrieve the MAC address learned on the VLAN sub-interface, it displays the forwarding database in which the MAC is learned, including the MAC address, the forwarder and the forwarder port to which the VLAN sub-interface is attached. In case the service is an ibridge, local cc, or remote cc, the service name is optional but recommended to be used for higher execution efficiency. If the service is a cc (with forwarding-database), the service name shall not be specified with this macro.

Input parameters:

* service-name: The name of the IBRIDGE (or) the IBRIDGE with user-to-user traffic enabled (or) the multiple uplink interfaces IBRIDGE (or) the multiple uplink interfaces IBRIDGE with user-to-user traffic enabled (or) the local cross-connect on the OLT (or) the remote cross-connect on the OLT
* vsi-name: The name of the VLAN sub-interface.

