This macro edits an GPON port infrastructure in the OLT which can be used as underlying hardware for a channel-termination interface in a GPON OLT infrastructure. The GPON port infrastructure consists of one transceiver-link-gpon and one channel-group inside a transceiver cage located on a board. This macro can only be used for GPON type.

Input parameters:

* model-name: Model number of SFP plugged in the cage (model number can be a generic model-name or a dedicated 3FE number).
* olt-port-name: OLT infrastructure port name.
* position: An indication of the relative position of this child component among all its sibling components.
* xpon-cage-name: Cage name.

