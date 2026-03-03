This macro defines an action to remotely deactivate an ONU via PLOAM. The target ONU is supposed to stop sending upstream traffic, reset itself and transition to the Initial state (O1). It is expected to re-activate shortly after, when the OLT will open a next quiet window.
Input parameters:

* olt-infrastructure-name: OLT infrastructure name.
* onu-serial-number: Serial Number of a ONU.

