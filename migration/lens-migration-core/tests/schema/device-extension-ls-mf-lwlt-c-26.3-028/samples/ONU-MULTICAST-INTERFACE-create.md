Description:
This sample creates a multicast gemport and onu-v-enet.

Prerequisite:
device has to be created.
ONU ANI has to be created.
Input parameters:

* ani-name: The name on an Access Node Interface.
* is-broadcast: A boolean value that is used to indicate if this multicast GEM port is an incidental GEM port. If true, this multicast GEM port is an incidental GEM port.
* mc-gemport-id: Multicast Gemport ID value, must be 2047 for GPON or 65534 for XGS PON and NGPON2. Incidental Gemport ID value, must be 2046 for GPON or 65533 for XGS PON and 25GS-PON. Incidental Gemport is for SSM only.
* mc-gemport-name: The name of multicast-gemport.
* onu-name: ONU name

