This macro edits a MPM port infrastructure in the OLT which can be used as underlying hardware for two channel-termination interfaces in a GPON OLT infrastructure and a XGSPON OLT infrastructure. The MPM port infrastructure consists of one transceiver-link-gpon, one transceiver-link-ngpon and one channel-group inside a transceiver cage located on a board. This macro can only be used for MPM.

Input parameters:

* model-name: Model number of SFP plugged in the cage (model number can be a generic model-name or a dedicated 3FE number).
* olt-port-name: OLT infrastructure port name.
* xpon-cage-name: Cage name.

