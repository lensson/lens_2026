Retrieve all TLS hello parameters for Call Home connection as configured in the
running datastore. Those parameters consist of two lists: one for the
acceptable TLS versions and another for the acceptable TLS ciphers.  Note that
the actual TLS versions and ciphers enabled in the device may be more than in
those lists. E.g. if a cipher of a non-configured TLS versions is configured,
the relevant TLS version will be enabled implicitly.


Input parameters:

* netconf-client-name: Name of the NETCONF client

