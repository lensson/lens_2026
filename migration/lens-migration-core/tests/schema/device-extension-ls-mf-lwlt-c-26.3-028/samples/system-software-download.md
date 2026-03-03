This macro downloads a new software, renames an existing software revision and and allows the download of a software revision that already exists as a different sw package type (e.g. chassis package, board package).

Pre-condition:

* Subscribe to the software download notification so that resulting notification is received.
* System should already have a valid operational software in state active, committed and system should be in idle state.
* Passive (inactive) software can be present or can be empty. System should have sufficient resources to store software revisions.
* Before executing software download action, it is important to be aware of the Software status of the device, so it is good practice to request the Software status via macro "SYSTEM-SOFTWARE-status-get - Retrieve status of all software versions".
* "server-public-key" should be provided for software download using HTTPS protocol. configure server CA certificate using "system-certificate-pinned-ca-edit" macro.
* "Client-Key-Reference" and "Client-Public-Key-Reference" parameters should be provided for software download is requested using mTLS via HTTPS. configure ietf-keystore "factory-callhome-key" and "factory-callhome-cert" using "system-certificate-keystore-edit" macro.
* "client-auth-est-profile-name" and "server-auth-est-profile-name" should be provided for software download, when requested using mTLS via HTTPS with EST PKI EST profile reference. Configure PKI EST profiles using "system-est-pki-client-profile-edit" macro.
* "key-name" should be provided for software download when using username and key-name–based SFTP download. An SSH key can be generated with the macro: “system-file-transfer-ssh-key-edit”.
* For key based SFTP downloads, user needs to copy the SFTP client's(LS device's) public key to the SFTP server using the "system-file-transfer-ssh-auth-publickey-get" macro. 

Procedure:

* Transfer protocol: TFTP, FTP, SFTP, HTTP and HTTPS protocols are supported.
* To download Software using HTTPS protocol user needs to configure server CA certificate.
* To download Software using mTLS via HTTPS user needs to configure ietf-keystore factory-callhome-key and factory-callhome-cert.
* To download Software using mTLS via HTTPS with PKI EST profile reference, user needs to configure client-auth-est-profile-name and server-auth-est-profile-name.
* To download Software using username and key-name based sftp protocol, user needs to generate SSH key with the macro: “system-file-transfer-ssh-key-edit”.

Description:

* "mode-HTTPS" should be "TLS/mTLS/false" for software download.
    - TLS   -> download Software using TLS via HTTPS
    - mTLS  -> download Software using mTLS via HTTPS
    - false -> download software using TFTP, SFTP, FTP and HTTP
* "server-public-key" should be provided for software download using HTTPS protocol. configure server CA certificate using "system-certificate-pinned-ca-edit" macro.
* "Client-Key-Reference" and "Client-Public-Key-Reference" parameters are optional, needed when download is requested using mTLS via HTTPS. configure ietf-keystore "factory-callhome-key" and "factory-callhome-cert" using "system-certificate-keystore-edit" macro.
* "client-auth-est-profile-name" and "server-auth-est-profile-name" should be provided for configuration download, when requested using mTLS via HTTPS with EST. Configure PKI EST profiles using "system-est-pki-client-profile-edit" macro.
* "mTLS-with-EST" should be "true" if software download requested using mTLS via HTTPS with PKI EST profile reference.
* "verify-enable" should be "true" if verification of software is needed or "false" to skip verification of software after download.
* "download-software-name" should be a unique name for every software revision.
* "software-name" should be provided if the board-level transformation package is downloaded. If a Fiber LT software is downloaded on a Fiber NT then LT board specific target LT SW application name should be used during download.
    - FELT-B -> FELT-B_software
    - FWLT-B -> FWLT-B_software
    - FWLT-C -> FWLT-C_software
    - FGLT-B -> FGLT-B_software
    - FGLT-D -> FGLT-D_software
    - FGUT-A -> FGUT-A_software
    - FGLT-E -> FGLT-E_software
