Description:
This macro removes the association of the LLDP-MED network media policy profile from the LLDP port using template parameters. 

Prerequisite:
- LLDP-MED media policy profile to be associated is already created in ONU template.
- LLDP-MED media policy profile is already associated to LLDP port.

Input parameters:

* lldp-med-media-policies-for-all-apps: LLDP MED media policy profile name which defines policies for all application types.
* lldp-med-plug-and-play-lan-policy-for-voice: LLDP MED media policy profile name for VOIP plug-and-play.
* onu-name: ONU name
* onu-uni1-intf: Ethernet UNI interface
* onu-uni2-intf: Ethernet UNI interface

