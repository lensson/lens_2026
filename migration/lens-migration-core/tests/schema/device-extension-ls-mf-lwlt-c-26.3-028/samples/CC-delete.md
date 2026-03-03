This macro deletes a 1:1-VLAN Forwarder between a user / subtended-node interface and the network interface.

* It deletes a VLAN sub-interface at the user / subtended-node interface to match classification for single tagged frames.
* It deletes a VLAN sub-interface at the network interface to match classification for double tagged frames with the specified VLAN-id.
* The macro also deletes a 1:1 VLAN Forwarder(crossconnect) between these two VLAN sub-interfaces.

Pre-condition: the referenced network interface and the referenced user / subtended-node interface must exist.

Input parameters:

* cc-name: The name of the local cross-connect on the OLT
* onu-name: ONU name
* onu-template-cc-name: ONU template CC interface name
* tc0-gemport-set-name: GEMPORT set name to indicate no-sharing, uni-sharing or onu-sharing for traffic class 0
* tc1-gemport-set-name: GEMPORT set name to indicate no-sharing, uni-sharing or onu-sharing for traffic class 1
* tc2-gemport-set-name: GEMPORT set name to indicate no-sharing, uni-sharing or onu-sharing for traffic class 2
* tc3-gemport-set-name: GEMPORT set name to indicate no-sharing, uni-sharing or onu-sharing for traffic class 3
* tc4-gemport-set-name: GEMPORT set name to indicate no-sharing, uni-sharing or onu-sharing for traffic class 4
* tc5-gemport-set-name: GEMPORT set name to indicate no-sharing, uni-sharing or onu-sharing for traffic class 5
* tc6-gemport-set-name: GEMPORT set name to indicate no-sharing, uni-sharing or onu-sharing for traffic class 6
* tc7-gemport-set-name: GEMPORT set name to indicate no-sharing, uni-sharing or onu-sharing for traffic class 7

