This macro deletes previously downloaded ONT software revision from the OLT.

Pre-conditions:

* Subscribe to the software delete notification so that the resulting notification is received.
* Atleast one ont_software should be present in the OLT.
* Software to be deleted needs to be downloaded via "SYSTEM-SOFTWARE-download - Download new software" macro.

Description:
* This macro should be executed by the operator for each ONT software to be deleted.

Input parameters:

* delete-software-name: Revision name of the ont_software to be deleted
* software-name: Name of the (predefined) ONT software type.

