This macro creates an XGSPON ONU on the OLT side.
Prerequisite:
Perform one of the macros below:
* transport-mpm-olt-port-edit
* transport-xgspon-olt-infrastructure-edit
NB: Reusing same ONU-ID values is allowed across some xPON types.

Input parameters:

* dbru-control: Used to control whether the OLT applies DBRu or not for this ONU.
* mgmt-aes: Whether AES encryption should be enabled/disabled for the management GEM port of this ONU.
* olt-infrastructure-name: The name of the OLT infrastructure on which the v-ani interface will be created.
* onu-id: The ONU ID used at the transport layer.
* onu-loid: The Logical ONU ID (LOID) value that the OLT expects to retrieve from ONU. A string that has been assigned to the subscriber on the management level, entered into and stored in non-volatile storage at the ONU.  It is used to identify a particular ONU installed at a particular location.
* onu-registration-id: A string that has been assigned to the subscriber on the management level, entered into and stored in non-volatile storage at the ONU.  It is used to identify a particular ONU installed at a particular location.
* onu-serial-number: The serial number of the ONT which the OLT expects to show up.
* onu-template-name: The name of the ONU template to instantiate.
* pm-enable: If true, enables performance counters on this interface.
* speed-monitoring-enable: If true, enables speed monitoring for the interface for the supported periods.
* upstream-channel-speed: Upstream channel speed for this interface in bits per second. It must be 10 000 000 000 (10G) for XGS and 2500 000 000 (2.5 G) for XGPON.
* upstream-fec-enable: Used to enable/disable use of FEC in upstream direction for this specific ONU.
* v-ani-name: The name of the virtual ANI Interface that will be created.
* v-onu-mgmt: Whether this ONU is managed by virtual ONU management.

