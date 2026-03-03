This macro configures the NETCONF server to derive the NETCONF username from a certificate using an ordered list of mappings that include certificate fingerprints and map types. The map types determine whether the username is explicitly configured or derived from the subjectAltName's rfc822Name field as specified in RFC6241. Ensure the configured user is added to the 'admin-group' to grant read, write, and action privileges to the NETCONF client. Please refer to 'system-authorization-groups-edit' macro.

Note:  

* The reserved endpoint name 'certificate_endpoint' MUST be used for callhome username to fingerprint mapping.
* Configuration of fingerprint to username mapping is generic and applies to all endpoints in the list, either static or dynamic (e.g. learnt from DHCP)

Input parameters:

* fingerprint: Fingerprint of the root, intermediate, or client certificate of the NETCONF client that will initiate the call-home. A tls-fingerprint value is composed of a 1-octet hashing algorithm identifier followed by the fingerprint value. The first octet value identifying the hashing algorithm is taken from the IANA 'TLS HashAlgorithm Registry' (RFC 5246). The remaining octets are filled using the results of the hashing algorithm. For example, for SHA-256 (identifier 04), SHA-384 (identifier 05), and SHA-512 (identifier 06), the fingerprint value should follow the format (04:YY:YY:YY:...:YY), (05:YY:YY:YY:...:YY), and (06:YY:YY:YY:...:YY) respectively.
* id: Id of fingerprint
* map-type: Specifies how the NETCONF username is derived from the certificate. If the value is 'specified', the username is taken from the name field that is explicitly configured. If the value is 'san-rfc822-name', the username is derived from the rfc822Name (i.e email) field in the certificate's subjectAltName.
* name: The NETCONF username that is only defined when map-type is 'specified', allowing 1-11 characters with alphanumeric characters, underscores (_), and plus signs (+) only.
* netconf-client-name: Name of NETCONF clients list.

