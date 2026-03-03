This macro displays an EST End certificate. The Certificate can be displayed either in raw, or detailed (decoded) format.

EST end-cert is configured via macro system-est-client-edit and can be referenced by other yang models.

Remark: Certificates are retrieved from an EST server, an action that can take a varying amount of time.
Only after the credential retrieveal is finished will these be available for display.
Input parameters:

* format: Format could be either "raw" (encoded) or "details" (decoded)
* profile-name: EST profile-name

