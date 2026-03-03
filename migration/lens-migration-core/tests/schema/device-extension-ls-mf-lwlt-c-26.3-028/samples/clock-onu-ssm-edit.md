The macro works for the enable or disable the SyncE/SSM function of ONU.

* For those ONUs which support G.988 standard ME464 'Synchronous Ethernet operation', if SyncE/SSM function is locked, the ONU would not lift and send out SSM messages.
* When SSM function is enabled on ONU, changing incidental GEM id would cause clock service impact.

Pre-condition:

* Incidental GEM id has been created in onu-multicast-vpn-interface-create.
* GEM id for ssmout: 65533 for XGSPON, 25GPON or 50GPON, 2046 for GPON.

Input parameters:

* admin-state: the administrative state of SyncE/SSM funtion.It's only valid for the ONUs which support G.988 ME464.
* ESMC-vlan-id: specifies the VLAN associated with LT output SSM messages. It should use the same VLAN ID with LT 'clock-ssm-out-vlan-profile'.
* onu-name: the custom name of the onu.
* QL-options: specifies the expected network QL states.It's only valid for the ONUs which support G.988 ME464.

