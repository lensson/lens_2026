This macro configures secondary NETCONF call-home connections to
NETCONF clients (endpoints). Multiple secondary NETCONF call-home
connections can simultaneously co-exist, acting as 'redundant' connections
to the primary call-home connection, for performance only reasons.
Those secondary connections are treated as 'slave' NETCONF call-home
connections, meaning that in case the primary NETCONF call-home connection
is lost, then all the established secondary NETCONF call-home connections
will be disconnected too. Those will be re-established only after the
connectivity with the primary NETCONF call-home connection is restored.
If no 'address' or 'port value is specified, then the same 'address' or 'port' will 
be used as per the established primary callhome connection.

Input parameters:

* endpoint-name: The name of specific endpoint
* ip-address: The IP address or hostname of the endpoint. If no 'address' value is specified, then the same 'address' will be used as per the establihsed primary callhome connection
* netconf-client-name: Name of NETCONF clients list
* port: The IP port for this endpoint. If no 'port' value is specified, then the same port will be used as per the established primary callhome connection

