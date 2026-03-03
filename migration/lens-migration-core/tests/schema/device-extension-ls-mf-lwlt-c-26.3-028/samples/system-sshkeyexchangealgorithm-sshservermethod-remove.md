This macro restores key exchange algorithms and ssh server method to default values.

Pre-condition:

* Only user who belongs to admin group can restore key exchange algorithms.
* Default value is “” empty which means that can be accepted for ssh connection any of the defined algorithms.

* Only user who belongs to admin group can configure SSH server method.
* Default value is the “” (empty) which means that ssh server can initiate connection with any of ssh-rsa or ssh-dss.

