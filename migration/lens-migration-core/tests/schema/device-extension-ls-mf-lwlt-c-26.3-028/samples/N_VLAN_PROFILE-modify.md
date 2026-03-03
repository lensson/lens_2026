This macro modifies a user vlan frame processing profile for CC.

Input parameters:

* n-vlan-id: VLAN ID received from the ONU, if not specified, it means matching untagged
* n-vlan-profile-name: the name of this profile
* n-vlan-tag-from: It's a VLAN tag index to indicate to use which pbit/DEI in the outer VLAN tag or inner VLAN tag at egress side. If the VLAN-TAG is 0, it indicates outer VLAN tag. If the VLAN-TAG is 1, it indicates inner VLAN tag. If not specified, it indicates untag at egress side.

