This macro configures option for DHCPv4 Packets received with option82 in L2 DHCPv4 Relay Agent profile

Note:
* Minimum one suboption should be configured in DHCPv4 Relay Agent profile before option82-handling-extn configuration.
* This is an optional configuration. When this option is not configured, DHCPv4 messages received with option-82 tag in upstream direction gets discarded

Input parameters:

* dhcp-profile-name: Name of the DHCPv4 Relay Agent profile
* option82-handling-extn: Config to handle option-82 tag in DHCPv4 messages

