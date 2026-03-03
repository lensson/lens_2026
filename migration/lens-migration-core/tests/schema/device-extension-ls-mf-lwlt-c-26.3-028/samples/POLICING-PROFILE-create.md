This macro creates a QoS policing profile.

* a policing policer is created with a couple of parameters to be set.

Pre-condition:

* OLT device has to be created.
* UNICAST-SERVICES-QOS-POLICY-PROFILES-POLICING_ACTION_PROFILE-create
* UNICAST-SERVICES-QOS-POLICY-PROFILES-POLICING_PRE_HANDLING_PROFILE-create

Input parameters:

* policing-action-profile-name: policing action profile name
* policing-cbs: the amount of traffic that can be admitted above the CIR and is considered green.
* policing-cir: the average rate of traffic that respect the guarantees of bandwidth
* policing-color-mode: color mode of the policer, should be color-aware or color-blind
* policing-coupling-flag: flag indicating whether tokens that would overflow the C-bucket should be added to the E-bucket
* policing-ebs: the amount of excessive traffic that can be admitted above the EIR without being discarded directly by the policer (yellow).
* policing-eir: how much traffic exceeding the CIR can be admitted in the network with the assurance that it will not be discarded directly by the policer.
* policing-pre-handling-profile-name: policing-pre-handling-profile name
* policing-profile-name: Policing profile name
* policing-scope: the scope of the policer instance sharing is within ethernet-interface or vlan-sub-interface, without configuring scope means sharing within ccl conditions in same vsi.
* policing-type: type of policer, trtcm(two-rate-three-color-marker) or srtcm(single-rate-two-color-marker)

