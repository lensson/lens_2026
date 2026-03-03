This macro explicitly verifies downloaded software version is from a trusted or known source.

Pre-condition:

* Subscribe to the software download notification so that resulting notification is received.
* System should already have a valid operational software in state active, committed and system should be in idle state.
* Passive (inactive) software can be present. System should have sufficient resources to store software revisions.
* Before executing verification action, it is important to be aware of the Software status of the device, so it is good practice to request the Software status via macro "SYSTEM-SOFTWARE-status-get - Retrieve status of all software versions".

Procedure:

* Explicit verification of downloaded software can be executed on any software (active or passive) at any time.

Input parameters:

* component: Name of the component, default must be Chassis.
* download-software-name: Name of the software to be activated
* software-name: Name of the application software

