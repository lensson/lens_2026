This macro handles the ability of an administrator to configure key exchange algorithms and ssh server method.

Pre-condition:

* Only user who belongs to admin group can configure key exchange algorithms.
* For Key Exchange Algorithm can be configured any of the following range of values:
'diffie-hellman-group-exchange-sha256', 'diffie-hellman-group-exchange-sha1',
'diffie-hellman-group14-sha1','diffie-hellman-group18-sha512', 'diffie-hellman-group14-sha256' and 'diffie-hellman-group1-sha1'.

* Default value for server host key and key exchange algorithm is “” empty which means that can be accepted for ssh connection any of the defined algorithms.All ssh algorithms can be configured with an empty string, signifying that the SSH server can initiate a connection with any of the defined algorithms. If a specific method is explicitly configured, the SSH server will use that method for connecting with an SSH client.
* Only user who belongs to admin group can configure SSH server method.
* For the SSH server method, accepted values include 'ssh-rsa', 'ssh-dss', or an empty string. Both supported values can be configured at the same time (comma separated) and the SSH server can initiate a connection with any of the  'ssh-rsa', 'ssh-dss'.
* Default value is the “” (empty) which means that ssh server can initiate connection with any of ssh-rsa or ssh-dss. If one method is explicitly configured, ssh server will use this method for connecting with a ssh-client.

Procedure:

* Key exchange algorithms, related configuration can be done by admin user.
* SSH server method related configuration can be done by admin user.

To limit the usable key exchange algorithms to'diffie-hellman-group14-sha1' and'diffie-hellman-group-exchange-sha256' (in that order) set this value to 'diffie-hellman-group14-sha1, diffie-hellman-group-exchange-sha256'.
To limit the usable serverHostKey algorithms to 'ssh-dss', set
this value to 'ssh-dss' or avoid installing a key of any other
type than ssh-dss in the sshServerKeyDir.

Input parameters:

* kex: The supported key exchange algorithms (as long as their hash functions are implemented in libcrypto) are 'diffie-hellman-group18-sha512', 'diffie-hellman-group14-sha256', 'diffie-hellman-group-exchange-sha256', 'diffie-hellman-group-exchange-sha1', 'diffie-hellman-group14-sha1' and 'diffie-hellman-group1-sha1'.
* serverhostkey: The supported serverHostKey algorithms (if implemented in libcrypto) are 'ssh-dss' and 'ssh-rsa', but for any SSH server, it is limited to those algorithms for which there is a host key installed in the directory given by /confdConfig/aaa/sshServerKeyDir.

