This macro creates or modify users.

Pre-condition:

* Users shall be configured by an existing user who is an administrator (i.e) a user who belongs to the admin group.

Input parameters:

* algorithm: The algorithm used to create a user's public key. This can be configured with a value of either ssh-rsa or ssh-dss.
* disable: handles the ability of an administrator user, to disable a user's account.A non-admin user cannot disable itself.Disable of user account cause the session of the user to be terminated. When a user is disabled/enabled, a notification will be sent over NETCONF.
* homedir: Absolute path to user's home directory.
* name: Login name of the user.
* new-password-at-login: Enable/Disable prompting a user to change password at next CLI login.
* password: Login password of the user. The new password if password reset is configured. This new password shall follow the configured password policy. The reset action shall require the new password to be specified once by the administrator. The user when logging in with reset password shall be forced to change password on first login.
* password-expiry: Password ageing time, i.e. the time in days within which the password expiration happens.If its value is zero password will not age.The users password can be configured to expire after a certain amount of time. Default value of password expiration time is disabled. Expire time is the period during which a password can be used, before the system requires the user to change it.
* password-expiry-notification: This parameter will set the days prior to pasword ageing.The user can be notified when the password expiration time approaches. Password ageing is not applicable for admin user.
* password-history-policy: Password history length, i.e. the number of recently used password.Recently used passwords are stored for each user. The administrator can configure how many passwords shall be used before an already used one can be reused. This capability is called password history policy.
* public-key: A user's public key in base64 format without any spaces. This key will be used to authenticate a user entering the system. Supported key types are in rsa1024/rsa2048/dss1024 types. Please be aware no validation of this value takes place.

