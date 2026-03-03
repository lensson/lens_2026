This macro edit/create the  PTP interface configuration data . 

* Every ONU owns its own PTP profile.
* One ONU should use one same PTP profile for all the uni ports.

Pre-condition:

* Before creating the PTP interface, ptp-profile need to be created.
* It should use same PTP profile type with OLT.

Input parameters:

* autoneg-status: to enable/disable auto negotiation function on uni interface.
* enable: to enable/disable PTP on uni interface.
* onu-name: the custom name of the onu.
* profile-name: the custom name of the uni PTP profile.It should use one same PTP profile for all uni ports on one ONU.
* profile-type: the spec type of the PTP profile.The allowed values are [g8275.1, ccsa]. It should use same PTP profile type for all uni ports on one ONU.
* uni-name: the custom name of the uni interface.
* uni-port-layer-if-name: the custom name of the uni port layer interface.

