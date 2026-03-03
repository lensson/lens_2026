Creates the container to hold local the private key and certificate for callhome.

Note:  

* The reserved endpoint name 'certificate_endpoint' MUST be used for callhome private key and certificate replacement operations.
* Configuration of private key and certificate is generic and applies to all endpoints in the list, either static or dynamic (e.g. learnt from DHCP)

Input parameters:

* netconf-client-name: Name of NETCONF clients list

