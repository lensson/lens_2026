Get-config information about lockout related data.

Pre-condition:
Lockout related data are the below:

* lockout-type - Defines the capability of the system to lockout ip address or users when failed login attempts is reached.
* max-retry-attempts - The cumulative number of failed login attempts happen to trigger a lockout. Once a failed login attempt happens, the remaining failed attempts should happen within lockout-duration to trigger a lockout. If failed login attempt, until max-retry-attempt happen after the lockout-duration, then the whole procedure is reset and no lockout happens.
* lockout-duration - The time duration of lockout. During this period, access is not allowed.

