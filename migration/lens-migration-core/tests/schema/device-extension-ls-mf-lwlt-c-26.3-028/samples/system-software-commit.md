This macro commits an activated software.

Pre-condition:

* Subscribe to the software commit notification so that the resulting notification of the action is received.
* Software to be committed needs to be successfully downloaded and activated via "SYSTEM-SOFTWARE-download - Download new software and SYSTEM-SOFTWARE-activate - Activate downloaded software" macro thus leaving it in state /activate/ uncommitted) and system should be in idle state.
* System should already have valid operational software in state non-active and committed. Another software revision needs to be in state valid/active/non-committed.
* Before executing this kind of software action, it is important to be aware of the software status of the device, so it is good practice to request the Software status via macro "SYSTEM-SOFTWARE-status-get - Retrieve status of all software versions".

Note:

* Database backup will be taken when the SW revision is committed and database will be updated for any configuration change until SW revision is in active state.
* This database will be retained as a backup even after an upgrade to a new SW revision. This allows the operator to revert to the previous SW revision with the latest backup database in case of manual rollback or SW downgrade.

Input parameters:

* component: Name of the component, default must be Chassis.
* download-software-name: Name of the software which needs to be committed
* software-name: Name of the application software

