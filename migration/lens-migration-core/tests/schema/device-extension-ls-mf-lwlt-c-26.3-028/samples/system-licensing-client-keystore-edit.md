This macro configures the characteristics of TLS session with mutual authentication for licensing. The private key, as well as the end entity certificate that is going to be used during the handshake phase, are determined via reference to an asymmetric key pair of keystore. User is able to define the TLS versions, as well as a set of TLS ciphers, to the respective lists of hello-params. The default TLS versions and ciphers, as well as their preference order, can be found in appendix section _Supported TLS versions and ciphers_.

Pre-condition:

* The local pinned certificates list has been configured or the PKI EST profile has been configured.
* Relevant asymetric key pair exists in the keystore (refer to macro system-certificate-keystore-edit)

Input parameters:

* cipher-suite: A cipher suite to add to the list of acceptable cipher suites of hello parameters
* pinned-ca-list: The local pinned certificates list name to be used for connection to License Server
* server-auth-est-profile-name: The PKI EST profile name to be used for connection to License Server
* tls-version: A TLS version to add to the list of acceptable TLS versions of hello parameters

