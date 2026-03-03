This macro enables/disables LEMI access for operator towards external server ( e.g. give access to vCLI )

* Precondition is the enablement of LEMI: cfr. LEMI-ACCESS-OPERATOR
* Operator should connect PC via ethernet cable to LEMI
* Operator should set default gateway of PC to IP 192.168.1.1 and destination IP equal to external management station IP
* Operator should enable LEMI access and ip forwarding on LEMI ( via this procedure )

After executing this procedure: the device will be acting as a router and will nat the PC source IP to the outgoing interface IP.

Input parameters:

* lemi-access-enabled: Enables (True) or disables (False) LEMI access

