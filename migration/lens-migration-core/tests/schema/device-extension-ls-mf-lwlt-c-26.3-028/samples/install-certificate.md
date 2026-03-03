This macro installs the device certificate, being the server for mutual TLS with the PMA upon Callhome of the Lightspan device (network element).

Giving specific device information in the certificate subject (/SerialNumber, /CN), the certificate will be installed outside the database avoiding the database is coupled to a specific device (per Serial Number). This way the same database can be used in case of device or board replacement.

Pre-condition:
Configure the local-definition container via 'system-callhome-local-definition-edit'


Input parameters:

* netconf-client-name: Name of NETCONF clients list, when replacing key/certificate the 'certificate_endpoint' name MUST be used
* server-certificate: Device Certificate value to be used

