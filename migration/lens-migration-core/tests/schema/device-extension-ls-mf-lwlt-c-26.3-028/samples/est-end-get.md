This macro can be used for retrieving an EST end-user certificate's attributes:

* signature: This is the signature algorithm containing the identifier of the used cryptographic algorithm for signing this certificate
* issuer: The issuer fields indicate the entity that has signed and issued the certificate. This is typically the certificate authority.
* valid-from: The date on which the certificate validity period begins (notBefore)
* valid-to: This field provide the expiration date (not After)
* subject: The subject fields identify the entity associated with the public key stored in the subject public key field
* key-encryption: This is identifying the public key encryption algorithm used
* key-size: Size of public key
* ca-flag: The ca boolean (part of basic constraints extension) indicates whether the certified public key may be used to verify certificate signatures
* feature: A leaf-list of all the feature names using the end-certificate

EST end-certs are configured via macro system-est-client-edit and they can be referenced by other yang models.

Remark: Certificates are retrieved from an EST server, an action that can take a varying amount of time.
Only after the credential retrieveal is finished will these be available for display.
Input parameters:

* profile-name: EST profile-name

