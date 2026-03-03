To delete Connectivity Fault Management's (CFM) MA in ONU this macro configures following data nodes:

- Configuring **md-id** identified by a string with which the MA is associated
- Configuring the **ma-id** identified by a string that defines the key of the Maintenance Association list of entries that needs to be deleted

Prerequisite:
MD and MA has to be created.

Input parameters:

* ma-id: The ID of MA that defines the key of the Maintenance Association list of entries that needs to be deleted
* md-id: Unique ID for MD with which the ma is associated.
* onu-name: ONU name

