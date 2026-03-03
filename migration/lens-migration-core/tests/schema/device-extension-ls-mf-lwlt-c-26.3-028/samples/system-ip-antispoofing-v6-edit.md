This macro configures the system level IPv6 antispoofing parameters.

Input parameters:

* on-admindown: If set to true, IPv6 addresses learnt via DHCPv6 on an interface will be cleared, whenever the interface state goes to admin-down.
* prefix-mode: Identifies the mode in which IPv6 addresses should be configured in the system.
* tca-in-ipv6-packet-discards: Specifies a threshold value of in-ipv6-packet-discards. When packets with illegal source IP and/or source MAC address exceed the threshold value within certain interval, a TCA alarm will be raised.

