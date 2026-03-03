This macro gets:

* the last time of changing the password of the user.
* the last login date and time after a successful login of a user.
* the last-failed time of a user x, if exist, since the last successful login.
* the number of failed login attempts of a user x, since the last successful login.

Pre-condition:

* Each user can retrieve their own login data
* Admin user can retrieve login data for all users

Note:

* Operational data related to external authentication are not included.

Input parameters:

* name: Login name of the user.

