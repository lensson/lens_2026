This macro retrieves the list of acceptable TLS protocol versions for the Call
Home connection, as configured in the running NETCONF datastore of the device.
However the actually enabled TLS versions for Call Home may be more than those.
For example if a TLSv1.3-supported cipher is configured in the datastore, even
if TLSv1.3 is not explicitly configured, it will be nonetheless enabled in the
device.


Input parameters:

* netconf-client-name: Name of the NETCONF client

