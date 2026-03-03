This macro creates the UNICAST SERVICES QoS PBIT Marker policy, the marker policy can used for ingress qos profile.

Prerequisite: OLT device has to be created.

* marker-policy-type selects which marker policy type is applied out of :
	* tagged only
	* tagged and untagged
	
* vsi-tag-number defines how many tags are associated with the VSI where the policy is applied to :
    * single
	* dual

* defines the pbit marking value for single tag (configure outer marker only)
	* configure pbitx-to-outer-pbit-marking
	* configure untagged-to-outer-pbit-marking

* defines the pbit marking value for dual tag (configure both outer and inner marker)
	* configure pbitx-to-outer-pbit-marking
	* configure pbitx-to-inner-pbit-marking
	* configure untagged-to-outer-pbit-marking
	* configure untagged-to-inner-pbit-marking


Input parameters:

* copy-dei-from-inner-frame-tag: copy inner tag's dei to dei marking index-1
* copy-dei-from-outer-frame-tag: copy outer tag's dei to dei marking index-0
* copy-dei-from-outer-frame-tag-to-markinglist0and1: copy outer tag's dei to dei marking indexes 0 and 1
* copy-pbit-from-inner-frame-tag: copy inner tag's pbit to pbit marking index-1
* copy-pbit-from-outer-frame-tag: copy outer tag's pbit to pbit marking index-0
* copy-pbit-from-outer-frame-tag-to-markinglist0and1: copy outer tag's pbit to pbit marking indexes 0 and 1
* dei0-to-inner-dei-marking: marking inner TAG dei for dei 0
* dei0-to-outer-dei-marking: marking outer TAG dei for dei 0
* marker-policy-type: the marker policy type
* pbit0-to-inner-pbit-marking: marking inner TAG p-bit for pbit 0
* pbit0-to-outer-pbit-marking: marking outer TAG p-bit for pbit 0
* pbit1-to-inner-pbit-marking: marking inner TAG p-bit for pbit 1
* pbit1-to-outer-pbit-marking: marking outer TAG p-bit for pbit 1
* pbit2-to-inner-pbit-marking: marking inner TAG p-bit for pbit 2
* pbit2-to-outer-pbit-marking: marking outer TAG p-bit for pbit 2
* pbit3-to-inner-pbit-marking: marking inner TAG p-bit for pbit 3
* pbit3-to-outer-pbit-marking: marking outer TAG p-bit for pbit 3
* pbit4-to-inner-pbit-marking: marking inner TAG p-bit for pbit 4
* pbit4-to-outer-pbit-marking: marking outer TAG p-bit for pbit 4
* pbit5-to-inner-pbit-marking: marking inner TAG p-bit for pbit 5
* pbit5-to-outer-pbit-marking: marking outer TAG p-bit for pbit 5
* pbit6-to-inner-pbit-marking: marking inner TAG p-bit for pbit 6
* pbit6-to-outer-pbit-marking: marking outer TAG p-bit for pbit 6
* pbit7-to-inner-pbit-marking: marking inner TAG p-bit for pbit 7
* pbit7-to-outer-pbit-marking: marking outer TAG p-bit for pbit 7
* remarking-policy-name: pbit marker policy name
* untagged-to-inner-pbit-marking: marking inner TAG p-bit for untagged
* untagged-to-outer-pbit-marking: marking outer TAG p-bit for untagged
* vsi-tag-number: the marker's filter tag number should be aligned with applied vsi's tag number

