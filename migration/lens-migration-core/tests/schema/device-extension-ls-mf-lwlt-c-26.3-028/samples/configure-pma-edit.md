This macro configures static pma details. The provided static pma information
is configured.

The statically configured endpoints will always have precedence, thus will always override the dynamically (e.g. DHCP) learnt endpoints (if any).

When all statically configured endpoints are removed, then Lightspan will fallback to dynamically (e.g. DHCP) learnt endpoints. Based on the dhcp client mode, DHCP re-discover will be triggered to learn new endpoints (see 'system-callhome-dhcp-client-edit').

Note:  

* The endpoint-name 'certificate_endpoint' is reserved only for TLS key/certificate replacement methods and for TLS specific details (e.g. TLS ciphers/TLS version etc). Assignment of endpoint IP/port is not possible via the 'certificate_endpoint'.
Input parameters:

* endpoint-name: The name of specific endpoint
* ip-address: The IP address or hostname of the endpoint
* netconf-client-name: Name of NETCONF clients list
* port: The IP port for this endpoint

