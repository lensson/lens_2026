This macro adds a TCONT to a xPON ONU configured on the OLT side. This will allow the OLT to correctly allocate upstream bandwidth to the ONU.
Prerequisite:
Perform the following macro

* Create-xpon-upstream-traffic-descriptor-profile
* perform the macro corresponding to the involved virtual ONU:
* Create-gpon-virtual-onu-on-gpon-olt-access-point
* Create-xgpon-virtual-onu-on-xpon-olt-access-point
NB: Reusing Alloc-ID values is allowed across some xPON types.

Input parameters:

* alloc-id: T-CONT alloc ID.
* onu-template-tcont-name: Identifies within the ONU template a TCONT that is to be instantiated within the actual ONU instance. The actual TCONT will have the data as configured in the template but completed / overruled with the data provided in this list entry.
* tcont-name: Name of the T-CONT.
* traffic-descriptor-profile-name: Traffic descriptor profile name.
* v-ani-name: Reference to v-ani interface.

