The macro works for the enable or disable the SSM out function of ONU UNI interface.

When SSM out function is enabled, changing incidental GEM id would cause clock service impact.

Pre-condition:

* The ONU SyncE/SSM function has been unlocked. 
* Incidental GEM id has been created in onu-multicast-vpn-interface-create.
* GEM id for ssmout: 65533 for XGSPON, 25GPON or 50GPON, 2046 for GPON.

Input parameters:

* onu-name: the custom name of the onu.
* ssm-out-enable: the ssmout status of the uni interface(true/false).
* uni-name: the custom name of the uni interface.

