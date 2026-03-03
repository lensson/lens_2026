This macro enables interface statistics for vlan-sub-interface.

Pre-condition:

* VSI-INTERFACE-NAME

* There are best-effort/all-available/false 3 modes.
	* best-effort: This is the default option, in/out octets, in/out discards.
	* all-available: In/out octets/discards/unicast packets/broadcast packets and out multicast packets are supported.
	* false: under this option, statistics are not collected.
	
	* best-effort: can be enabled on all VSIs.
	* all-available: can only be enabled on a limited number of VSIs.(number depends on different hardware dimension)

Input parameters:

* interface-statistics-mode: 
* vsi-interface-name: the name of the vlan-sub-interface who will enable interface statistics.

