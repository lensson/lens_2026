This macro configures Connectivity Fault Management (CFM) in CC mode in a network 

Prerequisite:

*   device has to be created.
*   maintenance-group-id, md-id, ma-id and mep-id should be initially configured, and are the keys for maintenance group, maintenance domain, maintenance association and maintenance association end point respectively.
Input parameters:

* ais-status: A boolean value that is used to enable/disable AIS generation of the MEP
* ccm-status: A boolean value which indicates whether the MEP can generate CCMs. If true, the MEP will generate CCM PDUs
* interface: A string that defines the uni where MEP is configured
* ma-id: Unique ID for MA.
* ma-name: A string that defines the name of the MA.
* ma-vlan-id: The VLAN ID under MA for Auto created MIPS is of 12 bits represented in a 2-octet integer.
* maintenance-group-id: Unique ID which is a key for maintenance group
* md-id: Unique ID which is a key for maintenance domain
* mep-id: Unique ID which is a key for maintenance association end point
* mep-status: A boolean value that defines the administrative state of MEP, true indicates that the MEP is to function normally, and false indicates that it is to cease functioning.
* onu-name: ONU name

