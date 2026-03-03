This macro adds one or more TLS protocol versions to the list of acceptable
protocol versions for the Call Home connection.  This list overrides the
default TLS versions that are otherwise used.

Note:  

* The reserved endpoint name 'certificate_endpoint' MUST be used for Call-home TLS protocol version configuration.
* Configuration of TLS protocol version is generic and applies to all endpoints in the list, either static or dynamic (e.g. learnt from DHCP)

Input parameters:

* netconf-client-name: Name of the NETCONF client
* version-id: YANG identifier of a TLS protocol version to add

