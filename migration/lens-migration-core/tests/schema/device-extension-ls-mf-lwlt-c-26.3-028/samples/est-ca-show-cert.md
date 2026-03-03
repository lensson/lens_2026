This macro displays a CA certificate enrolled via external PKI server using EST. The Certificate can be displayed either in raw, or detailed (decoded) format.

EST CA certificates enrollment is triggered by configuring an EST client profile that can be referenced from other application specific macros. Refer to macro system-est-client-edit for the respective EST client profile for the enrollment.

Remark: as the certificate are received from an external PKI server, there is a dependancy on the PKI server connectivity, proper credentials and positive response from the server before these certificate become available for display.
Input parameters:

* certificate-name: Certificate name
* format: Format could be either "raw" (encoded) or "details" (decoded)
* profile-name: EST profile-name

