To configure Connectivity Fault Management (CFM) in a network this macro configures following data nodes:

- Configuring **md-id** identified by a string that defines the index to the Maintenance Domain list
- Configuring **md-level** identified by an integer (0-7) that defines the level of the Maintenance Domain
- Configuring **md-name** identified by a string that defines the name of the Maintenance Domain
- Configuring **ma-id** identified by a string that defines the key of the Maintenance Association list of entries
- Configuring **ma-name** identified by a string that defines the name of the Maintenance Association
- Configuring the value for **ma-mhf-creation** which indicates whether the management entity can create MHFs (MIP Half Function) for the created Maintenance Association
- Configuring **ma-vlan-id** that defines the VLAN ID under MA for Auto created MIPS.
- Configuring **ccm-interval** that defines the interval between CCM transmissions to be used by all MEPs in the Maintenance Association
- Configuring **mep-id** identified by a string that is unique among all the MEPs in the same Maintenance Association

Input parameters:

* ccm-interval: The interval between CCM transmissions to be used by all MEPs in the Maintenance Association.
* ma-id: Unique ID for MA.
* ma-mhf-creation: The value indicating whether the management entity can create MHFs (MIP Half Function) for the created Maintenance Association.
* ma-name: A string that defines the name of the MA.
* ma-vlan-id: The VLAN ID under MA for Auto created MIPS is of 12 bits represented in a 2-octet integer.
* md-id: Unique ID for MD.
* md-level: Integer (0-7) that defines the level of MD.
* md-name: A string that defines the name of the MD.
* mep-id: An integer that is unique among all the MEPs in the same Maintenance Association.
* onu-name: ONU name

