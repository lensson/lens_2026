Description:
This macro attaches Ethernet performance monitoring tca profiles to an ONT UNI interface (ENET)

Prerequisite:

* Ethernet UNI interface should be created and PM enabled.
* Ethernet frame error TCA profile should be created to associate it with ethernet-frame-error-profile
* Ethernet physical layer TCA profile should be be created to associate it with ethernet-physical-layer-error-profile
* Ethernet frame error extended TCA profile should be created to associate it with ethernet-frame-error-extended-profile

Input parameters:

* ethernet-frame-error-profile    :  ethernet-frame-error-profile name
* ethernet-physical-layer-error-profile    :  ethernet-physical-layer-error-profile name
* ethernet-frame-error-extended-profile    :  ethernet-frame-error-extended-profile name
Input parameters:

* ethernet-frame-error-extended-profile: Ethernet frame error extended TCA profile.
* ethernet-frame-error-profile: Ethernet frame error TCA profile.
* ethernet-physical-layer-error-profile: Ethernet physical layer error TCA profile.
* onu-name: ONU name
* onu-template-uni-intf: UNI interface name

