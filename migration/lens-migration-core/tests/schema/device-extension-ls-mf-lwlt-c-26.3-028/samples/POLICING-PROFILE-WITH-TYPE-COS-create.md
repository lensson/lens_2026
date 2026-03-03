This macro creates a QoS policing profile.

* A policing profile of policing type is CoS variants which are trTCM-CoS and trTCM-Mef-CoS is set.

Pre-condition:

* OLT device has to be created.

Input parameters:

* policing-action-profile-name: Policing action profile name
* policing-cbs: the amount of traffic that can be admitted above the CIR and is considered green.
* policing-cir: the average rate of traffic that respect the guarantees of bandwidth
* policing-coupling-flag: flag indicating whether tokens that would overflow the C-bucket should be added to the E-bucket
* policing-ebs: the amount of excessive traffic that can be admitted above the EIR without being discarded directly by the policer (yellow).
* policing-eir: how much traffic exceeding the CIR can be admitted in the network with the assurance that it will not be discarded directly by the policer.
* policing-pbs: the amount of traffic that can be admitted above the PIR (burst) without being discarded directly by the policer (yellow).
* policing-pir: average rate of traffic that is admitted in the network with the assurance that it will not be discarded directly by the policer.
* policing-pre-handling-profile-name: Policing pre handling profile name
* policing-profile-name: Policing profile name
* policing-scope: the scope of the policer instance sharing is within ethernet-interface or vlan-sub-interface, without configuring scope means sharing within ccl conditions in same vsi.
* policing-tc-cbs-0: Identifies the policing-traffic-class value in cbs bucket
* policing-tc-cbs-1: Identifies the policing-traffic-class value in cbs bucket
* policing-tc-cbs-2: Identifies the policing-traffic-class value in cbs bucket
* policing-tc-cbs-3: Identifies the policing-traffic-class value in cbs bucket
* policing-tc-cbs-4: Identifies the policing-traffic-class value in cbs bucket
* policing-tc-cbs-5: Identifies the policing-traffic-class value in cbs bucket
* policing-tc-cbs-6: Identifies the policing-traffic-class value in cbs bucket
* policing-tc-cbs-7: Identifies the policing-traffic-class value in cbs bucket
* policing-tc-cbs-threshold-0: Identifies the threshold value for a policing-tc-cbs-0
* policing-tc-cbs-threshold-1: Identifies the threshold value for a policing-tc-cbs-1
* policing-tc-cbs-threshold-2: Identifies the threshold value for a policing-tc-cbs-2
* policing-tc-cbs-threshold-3: Identifies the threshold value for a policing-tc-cbs-3
* policing-tc-cbs-threshold-4: Identifies the threshold value for a policing-tc-cbs-4
* policing-tc-cbs-threshold-5: Identifies the threshold value for a policing-tc-cbs-5
* policing-tc-cbs-threshold-6: Identifies the threshold value for a policing-tc-cbs-6
* policing-tc-cbs-threshold-7: Identifies the threshold value for a policing-tc-cbs-7
* policing-tc-ebs-0: Identifies the policing-traffic-class value in ebs bucket
* policing-tc-ebs-1: Identifies the policing-traffic-class value in ebs bucket
* policing-tc-ebs-2: Identifies the policing-traffic-class value in ebs bucket
* policing-tc-ebs-3: Identifies the policing-traffic-class value in ebs bucket
* policing-tc-ebs-4: Identifies the policing-traffic-class value in ebs bucket
* policing-tc-ebs-5: Identifies the policing-traffic-class value in ebs bucket
* policing-tc-ebs-6: Identifies the policing-traffic-class value in ebs bucket
* policing-tc-ebs-7: Identifies the policing-traffic-class value in ebs bucket
* policing-tc-ebs-threshold-0: Identifies the threshold value for a policing-tc-ebs-0
* policing-tc-ebs-threshold-1: Identifies the threshold value for a policing-tc-ebs-1
* policing-tc-ebs-threshold-2: Identifies the threshold value for a policing-tc-ebs-2
* policing-tc-ebs-threshold-3: Identifies the threshold value for a policing-tc-ebs-3
* policing-tc-ebs-threshold-4: Identifies the threshold value for a policing-tc-ebs-4
* policing-tc-ebs-threshold-5: Identifies the threshold value for a policing-tc-ebs-5
* policing-tc-ebs-threshold-6: Identifies the threshold value for a policing-tc-ebs-6
* policing-tc-ebs-threshold-7: Identifies the threshold value for a policing-tc-ebs-7
* policing-tc-pbs-0: Identifies the policing-traffic-class value in pbs bucket
* policing-tc-pbs-1: Identifies the policing-traffic-class value in pbs bucket
* policing-tc-pbs-2: Identifies the policing-traffic-class value in pbs bucket
* policing-tc-pbs-3: Identifies the policing-traffic-class value in pbs bucket
* policing-tc-pbs-4: Identifies the policing-traffic-class value in pbs bucket
* policing-tc-pbs-5: Identifies the policing-traffic-class value in pbs bucket
* policing-tc-pbs-6: Identifies the policing-traffic-class value in pbs bucket
* policing-tc-pbs-7: Identifies the policing-traffic-class value in pbs bucket
* policing-tc-pbs-threshold-0: Identifies the threshold value for a policing-tc-pbs-0
* policing-tc-pbs-threshold-1: Identifies the threshold value for a policing-tc-pbs-1
* policing-tc-pbs-threshold-2: Identifies the threshold value for a policing-tc-pbs-2
* policing-tc-pbs-threshold-3: Identifies the threshold value for a policing-tc-pbs-3
* policing-tc-pbs-threshold-4: Identifies the threshold value for a policing-tc-pbs-4
* policing-tc-pbs-threshold-5: Identifies the threshold value for a policing-tc-pbs-5
* policing-tc-pbs-threshold-6: Identifies the threshold value for a policing-tc-pbs-6
* policing-tc-pbs-threshold-7: Identifies the threshold value for a policing-tc-pbs-7
* policing-type-cos: type of policer trtcm-with-cos (two-rate-three-color-marker-with-cos) or trtcm-mef-with-cos(two-rate-three-color-marker-mef-with-cos)

