This macro fetches the session status for the DHCPv4 client simulator.

Prerequisite:

* The dhcpv4-client-simulator session interface needs to be configured.
* The dhcpv4-client-simulator start action command to be executed.

DHCPv4 simulation session show/netconf-get behavior :

To start/stop DHCPv4 simulation session, following sequence is followed :

* Configuration : Configure the VSI entry in DHCPv4 simulation session list entry.
* Yang action   : To start the DHCPv4 simulation session.
* Yang action   : To stop the DHCPv4 simulation session.

If the simulation VSI is configured in the DHCPv4 simulation session list and start action is not triggered, show/netconf-get displays the VSI entry without the session details.

This behaviour is same for LT NE restart scenario as well.

* DHCPv4 simulation session list entry is configured and start action is triggered.
* LT restart is performed.
* The DHCPv4 simulation session deleted automatically as the session is not persistent.
* Once LT NE comes back after restart, show/netconf-get displays the VSI entry without the session details.

To prevent the VSI entry getting displayed in the show/netconf-get output, VSI entry needs to be unconfigured from the DHCPv4 simulation session configuration list.

With the configuration entry in DHCPv4 simulation list, operator can perform start/stop action multiple times for the same VSI.
It is suggested that the operator needs to unconfigure the VSI entry from the DHCPv4 simulation session list to remove the simulation configuration completely for a VSI.

Input parameters:

* interface: The user vlan-sub-interface on which the dhcp client simulation is to be performed

