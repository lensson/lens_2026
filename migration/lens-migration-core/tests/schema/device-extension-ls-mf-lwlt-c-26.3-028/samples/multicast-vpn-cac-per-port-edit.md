Configure multicast CAC attributes on channel pair,eth, ptm or lag.

Prerequisite:

* The channel pair,eth, ptm or lag must be created.

Note: The multicast-cac configurations max-group-number, max-multicast-rate-limit and multicast-rate-limit-exceed-action will be considered only for new joins.

Input parameters:

* interface-name: The name of a channel pair,eth, ptm or lag.
* max-group-number: Specifies the maximum number of dynamic multicast groups that may be replicated to the interface at any one time.
* max-multicast-rate-limit: Specifies the total bandwidth available on the interface for multicast traffic in kilobits per second.
* multicast-rate-limit-exceed-action: Specifies how a multicast switch shall act when the multicast CAC calculation indicates that accepting the MGMD request would result in a situation where more multicast bandwidth is needed than reserved on the interface.

