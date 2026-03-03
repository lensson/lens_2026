This macro creates the DHCPv4 Relay Agent profile.

Description:

* It configures DHCPv4 Relay Agent profile circuit-id, remote-id, start-numbering-from-zero, use-leading-zeros, access-loop-characteristics (TLV 0x90 is a detail).

Note: Following predefined keywords shall be used to configure a default-circuit-id-syntax or default-remote-id-syntax:

- Access_Node_ID: identifies the Lightspan Access Node. The Lightspan Access Node will insert the identifier that is configured as access-node-id in the subscriber configuration.
- Chassis: is the number of the chassis (shelf) that contains the board
- Slot: slot number in the shelf which terminates the subscriber line.
- ShSlt: same as "Slot" but without leading zeroes.
- Port: port number that user is connected to.
- ShPrt: same as "Port" but without leading zeroes.
- LzPrt: same as "Port" but using 3 digits and leading zeroes.
- Q-VID: VLAN ID on user interface (when applicable)
- U-VID: VLAN ID on user interface in case of tagged frames and nothing inserted as VLAN id in case of untagged frames. The special character / delimiter in front of this keyword in case of untagged frames is not inserted.
- LzUVID: VLAN ID on user interface (same as U-VID) but using 4 digits and leading zeroes.
- DUVID: same as U-VID, but in this case the special character / delimiter in front of this keyword incase of untagged frames is inserted.
- N-VID: refers to the C-VLAN ID at the network-side, which may be different from the user-side "Q-VID".
- LzNVID: C-VLAN at the network-side (same as N-VID) but using 4 digits and leading zeroes.
- N2VID: refers to the VLAN ID of the second VLAN tag at the network-side, which may be different from the user-side "Q-VID".
- LzN2-VID: VLAN ID of the second VLAN tag at the network-side (same as N2VID) but using 4 digits and leading zeroes.
- OnuID: Attribute onu-id of the virtual ani interface is the TC layer ONU-ID identifier which the OLT has assigned to the ONU during the ONUs activation using the Assign_ONU-ID PLOAM message. It identifies an ONU on a channel-group and is unique on a channel-group.
- LzOnu: the ONT/MDU identifier on the PON (same as OnuID) but using 3 digits and leading zeroes.
- v-ani: v-ontani interface name is a virtual representation of the 'ani' on the OLT.
- olt-v-enet: Virtual ethernet interface name is virtual interface which carry ethernet frames, which belong to the OLT and which are facing the xPON side of the OLT i.e. facing the ONU.
- channel-group: Channel-group interface name, channel group is a set of channel-pairs carried over a common fiber.
- pon-id: Depending on the pon type, it could be one of the following attributes of a channel termination (CT): gpon-ponid, xgs-ponid or xgpon-pon  id. These pon-id attributes of a channel termination are entirely configurable and available as state data.
- OnuRegID: A string that has been assigned to the subscriber on the management level. Registration id may be useful in identifying a particular ONU installed at a particular location.
- OnuSN: This is the serial number of the ONT which the OLT expects to show up. The serial number is unique for each ONU. It contains the vendor ID and vendor specific serial number. This attribute is configurable in management level.
- DSN: Detected-Serial-Number is the serial number that is sent by the ONU during connectivity establishment.
- description: Virtual ethernet interface description. This attribute is configurable and may contain values, such as OnuID, onuslot, onuport,      depending on their availability.
- Onuslot: The identifier of the ONU (virtual) slot.
- Onuport: The identifier of the ONU Ethernet UNI port under a given ONU (virtual) slot.

Note:

* The sub-options must include at least one of the above keywords. The constructed circuit-id or remote-id sub-options should not exceed 63 characters. If exceeded, only the first 63 characters will be included as part of the circuit-id and remote-id sub-options.
* use-leading-zeroes configuration supported keywords: Chassis, Slot, Port, Q-VID, U-VID, DUVID, N-VID, N2VID, OnuID and it's not applicable to: Onuslot, Onuport, ShSlt, LzPrt, ShPrt, LzUVID, LzOnu, LzNVID, LzN2-VID

Input parameters:

* access-loop-characteristics: Signal the access loop characteristics in option 82 it added using the vendor-specific sub-option
* access-loop-suboptions: Broadband line characteristics that are to be added in option 82
* circuit-id: Option 82 sub-option
* circuit-id-syntax: circuit id syntax will be used to generate a sub option circuit ID when no circuit-id is provided for the VLAN sub interface via a referenced subscriber-profiles
* dhcp-profile-name: Name of the DHCPv4 Relay Agent profile
* max-packet-size: The max-packet-size expresses the maximum size of the IP packet
* remote-id: Option 82 sub-option
* remote-id-syntax: remote id syntax will be used to generate a sub option remote ID when no remote-id is provided for the VLAN sub interface via a referenced subscriber-profiles
* start-numbering-from-zero: Identification shall be added to the sub-option value then this leaf determines if the slot or port numbering must start from 0 or 1
* use-leading-zero: Identification shall be added to the sub-option value then this leaf determines if the slot or port numbering must use leading 0 or not

