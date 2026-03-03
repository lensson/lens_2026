This action will reset the LT.

It allows the operator to request a hardware reset of the LT board.

The reset-type indicates the actions done by the system on reset:

* hardware-reset: to reset with preservation of all committed configuration.
* hardware-reset-to-default-configuration: to reset and revert to the default configuration but with preservation of the connectivity data to ensure preservation of inband management connectivity after the reset.
* hardware-reset-to-factory-datastore: to reset and revert to the default configuration, including removal of the connectivity data. Be aware, that without connectivity data, the system will become ip unreachable after the reset.
* hardware-reset-with-self-test: to reset, preceded by a number of HW specific sanity checks on the individual boards. It is only allowed when operating in AC power mode and ignored in RPF power mode.

for standby NT, NTIO and FAN/PSU/ACU, both hardware-reset-to-factory-datastore and hardware-reset-to-default-configuration are same as hardware-reset.

In all cases the active software (if committed) is preserved after reset.

Pre-condition:

* Component should be physically present and powered-up.
Input parameters:

* hw-name: Name of the harware which needs to be reset.
* reset-type: Reset type option for the respective hardware component.
Input parameters:

* board-name: Name of the hardware thats needs to be reset. If this RPC is executed on NT,then the board-name is LT name (fglt-b-1). If this RPC is executed on LT,then the board-name is Board.
* reset-type: Reset type option for the respective hardware component.