* "software-name" remains "application_software" for NT software download and own board LT software download (software downloaded directly on fiber LT)
* "software-name" should be ont_software when the new ONT software version is being downloaded on the NT and DF/SF platforms.
* "software-name" should be onu_vendor_specific_software when the new ONU vendor-specific software package is being downloaded on the NT and DF/SF platforms.
* "software-name" should be <board-type>_software when the transformation package is being downloaded on the FX NT. This package contains software files to transform Standby SNMP NT to Lightspan.
* "key-name" - The SSH authentication key type for SFTP-based software download. Supported values are: ecdsa-sha2-nistp256, ssh-dss, and ssh-rsa.

Note:

* For downloading system-level, board-level or chassis-level package use software descriptor (cypher+variant) as "descriptor_file_path" referenced in "url" which can be deduce from board_mapping.json file present in OLCS tar package.
* For downloading LT board-level transformation package, use either the software descriptor of the corresponding LT board-level software package or the software descriptor of Chassis package as "descriptor_file_path" referenced in "url" parameter. Transformation package for different LT boards can be downloaded using the same Chassis-level package descriptor.
* Additionally, software downloads now support using "Fully Qualified Domain Name (FQDN)/Hostname" instead of the "IP address" of the server
* This macro does not have a local definition for installing factory-callhome-key/factory-callhome-cert via NETCONF for software downloads. The only way to perform mTLS for software download is by using the reference to the system-certificate-keystore-edit macro. In this release, mTLS is only supported by reusing the (pre-) installed private-key and certificate used for Callhome (=Netconf/mTLS). This is a restriction until full support of a Public Key Infrastructure becomes available.
* ONU software and ONU vendor-specific software download support is available only in NT and DF/SF platforms, and not supported in LT.
* Username/password-based authentication is not supported for software download using HTTP/HTTPS protocols.

Exceptional Use-Cases:

* Changing the software name of an already downloaded software revision.
      (Re-)using the macro by only changing “download-software-name” of the existing software revision in the Lightspan devices while retaining the software descriptor name in the in “url” parameter (see “descriptor_file_path”) is not resulting in a physical re-download of the software. In stead it will result in a software revision name change only !. The last-downloaded state will be update with the new name and a Notification is provided to the Netconf client.

* Changing the Software (package) descriptor of an already downloaded software revision. (ONLY ON FIBER PLAFORMS)
      As explained in the Note above, Lightspan devices supports system-level, chassis-level and board-level packages. The software management application of Lightspan device allows download of a software package that already exists in the same version but using a different software package type (e.g. chassis package, board package). Downloading a board-level package with the same build version of active/committed system-level package and vice versa is permitted. 
Since the software files (cyphers and versions) are the same, there will be no physical download and the activation will not result in any software being replaced and/or the system being reset.
Since the copper platforms do not support ISSU these systems will always reset on activation of an internally identical sw package.

Input parameters:

* client-auth-est-profile-name: The PKI EST profile name to be used for mTLS download. This profile will be used for client authentication.
* client-key-reference: The client-key-reference that is going to be used for mTLS download
* client-public-key-reference: The client-public-key-reference to be used for mTLS download
* component: Name of the component, default must be Chassis.
* download-software-name: Operator chosen name to the software revision to be downloaded
* key-name: SSH key name to be used for key-based sftp download.
* mode-HTTPS: Mode selection for download using https
* mTLS-with-EST: Indicates if PKI EST profile names should be used with mTLS during HTTPS-based download.
* server-auth-est-profile-name: The PKI EST profile name to be used for mTLS download. This profile will be used for server authentication.
* server-public-key: CA certificate of the server
* software-name: Name of the (predefined) target software type
* url: URL from which download should be triggered.This URL can use either an IP address or a Fully Qualified Domain Name (FQDN).
* verify-enable: Enable or Disable verification of software after download.

