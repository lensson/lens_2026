This macro retrieves operational data of the SFP and its child components.

This data provides the operator with information on several aspects of the SFP:

* Identification of the SFP: e.g. model-name or serial-number.
* The hierarchy of the SFP: e.g. how many ports.
* State and status of the SFP:	e.g. operational-state and diagnostics data.
* Information about sensor data (i.e. temperature sensors).

Pre-condition:

* Operational data for a component is only retrieved if the component is detected by the system as physically present and its parent component its oper-state is enabled.

Input parameters:

* transceiver-name: The name of transceiver

