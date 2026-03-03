This macro can be used for retrieving a subset of end-user certificates attributes:

* signature: This is the signature algorithm containing the identifier of the used cryptographic algorithm for signing this certificate
* issuer: The issuer fields indicate the entity that has signed and issued the certificate. This is typically the certificate authority.
* valid-from: The date on which the certificate validity period begins (notBefore)
* valid-to: This field provide the expiration date (not After)
* subject: The subject fields identify the entity associated with the public key stored in the subject public key field
* key-encryption: This is identifying the public key encryption algorithm used
* key-size: Size of public key
* ca-flag: The ca boolean (part of basic constraints extension) indicates whether the certified public key may be used to verify certificate signatures

End-user certificates are issued to subjects that are not authorized to issue other certificates, they identify a client or a server and they are used during the establishment of a TLS connection with mutual authentication (handshake phase).

For the case of end-user certificates the actual user is the feature and their provisioning is performed via the relevant yang model. This means that a 'name' will not be directly assigned to the relevant end-user certificate and for that reason the value of parameter 'feature-name' is corelated with the feature that uses the specific certificate, for example ipfix, syslog, licensing, callhome.

The value of parameter certificate-name is either fixed or in case that multiple certificates are used (list) the key of the list will be used. The values of parameters feature-name and certificate-name are assigned automatically during the provisioning of the end-user certificate. User will be prompted to choose the value of those parameters through a list with the installed end-user certificates in the device, organized per feature-name.

Remark: for the end-user callhome certificates the value 'callhome' is used for feature-name. By checking the "Issuer" field, it can be discerned if the callhome certificate is a pre-installed (Nokia) or a replaced (Customer) certificate.

Pre-condition: certificates must be installed in the device, for being part of the feature list.

Input parameters:

* certificate-name: User can choose for which of the available certificates, the data will be displayed
* feature-name: Indicates by which feature the certificate is used

