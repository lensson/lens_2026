This macro creates an IPFIX exporter, configures the IPFIX TLS collector attributes and establishes a TLS session with it. The macro specifies to the exporter whether the collector is primary or an alternate collector. Up to 4 alternate collectors can be configured. More than one alternate collector can be configured by using the same macro repetitively.

The end-entity certificate for the ipfix exporter (client) that is going to be used during the handshake phase is also configured with this macro.
In case of manual installed end-entity certificate, the macro will add the certificate to the client certificate local-definition. In case of dynamic certificate enrollment via an external PKI server using EST as protocol, a reference is used instead.

Through this macro the following attributes are configured:

* Creates or updates the local-definition for the client certificate or the reference to the est-profile-name used for the Mutual TLS with the IPFIX Collector
* References to an already configured pinned-certificate or est-profile-name for server authentication
* Adds both a set of TLS versions and a set of TLS ciphers to the respective lists of acceptable TLS hello parameters. The default TLS versions and ciphers, as well as their preference order, can be found in appendix section _Supported TLS versions and ciphers_.

IPFIX functionality and info:

* IPFIX exporter autonomously tries to connect with alternate collector (if primary collector is not reachable) based on the configured order of priority and keeps retrying till a connection is established with collector.
* In case when the connection with collector is not established, IPFIX exporter will retry to connect to the same collector every ~2sec till the configured retransmission timeout; before moving to the next alternate collector in sequence.
* The retransmission timeout is configurable with a default of 60 secs. (It is suggested for copper boards using IPv6 connectivity to collector, to set a timeout value of at least 180 secs).
* The priority for a collector destination could have a value from 1 (signifying highest priority collector) up to 255 (signifying lowest priority collector). No two destinations can have the same priority.
* If more than one destination is configured without priority, the destination will be selected in the configured order. In case of bulk creation (commit) of destinations, the selection order will be based on the alphabetical order of the destination-name (the order in which the creation will be notified to IPFIX app).
* Username and password authentication with Altiplano (if acting as the Collector) will be used in TLS (LS will verify and trust the Collector using the TLS connection, but AP cannot verify LS's credentials in lack of mTLS)
* TLS versions and/or a set of TLS ciphers which will be used during the handshake phase of the connection to the configured Collector, may also be configured. If a TLS cipher is configured without configuring the corresponding TLS version, then the relevant TLS version is implicitely enabled. Conversely, configuring a TLS version without any relevant cipher(s) will enable the default ciphers for that TLS version. The default TLS versions and ciphers, as well as their preference order, can be found in appendix section _Supported TLS versions and ciphers_.
* All elements of type leaf-list will be exported as a variable length string. Each value of the leaf-list will be seperated by a comma (,).
* In the exported data, following IANA standard data types are not supported:

		Value  |  Description           |  Reference

		20     |  basicList             |  [RFC6313][RFC7011]

		21     |  subTemplateList       |  [RFC6313][RFC7011]

		22     |  subTemplateMultiList  |  [RFC6313][RFC7011]

* In the exported data, following proprietary data types have been added in the reserved range:

		Value  |  Description  |  Reference

		253    |  Identityref  |  [RFC7950][RFC7011]

		254    |  Enumeration  |  [RFC7950][RFC7011]

		255    |  Union	       |  [RFC7950][RFC7011]

       'identityref' will be encoded like a variable length (65535) IE. Length of data (including datatype in case of union) and reference (value) of identityref will be exported as part of the IPFIX data record.

       ‘enumeration’ will be encoded like a unsigned32 value with length as 4. The integer equivalent of the enumeration value will be exported as part of the IPFIX data record.

       ‘union’ will be encoded like a variable length (65535) IE. The only difference being that the first octet of the IE value will denote the size, the second octet indicates data-type of the IE value and the rest of the octets are the actual values.

Pre-condition:

* PKI EST profile has been configured for the CA certificate, or
* The local pinned certificate (CA name) should be already configured using system-certificate-pinned-ca-edit.

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

