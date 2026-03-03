This macro configures RADIUS connection parameters.

Prerequisite:

* RADIUS servers must be configured.

Input parameters:

* acc-server1-name: The primary RADIUS accounting server.
* acc-server2-name: The secondary RADIUS accounting server.
* accept-or-reject-all: Controls whether to accept or reject user sessions in case the authentication server is not reachable during 802.1X user session establishment.
* accounting-interim-interval: The amount of time (in seconds) between sending interim messages to the accounting server.
* accounting-on-reboot: Controls whether or not the Radius client sends accounting-on related messages to the accounting server associated with 802.1x sessions in case of system restart/reboot event.
* attempts: The number of times the resolver will send a query to all of its name servers before giving up and returning an error to the calling application.
* auth-server1-name: The primary RADIUS authentication server.
* auth-server2-name: The secondary RADIUS authentication server.
* calling-station-id-format: Format of the Calling-Station-Id parameter in RADIUS packets.
* disable-accounting: Indicates to disable accounting when the value is true.
* domain-name: Name of the domain.
* nas-id: NAS-Identifier used in messages towards RADIUS servers.
* nas-ip-address: NAS-IP-Address used in messages towards RADIUS servers. If this parameter is not configured, then the Lightspan Access Node system IP address is filled as nas-ip-address in the RADIUS messages.
* nas-port-id-syntax: Keywords such as Chassis, Slot, Port, Onuslot, Onuport, ShSlt, ShPrt, LzPrt with delimiters are allowed. "eth Chassis:Slot:Port:Onuslot:Onuport:ShSlt:ShPrt:LzPrt" or "efm Chassis/Slot/Port/Onuslot/Onuport/ShSlt/ShPrt/LzPrt" shall be replaced in RADIUS message as 'eth 1:1:8:1:1:1:8:008' or 'efm 1/1/10/1/1/1/10/010' respectively.
* policy-name: Name of the RADIUS policy.
* timeout: The amount of time (in seconds) the resolver will wait for a response from each remote name server before retrying the query via a different name server.

