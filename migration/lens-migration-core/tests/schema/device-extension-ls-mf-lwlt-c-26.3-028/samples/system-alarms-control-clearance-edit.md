This macro controls the time delay that will be applied on the reporting of
an alarm instance clearance to northbound (via alarm-notification). By
configuring the appropriate delay it can be accomplished the reduction of an
alarm instance toggling on northbound due to continuous change of alarm
status (cleared/raised) in short timeframe.

Alarm clearance is reported when no toggling of alarm instance is detected
for the configured delay timeframe (on system or alarm identifier level).
In case that a re-raise alarm event is detected during the delay phase,
the raise event will be suppressed and delay clearance timeframe will be
reset to the configured value to continue further monitoring. A re-raise
event will be reported only if the *alarm-text* or *severity* is modified.

User can configure delay clearance time on system level (parameter
system-clearance-delay) as well as per alarm type identifier (parameter
alarm-type-id). Configuration per alarm type identifier overrules the
clearance delay time on system level (if it is configured) and one of
the following options can be applied:

* Apply a clearance delay time (parameter clearance-delay) which is applicable
only for the specific alarm type identifier.
* It is sufficient to configure only the alarm type identifier to exclude it
from being monitored, when an alarm clearance delay timeframe is configured on
system level. The macro will automatically disable the clearance-delay in this case.

Please note that only concrete alarm types that appear in the alarm inventory can
be configured. Available alarm types and the relevant namespaces can be retrieved via
macro system-alarms-inventory-get.

Input parameters:

* alarm-type-id: Identifies an alarm type. Only identities of concrete alarm types (present in the alarm inventory) can be configured. Usage of an abstract alarm type will be rejected. Refer to alarms guide or alarm-inventory for the available alarm types as well as for their namespaces. This parameter must be configured in combination with alarm-type-ns.
* alarm-type-ns: The namespace of configured alarm-type-id. Refer to alarms guide or alarm-inventory for the applicable namespace per alarm type id. This parameter must be configured in combination with alarm-type-id.
* clearance-delay: Define the minimum timeframe (range of 1..180 seconds) without toggling from cleared to active state for an alarm. Whenever such a transition is detected, the clearance of the alarm will be postponed. This value controls the delay of alarms clearance for a specific alarm-type, also could overrule the clearance delay configuration on system level. If there is no value in clearance-daley, clearance-delay-disable will be configured.
* system-clearance-delay: Define the minimum time (range of 1..180 seconds) without toggling from cleared to active state for an alarm. Whenever such a transition is detected, the clearance of the alarm will be postponed. This value have system wide impact (affects all the alarm type ids), in case that it is not configured it is considered as disabled on system level.

