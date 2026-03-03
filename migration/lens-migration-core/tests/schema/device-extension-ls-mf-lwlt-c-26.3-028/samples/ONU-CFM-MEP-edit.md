This macro is to update the status of Connectivity Fault Management (CFM) in a network 

Prerequisite:

*   device has to be created.
*   maintenance-group-id, md-id, ma-id and mep-id should be initially configured, and are the keys for maintenance group, maintenance domain, maintenance association and maintenance association end point respectively.
Input parameters:

* ais-status: A boolean value that is used to enable/disable AIS generation of the MEP
* ccm-status: A boolean value which indicates whether the MEP can generate CCMs. If true, the MEP will generate CCM PDUs
* maintenance-group-id: Unique ID which is a key for maintenance group
* mep-id: Unique ID which is a key for maintenance association end point
* mep-status: A boolean value that defines the administrative state of MEP, true indicates that the MEP is to function normally, and false indicates that it is to cease functioning.
* onu-name: ONU name

