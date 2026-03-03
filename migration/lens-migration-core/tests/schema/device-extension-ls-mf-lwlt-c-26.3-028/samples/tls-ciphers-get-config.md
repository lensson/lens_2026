This macro retrieves the TLS ciphers that are configured in the running NETCONF
datastore of the device.  However the actual enabled ciphers for Call Home may
be more than those. For example if TLSv1.3 is configured in the datastore
without any TLSv1.3-supported algorithm in it, then the device will enable all
the TLSv1.3-supported algorithms among those listed in the TLS hello params'
data constraints.

Input parameters:

* netconf-client-name: Name of the NETCONF client

