This macro stops verifiction of a downloaded/downloading software revision.

Pre-condition:

* Subscribe to the software notification so that the resulting notification of action is received.
* System should already have an operational software in state (active/committed). Software revision downloaded should be in state download enabled/inactive/uncommitted and system should be in idle state.
* Before executing this kind of software action, it is important to be aware of the software status of the device,so it is good practice to request the Software status via macro "SYSTEM-SOFTWARE-status-get - Retrieve status of all software versions".

Description:

* At any moment in time a verification action on downloaded/downloading can be stopped by executing abort download verify action.

Input parameters:

* component: Name of the component, default must be Chassis.
* download-software-name: Name of the passive software downloaded
* software-name: Name of the application.

