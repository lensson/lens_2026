This macro configures the characteristics of TLS session with mutual authentication for licensing.
The end-entity certificate for the license manager (client) that is going to be used during the handshake phase is configured with this macro.
In case of manual installed end-entity certificate, the macro will add the certificate to the client certificate local-definition. In case of dynamic certificate enrollment via an external PKI server using EST as protocol a reference is used instead.

Through this macro the following attributes are configured:

* creates or updates the local-definition for the client certificate or the reference to the est-profile-name used for the Mutual TLS with the License Server
* references to an already configured pinned-certificate or est-profile-name for server authentication
* adds both a set of TLS versions and a set of TLS ciphers to the respective lists of acceptable TLS hello parameters. The default TLS versions and ciphers, as well as their preference order, can be found in appendix section _Supported TLS versions and ciphers_.

Pre-condition: The local pinned certificates list or the PKI EST profile(s) has been configured.

Notes:
* although all parameters are marked as optional, the connection with the license server must be a mutual- TLS connection. Hence it is required to have an input for the client end-entity certificate (local-definition or est-profile) and the certificate for server authentication (pinned-ca-list or est-profile). But for both client end-entity and server authentication, two independent options are possible.


Input parameters:

* certificate: The local end-entity certificate to be used for Mutual TLS with the License Server that will be added to the local-definition
* cipher-suite: A cipher suite to add to the list of acceptable cipher suites of hello parameters
* client-auth-est-profile-name: The PKI EST profile name to be used for Mutual TLS with the License Server
* pinned-ca-list: The local pinned certificates list name to be used for connection to License Server
* server-auth-est-profile-name: The PKI EST profile name to be used to authenticate the License Server
* tls-version: A TLS version to add to the list of acceptable TLS versions of hello parameters

