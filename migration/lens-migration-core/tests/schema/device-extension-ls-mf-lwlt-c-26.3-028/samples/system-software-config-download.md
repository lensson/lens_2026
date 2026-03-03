This macro downloads configuration on an existing software revision.

Pre-condition:

* Subscribe to the configuration download notification so that resulting notification is received.
* System should already have a valid operational software in state active, committed and system should be in idle state.
* Passive (inactive) software should be present. System should have sufficient resources to store configuration file.
* Before executing configuration download action, it is important to be aware of the Software status of the device, so it is good practice to request the Software status via macro "SYSTEM-SOFTWARE-status-get - Retrieve status of all software versions".
* "server-public-key" should be provided for configuration download is requested using TLS via HTTPS. configure server CA certificate using "system-certificate-pinned-ca-edit" macro.
* "Client-Key-Reference" and "Client-Public-Key-Reference" parameters should be provided for configuration download, when requested using mTLS via HTTPS. This parameters are needed when configuration file is encrypted. configure ietf-keystore "factory-callhome-key" and "factory-callhome-cert" using "system-certificate-keystore-edit" macro.
* "client-auth-est-profile-name" and "server-auth-est-profile-name" should be provided for configuration download, when requested using mTLS via HTTPS with PKI EST profile reference. Configure PKI EST profiles using "system-est-pki-client-profile-edit" macro.
* "key-name" should be provided for configuration download when using username and key-name–based SFTP download. An SSH key can be generated with the macro: “system-file-transfer-ssh-key-edit”.
* For key based SFTP downloads, user needs to copy the SFTP client's(LS device's) public key to the SFTP server using the "system-file-transfer-ssh-auth-publickey-get" macro.

Procedure:

* Transfer protocol: TFTP, SFTP, FTP, HTTP and HTTPS protocols are supported.
* To download configuration using HTTPS protocol user needs to configure server CA certificate.
* To download configuration using mTLS via HTTPS user needs to configure ietf-keystore factory-callhome-key and factory-callhome-cert.
* To download configuration using mTLS via HTTPS PKI EST profile reference, user needs to configure client-auth-est-profile-name and server-auth-est-profile-name.
* To download configuration using username and key-name based sftp protocol, user needs to generate SSH key with the macro: “system-file-transfer-ssh-key-edit”.

Description:

* "mode-HTTPS" should be "TLS/mTLS/false" for configuration download.
    - TLS   -> download Software using TLS via HTTPS
    - mTLS  -> download Software using mTLS via HTTPS
    - false -> download software using TFTP, SFTP, FTP and HTTP.
* "server-public-key" should be provided for configuration download using HTTPS protocol. configure server CA certificate using "system-certificate-pinned-ca-edit" macro.
* "Client-Key-Reference" and "Client-Public-Key-Reference" parameters should be provided for configuration download, when requested using mTLS via HTTPS. This parameters are needed when configuration file is encrypted. configure ietf-keystore "factory-callhome-key" and "factory-callhome-cert" using "system-certificate-keystore-edit" macro.
* "client-auth-est-profile-name" and "server-auth-est-profile-name" should be provided for configuration download, when requested using mTLS via HTTPS with EST.Configure PKI EST profiles using "system-est-pki-client-profile-edit" macro.
* "mTLS-with-EST" should be "true" if configuration download requested using mTLS via HTTPS with PKI EST profile reference.
* Additionally, software downloads now support using "Fully Qualified Domain Name (FQDN)/Hostname" instead of the "IP address" of the server.
* "key-name" - The SSH authentication key type for SFTP-based configuration download. Supported values are: ecdsa-sha2-nistp256, ssh-dss, and ssh-rsa.

Note:

* This macro does not have a local definition for installing factory-callhome-key/factory-callhome-cert via NETCONF for software downloads. The only way to perform mTLS for software download is by using the reference to the system-certificate-keystore-edit macro. In this release, mTLS is only supported by reusing the (pre-) installed private-key and certificate used for Callhome (=Netconf/mTLS). This is a restriction until full support of a Public Key Infrastructure becomes available.
* Username/password-based authentication is not supported for configuration download using HTTP/HTTPS protocols.

Input parameters:

* client-auth-est-profile-name: The PKI EST profile name to be used for mTLS download and configuration file encryption. This profile will be used for client authentication.
* client-key-reference: The client-key-reference that is going to be used for mTLS download and configuration file encryption
* client-public-key-reference: The client-public-key-reference that is going to be used for mTLS download and configuration file encryption
* component: Name of the component, default must be Chassis.
* config-url: URL from which configuration download should be triggered.This URL can use either an IP address or a Fully Qualified Domain Name (FQDN).
* downloaded-software-name: Name of the software to be  downloaded
* key-name: SSH key name to be used for key-based sftp download.
* mode-HTTPS: Mode selection for download using https
* mTLS-with-EST: Indicates if PKI EST profile names should be used with mTLS during HTTPS-based download.
* server-auth-est-profile-name: The PKI EST profile name to be used for mTLS download and configuration file encryption. This profile will be used for server authentication.
* server-public-key: CA certificate of the server
* software-name: Name of the application software

