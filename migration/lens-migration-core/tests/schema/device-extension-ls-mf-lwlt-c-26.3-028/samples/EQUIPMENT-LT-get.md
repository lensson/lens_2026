This macro retrieves operational data of the LT.

* Identification of the LT: e.g. model-name, serial-number.
* State and status of the LT: e.g. operational-state.
* Information about sensor data (i.e. temperature sensors).
* Last reset information (type, reason, time).

Pre-condition:

* Operational data for a component is only retrieved if the component is detected by the system as physically present and its parent component its oper-state is enabled.

Procedure:

* Retrieve operational data of the LT.

Input parameters:

* board-name: Name of the hardware from which operational data should be retrieved. If this RPC is executed on NT,then the board-name is LT name (fglt-b-1). If this RPC is executed on LT,then the board-name is Board.

