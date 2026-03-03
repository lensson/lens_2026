This macro deletes previously downloaded ONU vendor specific software from the OLT.

Pre-conditions:

* Subscribe to the software delete notification so that the resulting notification is received.
* Atleast one onu_vendor_specific_software should be present in the OLT.
* Software to be deleted needs to be downloaded via "SYSTEM-SOFTWARE-download - Download new software" macro.

Description:
* This macro should be executed by the operator for each ONU vendor specific software to be deleted.

Input parameters:

* delete-software-name: Revision name of the onu_vendor_specific_software to be deleted
* software-name: Name of the (predefined) ONU vendor specific software type.

