This macro stops ongoing configuration download on an existing downloaded software revision.

Pre-condition:

* Subscribe to the software notification so that the resulting notification of action is received.
* System should already have an operational software in state (active/committed). Software revision downloaded should be in state download enabled/inactive/uncommitted and system should be in idle state.
* Before executing this kind of software action, it is important to be aware of the software status of the device,so it is good practice to request the Software status via macro "SYSTEM-SOFTWARE-status-get - Retrieve status of all software versions".

Description:

* The ongoing configuration download of the software is stopped.
* At any moment in time a configuration download can be stopped by executing abort config download action.

Input parameters:

* component: Name of the component, default must be Chassis.
* downloaded-software-name: Name of the passive software downloaded
* software-name: Name of the application.

