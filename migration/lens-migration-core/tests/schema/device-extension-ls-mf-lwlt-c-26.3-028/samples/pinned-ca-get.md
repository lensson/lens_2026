This macro can be used for retrieving a subset of pinned certificates attributes:

* signature: This is the signature algorithm containing the identifier of the used cryptographic algorithm for signing this certificate
* issuer: The issuer fields indicate the entity that has signed and issued the certificate. This is typically the certificate authority.
* valid-from: The date on which the certificate validity period begins (notBefore)
* valid-to: This field provide the expiration date (not After)
* subject: The subject fields identify the entity associated with the public key stored in the subject public key field
* key-encryption: This is identifying the public key encryption algorithm used
* key-size: Size of public key
* ca-flag: The ca boolean (part of basic constraints extension) indicates whether the certified public key may be used to verify certificate signatures

Pinned certificates are configured via the macro system-certificate-pinned-ca-edit and they can be referenced by other yang models.

Remark: for the pre-installed callhome certificates (device specific server certificate per DUID) the value ‘factory-callHome’ is used as ‘certificate-list-name’. During the phase of callhome certificates replacement, both configured and pre-install callhome certificates co-exists. The pre-installed certificates (factory-callHome) will be removed from the list with available ‘certificate-list-name’ after the successful establishment of new callhome TLS connection (refer to macro system-callhome-restart).

Input parameters:

* certificate-list-name: Name of pinned certificates list
* certificate-name: Certificate name

