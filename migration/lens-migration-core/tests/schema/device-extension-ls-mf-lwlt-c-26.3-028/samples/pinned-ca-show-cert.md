This macro displays a pinned certificate.  Certificate can be displayed either in raw, or detailed (decoded) format.

Pinned certificates are configured via macro system-certificate-pinned-ca-edit and they can be referenced by other yang models.

Remark: for the pre-installed callhome certificates  (eg Client CA certificate) the value ‘factory-callHome’ is used as ‘certificate-list-name’. During the phase of callhome certificates replacement, both configured and pre-install callhome certificates co-exists. The pre-installed certificates (factory-callHome) will be removed from the list with available ‘certificate-list-name’ after the successful establishment of callhome TLS connection (refer to macro system-callhome-restart).

Input parameters:

* certificate-list-name: Certificate list name
* certificate-name: Certificate name
* format: Format could be either "raw" (encoded) or "details" (decoded)

