This macro configures the system level IPv4 antispoofing parameters.

Input parameters:

* on-admindown: If set to true, IPv4 addresses learnt via DHCPv4 on an interface will be cleared, whenever the interface state goes to admin-down.
* tca-in-ip-packet-discards: Specifies a threshold value of in-ip-packet-discards. When packets with illegal source IP and/or source MAC address exceed the threshold value within certain interval, a TCA alarm will be raised.

