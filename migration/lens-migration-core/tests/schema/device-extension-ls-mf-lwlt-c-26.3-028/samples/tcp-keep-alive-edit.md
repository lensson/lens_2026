This macro configures the tcp keep-alive parameters:

* max-wait: Sets the amount of time in seconds, after which, if no data has been received
from the TCP peer, a TCP-level message will be sent to test the aliveness of the TCP peer.
* max-attempts: Sets the maximum number of sequential keep-alive messages that can fail
to obtain a response from the TCP peer before assuming the TCP peer is no longer alive.
* interval-between-attempts: Sets the amount of time in seconds, after which, if no
reply to a keep-alive message has been received from the TCP peer, the next keep-alive
message will be sent.

Warning:

* On first establishment of call-home connection with a device, special attention should be paid to enable the keep-alive container on that device as per this section. This is a strong recommendation, as otherwise, if the physical connection between PMA and the device is interrupted, such as when the physical connection gets broken, the device will not be able to restore the connectivity with PMA and re-establish the connection, when physical layer is available again. In that case, in order to restore the connection, you will have to log in to the device via other interface, e.g. SSH and then disable and re-enable call-home as per section 2.2.5 to restore connectivity with PMA via call-home.

Note:

* To protect against node isolation, the Device will, by default, check the aliveness of the established call-home connection by using sparse TCP keep-alive values. These default values will be replaced by values provisioned by the Netconf Client during the first NC/Y connection.
* These default TCP keep-alive values are max-wait: 7200 seconds, max-attempts: 9, interval-between-attempts: 75 seconds (suggested defaults from OS).
* These default TCP keep-alive values will be applied, even if no relative configuration exists. This happens to prevent LightSpan from being isolated from PMA (e.g. if underlying physical layer is disconnected and no relative tcp-keep-alive configuration exists).

Input parameters:

* interval-between-attempts: Interval timeframe can be in the range of 1 up to 32767 seconds
* max-attempts: Maximum number of sequential keep-alive messages can be set in the range of 1 up to 127
* max-wait: Maximum time can be in the range of 1 up to32767 seconds
* netconf-client-name: Name of NETCONF clients list

