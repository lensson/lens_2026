To get Connectivity Fault Management's (CFM) MEP, this macro configures following data nodes:

- Configuring **md-id** identified by a string that defines the index to the Maintenance Domain list
- Configuring **ma-id** identified by a string that defines the key of the Maintenance Association list of entries
- Configuring **mep-id** identified by a string that is unique among all the MEPs in the same Maintenance Association

Prerequisite:
MD, MA and MEP has to be created.

Input parameters:

* ma-id: Unique ID for MA.
* md-id: Unique ID which is a key for the maintenance domain
* mep-id: An integer that is unique among all the MEPs in the same Maintenance Association.
* onu-name: ONU name

