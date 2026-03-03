Description:
This sample modifies the Ethernet interfaces.

Prerequisite:
device has to be created.

Input parameters:

* ani-name: The name of the ONU ANI Interface
* disable-upon-ponlos: Indicates whether a UNI must be disabled or not when the ONU detects a DSLOS
* enet-name: ONU ENET interface name
* eth-port-hw-number: ONU ENET Number
* eth-port-hw-option: ONU Ethernet HW Option,Values Range:[rj45, rj45-10-100M, rj45-1G, rj45-10, rj45-2.5G, rj45-5G, rj45-25G, rj45-40G,veip],port type specification is required if ONU support multiple electrical UNI port type. Otherwise,if ONU only has one rj45 port type, port type specification is not required,this value just setting rj45. This parameter should be blank for pluggable-optical-electrical-SFP and special-integrated-ONUs.
* fec: Indicates whether FEC has to be enabled or not on the ONU ENET interface.  Currently only supported for 25G ONU ENET interface
* onu-name: ONU name
* pluggable-optical-electrical-SFP: This attribute is indicate that for UNI, if an pluggable optical/electrical SFP is used or not
* port-id: This attribute is defined on port. In OMCI, some ONUs have multiple UNI ports on top of one virtual Boards unknown to the ONU YANG HW model.This data node provides port identifer used by OMCI for this port in the ONU.This port number is ONU vendor specific.
* power-over-ethernet-control: This attribute is defined on port, it is used to config power-over-ethernet-control,only support for rj45*
* special-integrated-ONUs: This attribute is indicate that this kind ONU will report several different virtual boards for ethernet ports with same port type,Configure these special ONUs with virtual-borad-number and port-id, special onu list:[U-00160CP-P,G-00240G-M]
* virtual-board-number: This attribute is defined on port, it is used to configure virtual board number reported by ONU      (just as legacy parent-rel-pos on board).

