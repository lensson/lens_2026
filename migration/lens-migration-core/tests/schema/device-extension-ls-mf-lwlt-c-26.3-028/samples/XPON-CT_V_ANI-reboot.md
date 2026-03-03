This macro defines an action to remotely reboot an ONU via PLOAM, unconditionally. The target ONU is supposed to perform an equivalent of the OMCI reboot (per G.988 clause A.2.35). It is expected to re-activate shortly after with the same (committed) SW image, when the OLT will open a next quiet window.
Input parameters:

* olt-infrastructure-name: OLT infrastructure name.
* onu-serial-number: Serial Number of a ONU.

