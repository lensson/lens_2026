This macro fetches the session status for the PPPoE client simulator.

Prerequisite:

* The pppoe-client-simulator session interface needs to be configured.
* The pppoe-client-simulator start action command to be executed.

PPPoE simulation session show/netconf-get behavior :

To start/stop PPPoE simulation session, following sequence is followed :

* Configuration : Configure the VSI entry in PPPoE simulation session list entry.
* Yang action   : To start the PPPoE simulation session.
* Yang action   : To stop the PPPoE simulation session.

If the simulation VSI is configured in the PPPoE simulation session list and start action is not triggered, show/netconf-get displays the VSI entry without the session details.

This behaviour is same for LT NE restart scenario as well.

* PPPoE simulation session list entry is configured and start action is triggered.
* LT restart is performed.
* The PPPoE simulation session deleted automatically as the session is not persistent.
* Once LT NE comes back after restart, show/netconf-get displays the VSI entry without the session details.

To prevent the VSI entry getting displayed in the show/netconf-get output, VSI entry needs to be unconfigured from the PPPoE simulation session configuration list.

With the configuration entry in PPPoE simulation list, operator can perform start/stop action multiple times for the same VSI.
It is suggested that the operator needs to unconfigure the VSI entry from the PPPoE simulation session list to remove the simulation configuration completely for a VSI.

Input parameters:

* interface: The user vlan-sub-interface on which the PPPoE Client simulation is to be performed

