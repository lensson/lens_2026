This macro changes a user’s password.

Pre-condition:

* The user who belongs to the admin group can change all users’ password by change-password action.
* The password shall follow the password policy.
* The confirm-password is needed and shall be the same as new-password.

Warning:  This macro results to a configuration change directly in the datastore of the targeted device.
If it is used in NBI by Altiplano, no update will be done in the device datastore in the PMA of Altiplano. Such action will therefore result in a misaligned of the datastore of the virtual device (in the PMA) and the datastore of the physical device. Upon resynchronization of the master (virtual) datastore in the PMA of Altiplano to the physical device, the password change will be lost and restored back to the previous.
Alternatively, the system-users-edit macro can be used for setting new password for a user when using Altiplano.


Input parameters:

* confirm-password: User's new password
* new-password: User's new password
* old-password: User's old password
* user-name: Login name of the user

