Description:
This sample configures the dscp to marked pbit parameters.

Prerequisite:
device has to be created.
Ethernet port has to be created

Input parameters:

* dscp-2-mpbit-policy: Policy name
* dscp0-mpbit: Value for marked pbit to traffic class 0, value could be number list (0-10) or (0,3,10), any, untag to indicate write pbit for untagged package
* dscp1-mpbit: Value for marked pbit to traffic class 1, value could be number list (0-10) or (0,3,10), any, untag to indicate write pbit for untagged package
* dscp2-mpbit: Value for marked pbit to traffic class 2, value could be number list (0-10) or (0,3,10), any, untag to indicate write pbit for untagged package
* dscp3-mpbit: Value for marked pbit to traffic class 3, value could be number list (0-10) or (0,3,10), any, untag to indicate write pbit for untagged package
* dscp4-mpbit: Value for marked pbit to traffic class 4 (if specified)
* dscp5-mpbit: Value for marked pbit to traffic class 5 (if specified)
* dscp6-mpbit: Value for marked pbit to traffic class 6 (if specified)
* dscp7-mpbit: Value for marked pbit to traffic class 7 (if specified)
* onu-name: ONU name

