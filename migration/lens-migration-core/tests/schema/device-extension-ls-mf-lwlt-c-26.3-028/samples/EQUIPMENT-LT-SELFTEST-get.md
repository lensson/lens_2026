This macro indicates last self test error. As long as there has been no failing selftest, the value would be 00:00:00:00 Any other value indicates the last failed test information,which needs to be further checked and correlated with OFLT(offline test) document

Pre-condition:

* Operational data for a component is only retrieved if the component is detected by the system as physically present and its parent component its oper-state is enabled.

Procedure:

* Retrieve operational data of the selftest result.

Input parameters:

* hw-name: Name of the harware which needs to be selftest.If the command is operated on NT,the value is LT-name. if the command is executed on LT, the value is Board.

