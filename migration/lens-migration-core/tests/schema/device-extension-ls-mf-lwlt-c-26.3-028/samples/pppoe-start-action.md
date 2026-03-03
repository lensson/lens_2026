This macro performs the PPPoE Client session simulation start action.

Prerequisite:

* The pppoe-client-simulator session interface needs to be configured.

Note: Start action command can be executed in the below specific way only. Password leaf value is sensitive & hence, it has been masked to avoid security breach. All the optional leafs should be entered before the password leaf value as part of the start action command. When password leaf is entered before optional leafs, then optional leafs value cannot be entered. Username & Password are mandatory when authentication-protocol is configured.

Example:

pppoe-client-simulator session intf1 start-client-session client-mac 00:01:02:03:04:05 mru 1492 inner-vlan-pbit-value 3 outer-vlan-pbit-value 5 time-out 10 authentication-protocol pap user-name nokia password
Value for 'password' (<string, min: 1 chars, max: 64 chars>): *******

Note: in case the password leaf is entered before the optional leafs, then optional leafs values cannot be entered
In case optional leaf values are needed, but were not entered before the password leaf, then the following correction actions must be taken:

* In case the start action has not been executed yet, then reconfigure the simulated session using the correct order
* In case the start action has been executed, then the session has to be stopped using the stop action command. Next, the simulated session has to be reconfigured using the correct order

Input parameters:

* authentication-protocol: This leaf provides a method to negotiate the use of a specific protocol for authentication. If not configured, no authentication will be performed
* client-mac: MAC address of the Client
* inner-vlan-pbit-value: The pbit-value to be inserted in the PBIT field of the inner VLAN tag of the outgoing PPPoE packets
* interface: The user vlan-sub-interface on which the PPPoE Client simulation is to be performed
* mru: The Maximum Receive Unit(mru) Option is sent to inform peer about the maximum packet the client could receive
* outer-vlan-pbit-value: The pbit-value to be inserted in the PBIT field of the outer VLAN tag of the outgoing PPPoE packets
* password: Password to be used in authentication process with PPP server
* time-out: The time interval within which the simulated PPPoE Client test session is expected to be bound
* user-name: Username to be used in authentication process with PPP server

