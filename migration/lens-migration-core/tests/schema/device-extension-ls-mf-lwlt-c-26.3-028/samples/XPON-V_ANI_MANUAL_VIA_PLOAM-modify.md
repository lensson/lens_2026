This macro allows to configure a channel-pair to force an ONU in/out of Emergency Stop state via PLOAM. With the "disable" option, the target ONU will be prohibited from forwarding any traffic until further notice and this state will persist over ONU reboot and power cycle. With the "enable" option, the target ONU is expected to re-activate shortly, when the OLT will open a next quiet window.
Input parameters:

* olt-infrastructure-name: OLT infrastructure name.
* onu-serial-number: Serial Number of a ONU
* ploam-function: Whether the ONU should be enabled or disabled by means of 'Disable_Serial_Number' downstream PLOAM message."

