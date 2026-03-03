To get Connectivity Fault Management's (CFM) MG, this macro configures following data nodes:

- Configuring **maintenance-group-id** identified by a string that defines the key to the Maintenance group list
- Configuring **md-id** identified by a string that defines the value of maintenance domain
- Configuring **ma-id** identified by a string that defines the value of maintenance association
- Configuring **mep-id** identified by a string that is unique among all the MEPs in the same Maintenance Association

Prerequisite:
MD, MA ,MEP and MG has to be created.

Input parameters:

* ma-id: Unique ID for MA.
* maintenance-group-id: Unique ID which is a key for the maintenance group
* md-id: Unique ID for MD.
* mep-id: An integer that is unique among all the MEPs in the same Maintenance Association.
* onu-name: ONU name

