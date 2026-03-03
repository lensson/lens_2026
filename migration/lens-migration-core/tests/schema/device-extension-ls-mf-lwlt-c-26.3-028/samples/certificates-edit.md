This macro configures the client CA certificates for callhome.

Pre-condition:
The "certificate" configuration requires the configuration of "pinned-ca-list"
The "pinned-ca-list" should reference to already configured by "system-certificate" trust-anchors

Input parameters:

* ca-name: Name of pinned certificates list
* netconf-client-name: Name of NETCONF clients list

