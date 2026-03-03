Description: 
This macro remove gemport set template.
It is a set of gemports, 1 for each traffic class. Multiple gemport sets can be defined per cross-connect configured within a ONU template. When the LT-side cross-connect or bridge user port is configured the gemport can be selected from one of the configured gemport sets.

Prerequisite:
VSI has been created.


Input parameters:

* cc-name: The name of the VLAN sub-interface that will be created
* enet-name: The name of the Ethernet UNI on which to designate whether sharing gemport on the uni
* gemport-set-name: GEMPORT set name to indicate T-CONT no-sharing, uni-sharing or onu-sharing
* onu-name: ONU name

