To update Connectivity Fault Management's (CFM) Maintenance Group in ONU this macro configures following data nodes:

- Configuring **maintenance-group-id** identified by a string which provides a handle for the MD and MA combination
- Configuring **md-id** identified by a string which gives a reference to the maintenance domain that the maintenance
group is associated with
- Configuring **ma-id** identified by a string which gives a reference to the maintenance association in the specified
maintenance domain, that the maintenance group is associated with
- Configuring **mep-id** identified by a string which is unique among all the MEPs in the same Maintenance Association
- Configuring **enabled** which is the administrative state of MEP, true indicates that the MEP is to function normally, and false indicates that it is to cease functioning
- Configuring **ccm-enabled** which indicates whether the MEP can generate CCMs. If true, the MEP will generate CCM PDUs
- Configuring **enable** which is a boolean value that is used to enable/disable AIS generation of the MEP
- Configuring **meglevel** which is the level at which the most immediate client layer MIPs and MEPs exist
- Configuring **period** that determines transmission periodicity of frames with ETH-AIS information
- Configuring **priority** that identifies the priority of frames with ETH-AIS information

Prerequisite:
 maintenance-group-id, md-id, ma-id and mep-id should be initially configured, and are the keys for maintenance group,
 maintenance domain, maintenance association and maintenance association end point respectively.

Input parameters:

* ccm-enabled: A boolean value which indicates whether the MEP can generate CCMs. If true, the MEP will generate CCM PDUs
* enable: A boolean value that is used to enable/disable AIS generation of the MEP
* enabled: A boolean value that defines the administrative state of MEP, true indicates that the MEP is to function normally, and false indicates that it is to cease functioning.
* ma-id: Unique ID which is a key for maintenance association
* maintenance-group-id: Unique ID which is a key for maintenance group.
* md-id: Unique ID which is a key for maintenance domain
* meglevel: It is the level at which the most immediate client layer MIPs and MEPs exist
* mep-id: Unique ID which is a key for maintenance association end point
* onu-name: ONU name
* period: It determines transmission periodicity of frames with ETH-AIS information
* priority: It identifies the priority of frames with ETH-AIS information

