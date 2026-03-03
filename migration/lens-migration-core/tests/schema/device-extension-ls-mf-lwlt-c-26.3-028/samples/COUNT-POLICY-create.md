This macro creates a QoS count policy along with several classifiers

* a policy profile used for count is created.
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

* count-policy-name: Policy name
* filter-operation: Filters are applicable as any or all filters
* pbit-0: The p-bit value of outer TAG for counting flow-stats
* pbit-1: The p-bit value of outer TAG for counting flow-stats
* pbit-2: The p-bit value of outer TAG for counting flow-stats
* pbit-3: The p-bit value of outer TAG for counting flow-stats
* pbit-4: The p-bit value of outer TAG for counting flow-stats
* pbit-5: The p-bit value of outer TAG for counting flow-stats
* pbit-6: The p-bit value of outer TAG for counting flow-stats
* pbit-7: The p-bit value of outer TAG for counting flow-stats
* pbit-index-0: The index associated with a metadata P-bit value
* pbit-index-1: The index associated with a metadata P-bit value
* pbit-type: the pbit policy type
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

