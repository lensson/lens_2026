This macro creates a QoS Queue color policy along with several classifiers

* a policy profile used for Queue color policy is created.
* several classifiers are created based on operator's input.
* possible classifiers to be created include:
  * classifier0-x
  * classifier1-x
  * classifier2-x
  * classifier3-x
  * classifier4-x
  * classifier5-x
  * classifier6-x
  * classifier7-x

Pre-condition:

* OLT device has to be created.

Input parameters:

* color-0: the bac-color action
* color-1: the bac-color action
* color-2: the bac-color action
* color-3: the bac-color action
* color-4: the bac-color action
* color-5: the bac-color action
* color-6: the bac-color action
* color-7: the bac-color action
* color-policy-name: Policy name
* dei-0: The dei value to match for marking bac-color
* dei-1: the dei value to match for marking bac-color
* dei-index: index of dei marking list
* inner-tag-dei-to-color-0: The inner tag dei to be mapped for marking bac-color
* inner-tag-dei-to-color-1: The inner tag dei to be mapped for marking bac-color
* inner-tag-pbit-to-color-0: The inner tag pbit list to be mapped for marking bac-color
* inner-tag-pbit-to-color-1: The inner tag pbit list to be mapped for marking bac-color
* inner-tag-pbit-to-color-2: The inner tag pbit list to be mapped for marking bac-color
* inner-tag-pbit-to-color-3: The inner tag pbit list to be mapped for marking bac-color
* inner-tag-pbit-to-color-4: The inner tag pbit list to be mapped for marking bac-color
* inner-tag-pbit-to-color-5: The inner tag pbit list to be mapped for marking bac-color
* inner-tag-pbit-to-color-6: The inner tag pbit list to be mapped for marking bac-color
* inner-tag-pbit-to-color-7: The inner tag pbit list to be mapped for marking bac-color
* match-type: the match type for the policy
* metered-color: True if the color is marked after policing by certain policer types.
* outer-tag-dei-to-color-0: The outer tag dei to be mapped for marking bac-color
* outer-tag-dei-to-color-1: The outer tag dei to be mapped for marking bac-color
* outer-tag-pbit-to-color-0: The outer tag pbit list to be mapped for marking bac-color
* outer-tag-pbit-to-color-1: The outer tag pbit list to be mapped for marking bac-color
* outer-tag-pbit-to-color-2: The outer tag pbit list to be mapped for marking bac-color
* outer-tag-pbit-to-color-3: The outer tag pbit list to be mapped for marking bac-color
* outer-tag-pbit-to-color-4: The outer tag pbit list to be mapped for marking bac-color
* outer-tag-pbit-to-color-5: The outer tag pbit list to be mapped for marking bac-color
* outer-tag-pbit-to-color-6: The outer tag pbit list to be mapped for marking bac-color
* outer-tag-pbit-to-color-7: The outer tag pbit list to be mapped for marking bac-color
* pbit-index-0: The p-bit index to match for enhanced classifier pbit-marking-list
* pbit-index-1: The p-bit index to match for enhanced classifier pbit-marking-list
* pbit-value0-for-index-0: The p-bit value to match for pbit-index-0
* pbit-value0-for-index-1: The p-bit value to match for pbit-index-1
* pbit-value1-for-index-0: The p-bit value to match for pbit-index-0
* pbit-value1-for-index-1: The p-bit value to match for pbit-index-1
* pbit-value2-for-index-0: The p-bit value to match for pbit-index-0
* pbit-value2-for-index-1: The p-bit value to match for pbit-index-1
* pbit-value3-for-index-0: The p-bit value to match for pbit-index-0
* pbit-value3-for-index-1: The p-bit value to match for pbit-index-1
* pbit-value4-for-index-0: The p-bit value to match for pbit-index-0
* pbit-value4-for-index-1: The p-bit value to match for pbit-index-1
* pbit-value5-for-index-0: The p-bit value to match for pbit-index-0
* pbit-value5-for-index-1: The p-bit value to match for pbit-index-1
* pbit-value6-for-index-0: The p-bit value to match for pbit-index-0
* pbit-value6-for-index-1: The p-bit value to match for pbit-index-1
* pbit-value7-for-index-0: The p-bit value to match for pbit-index-0
* pbit-value7-for-index-1: The p-bit value to match for pbit-index-1

