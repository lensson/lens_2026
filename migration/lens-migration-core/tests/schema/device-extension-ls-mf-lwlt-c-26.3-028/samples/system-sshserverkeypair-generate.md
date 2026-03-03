This macro handles the ability of an administrator to generate ssh-server keys.

Pre-condition:

* Administrator can generate ssh-server key pairs.
* By generating a new key-pair, the existing one will be replaced.
* Users belonging to admin group will be able to generate server keys.
* System can generate at most two keys. One for ssh-rsa method and one for ssh-dss method.
* With ssh-rsa method can be generated keys with bit values 1024 or 2048.
* With ssh-dss method can be generated keys only with 1024 bit value.
* Inputs for action are rsa1024, rsa2048, dsa1024.

Input parameters:

* algorithm: The algorithm to be used when generating the asymmetric key.
* host-key-name: An arbitrary name for this host-key

