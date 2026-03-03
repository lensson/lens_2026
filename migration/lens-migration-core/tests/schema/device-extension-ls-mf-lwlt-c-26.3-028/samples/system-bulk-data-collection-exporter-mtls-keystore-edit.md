This macro configures a remote IPFIX collector over TLS with mutual authentication.
The private key as well as the end entity certificate that is going to be used during
the handshake phase are determined via reference to an asymmetric key pair of keystore.
User is able to define the TLS versions as well as a set of TLS ciphers to the respective lists of hello-params. The default TLS versions and ciphers, as well as their preference order, can be found in appendix section _Supported TLS versions and ciphers_.

Pre-condition:

* The IPFIX collector CA Certificate should be configured via system/certificate/pinned-ca-edit, before configuring the CA list reference OR the respective EST PKI certificate enrollment profile is configured to be used for server CA (collector) certificate reference.
* The relevant end entity client certificate exists in the keystore, local or by reference

Input parameters:

* ca-name: The local pinned certificate name to be used for connection to IPFIX collector
* cipher-suite: A cipher suite to add to the list of acceptable cipher suites of hello parameters
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

