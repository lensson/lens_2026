To get Connectivity Fault Management's (CFM) MEP, this macro configures following data nodes:

- Configuring **md-id** identified by a string that defines the index to the Maintenance Domain list
- Configuring **ma-id** identified by a string that defines the key of the Maintenance Association list of entries
- Configuring **mep-id** identified by a string that is unique among all the MEPs in the same Maintenance Association

Prerequisite:
MD, MA and MEP has to be created.

Input parameters:

* maintenance-group-id: Unique ID which is a key for maintenance group
* mep-id: Unique ID which is a key for maintenance association end point
* onu-name: ONU name

