This macro creates the g8275dot1/ccsa PTP profile configuration data for specific onu.

* 'step-mode' value should be consistent with the ONU type.

Input parameters:

* dest-mac-addr-forwardable: the dest-mac-addr-forwardable value of the PTP profile. allowed values are ['forwardable', 'non-forwardable']
* onu-name: the custom name of the onu.
* profile-name: the custom name of the PTP profile.
* profile-type: the spec type of the PTP profile. allowed values are [g8275dot1, ccsa]. Recommend to using same ptp profile type with OLT.
* step-mode: the step-mode value of the PTP profile.

