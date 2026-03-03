This macro retrieves the verification status of the downloaded software.

Pre-condition:

* Subscribe to the software download notification so that resulting notification is received.
* System should already have a valid operational software in state active, committed and system should be in idle state.
* Passive (inactive) software can be present or can be empty. System should have sufficient resources to store software revisions.
* Before executing software download action, it is important to be aware of the Software status of the device, so it is good practice to request the Software status via macro "SYSTEM-SOFTWARE-status-get - Retrieve status of all software versions".

Input parameters:

* component: Name of the component, default must be Chassis.

