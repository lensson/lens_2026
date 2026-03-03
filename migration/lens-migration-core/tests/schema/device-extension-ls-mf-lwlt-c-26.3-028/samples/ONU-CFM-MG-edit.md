To configure Connectivity Fault Management's (CFM) Maintenance Group in ONU this macro configures following data nodes:

- Configuring **maintenance-group-id** identified by a string which provides a handle for the MD and MA combination
- Configuring **md-id** identified by a string which gives a reference to the maintenance domain that the maintenance
group is associated with
- Configuring **ma-id** identified by a string which gives a reference to the maintenance association in the specified
maintenance domain, that the maintenance group is associated with
- Configuring **mep-id** identified by a string which is unique among all the MEPs in the same Maintenance Association
- Configuring the **direction** in which the MEP faces on the Bridge Port. Example, up or down
- Configuring **enabled** which is the administrative state of MEP, true indicates that the MEP is to function normally, and false indicates that it is to cease functioning
- Configuring **ccm-ltm-priority** identified by an integer that defines the priority value for CCMs and LTMs
transmitted by the MEP. The default value is the highest priority allowed to pass through the Bridge Port for any of the MEPs VID(s)
- Configuring the **interface** of the uni where the MEP is configured
- Configuring **ccm-enabled** which indicates whether the MEP can generate CCMs. If true, the MEP will generate CCM PDUs
- Configuring **enable** which is a boolean value that is used to enable/disable AIS generation of the MEP
- Configuring **meglevel** which is the level at which the most immediate client layer MIPs and MEPs exist
- Configuring **period** that determines transmission periodicity of frames with ETH-AIS information
- Configuring **priority** that identifies the priority of frames with ETH-AIS information

Input parameters:

* ccm-enabled: A boolean value which indicates whether the MEP can generate CCMs. If true, the MEP will generate CCM PDUs
* ccm-ltm-priority: The priority value for CCMs and LTMs transmitted by the MEP. The default value is the highest priority allowed to pass through the Bridge Port for any of the MEPs VID(s).
* direction: The direction in which the MEP faces on the Bridge Port. Example, up or down.
* enable: A boolean value that is used to enable/disable AIS generation of the MEP
* enabled: A boolean value that defines the administrative state of MEP, true indicates that the MEP is to function normally, and false indicates that it is to cease functioning.
* interface: A string that defines the uni where MEP is configured
* ma-id: Unique ID for MA.
* maintenance-group-id: Unique ID for Maintenance Group.
* md-id: Unique ID for MD.
* meglevel: It is the level at which the most immediate client layer MIPs and MEPs exist
* mep-id: A string that is unique among all the MEPs in the same Maintenance Association.
* onu-name: ONU name
* period: It determines transmission periodicity of frames with ETH-AIS information
* priority: It identifies the priority of frames with ETH-AIS information

