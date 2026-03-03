Description:
This sample configures the Ethernet interfaces.

Prerequisite:
device has to be created.

Input parameters:

* ani-name: The name of the ONU ANI Interface
* disable-upon-ponlos: Indicates whether a UNI must be disabled or not when the ONU detects a DSLOS
* downstream-aes: Used to designate whether AES should be enabled/disabled for GEM ports for the downstream direction.
* enet-name: The name of the ONU ENET interface that will be created
* eth-port-hw-number: ONU ENET Number
* eth-port-hw-option: ONU Ethernet HW Option,Values Range:[rj45, rj45-10-100M, rj45-1G, rj45-10, rj45-2.5G, rj45-5G, rj45-25G, rj45-40G, veip, rf-video, moca],port type specification is required if ONU support multiple electrical UNI port type. Otherwise,if ONU only has one rj45 port type, port type specification is not required,this value just setting rj45. This parameter should be blank for pluggable-optical-electrical-SFP and special-integrated-ONUs.
* fec: Indicates whether FEC has to be enabled or not on the ONU ENET interface.  Currently only supported for 25G ONU ENET interface
* gemport-sharing: Used to designate whether sharing gemport on uni
* moca-mode: configure ONU support MoCA1.1 or MoCA2.5
* moca-password: MoCA Encryption Key
* onu-name: ONU name
* pluggable-optical-electrical-SFP: This attribute is indicate that for UNI, if an pluggable optical/electrical SFP is used or not
* port-id: This attribute is defined on port. In OMCI, some ONUs have multiple UNI ports on top of one virtual Boards unknown to the ONU YANG HW model.This data node provides port identifer used by OMCI for this port in the ONU.This port number is ONU vendor specific.
* power-over-ethernet-control: This attribute is defined on port, it is used to config power-over-ethernet-control,only support for rj45*
* special-integrated-ONUs: This attribute is indicate that this kind ONU will report several different virtual boards for ethernet ports with same port type,Configure these special ONUs with virtual-borad-number and port-id, special onu list:[U-00160CP-P,G-00240G-M]
* tc0-gemport-id: GEM Port ID used for the configured Traffic Class 0. The value must be left empty when using the macro for configuring a ONU template
* tc0-tcont-name: T-CONT name of gemport for the configured Traffic Class 0
* tc1-gemport-id: GEM Port ID used for the configured Traffic Class 1. The value must be left empty when using the macro for configuring a ONU template
* tc1-tcont-name: T-CONT name of gemport for the configured Traffic Class 1
* tc2-gemport-id: GEM Port ID used for the configured Traffic Class 2. The value must be left empty when using the macro for configuring a ONU template
* tc2-tcont-name: T-CONT name of gemport for the configured Traffic Class 2
* tc3-gemport-id: GEM Port ID used for the configured Traffic Class 3. The value must be left empty when using the macro for configuring a ONU template
* tc3-tcont-name: T-CONT name of gemport for the configured Traffic Class 3
* tc4-gemport-id: GEM Port ID used for the configured Traffic Class 4. The value must be left empty when using the macro for configuring a ONU template
* tc4-tcont-name: T-CONT name of gemport for the configured Traffic Class 4
* tc5-gemport-id: GEM Port ID used for the configured Traffic Class 5. The value must be left empty when using the macro for configuring a ONU template
* tc5-tcont-name: T-CONT name of gemport for the configured Traffic Class 5
* tc6-gemport-id: GEM Port ID used for the configured Traffic Class 6. The value must be left empty when using the macro for configuring a ONU template
* tc6-tcont-name: T-CONT name of gemport for the configured Traffic Class 6
* tc7-gemport-id: GEM Port ID used for the configured Traffic Class 7. The value must be left empty when using the macro for configuring a ONU template
* tc7-tcont-name: T-CONT name of gemport for the configured Traffic Class 7
* upstream-aes: Used to designate whether AES should be enabled/disabled for GEM ports for the upstream direction
* virtual-board-number: This attribute is defined on port, it is used to configure virtual board number reported by ONU      (just as legacy parent-rel-pos on board).

