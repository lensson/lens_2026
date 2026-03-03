This macro adds both a set of TLS versions and a set of TLS ciphers to the
respective lists of acceptable TLS handshake parameters.  
During handshake it will be Lightspan NE, as a server, that decides the
handshake parameters based on the acceptable TLS version(s) and/or TLS
cipher(s). The default TLS versions and ciphers, as well as their preference order, 
can be found in appendix section _Supported TLS versions and ciphers_.

In case the user configures any non-recommended ciphers, an alarm will be raised
containing the YANG identifiers of those ciphers,  
so that appropriate action can be taken.

Note:  

* The reserved endpoint name 'certificate_endpoint' MUST be used for Call-Home TLS handshake parameters.
* Configuration of TLS handshake parameters is generic and applies to all endpoints in the list, either static or dynamic (e.g. learnt from DHCP)

Input parameters:

* cipher-id: YANG identifier of a TLS cipher to add
* netconf-client-name: Name of the NETCONF client
* version-id: YANG identifier of a TLS protocol version to add

