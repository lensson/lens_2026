This macro attaches the DHCPv4 Relay Agent Profile to VLAN sub-interface

Prerequisite:

* DHCPv4 Relay Agent profile must be configured
* Service creation must be configured

Input parameters:

* cc-name: The name of CC sample
* dhcp-profile-name: Name of the DHCPv4 Relay Agent profile
* enable: Enables L2 DHCPv4 Relay Agent option 82 when configured as true
* ibridge-user-port-name: Ibridge user port name
* trusted-port: On a trusted port the option 82 from the user is accepted in upstream packets and it is not removed from downstream packets and vice versa for untrusted port

