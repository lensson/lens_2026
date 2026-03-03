This macro configures a remote syslog collector.

* In this example a new remote log collector rule is created on the device with name logCollector1 with IP address 10.0.0.1 and port 514.
* Parameters facility and severity should be both configured, else they will be ignored.
* By default action is set to LOG, meaning that the message will be logged.
* By default compare is set to EQUALS-OR-HIGHER, meaning that the severity comparison operation will be equals or higher.

Pre-condition:

The following procedures must be fulfilled before an external Log Collector can be configured

* Enable the required logging levels of each Application/Submodule, otherwise only WARNING and above logs from applications will be generated
* IP interface configured already
* External remote syslog collector is reachable via the IP interface

Input parameters:

* advance-action: If action is LOG (default) then message will be logged. If action is BLOCK then the message will not be logged.
* advance-compare: If compare is EQUALS-OR-HIGHER (default) then the severity comparison operation will be equals or higher. Else if compare is EQUALS then the severity comparison operation will be equals.
* facility: represents the process that creates the syslog event. For example, USER facility refers to all applications that can be listed with "get all active applications" and their log level can be configured explicitly. Available facilities are USER, SYSLOG, NTP, FTP and default facility is USER.
* ipaddress: Uniquely specifies the address of the remote collector. One of the following MUST be specified: an ipv4/ipv6 address or a hostname
* pattern-match: string that can be used to select a syslog message for logging
* port: The port-number of remote collector to deliver syslog messages. The default port is 514. Port 0 is not allowed to be configured.
* severity: by default the severity with equal or higher importance from the given value are allowed. Severity configured for remote collector take precedence over the one configured in application level
* syslog-collector-name: Remote destination log collector name

