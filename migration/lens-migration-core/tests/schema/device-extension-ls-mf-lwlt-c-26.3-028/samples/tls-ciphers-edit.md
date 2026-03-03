This macro adds cryptographic ciphers to the list of acceptable TLS ciphers for
the Call Home connection. This list overrides the set of default ciphers that
are otherwise used and is in order of descending preference.

Note:  

* The reserved endpoint name 'certificate_endpoint' MUST be used for Call-home TLS cipher configuration.
* Configuration of TLS cipher configuration is generic and applies to all endpoints in the list, either static or dynamic (e.g. learnt from DHCP)

Input parameters:

* cipher-id: YANG identifier of a TLS cipher to add
* netconf-client-name: Name of the NETCONF client

