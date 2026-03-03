This macro configures a remote syslog collector over TLS with mutual authentication.
The private key as well as the end entity certificate that is going to be used during
the handshake phase are determined via reference to an asymmetric key pair of keystore.
User is able to define the TLS versions, as well as a set of TLS ciphers, to the respective lists of hello-params. The default TLS versions and ciphers, as well as their preference order, can be found in appendix section _Supported TLS versions and ciphers_.

* In this example a new remote log collector rule is created on the device with name logCollector2 with IP address 10.0.0.1 and port 6514.
* Parameters facility and severity should be both configured, else they will be ignored.
* By default action is set to LOG, meaning that the message will be logged.
* By default compare is set to EQUALS-OR-HIGHER, meaning that the severity comparison operation will be equals or higher.
* Keepalive parameters idle-time, max-probes and probe-interval should all be configured, else the default values will be provided.
* TLS version is set to TLSv1.3 and only the cipher tls-aes-256-gcm-sha384 will be offered in the Client Hello

Pre-condition:

The following procedures must be fulfilled before an external Log Collector can be configured

* Enable the required logging levels of each Application/Submodule, otherwise only WARNING and above logs from applications will be generated
* IP interface configured already
* External remote syslog collector is reachable via the IP interface
* A pinned certificates list or the PKI EST profile has been configured
* Relevant asymetric key pair exists in the keystore (refer to macro system-certificate-keystore-edit)

Input parameters:

* advance-action: If action is LOG (default) then message will be logged. If action is BLOCK then the message will not be logged.
* advance-compare: If compare is EQUALS-OR-HIGHER (default) then the severity comparison operation will be equals or higher. Else if compare is EQUALS then the severity comparison operation will be equals.
* cipher-suite: YANG identifier of a TLS cipher to add
* facility: represents the process that creates the syslog event. For example, USER facility refers to all applications that can be listed with "get all active applications" and their log level can be configured explicitly. Available facilities are USER, SYSLOG, NTP, FTP and default facility is USER.
* idle-time: The time (in seconds) that a connection must be idle before the first keepalive packet is sent
* ipaddress: Uniquely specifies the address of the remote collector. One of the following MUST be specified: an ipv4/ipv6 address or a hostname
* max-probes: The maximum number of unacknowledged keepalive packets that the system will send before considering the connection dead
* pattern-match: string that can be used to select a syslog message for logging
* pinned-ca-list: The pinned certificates list name to be used for syslog
* port: The port-number of remote collector to deliver syslog messages. The default port is 6514. Port 0 is not allowed to be configured.
* probe-interval: The interval (in seconds) between successive keepalive packets if no response (acknowledgment) is received from the remote host
* server-auth-est-profile-name: The PKI EST profile name to be used for server authentication, if parameter 'pinned-ca-list' is empty
* severity: by default the severity with equal or higher importance from the given value are allowed. Severity configured for remote collector take precedence over the one configured in application level
* syslog-collector-name: Remote destination log collector name
* tls-version: YANG identifier of a TLS protocol version to add

