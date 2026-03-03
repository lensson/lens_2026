This macro deletes a QoS CCL policy.

* Delete the QoS CCL policy profile.
* Delete the classifier referred by QoS CCL policy profile above.
* Delete enhance-filter referred by classifier.

Pre-condition:

* UNICAST-SERVICES-QOS-POLICY-PROFILES-CCL_POLICY-create

Input parameters:

* ccl-policy-name: ccl policy name
* classifier-name-list: all classifiers name in ccl policy

