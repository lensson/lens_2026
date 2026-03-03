This macro update Password Policy Rules.
The system shall support a configurable password policy to define the minimum length of the password, the least number of digital numbers, the least number of special characters and define if both upper- and lower-case alphabetic characters shall or shall not be present. It is possible to restore all the elements to their default values by deleting the system-security password-policy or delete one single element (e.g. mixed-case). The completely deletion of the system-security password-policy module is not feasible, while all the elements of the module are set with default values.

Pre-condition:

* Only a user that belongs to an admin group can change the password policy and can restore the default values.
* Users that do not belong to admin group are allowed only to read the password policy.
* The initial and default values of the password policy shall be one number, one lower case letter, one uppercase letter, and one special character and minimum length of password 8 characters.
* The password length shall be equal or greater to min-length and equal or less than max-length. The password length shall be configurable, and it shall not exceed the 32 characters. Only a user who belongs to the admin group can set the maximum length of the password.
* The password shall contain at least one alphabet character in case mixed-case is false and at least two alphabet characters in case mixed-case is true.
* When updating the password policy values, the sum of the elements shall not exceed the configured maximum length of password, 32 characters or less.
* In case of an attempt to set a value to password max-length that is outside the expected range of 0 -32, an error message will be displayed.

Input parameters:

* max-length: The maximum length of the password.Default value 20.
* min-length: The minimum length of the password. Default value 8.
* min-num-numeric-char: The minimum number of numerical characters.Default value 1.
* min-num-special-char: The minimum number of special characters.Default value 1.
* mixed-case: Both upper and lower-case alphabet characters are mandatory.Default value true.

