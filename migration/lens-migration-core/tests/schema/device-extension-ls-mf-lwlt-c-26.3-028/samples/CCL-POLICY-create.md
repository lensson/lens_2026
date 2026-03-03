This macro creates a QoS CCL policy.

* Create a enhance-filter.
* Create a classifier referring the enhance-filter above as CCL filter.
* Create a QoS CCL policy with this classifier.

Pre-condition: 
If do the policing for ccl, Policing profile must be created by unicast-qos-policy-profiles-policing_profile-edit

Input parameters:

* ccl-policing-action: Do the policing for ccl if it is true
* ccl-policy-name: ccl policy name
* classifier-name: Classifier name
* dei: Filter containing DEI bit value to be matched with the values of the corresponding packet fields
* dei-marking-list: A DEI value to be used as match criteria
* dest-any-multicast: This represents the any multicast mac address of destination mac
* dest-broadcast: This represents the broadcast mac address of destination mac
* dest-cfm-multicast: This represents a mask for all CFM OAM multicast addresses of destination mac
* dest-ipv4-address: The destination ipv4 address in the frame's ipv4 header, e.g. 135.251.160.0/24
* dest-ipv4-multicast: This represents a mask for all ipv4 multicast addresses of destination mac
* dest-ipv6-address: The destination IPV6 address in the frame's IPv6 header, e.g. 2001:3456::/32
* dest-ipv6-multicast: This represents a mask for all IPv6 multicast addresses of destination mac
* dest-lower-port: The lower-port of destination port range
* dest-mac-address: Enable/disable setting a filter on the destination mac address
* dest-mac-mask: A specific mac address mask of destination mac, e.g. FF:FF:FF:FF:FF:FF
* dest-mac-specific: Indicate the value and the mask together identify a set of mac addresses of destination mac
* dest-mac-value: A specific mac address of destination mac, e.g. 01:02:03:04:05:06
* dest-unicast: This represents the unicast mac address of destination mac
* dest-upper-port: The upper-port of destination port range
* discard-action: discard the packets for ccl if it is true
* dscp: String identifying the DSCP values and/or range, e.g. 2,34-36,63
* enhance-filter-operation: Specifies how the entries of the 'filter' list have to be combined, the values should be match-all-filter or match-any-filter
* ethernet-frame-type: The value to be compared with the first Ethertype of an untagged Ethernet frame, e.g. ipv4
* inner-marking-pbit: The p-bit marking value of inner TAG
* ip-version: IP version for L3 filter
* match-any-frame: Choose whether the entry use any-frame or enhance-filter
* outer-marking-pbit: The p-bit marking value of outer TAG
* pass-action: Make the packets flow for ccl if it is true
* pbit-list: Filter containing P-bit value(s) to be matched with the value of the corresponding packet field, e.g. 0,2-4,7
* pbit-marking-action: do the p-bit marking for ccl if it is true
* pbit-marking-list: Provides a set of possible P-bit values as a criterion for classifying packets, e.g. 0;1;2
* policing-profile-name: Policing profile which is used by ccl
* protocol: Internet Protocol number.  Refers to the protocol of the payload
* protocols: A set of protocols as a criterion for classifying packets, e.g. igmp;dhcpv4;dhcpv6;pppoe-discovery
* src-broadcast: This represents the broadcast mac address of source mac
* src-cfm-multicast: This represents a mask for all CFM OAM multicast addresses of source mac
* src-ipv4-address: The source ipv4 address in the frame's ipv4 header, e.g. 135.251.160.0/24
* src-ipv4-multicast: This represents a mask for all ipv4 multicast addresses of source mac
* src-ipv6-address: The source IPV6 address in the frame's IPv6 header, e.g. 2001:3456::/32
* src-ipv6-multicast: This represents a mask for all IPv6 multicast addresses of source mac
* src-lower-port: The lower-port of source port range
* src-mac-address: Enable/disable setting a filter on the source mac address
* src-mac-mask: A specific mac address mask of source mac, e.g. FF:FF:FF:FF:FF:FF
* src-mac-specific: Indicate the value and the mask together identify a set of mac addresses of source mac
* src-mac-value: A specific mac address of source mac, e.g. 01:02:03:04:05:06
* src-upper-port: The upper-port of source port range

