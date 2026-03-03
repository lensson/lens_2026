This macro stops ongoing download of a new software version.

Pre-condition:

* Subscribe to the software notification so that the resulting notification of action is received.
* System should already have an operational software in state (active/committed). Software revision being downloaded should be in state download in-progress/in active/uncommitted and system should be in idle state.
* Before executing this kind of software action, it is important to be aware of the software status of the device,so it is good practice to request the Software status via macro "SYSTEM-SOFTWARE-status-get - Retrieve status of all software versions".

Description:

* The ongoing download of the software is stopped.
* At any moment in time a software download can be stopped by executing abort software action.
* Software types like application_software, ont_software, onu_vendor_specific_software, and transformation_software can be aborted using this sample.

Input parameters:

* component: Name of the component, default must be Chassis.
* download-software-name: Name of the on-going software download
* software-name: Name of the application software

