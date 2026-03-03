To update Connectivity Fault Management's (CFM) parameters in a network this macro configures following data nodes:

- Configuring **md-id** identified by a string that defines the index to the Maintenance Domain list
- Configuring **ma-id** identified by a string that defines the key of the Maintenance Association list of entries
- Configuring **ccm-interval** that defines the interval between CCM transmissions to be used by all MEPs in the Maintenance Association

Prerequisite:
md-id and ma-id should be initially configured, and are the keys for maintenance domain and maintenance association respectively.

Input parameters:

* ccm-interval: The interval between CCM transmissions to be used by all MEPs in the Maintenance Association.
* ma-id: Unique ID which is a key for the maintenance association
* md-id: Unique ID which is a key for the maintenance domain
* onu-name: ONU name

