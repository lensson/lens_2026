This procedure allows the operator to fetch configuration information and status of the LT component.

Pre-condition:

* configuration data for a component is only retrieved if the component is detected by the system as physically present and its parent component its oper-state is enabled.

Procedure:

* Retrieve configuration data of the LT.

Input parameters:

* board-name: Name of the hardware from which configuration data should be retrieved. If this RPC is executed on NT,then the board-name is LT name (fglt-b-1). If this RPC is executed on LT,then the board-name is Board.

