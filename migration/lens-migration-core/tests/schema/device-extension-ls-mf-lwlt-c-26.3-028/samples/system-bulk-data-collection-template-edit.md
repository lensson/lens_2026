

This macro can be used to create IPFIX templates for export of data. The configured yang path can be at a container level or certain leafs within a same container.
Guidelines:

 -  The supported yang paths that can be configured in a ipfix template & their IEIDs are provided as part of the software package.
 -  Configuring yang leaf paths from different container/list is not supported within a same template.
 -  The time interval for data export can be configured from 1 min onwards. The default time interval is 15min.
 -  Configuration of yang container/list paths are recommended only when all the leaf attributes of the path are supported in bulk streaming.
 -  Data-presence-indication will be added by default as first field within the data record for all templates. This binary value will indicate whether each field in the data record has actual or dummy value. The first bit (LSB) denotes the second field, second bit (LSB) denotes the third field & so on. A bit value of 1 indicates that the field corresponding to the bit position holds actual value, and a bit value 0 indicates that the field corresponding to the bit position holds a dummy value which is to be ignored by the collector. An empty value for the data-presence-indication will indicate that all the fields in the data record have actual values.
 -  Collection-timestamp will be added by default as second field within the data record for all templates except for the 15-min performance history data record. This timestamp (in yang:date-and-time format) will indicate the time at which the instance of data was collected for export.
 -  In case of 15-min performance history data record, the timestamp is included within data record as per Yang definition. This timestamp provides the start data / time for this interval.
 -  When a yang container/list path is configured in IPFIX template, all the child leafs of that container/list path will be exported.
 -  An optional scope identifier (interface-type or hardware-class) can be configured for all templates that contain yang paths modelled on interfaces-state or hardware-state. When this scope identifier is configured, only the data of the configured interface-type or hardware-class will be exported. If no scope identifier is configured, all the data for the configured yang paths will be exported.
 -  Some examples of hardware-class that can be configured are ianahw:sensor, ianahw:chassis, bbf-hwt:transceiver, ..
 -  IPFIX templates can also be configured with specific resources for which data is needed. When this is configured, only the data corresponding to the resource will be exported. A maximum of 5 resources can be configured in a template, in instance-identifier format; for example, /if:interfaces-state/if:interface[name=<>] or /hw:hardware-state/hw:component[name=<>] (replace <> with the name for the interface or component). A maximum of 25 resources can be supported across caches. Whenever a resource is configured, it is recommended to configure the scope identifier for better performance.
 -  Up to 4 exportingProcesses may be configured in the system. The exportingProcess has to be configured in the cache in order to have the data exported out. Each cache can be configured with max 1 exportingProcess.
 -  Cache configuration rules remain the same independent of the number of IPFIX exporters.
 -  IPFIX Application in LS Device uses a temporary memory of 10 MBs to temporarily store IPFIX formatted data records when there is loss of connection with collector. In case this temporary memory gets filled, the data will be overwritten in a rotatory FIFO manner. The temporary storage is only applied for data records belonging to IPFIX Cache templates which are marked with critical-content = True. After collector becomes reachable, the records from this temporary memory storage are streamed to collector.

Configuring performance history yang path in the template:

 -  The performance counters would have to be enabled on the specific object instance during configuration of object instance for counters to be available for export with IPFIX.
 -  For a 15-min interval requested data, the configured pm data is exported to ipfix collector every 15 min interval as per wall clock time (e.g. 00:00, 00:15, 00:30, .. 23:30, 23:45, 00:00). If template is configured at 00:13, the export starts from 00:15 for the previous 15 min interval from 00:00 to 00:14.
 -  The template example shown in sample below denotes each yang leaf being configured as separate fields. If all fields in a 15-min performance history is required in a template, this could be configured with a single container path e.g., "/if:interfaces-state/if:interface/bbf-if-pm:performance/bbf-xponcommon-pm:xpon-bip-pm/bbf-xponcommon-pm:intervals-15min/bbf-xponcommon-pm:history" as a single field.

Input parameters:

* cache-name: cache name
* critical-content: This field indicates that the cache contains critical data and ipfix-app should retain the data for this cache which could not be exported, when connection with collector is lost. This cache's data will be maintained in ipfix-app's memory and flushed upon connectivity restoration.
* export-interval: export interval
* exportingProcess: This field indicates the exportingProcess name whose destination(s) will be used for pushing the cache's data out. The exportingProcess has to be configured in the cache in order to have the data exported out. Each cache can be configured with max 1 exportingProcess.
* field1-ie-name: field ie name
* field1-name: field name
* field2-ie-name: field ie name
* field2-name: field name
* field3-ie-name: field ie name
* field3-name: field name
* field4-ie-name: field ie name
* field4-name: field name
* field5-ie-name: field ie name
* field5-name: field name
* interface-type: Interface-type is the scope identifier for ipfix data export. If this value is not set data will be exported for all instances.Please note, the prefix & the xml namespace should be updated corresponding to the interface-type used.
* reporting-enable: reporting enable flag

