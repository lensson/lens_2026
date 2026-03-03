This macro creates a QoS pbit scheduling policy using enhanced filter

* A policy profile used for pbit scheduling is created.
* Several enhanced classifiers are created based on operator's input.
* Possible classifiers to be created include:
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

* filter-operation: Filters are applicable as any or all filters
* pbit-index0-cls0: Index of pbit marking list for classifier0
* pbit-index0-cls1: Index of pbit marking list for classifier1
* pbit-index0-cls2: Index of pbit marking list for classifier2
* pbit-index0-cls3: Index of pbit marking list for classifier3
* pbit-index0-cls4: Index of pbit marking list for classifier4
* pbit-index0-cls5: Index of pbit marking list for classifier5
* pbit-index0-cls6: Index of pbit marking list for classifier6
* pbit-index0-cls7: Index of pbit marking list for classifier7
* pbit-index1-cls0: Index of pbit marking list for classifier0
* pbit-index1-cls1: Index of pbit marking list for classifier1
* pbit-index1-cls2: Index of pbit marking list for classifier2
* pbit-index1-cls3: Index of pbit marking list for classifier3
* pbit-index1-cls4: Index of pbit marking list for classifier4
* pbit-index1-cls5: Index of pbit marking list for classifier5
* pbit-index1-cls6: Index of pbit marking list for classifier6
* pbit-index1-cls7: Index of pbit marking list for classifier7
* pbit-scheduling-policy-name: Policy name
* pbit-value0-for-index0-cls0: The pbit value(s) to match for pbit-index0 of classifier0
* pbit-value0-for-index0-cls1: The pbit value(s) to match for pbit-index0 of classifier1
* pbit-value0-for-index0-cls2: The pbit value(s) to match for pbit-index0 of classifier2
* pbit-value0-for-index0-cls3: The pbit value(s) to match for pbit-index0 of classifier3
* pbit-value0-for-index0-cls4: The pbit value(s) to match for pbit-index0 of classifier4
* pbit-value0-for-index0-cls5: The pbit value(s) to match for pbit-index0 of classifier5
* pbit-value0-for-index0-cls6: The pbit value(s) to match for pbit-index0 of classifier6
* pbit-value0-for-index0-cls7: The pbit value(s) to match for pbit-index0 of classifier7
* pbit-value0-for-index1-cls0: The pbit value(s) to match for pbit-index1 of classifier0
* pbit-value0-for-index1-cls1: The pbit value(s) to match for pbit-index1 of classifier1
* pbit-value0-for-index1-cls2: The pbit value(s) to match for pbit-index1 of classifier2
* pbit-value0-for-index1-cls3: The pbit value(s) to match for pbit-index1 of classifier3
* pbit-value0-for-index1-cls4: The pbit value(s) to match for pbit-index1 of classifier4
* pbit-value0-for-index1-cls5: The pbit value(s) to match for pbit-index1 of classifier5
* pbit-value0-for-index1-cls6: The pbit value(s) to match for pbit-index1 of classifier6
* pbit-value0-for-index1-cls7: The pbit value(s) to match for pbit-index1 of classifier7
* pbit-value1-for-index0-cls0: The pbit value(s) to match for pbit-index0 of classifier0
* pbit-value1-for-index0-cls1: The pbit value(s) to match for pbit-index0 of classifier1
* pbit-value1-for-index0-cls2: The pbit value(s) to match for pbit-index0 of classifier2
* pbit-value1-for-index0-cls3: The pbit value(s) to match for pbit-index0 of classifier3
* pbit-value1-for-index0-cls4: The pbit value(s) to match for pbit-index0 of classifier4
* pbit-value1-for-index0-cls5: The pbit value(s) to match for pbit-index0 of classifier5
* pbit-value1-for-index0-cls6: The pbit value(s) to match for pbit-index0 of classifier6
* pbit-value1-for-index0-cls7: The pbit value(s) to match for pbit-index0 of classifier7
* pbit-value1-for-index1-cls0: The pbit value(s) to match for pbit-index1 of classifier0
* pbit-value1-for-index1-cls1: The pbit value(s) to match for pbit-index1 of classifier1
* pbit-value1-for-index1-cls2: The pbit value(s) to match for pbit-index1 of classifier2
* pbit-value1-for-index1-cls3: The pbit value(s) to match for pbit-index1 of classifier3
* pbit-value1-for-index1-cls4: The pbit value(s) to match for pbit-index1 of classifier4
* pbit-value1-for-index1-cls5: The pbit value(s) to match for pbit-index1 of classifier5
* pbit-value1-for-index1-cls6: The pbit value(s) to match for pbit-index1 of classifier6
* pbit-value1-for-index1-cls7: The pbit value(s) to match for pbit-index1 of classifier7
* pbit-value2-for-index0-cls0: The pbit value(s) to match for pbit-index0 of classifier0
* pbit-value2-for-index0-cls1: The pbit value(s) to match for pbit-index0 of classifier1
* pbit-value2-for-index0-cls2: The pbit value(s) to match for pbit-index0 of classifier2
* pbit-value2-for-index0-cls3: The pbit value(s) to match for pbit-index0 of classifier3
* pbit-value2-for-index0-cls4: The pbit value(s) to match for pbit-index0 of classifier4
* pbit-value2-for-index0-cls5: The pbit value(s) to match for pbit-index0 of classifier5
* pbit-value2-for-index0-cls6: The pbit value(s) to match for pbit-index0 of classifier6
* pbit-value2-for-index0-cls7: The pbit value(s) to match for pbit-index0 of classifier7
* pbit-value2-for-index1-cls0: The pbit value(s) to match for pbit-index1 of classifier0
* pbit-value2-for-index1-cls1: The pbit value(s) to match for pbit-index1 of classifier1
* pbit-value2-for-index1-cls2: The pbit value(s) to match for pbit-index1 of classifier2
* pbit-value2-for-index1-cls3: The pbit value(s) to match for pbit-index1 of classifier3
* pbit-value2-for-index1-cls4: The pbit value(s) to match for pbit-index1 of classifier4
* pbit-value2-for-index1-cls5: The pbit value(s) to match for pbit-index1 of classifier5
* pbit-value2-for-index1-cls6: The pbit value(s) to match for pbit-index1 of classifier6
* pbit-value2-for-index1-cls7: The pbit value(s) to match for pbit-index1 of classifier7
* pbit-value3-for-index0-cls0: The pbit value(s) to match for pbit-index0 of classifier0
* pbit-value3-for-index0-cls1: The pbit value(s) to match for pbit-index0 of classifier1
* pbit-value3-for-index0-cls2: The pbit value(s) to match for pbit-index0 of classifier2
* pbit-value3-for-index0-cls3: The pbit value(s) to match for pbit-index0 of classifier3
* pbit-value3-for-index0-cls4: The pbit value(s) to match for pbit-index0 of classifier4
* pbit-value3-for-index0-cls5: The pbit value(s) to match for pbit-index0 of classifier5
* pbit-value3-for-index0-cls6: The pbit value(s) to match for pbit-index0 of classifier6
* pbit-value3-for-index0-cls7: The pbit value(s) to match for pbit-index0 of classifier7
* pbit-value3-for-index1-cls0: The pbit value(s) to match for pbit-index1 of classifier0
* pbit-value3-for-index1-cls1: The pbit value(s) to match for pbit-index1 of classifier1
* pbit-value3-for-index1-cls2: The pbit value(s) to match for pbit-index1 of classifier2
* pbit-value3-for-index1-cls3: The pbit value(s) to match for pbit-index1 of classifier3
* pbit-value3-for-index1-cls4: The pbit value(s) to match for pbit-index1 of classifier4
* pbit-value3-for-index1-cls5: The pbit value(s) to match for pbit-index1 of classifier5
* pbit-value3-for-index1-cls6: The pbit value(s) to match for pbit-index1 of classifier6
* pbit-value3-for-index1-cls7: The pbit value(s) to match for pbit-index1 of classifier7
* pbit-value4-for-index0-cls0: The pbit value(s) to match for pbit-index0 of classifier0
* pbit-value4-for-index0-cls1: The pbit value(s) to match for pbit-index0 of classifier1
* pbit-value4-for-index0-cls2: The pbit value(s) to match for pbit-index0 of classifier2
* pbit-value4-for-index0-cls3: The pbit value(s) to match for pbit-index0 of classifier3
* pbit-value4-for-index0-cls4: The pbit value(s) to match for pbit-index0 of classifier4
* pbit-value4-for-index0-cls5: The pbit value(s) to match for pbit-index0 of classifier5
* pbit-value4-for-index0-cls6: The pbit value(s) to match for pbit-index0 of classifier6
* pbit-value4-for-index0-cls7: The pbit value(s) to match for pbit-index0 of classifier7
* pbit-value4-for-index1-cls0: The pbit value(s) to match for pbit-index1 of classifier0
* pbit-value4-for-index1-cls1: The pbit value(s) to match for pbit-index1 of classifier1
* pbit-value4-for-index1-cls2: The pbit value(s) to match for pbit-index1 of classifier2
* pbit-value4-for-index1-cls3: The pbit value(s) to match for pbit-index1 of classifier3
* pbit-value4-for-index1-cls4: The pbit value(s) to match for pbit-index1 of classifier4
* pbit-value4-for-index1-cls5: The pbit value(s) to match for pbit-index1 of classifier5
* pbit-value4-for-index1-cls6: The pbit value(s) to match for pbit-index1 of classifier6
* pbit-value4-for-index1-cls7: The pbit value(s) to match for pbit-index1 of classifier7
* pbit-value5-for-index0-cls0: The pbit value(s) to match for pbit-index0 of classifier0
* pbit-value5-for-index0-cls1: The pbit value(s) to match for pbit-index0 of classifier1
* pbit-value5-for-index0-cls2: The pbit value(s) to match for pbit-index0 of classifier2
* pbit-value5-for-index0-cls3: The pbit value(s) to match for pbit-index0 of classifier3
* pbit-value5-for-index0-cls4: The pbit value(s) to match for pbit-index0 of classifier4
* pbit-value5-for-index0-cls5: The pbit value(s) to match for pbit-index0 of classifier5
* pbit-value5-for-index0-cls6: The pbit value(s) to match for pbit-index0 of classifier6
* pbit-value5-for-index0-cls7: The pbit value(s) to match for pbit-index0 of classifier7
* pbit-value5-for-index1-cls0: The pbit value(s) to match for pbit-index1 of classifier0
* pbit-value5-for-index1-cls1: The pbit value(s) to match for pbit-index1 of classifier1
* pbit-value5-for-index1-cls2: The pbit value(s) to match for pbit-index1 of classifier2
* pbit-value5-for-index1-cls3: The pbit value(s) to match for pbit-index1 of classifier3
* pbit-value5-for-index1-cls4: The pbit value(s) to match for pbit-index1 of classifier4
* pbit-value5-for-index1-cls5: The pbit value(s) to match for pbit-index1 of classifier5
* pbit-value5-for-index1-cls6: The pbit value(s) to match for pbit-index1 of classifier6
* pbit-value5-for-index1-cls7: The pbit value(s) to match for pbit-index1 of classifier7
* pbit-value6-for-index0-cls0: The pbit value(s) to match for pbit-index0 of classifier0
* pbit-value6-for-index0-cls1: The pbit value(s) to match for pbit-index0 of classifier1
* pbit-value6-for-index0-cls2: The pbit value(s) to match for pbit-index0 of classifier2
* pbit-value6-for-index0-cls3: The pbit value(s) to match for pbit-index0 of classifier3
* pbit-value6-for-index0-cls4: The pbit value(s) to match for pbit-index0 of classifier4
* pbit-value6-for-index0-cls5: The pbit value(s) to match for pbit-index0 of classifier5
* pbit-value6-for-index0-cls6: The pbit value(s) to match for pbit-index0 of classifier6
* pbit-value6-for-index0-cls7: The pbit value(s) to match for pbit-index0 of classifier7
* pbit-value6-for-index1-cls0: The pbit value(s) to match for pbit-index1 of classifier0
* pbit-value6-for-index1-cls1: The pbit value(s) to match for pbit-index1 of classifier1
* pbit-value6-for-index1-cls2: The pbit value(s) to match for pbit-index1 of classifier2
* pbit-value6-for-index1-cls3: The pbit value(s) to match for pbit-index1 of classifier3
* pbit-value6-for-index1-cls4: The pbit value(s) to match for pbit-index1 of classifier4
* pbit-value6-for-index1-cls5: The pbit value(s) to match for pbit-index1 of classifier5
* pbit-value6-for-index1-cls6: The pbit value(s) to match for pbit-index1 of classifier6
* pbit-value6-for-index1-cls7: The pbit value(s) to match for pbit-index1 of classifier7
* pbit-value7-for-index0-cls0: The pbit value(s) to match for pbit-index0 of classifier0
* pbit-value7-for-index0-cls1: The pbit value(s) to match for pbit-index0 of classifier1
* pbit-value7-for-index0-cls2: The pbit value(s) to match for pbit-index0 of classifier2
* pbit-value7-for-index0-cls3: The pbit value(s) to match for pbit-index0 of classifier3
* pbit-value7-for-index0-cls4: The pbit value(s) to match for pbit-index0 of classifier4
* pbit-value7-for-index0-cls5: The pbit value(s) to match for pbit-index0 of classifier5
* pbit-value7-for-index0-cls6: The pbit value(s) to match for pbit-index0 of classifier6
* pbit-value7-for-index0-cls7: The pbit value(s) to match for pbit-index0 of classifier7
* pbit-value7-for-index1-cls0: The pbit value(s) to match for pbit-index1 of classifier0
* pbit-value7-for-index1-cls1: The pbit value(s) to match for pbit-index1 of classifier1
* pbit-value7-for-index1-cls2: The pbit value(s) to match for pbit-index1 of classifier2
* pbit-value7-for-index1-cls3: The pbit value(s) to match for pbit-index1 of classifier3
* pbit-value7-for-index1-cls4: The pbit value(s) to match for pbit-index1 of classifier4
* pbit-value7-for-index1-cls5: The pbit value(s) to match for pbit-index1 of classifier5
* pbit-value7-for-index1-cls6: The pbit value(s) to match for pbit-index1 of classifier6
* pbit-value7-for-index1-cls7: The pbit value(s) to match for pbit-index1 of classifier7
* pbit0-tc: Traffic class to be associated with classifier0 pbits.
* pbit1-tc: Traffic class to be associated with classifier1 pbits.
* pbit2-tc: Traffic class to be associated with classifier2 pbits.
* pbit3-tc: Traffic class to be associated with classifier3 pbits.
* pbit4-tc: Traffic class to be associated with classifier4 pbits.
* pbit5-tc: Traffic class to be associated with classifier5 pbits.
* pbit6-tc: Traffic class to be associated with classifier6 pbits.
* pbit7-tc: Traffic class to be associated with classifier7 pbits.

