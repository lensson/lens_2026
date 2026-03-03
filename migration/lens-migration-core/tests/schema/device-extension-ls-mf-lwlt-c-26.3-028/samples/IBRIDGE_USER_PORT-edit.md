This sample connects a user to an N:1-VLAN Forwarder.  

* It creates a VLAN sub-interface at the user / subtended-node interface to match classification for single tagged frames.  
* It attaches this VLAN sub-interface to the specified Forwarder.  
  
Pre-condition:  

* the referenced user / subtended-node interface must exist.  
* the referenced N:1-VLAN Forwarder must exist.  
* the QoS policy profiles referenced by the VLAN sub-interface must exist (by default named "UPSTREAM_USERPORT" and "DOWNSTREAM_USERPORT").  

Input parameters:

* downstream-aes: Used to designate whether AES should be enabled/disabled for GEM ports for the downstream direction
* egress-qos-policy-profile-name: the qos policy profile name referenced by the VLAN sub-interface for egress
* enet-name: The name of the virtual UNI on which the local cross-connect is configured
* frame-processing-profiles-name: the name of the N-VLAN profile
* gemport-sharing: Used to indicate whether gemport sharing is enabled. Setting this variable to false means that gemports are associated with VLAN sub-interface; setting this variable to true means that gemports are not associated with VLAN sub-interface and they are shared between the VLAN sub-interfaces on top of the lower layer interface. Not setting this variable defaults the value to be false(gemport sharing is disabled).
* ibridge-name: The name of network-side VLAN sub-interface, which is connected to either the backplane or the uplink interfaces and ports
* ibridge-user-port-name: The name of the local VLAN port on the OLT. The macro will create the LT-side configuration as well as enabling (instantiating) the cross-connect when the ONU is configured by template
* ingress-qos-policy-profile-name: the qos policy profile for the ingress traffic at the LT-side
* ip-anti-spoofing: Control flag to enable IPv4 address security checks on incoming packets on the VLAN sub-interface
* ip-anti-spoofing-statistics: Control flag to enable IPv4 security check statistics of the user interface are collected. This setting requires that ip-anti-spoofing must be set to true
* leaf-scheduler-name: The leaf scheduler name to which the traffic is sent in downstream
* max-number-mac-address: the maximum number of MAC addresses that can be stored in the forwarding database for this interface
* olt-infrastructure-name: The OLT infrastructure name used as root for traffic scheduling
* onu-ingress-qos-policy-profile-name: the qos policy profile name that overrides the ingress QoS policy profile configured in the ONU template. This parameter must be left empty in case the ONU is directly configured (without ONU template)
* onu-name: The name of ONU instance for enabling the ONU-side cross-connect and the related user-side traffic types
* onu-template-cc-name: The name of the VLAN sub-interface created by the cross-connect macro in the ONU template
* onu-template-instantiate-anyframe: Enables the anyframe traffic on this VLAN sub-interface as defined in the ONU template
* onu-template-instantiate-prio-tagged: Enables the priority tagged traffic on this VLAN sub-interface as defined in the ONU template
* onu-template-instantiate-tagged: Enables the tagged traffic on this VLAN sub-interface as defined in the ONU template
* onu-template-instantiate-untagged: Enables the untagged traffic on this VLAN sub-interface as defined in the ONU template
* performance-enable: Control flag to enable counting of performance statistics
* tc0-gemport-id: The GEM Port ID used for the configured Traffic Class
* tc0-gemport-set-name: GEMPORT set name to indicate no-sharing, uni-sharing or onu-sharing for traffic class 0
* tc1-gemport-id: The GEM Port ID used for the configured Traffic Class
* tc1-gemport-set-name: GEMPORT set name to indicate no-sharing, uni-sharing or onu-sharing for traffic class 1
* tc2-gemport-id: The GEM Port ID used for the configured Traffic Class
* tc2-gemport-set-name: GEMPORT set name to indicate no-sharing, uni-sharing or onu-sharing for traffic class 2
* tc3-gemport-id: The GEM Port ID used for the configured Traffic Class
* tc3-gemport-set-name: GEMPORT set name to indicate no-sharing, uni-sharing or onu-sharing for traffic class 3
* tc4-gemport-id: The GEM Port ID used for the configured Traffic Class
* tc4-gemport-set-name: GEMPORT set name to indicate no-sharing, uni-sharing or onu-sharing for traffic class 4
* tc5-gemport-id: The GEM Port ID used for the configured Traffic Class
* tc5-gemport-set-name: GEMPORT set name to indicate no-sharing, uni-sharing or onu-sharing for traffic class 5
* tc6-gemport-id: The GEM Port ID used for the configured Traffic Class
* tc6-gemport-set-name: GEMPORT set name to indicate no-sharing, uni-sharing or onu-sharing for traffic class 6
* tc7-gemport-id: The GEM Port ID used for the configured Traffic Class
* tc7-gemport-set-name: GEMPORT set name to indicate no-sharing, uni-sharing or onu-sharing for traffic class 7
* upstream-aes: Used to designate whether AES should be enabled/disabled for GEM ports for the upstream direction
* vector-of-data-name: The name of vector of data profile

