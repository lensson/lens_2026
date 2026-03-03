This macro activates a downloaded software.

Pre-conditions:

* Subscribe to the software activate notification so that the resulting notification is received.
* System should already have valid operational software in state active, committed.
* Software to be activated needs to be successfully downloaded via SYSTEM-SOFTWARE-download - Download new software macro thus leaving it in state valid,inactivate uncommitted and system should be in idle state.
* Before executing this kind of software action, it is important to be aware of the software status of the device, so it is good practice to request the software status via macro "SYSTEM-SOFTWARE-status-get - Retrieve status of all software versions".

Procedure:

* "default-datastore" parameter should be set to "true" if the configuration database should be cleaned-up during software activation.

  If the node management plane is connected through a FELTB uplink port, this operation might cause a management plane connectivity loss. Therefore, in this case, this operation is only intended for internal use and not recommended for customers use.


* Before doing downgrade,

  To remove the oamsave.cfg file, the user has to execute the following commands from MD-CLI -

  1.Delete the oamsave leaf on interfaces (Example : /configure service ies "2" interface "telnet" delete oamsave)

  2.Execute action command (Example : /action-rpc ihub-database oamsave true)

Note:

* when a rollback happens to a SW revision which was never committed before, that SW will be activated with default datastore. Since no database backup done for uncommitted SW.

Input parameters:

* component: Name of the component, default must be Chassis.
* default-datastore: Activation of software along with configuration DB clean-up.
* download-software-name: Name of the software to be activated
* software-name: Name of the application software

