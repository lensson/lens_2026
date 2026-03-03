This macro configures the Authentication-mode,Timers, Maximum Retry Count, Initiate Authentication Request,  to the respective user interface.

Prerequisite:

* user interface must be configured.



Input parameters:

* authentication-mode: The object identifies the authentication mode of the interface.
* handshake-enable: Handshake mechanism is enabled or not.
* handshake-period: The among of time (in range of 5..90 seconds) between handshake messages sent to the supplicant.
* initiate-authentication-request: Controls whether or not to send EAP Request ID messages towards all configured and unauthenticated users on the user interface, using an interval defined by tx-period.
* interface-supplicant-timeout: If no reply from supplicant is received within this timeout (in seconds), the authenticator will retry with a new EAP Request.
* max-mac-addresses: The maximum number mac-address that (in range of 1..2) are allowed to authenticate on the interface.
* quiet-period: Number of seconds that the authenticator remains in the quiet state following a failed authentication exchange with the supplicant.
* tx-period: The amount of time (in seconds) between sending EAP Request ID messages to the supplicant.
* user-interface: Name of the user interface.

