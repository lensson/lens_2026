This macro configures 802.1X Port Access Entity (PAE) authentication at user interface level.
Signalling-channel, v-ent uni-name and auth port-capabilities should be enabled/disabled in single commit.

Prerequisite:

* user interface must be configured.

Input parameters:

* enable-authentication: If set to true, enables the 802.1X Authentication at user interface level.
* signalling-channel: Reference to the vlan-sub-interface for 802.1x packets.
* uni-name: The name of uni on onu side.
* user-interface: Name of the user interface.

