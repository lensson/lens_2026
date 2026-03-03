This macro configures the allow-server-at-user-side flag to allow exchanging DHCP messages with a DHCP server located at the user side and to allow exchanging DHCP messages with a DHCP client located at the network side instead of discarding them. This flag does not impact the processing of DHCP messages exchanged with a DHCP client/server at the user/network side.


The default value of this parameter is false.

Prerequisite:

* Applicable only when DHCPv4/DHCPv6 Relay Agent functionality is enabled

Input parameters:

* allow-server-at-user-side: Enable/Disable the option to forward server DHCPv4/DHCPv6 messages from user interface and client DHCPv4/DHCPv6 messages from network side
* cc-name: The name of CC sample
* ibridge-user-port-name: Ibridge user port name

