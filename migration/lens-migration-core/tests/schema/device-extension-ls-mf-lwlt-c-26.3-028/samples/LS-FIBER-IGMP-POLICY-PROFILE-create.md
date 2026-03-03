This macro creates Multicast QoS Policy Management Profile.

Successful execution results in a complete set of QoS Policy profiles being created:

* a classifier that classifies the IGMP protocol frame and generates the Pbit as the value of PBIT-For-IGMP:
  * classifier_igmp_egress
* a policy that contains the classifier for IGMP protocol frame, classifier_igmp_egress
  * policy_igmp_egress
* a qos profile that contains the policy for IGMP protocol frame, policy_igmp_egress
  * qos_profile_igmp_egress

If all of the profiles with the specified name don't exist before, then they are created.
If the profile with the specified name exists before, then the command will be rejected.

Pre-condition:

* the set of profiles (see further) shall not already exist.

Input parameters:

* other-policy: the other policy in the qos policy profile
* pbit-for-igmp: the pbit for IGMP protocol frame, default value is 7
* qos-policy-profile-has-more-policy: if true, one qos policy profile will add the IGMP policy
* qos-profile-egress: the qos policy profile which add IGMP policy
* qos-profile-igmp-egress: 

