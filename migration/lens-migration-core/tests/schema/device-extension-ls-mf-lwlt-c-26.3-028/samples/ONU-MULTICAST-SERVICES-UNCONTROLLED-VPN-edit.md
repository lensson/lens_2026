Description:
This sample creates a multicast uncontrolled VPN. The VPN will snoop upstream IGMP or MLD messages and unconditionally send a copy of a MC stream to ethernet interface.

Prerequisite:
device has to be created.
ONU ANI has to be created.
ONU ENET interface has to be created.

Input parameters:

* ani-name: The name of an Access Node Interface.
* enet-name: The name of the ONU ENET interface that will be created
* mc-gemport-id: Multicast Gemport ID value, must be 2047 for GPON or 65534 for XGS PON and NGPON2
* onu-name: ONU name
* vpn-name: The name of a multicast uncontrolled vpn.

