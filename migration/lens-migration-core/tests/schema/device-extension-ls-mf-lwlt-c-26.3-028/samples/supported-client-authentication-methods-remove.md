This macro handles the ability of an administrator to configure the allowed authentication methods for users of the system

Pre-condition

* By default, both authentication methods are allowed (publickey and password)
* Either both methods or public key method only are allowed. If a user is configured without a public key and the system authentication method is changed to accept only public keys, the user will be denied access to the system.
* If key-authentication is not successful, user will be prompted for password. In case a system is configured only for public key logins, whatever password is entered, it will be ignored. For such a case, the failed attempts to login with password will not be counted towards the user lockout.

Procedure:

* Configuration for the related authentication methods of a user can be done by admin user.


Input parameters:

* authentication-method: The authentication method to be deleted from the system.

