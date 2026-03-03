This macro creates a list of pinned (CA) certificates. These certificates can be used by a server (e.g. callhome feature) to authenticate the peer client, or by a client (e.g. syslog feature) to authenticate the peer server. Each list of pinned certificates (chain of trust) should be specific to a feature/purpose, as the list as a whole may be referenced by other yang modules. The list (chain of trust) could contain a top level CA certificate (Root CA certificate) or a chain of up to 5 certificates (Root CA and intermediate certificates).

Input parameters:

* certificate-key: Certificate string
* certificate-list-name: Certificate list name
* certificate-name: Certificate name

