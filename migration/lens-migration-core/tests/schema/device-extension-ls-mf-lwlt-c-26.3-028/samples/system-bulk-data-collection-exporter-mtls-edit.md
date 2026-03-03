This macro creates an IPFIX exporter and configures its IPFIX mTLS collector attributes. IPFIX exporter establishes an mTLS session with IPFIX collector using the configured collector attributes.

The end-entity certificate for ipfix exporter (client) that is going to be used during the handshake phase is configured with this macro.
In case of manual installed end-entity certificate, the macro will add the certificate to the client certificate local-definition. In case of dynamic certificate enrollment via an external PKI server using EST as protocol a reference is used instead.

Through this macro the following attributes are configured:

* Creates or updates the local-definition for the client certificate or the reference to the est-profile-name used for the Mutual TLS with the IPFIX Collector
* References to an already configured pinned-certificate or est-profile-name for server authentication
* Adds both a set of TLS versions and a set of TLS ciphers to the respective lists of acceptable TLS hello parameters. The default TLS versions and ciphers, as well as their preference order, can be found in appendix section _Supported TLS versions and ciphers_.

Further to what applies for a TLS session configuration, please note the following:

* When enabling mTLS functionality to achieve connectivity on the destination endpoint, a CA certificate list must have been created along with the client certificate and the private key of that endpoint, or PKI EST profile(s) have been configured
* There is no need to configure username and password in mTLS, given that in the mTLS case the Collector is authenticating the client via its certificates. However, if those are configured in Altiplano/collector, we should expect that Altiplano demands those to be received in option template. But in case there is no username and password configured in Altiplano, then we should expect that mTLS and exporting will work without username and password.

Pre-condition:

* PKI EST profile has been configured for the CA certificate, or
* The local pinned certificate (CA name) should be already configured using system-certificate-pinned-ca-edit. Also, the private key should be installed using system-bulk-data-collection-exporter-tls-installprivatekey.

Notes:

* Although all parameters are marked as optional, the connection with the IPFIX Collector must be a mutual-TLS connection. Hence it is required to have an input for the client end-entity certificate (local-definition or est-profile) and the certificate for server authentication (pinned-ca-list or est-profile). But for both client end-entity and server authentication, two independent options are possible.
Input parameters:

* ca-name: The local pinned certificate name to be used for connection to IPFIX collector
* cipher-suite: A cipher suite to add to the list of acceptable cipher suites of hello parameters
* client-auth-est-profile-name: The PKI EST profile name to be used for Mutual TLS with the IPFIX collector
* client-certificate: The local end-entity certificate to be used for Mutual TLS with the IPFIX collector that will be added to the local-definition
* collector-name: collector name
* dest-fqdn: destination FQDN
* dest-ip-address: destination ip address
* dest-port: destination port
* exporter-name: exporter name
* ipfix-exporting-enable: export enable flag
* password: password
* priority: priority
* retransmission-timeout: retransmission timeout
* server-auth-est-profile-name: The PKI EST profile name to be used to authenticate the IPFIX collector
* tls-version: A TLS version to add to the list of acceptable TLS versions of hello parameters
* username: username

