This macro configures how many zeros should be added in Onuslot/Onuport numbering to achieve the desired string length.

Applies to the keywords "Onuslot" and "Onuport" when inserted by the following protocols:

* DHCPv4 when used to insert the information in option 82.
* DHCPv6 when used to insert the information in option 18 and option 37.
* PPPoE when used to insert the information in the PPPoE relay tag.
* RADIUS, when used to insert information in the NAS-Port-Id attribute (87).

Range: 1 to 5, with a default value of 1 for both onu-slot-minimum-string-length and onu-port-minimum-string-length attributes.

Input parameters:

* onu-port-minimum-string-length: Determines if the ONU port numbering MUST use leading 0's or not, and how many 0's are added to achieve the desired string length. e.g., configuring 2 and if port-id = 1, keyword Onuport will be replaced by value 01. It indicates the minimum string length and actual value can be larger if needed. e.g., configuring 1 and port-id = 12 would be allowed since string length 2 >= 1"
* onu-slot-minimum-string-length: Determines if the ONU slot numbering MUST use leading 0's or not, and how many 0's are added to achieve the desired string length. e.g., configuring 2 and if slot-id = 1, keyword Onuslot will be replaced by value 01. It indicates the minimum string length and actual value can be larger if needed. e.g., configuring 1 and slot-id = 12 would be allowed since string length 2 >= 1"

