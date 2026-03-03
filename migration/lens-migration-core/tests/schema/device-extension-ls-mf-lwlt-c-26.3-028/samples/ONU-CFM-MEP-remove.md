To delete Connectivity Fault Management's (CFM) MEP in ONU this macro configures following data nodes:

- Configuring **md-id** identified by a string with which the MA is associated
- Configuring the **ma-id** identified by a string with which the MEP is associated
- Configuring the **mep-id** identified by a string that needs to be deleted

Prerequisite:
MEP has to be created and the maintenance group is deleted which is associated with the MEP.

Input parameters:

* ma-id: The ID of MA identified by a string with which the MEP is associated
* md-id: Unique ID for MD with which the ma is associated.
* mep-id: The ID of MEP that needs to be deleted
* onu-name: ONU name

