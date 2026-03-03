To configure Connectivity Fault Management's (CFM) AIS auto-shutdown this macro configures following data nodes:

- Configuring **interface-name** under which the CFM AIS auto-shutdown is to be enabled
- Configuring **auto-shutdown** which is a flag used to indicate whether to shutdown port when AIS is received

Prerequisite:
The interface has to be already created, interface-type should be ethernetCsmacd and interface-usage should be user-port.

Input parameters:

* auto-shutdown: A flag used to indicate whether to shutdown port when AIS is received
* interface-name: The interface name under which the CFM AIS auto-shutdown is to be enabled
* onu-name: ONU name

