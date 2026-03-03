Description:
This sample configures the voip-onu-v-enet, VSI and IP host interfaces.

Prerequisite:
ONU device has to be created.
v-ani interface has to be created.
Ingress Qos profile has to be created.
Tcont has to be created.

Input parameters:

* ani-name: ONU ANI Interface name
* dhcp-dscp: DSCP for dhcp packets
* gateway-address: IP address of the default router
* gemport-id: The GEM Port ID for the configured Traffic Class
* gemport-t-cont: The T-CONT for Gemport
* ip-address: IP address of the IP Host at the ONT.
* ip-origin: the methods to get IP, dhcp or static
* n-vlan-id: N-VLAN id
* netmask: IP address network mask of the IP Host at the ONT.
* onu-name: ONU name
* ping: Whether to enable ping. Valid values:[true, false]
* primary-dns: Address of the primary DNS server.
* secondary-dns: Address of the secondary DNS server.
* tc: The Traffic Class for Gemport
* traceroute: Whether to enable traceroute. Valid values:[true, false]
* us-pbit: The Pbit for Up Stream Traffic.
* voip-cc-name: VSI name

