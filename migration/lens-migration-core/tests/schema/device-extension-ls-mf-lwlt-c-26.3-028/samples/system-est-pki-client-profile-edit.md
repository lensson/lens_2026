The EST PKI client profile is enabling the automatic certificate enrollment for any Lightspan embedded application by means of interacting with an external PKI (aka Certificate Authority) using EST as a protocol.

EST is referring to RFC 7030: Enrollment over Secure Transport.

This macro configures:

* the EST server connection details, including the required authentication credentials for both the Lightspan EST PKI client and the EST PKI server.
* adds both a set of TLS versions and a set of TLS ciphers to the respective lists of acceptable TLS hello parameters. The default TLS versions and ciphers, as well as their preference order, can be found in appendix section _Supported TLS versions and ciphers_.
* certificate subject attributes
* certificate update policy

The EST PKI client profile is referred to by the respective Lightspan application when the application required EST PKI enrolled certificates for setting up the underlaying secure (m)TLS connection for its external protocol handling (e.g. IPFIX/mTLS).
The operator can create multiple, EST PKI client profiles depending on the difference in requirements per Lightspan application.
In the same time, the same EST PKI client profile can be re-reused by multiple applications.
Typically, there is a difference in certificate requirements or dedicated PKI server for either TLS client based applications (LicMgr, IPFIX, Syslog, SWmgnt) or TLS server based applications (Netconf server – CallHome Application).

Pre-condition:

* The pinned certificates list has been configured with the CA certificate of the EST PKI server
* In case of certificate authentication, relevant asymmetric key pair exists in the keystore and must be configured (refer to macro system-certificate-keystore-edit). In practice, this is referring to factory preinstalled Nokia signed End-Entity certificates
* In case of certificate authentication for the EST PKI client using the factory default Nokia certificate, the correct Nokia CA certificate to be installed in the EST PKI server

Previously enrolled EST certificates and previously fetched EST CA certificates are removed from Lightspan for an EST profile and a fresh EST enrollment is triggered for this EST profile in case that any of the following parameters is modified : est-server-url, pinned-ca-list, use-certificate-auth, http-username, http-password, private-key-algorithm, subject-distinguished-name, subject-alternative-name or auto-fill-duid-attributes.

Input parameters:

* auto-fill-duid-attributes: Whether to include the DUID in the certificate signing request (CSR). The DUID is added in /SerialNumber subject attribute
* ca-certificate-renew-interval: The interval in days for the ca certificates renewal
* cipher-suite: A cipher suite to add to the list of acceptable cipher suites of hello parameters
* end-entity-certificate-renew-schedule-interval: The interval in days for the end entity certificate renew schedule type
* end-entity-certificate-renew-schedule-type: Whether to check for re-enrollment end-entity certificate AFTER the issuing date or BEFORE expiring date
* est-profile-name: The EST PKI client profile name
* est-server-url: The URL of the EST PKI server
* http-password: The password for http client authentication
* http-username: The username for http client authentication
* key-policy: Whether a new private key will be generated for upcoming re-enrollment
* pinned-ca-list: Reference to pinned-ca-list for EST PKI server authentication
* private-key-algorithm: The private key generation algorithm
* restart-connection-after-certificate-update: Whether the connection of the service using the end certificate will be restarted upon certificate re-enrollment
* subject-alternative-name: A subject alternative name for the certificate signing request (CSR)
* subject-distinguished-name: A subject distinguished name for the certificate signing request (CSR)
* tls-version: A TLS version to add to the list of acceptable TLS versions of hello parameters
* use-certificate-auth: If TRUE, the factory pre-installed, Nokia signed device certificate will be used for EST client authentication

