Description:
This sample configures the VSI parameters.

Prerequisite:
device has to be created.
Ethernet port has to be created

Input parameters:

* anyframe-auto-instantiate: Specifies if anyframe traffic rule is enabled by default when creating a ONU instance from a ONU template
* anyframe-traffic: A boolean flag enabling user-side anyframe traffic
* cc-name: The name of the VLAN sub-interface that will be created
* downstream-aes: Used to designate whether AES should be enabled/disabled for GEM ports for the downstream direction.
* enet-name: The name of the Ethernet UNI on which the local cross-connect is configured
* ethernet-frame-type: The value to be compared with the second Ethertype to identify the VLAN tag number.
* gemport-sharing: Used to designate whether sharing gemport on uni
* ingress-qos-profile-name: Specifies the the QoS handling for the user-side traffic. The QoS handling can include remarking rules which can be used to mark the upstream traffic. The actual marking is enabled through the parameters with suffix US-PBIT
* n-vlan-id: The normalized VLAN used in between the ONU and the OLT. The N-VLAN-ID can be empty, meaning the user-side traffic will be forwarded as is
* onu-name: ONU name
* prio-tagged-auto-instantiate: Specifies if priority tagged traffic rule is enabled by default when creating a ONU instance from a ONU template
* prio-tagged-traffic: A boolean flag to enable user-side priority tagged traffic
* prio-tagged-us-pbit: Specifies how the inner VLAN pbit is marked in the upstream traffic towards the network. Options are copy from the user-side, copy from a marking pbit derived from the user-side pbit or DSCP, or a fixed value (0..7)
* tagged-auto-instantiate: Specifies if tagged traffic rule is enabled by default when creating a ONU instance from a ONU template
* tagged-q-vlan-id: The VLAN ID used to match the ingress user-side traffic, can be a value between 1..4094 or any
* tagged-traffic: A boolean flag to enable user-side tagged traffic.
* tagged-us-pbit: Specifies how the inner VLAN pbit is marked in the upstream traffic towards the network. Options are copy from the user-side, copy from a marking pbit derived from the user-side pbit or DSCP, or a fixed value (0..7)
* tc0-gemport-id: GEM Port ID used for the configured Traffic Class 0. The value must be left empty when using the macro for configuring a ONU template
* tc0-tcont-name: T-CONT name of gemport for the configured Traffic Class 0
* tc1-gemport-id: GEM Port ID used for the configured Traffic Class 1. The value must be left empty when using the macro for configuring a ONU template
* tc1-tcont-name: T-CONT name of gemport for the configured Traffic Class 1
* tc2-gemport-id: GEM Port ID used for the configured Traffic Class 2. The value must be left empty when using the macro for configuring a ONU template
* tc2-tcont-name: T-CONT name of gemport for the configured Traffic Class 2
* tc3-gemport-id: GEM Port ID used for the configured Traffic Class 3. The value must be left empty when using the macro for configuring a ONU template
* tc3-tcont-name: T-CONT name of gemport for the configured Traffic Class 3
* tc4-gemport-id: GEM Port ID used for the configured Traffic Class 4. The value must be left empty when using the macro for configuring a ONU template
* tc4-tcont-name: T-CONT name of gemport for the configured Traffic Class 4
* tc5-gemport-id: GEM Port ID used for the configured Traffic Class 5. The value must be left empty when using the macro for configuring a ONU template
* tc5-tcont-name: T-CONT name of gemport for the configured Traffic Class 5
* tc6-gemport-id: GEM Port ID used for the configured Traffic Class 6. The value must be left empty when using the macro for configuring a ONU template
* tc6-tcont-name: T-CONT name of gemport for the configured Traffic Class 6
* tc7-gemport-id: GEM Port ID used for the configured Traffic Class 7. The value must be left empty when using the macro for configuring a ONU template
* tc7-tcont-name: T-CONT name of gemport for the configured Traffic Class 7
* untagged-auto-instantiate: Specifies if untagged traffic rule is enabled by default when creating a ONU instance from a ONU template
* untagged-traffic: A boolean flag enabling user-side untagged traffic
* upstream-aes: Used to designate whether AES should be enabled/disabled for GEM ports for the upstream direction
* vsi-auto-instantiate: Specifies if VSI interface enabled by default when creating a ONU instance from a ONU template

