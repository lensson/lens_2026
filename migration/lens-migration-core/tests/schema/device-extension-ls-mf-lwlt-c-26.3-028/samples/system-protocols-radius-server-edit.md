This macro configures RADIUS authentication and accounting servers with IPv4 or IPv6 address, destination port and shared secret for exchanging the RADIUS message.

* RADIUS packets will be tagged with inband management VLAN.

* RADIUS server IP address configuration accepts either IPv4 or IPv6 address.

Note: RADIUS accounting is not supported for operator authentication. RADIUS servers with IPv6 address is not supported for 802.1X user authentication.

Input parameters:

* acc-server1-address: The address of the primary RADIUS accounting server.
* acc-server1-name: Name of the primary RADIUS accounting server.
* acc-server1-port: The port number of the primary RADIUS accounting server.
* acc-server1-shared-secret: The shared secret, which is known to both the RADIUS client and primary accounting server.
* acc-server2-address: The address of the secondary RADIUS accounting server.
* acc-server2-name: Name of the secondary RADIUS accounting server.
* acc-server2-port: The port number of the secondary RADIUS accounting server.
* acc-server2-shared-secret: The shared secret, which is known to both the RADIUS client and secondary accounting server.
* auth-server1-address: The address of the primary RADIUS authentication server.
* auth-server1-name: Name of the primary RADIUS authentication server.
* auth-server1-port: The port number of the primary RADIUS authentication server.
* auth-server1-shared-secret: The shared secret, which is known to both the RADIUS client and primary authentication server.
* auth-server2-address: The address of the secondary RADIUS authentication server.
* auth-server2-name: Name of the secondary RADIUS authentication server.
* auth-server2-port: The port number of the secondary RADIUS authentication server.
* auth-server2-shared-secret: The shared secret, which is known to both the RADIUS client and secondary authentication server.
* pinned-ca-certs1: A reference to a list of certificate authority (CA) certificates used by the TLS client to authenticate TLS server certificates. A server certificate is authenticated if it has a valid chain of trust to a configured pinned CA certificate for mab-based authentication.
* pinned-ca-certs2: A reference to a list of certificate authority (CA) certificates used by the TLS client to authenticate TLS server certificates. A server certificate is authenticated if it has a valid chain of trust to a configured pinned CA certificate for mab-based authentication.
* pinned-server-certs1: A reference to a list of server certificates used by the TLS client to authenticate TLS server certificates. A server certificate is authenticated if it is an exact match to a configured pinned server certificate for mab-based authentication.
* pinned-server-certs2: A reference to a list of server certificates used by the TLS client to authenticate TLS server certificates. A server certificate is authenticated if it is an exact match to a configured pinned server certificate for mab-based authentication.

