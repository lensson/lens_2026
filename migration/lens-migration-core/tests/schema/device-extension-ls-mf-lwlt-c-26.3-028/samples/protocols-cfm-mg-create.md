This macro creates CFM maintenance group

Prerequisites

-   CFM maintenance domain should be created (along with MIP and/or MEP).
-   Incase of using MIP, forwarder configs must be created along with user and network vsi.

Input parameters:

* ccm-ltm-inner-tag-priority: Priority.3 bit value to be used in the inner tag, if present in the transmitted frame. If this optional leaf is not configured and the CFM packet need to send with the inner tag then default value 7 implicitly considered for the inner tag.
* ccm-ltm-priority: The priority value for CCMs and LTMs transmitted by the MEP. The default value is the highest priority allowed to pass through the Bridge Port for any of the MEPs VID(s).
* direction: The direction in which the MEP faces on the Bridge Port.
* forwarder: All MIPs within a single MA shall reference VLAN sub-interfaces that participate in the same forwarder.
* interface: References the interface on which the MEP shall be created.
* ma-id: The Maintenance Association name and name format choice.
* maintenance-group-id: The maintenance group provides a handle for the MD and MA combination.
* md-id: The Maintenance Domain name and name format choice.
* mep-id: The list of all MEPs that belong to this Maintenance Association.
* mep-state: The administrative state of the MEP. TRUE indicates that the MEP is to functional normally,and FALSE indicates that it is to cease functioning.

