This macro creates an IPFIX exporter and configures the IPFIX collector attributes. IPFIX exporter establishes a TCP session with IPFIX collector using the configured collector attributes. The macro specifies to the exporter whether the collector is primary or an alternate collector. Upto 4 alternate collectors can be configured. More than one alternate collector can be configured by using the same macro repetitively. 

-	IPFIX exporter autonomously tries to connect with alternate collector (if primary collector is not reachable) based on the configured order of priority and keeps retrying till a connection is established with collector. 
-	In case when the connection with collector is not established, IPFIX exporter will retry to connect to the same collector every ~2sec till the configured retransmission timeout; before moving to the next alternate collector in sequence. 
-	The retransmission timeout is configurable with a default of 60 secs. (It is suggested for copper boards using IPv6 connectivity to collector to set a timeout value of at least 180 secs).
-	The priority for a collector destination could have a value from 1 (signifying highest priority collector) upto 255 (signifying lowest priority collector). No two destinations can have the same priority. 
-	If more than one destination is configured without priority, the destination will be selected in the configured order. In case of bulk creation (commit) of destinations, the selection order will be based on the alphabetical order of the destination-name (the order in which the creation will be notified to IPFIX app). 
-	IPFIX exporter must be explicitly enabled for an IPFIX exporter to establish connection with its collector and start exporting the records.
-	All elements of type leaf-list will be exported as a variable length string. Each value of the leaf-list will be seperated by a comma (,).
-	In the exported data, following IANA standard data types are not supported:

		Value  |  Description           |  Reference

		20     |  basicList             |  [RFC6313][RFC7011]

		21     |  subTemplateList       |  [RFC6313][RFC7011]

		22     |  subTemplateMultiList  |  [RFC6313][RFC7011]

-	In the exported data, following proprietary data types have been added in the reserved range:

		Value  |  Description  |  Reference

		253    |  Identityref  |  [RFC7950][RFC7011]

		254    |  Enumeration  |  [RFC7950][RFC7011]

		255    |  Union	       |  [RFC7950][RFC7011]

       'identityref' will be encoded like a variable length (65535) IE. Length of data(including datatype in case of union) and reference(value) of identityref will be exported as part of the IPFIX data record.

       ‘enumeration’ will be encoded like a unsigned32 value with length as 4. The integer equivalent of the enumeration value will be exported as part of the IPFIX data record.

       ‘union’ will be encoded like a variable length (65535) IE. The only difference being that the first octet of the IE value will denote the size, the second octet indicates data-type of the IE value and the rest of the octets are the actual values. 

Input parameters:

* collector-name: collector name
* dest-fqdn: destination FQDN
* dest-ip-address: destination ip address
* dest-port: destination port
* exporter-name: exporter name
* ipfix-exporting-enable: export enable flag
* password: password
* priority: priority
* retransmission-timeout: retransmission timeout(in secs)
* username: username

