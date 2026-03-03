This macro creates a QoS pbit scheduling policy along with several classifiers

* a policy profile used for pbit scheduling is created.
* several classifiers are created based on operator's input.
* possible classifiers to be created include:
  * cls0-x
  * cls1-x
  * cls2-x
  * cls3-x
  * cls4-x
  * cls5-x
  * cls6-x
  * cls7-x

Pre-condition:

* OLT device has to be created.

Input parameters:

* cls0-pbit-value-0: The pbit value of outer TAG for classifier0
* cls0-pbit-value-1: The pbit value of inner TAG for classifier0
* cls1-pbit-value-0: The pbit value of outer TAG for classifier1
* cls1-pbit-value-1: The pbit value of inner TAG for classifier1
* cls2-pbit-value-0: The pbit value of outer TAG for classifier2
* cls2-pbit-value-1: The pbit value of inner TAG for classifier2
* cls3-pbit-value-0: The pbit value of outer TAG for classifier3
* cls3-pbit-value-1: The pbit value of inner TAG for classifier3
* cls4-pbit-value-0: The pbit value of outer TAG for classifier4
* cls4-pbit-value-1: The pbit value of inner TAG for classifier4
* cls5-pbit-value-0: The pbit value of outer TAG for classifier5
* cls5-pbit-value-1: The pbit value of inner TAG for classifier5
* cls6-pbit-value-0: The pbit value of outer TAG for classifier6
* cls6-pbit-value-1: The pbit value of inner TAG for classifier6
* cls7-pbit-value-0: The pbit value of outer TAG for classifier7
* cls7-pbit-value-1: The pbit value of inner TAG for classifier7
* pbit-scheduling-policy-name: Policy name
* pbit0-tc: Traffic class to be associated with pbit0
* pbit1-tc: Traffic class to be associated with pbit1
* pbit2-tc: Traffic class to be associated with pbit2
* pbit3-tc: Traffic class to be associated with pbit3
* pbit4-tc: Traffic class to be associated with pbit4 (if specified)
* pbit5-tc: Traffic class to be associated with pbit5 (if specified)
* pbit6-tc: Traffic class to be associated with pbit6 (if specified)
* pbit7-tc: Traffic class to be associated with pbit7 (if specified)

