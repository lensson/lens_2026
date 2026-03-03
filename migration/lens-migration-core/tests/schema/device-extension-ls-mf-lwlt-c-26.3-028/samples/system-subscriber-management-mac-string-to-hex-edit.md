This macro enables/disables the conversion of the MAC address string value inserted into PPPoE/DHCPv4/DHCPv6 packets to hexadecimal format.

The default value of this attribute is false.

Input parameters:

* mac-address-string-to-hex-conversion: Enable/Disable the conversion of the MAC address string value inserted into PPPoE/DHCPv4/DHCPv6 packets to hexadecimal format. The conversion applies to the MAC address string inserted by the Access Node in following fields DHCPv4 option 82 circuit-id and remote-id sub-options, DHCPv6 option 18 interface-ID, DHCPv6 option 37 relay agent remote-ID and PPPoE Agent Circuit ID and Agent Remote ID tags (part of Broadband Forum PPPoE Tag).When enabled, the string value configured in the circuit-id and remote-id YANG parameters of the subscriber profile will be checked if they correspond to a case insensitive MAC address using delimiters ":", "-" or no delimiters. For example "D4:63:FE:FB:55:01", "d4-63-fe-fb-55-01" and "D463fefb5501" would all be converted to hex D463FEFB5501.

