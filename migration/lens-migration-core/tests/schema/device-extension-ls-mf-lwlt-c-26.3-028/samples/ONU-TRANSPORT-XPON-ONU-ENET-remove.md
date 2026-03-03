Description:
This sample deletes the Ethernet interface and corresponding hardware component.

Prerequisite:
device has to be created.

Input parameters:

* enet-name: ONU ENET Port name
* eth-port-hw-number: 
* eth-port-hw-option: ONU Ethernet HW Option,Values Range:[rj45, rj45-10-100M, rj45-1G, rj45-10, rj45-2.5G, rj45-5G, rj45-25G, rj45-40G, veip, rf-video],port type specification is required if ONU support multiple electrical UNI port type. Otherwise,if ONU only has one rj45 port type, port type specification is not required,this value just setting rj45. This parameter should be blank for pluggable-optical-electrical-SFP and special-integrated-ONUs.
* onu-name: ONU name
* pluggable-optical-electrical-SFP: This attribute is indicate that for UNI, if an pluggable optical/electrical SFP is used or not
* special-integrated-ONUs: This attribute is indicate that this kind ONU will report several different virtual boards for ethernet ports with same port type,Configure these special ONUs with virtual-borad-number and port-id, special onu list:[U-00160CP-P,G-00240G-M]

