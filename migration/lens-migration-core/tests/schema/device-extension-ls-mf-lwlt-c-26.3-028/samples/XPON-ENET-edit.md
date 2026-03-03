This macro edits an ONU Ethernet (ENET) port.
Input parameters:

* description: Description of the interface.
* downstream-aes: Used to designate whether AES should be enabled/disabled for GEM ports for the downstream direction
* enet-name: The name of the virtual ENET that will be created
* eth-port-hw-option: ONU Ethernet HW Option, Values Range:[1 ,10, 25, veip]
* fec-flag: ONU Ethernet FEC Option, Values Range:[enable ,disable, per-802.3]
* gemport-sharing: Used to indicate whether gemport sharing is enabled. Setting this variable to false means that gemports are associated with VLAN sub-interface; setting this variable to true means that gemports are not associated with VLAN sub-interface and they are shared between the VLAN sub-interfaces on top of the lower layer interface. Not setting this variable defaults the value to be false(gemport sharing is disabled)
* interface-usage: The ethernet port type, default is uni, can also set as subtended-node-port.
* leaf-scheduler-name: The leaf scheduler name to which the traffic is sent in downstream
* max-number-mac-addresses-interface: Configures max-number-mac on interface
* olt-infrastructure-name: The OLT infrastructure name used as root for traffic scheduling
* onu-template-enet-name: ENET interface name
* onu-uniloopdetect-auto-shut-off: Uni Loop detect auto shut off for an ONU template.
* onu-uniloopdetect-enable-flag: Uni Loop detect enable or disable for an ONU template.
* packet-rate-policy-profile-name: The name of referenced policy, which actions in the referenced classifiers all are rate-limit-frames.
* port-id: Used to identify the ONU Ethernet UNI port under a given ONU (virtual) slot; this value can be inserted in various protocol messages
* slot-id: Used to identify the ONU (virtual) slot; this value can be inserted in various protocol messages
* tc0-gemport-id: The GEM Port ID used for the configured Traffic Class
* tc0-gemport-set-name: GEMPORT set name to indicate no-sharing, uni-sharing or onu-sharing for traffic class 0
* tc1-gemport-id: The GEM Port ID used for the configured Traffic Class
* tc1-gemport-set-name: GEMPORT set name to indicate no-sharing, uni-sharing or onu-sharing for traffic class 1
* tc2-gemport-id: The GEM Port ID used for the configured Traffic Class
* tc2-gemport-set-name: GEMPORT set name to indicate no-sharing, uni-sharing or onu-sharing for traffic class 2
* tc3-gemport-id: The GEM Port ID used for the configured Traffic Class
* tc3-gemport-set-name: GEMPORT set name to indicate no-sharing, uni-sharing or onu-sharing for traffic class 3
* tc4-gemport-id: The GEM Port ID used for the configured Traffic Class
* tc4-gemport-set-name: GEMPORT set name to indicate no-sharing, uni-sharing or onu-sharing for traffic class 4
* tc5-gemport-id: The GEM Port ID used for the configured Traffic Class
* tc5-gemport-set-name: GEMPORT set name to indicate no-sharing, uni-sharing or onu-sharing for traffic class 5
* tc6-gemport-id: The GEM Port ID used for the configured Traffic Class
* tc6-gemport-set-name: GEMPORT set name to indicate no-sharing, uni-sharing or onu-sharing for traffic class 6
* tc7-gemport-id: The GEM Port ID used for the configured Traffic Class
* tc7-gemport-set-name: GEMPORT set name to indicate no-sharing, uni-sharing or onu-sharing for traffic class 7
* upstream-aes: Used to designate whether AES should be enabled/disabled for GEM ports for the upstream direction
* v-ani-name: The name of the ONU V-ANI Interface on which the virtual ENET is created
* v-ethernet-id: The v-ethernet-id is used to generate v-mac for the v-enet interface.

