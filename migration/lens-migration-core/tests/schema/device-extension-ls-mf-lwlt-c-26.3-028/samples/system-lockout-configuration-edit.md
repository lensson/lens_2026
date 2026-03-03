This macro configures the lockout.
A user or IP can be locked out from accessing the device, when a certain threshold of failed attempt is reached.
This threshold is the max-retry-attempts and it can be configured in the device. The max-retry-attempts is the cumulative number of failed login attempts that must happen in order to trigger a lockout. The time duration of lockout is called lockout-duration and during this period, access to the device is not allowed, even a login with correct password will be denied. Once a failed login attempt happens, the remaining failed attempts must happen within a specified duration equal to the lockout-duration to trigger a lockout. If failed login attempt, until max-retry-attempt, happens after the lockout-duration, then the whole procedure is reset and no lockout happens.
Once a failed login attempt happens, the remaining failed attempts must happen within a specified duration equal to the lockout-duration to trigger a lockout. If failed login attempt, until max-retry-attempt, happens after the lockout-duration, then the whole procedure is reset and no lockout happens.

Pre-condition:

* It is possible to configure the lockout of the device, based on IP address or user, so either an IP address or a user will be locked out.
* Administrator can display the users/IP addresses that are in lockout and can remove the lockout from either user or IP address.
* In case of an attack to the device with multiple failed logins from several IP address or users, the device goes to Global-lockout state and login to the device is not permitted for all users. So, there are 2 lockout mechanisms, individual lockout (based on IP address or user account) and global lockout.
* Whenever lockout happens (either individual or global), the active sessions are not impacted, and they remain active/connected to the device.
* There are NETCONF notifications messages sent out, when lockout happens.
* In case of system reboot, the information related to lockout is lost, as this info is not stored in a persistent way.

Note:

* Lockout can be triggered even with unsuccessful external authentication, according to the system's lockout configuration.
Input parameters:

* lockout-duration: The time duration of lockout. During this period, access is not allowed. Lockout duration can be configured either as dynamic or fixed. Default value '0' enables dynamic lockout type. Initial value of dynamic lockout duration is 2 minutes and every subsequent failure increase the lockout-duration for 2 minutes. Maximum lockout duration is restricted to 15 minutes.
* lockout-type: Defines the capability of the system to lockout ip address or users when failed login attempts is reached.
* max-retry-attempts: The cumulative number of failed login attempts happen to trigger a lockout. Once a failed login attempt happens, the remaining failed attempts should happen within lockout-duration to trigger a lockout. If failed login attempt, until max-retry-attempt happen after the lockout-duration, then the whole procedure is reset and no lockout happens.

