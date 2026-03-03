Create a new protocol-tracing config session.
If a session with the same name exists, it will be updated.

Pre-condition:

* IGMP tracing is allowed on interfaces with usage user-port and Vlan-SubInterfaces of usage network-port.
  Tracing of other protocols is allowed only on interfaces with usage as user-port.
* To enable tracing of ARP protocol, antispoofing needs to be enabled.
* On fiber systems, only Upstream ARP packets can be traced.
* PPPoE tracing of Downstream traffic is possible only when Downstream tag handling flag is enabled.

Input parameters:

* enabled: Tracing status.
* interface: Interface can refer to a VLAN-SUB-INTERFACE or its parent interface (eg. vENET, PTM)
* protocols: protocol-selection to be configured.For multiple protocols, separate them by a space.You can use "all" to enable all protocols.
* session-name: A name to identify this session.

