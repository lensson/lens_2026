This macro retrieves the software details of board level software revision.

Pre-condition:
* System should already have a valid operational software in state active, committed and system should be in idle state.
* Passive (inactive) software can be present. System should have sufficient resources to store software revisions.
* This macro is supported only on Fiber board level package system.



Input parameters:

* component: Name of the component, default must be Chassis.
* download-software-name: Name of the software for which software details are needed.

