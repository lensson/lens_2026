This macro creates two network vlan frame processing profiles for CC.

* CC-SINGLE-VLAN-PROFILE has single tag.
* CC-QINQ-VLAN-PROFILE has dual tags.

Input parameters:

* c-vlan-pbit-dei-marking-list-index: The index of the marking-list from where the pbit and DEI values should be copied into the egress frame for the C-VLAN. If not configured, 0 is assumed.
* s-vlan-pbit-dei-marking-list-index: The index of the marking-list from where the pbit and DEI values should be copied into the egress frame for the S-VLAN. If not configured, 0 is assumed.

