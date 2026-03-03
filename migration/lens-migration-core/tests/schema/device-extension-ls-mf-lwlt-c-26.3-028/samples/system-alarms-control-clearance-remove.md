This macro removes the configuration for alarm clearance delay time for a
specific alarm type identifier or on system level. If no alarm type (defined by 
alarm-type-id and alarm-type-ns) is specified and disable-system-clearance-delay 
is false, the entire alarms-delay-profile will be deleted.

Please note that only concrete alarm types that appear in the alarm inventory can
be configured. Available alarm types and the relevant namespaces can be retrieved via
macro system-alarms-inventory-get.

Input parameters:

* alarm-type-id: Identifies an alarm type. Only identities of concrete alarm types (present in the alarm inventory) can be configured. Usage of an abstract alarm type will be rejected. Refer to alarms guide or alarm-inventory for the available alarm types as well as for their namespaces. This parameter must be configured in combination with alarm-type-ns.
* alarm-type-ns: The namespace of configured alarm-type-id. Refer to alarms guide or alarm-inventory for the applicable namespace per alarm type id. This parameter must be configured in combination with alarm-type-id.
* disable-system-clearance-delay: Disable alarm clearance delay on system level, if it is set to true.

