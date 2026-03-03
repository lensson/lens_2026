This macro can be used to create IPFIX on-change templates for export of data.
Guidelines:

 -  The supported yang paths that can be configured in an ipfix on-change template are available in the Telemetry data document.
 -  Configuring yang leaf paths from different container/list is not supported within a same template.
 -  The heartbeat time interval for periodic data export in addition to the on-change data export can be configured from 3600sec (1hr) onwards. This time interval is configured via the leaf heartbeat-interval. By default, the on-change templates do not have a periodic time interval configured (default heartbeat-interval is 0).
 -  The data record of all on-change templates will include the below fields by default:
    -  Data-presence-indication will be added by default as first field within the data record for all templates. This binary value will indicate whether each field in the data record has actual or dummy value. The first bit (LSB) denotes the second field, second bit (LSB) denotes the third field & so on. A bit value of 1 indicates that the field corresponding to the bit position holds actual value, and a bit value 0 indicates that the field corresponding to the bit position holds a dummy value which is to be ignored by the collector. An empty value for the data-presence-indication will indicate that all the fields in the data record have actual values.
    -  Collection-timestamp will be added by default as second field within the data record for all on-change templates. This timestamp (in yang:date-and-time format) will indicate the time at which the instance of data was collected for export.
    -  Cache-sequence-number will be added by default as third field within the data record for all on-change templates. This number indicates the number of data records that is exported to the collector for the template. The cache-sequence-number will be incremented for every data record exported for the cache other than the audit message. This number will be reset to 0 at the start of every full-data-sync data and heartbeat-interval expiry data. This will also be reset to 0 when some on-change data for the template could not be exported to the collector or when the IPFIX on-change template fields/scope/reporting are modified or when IPFIX exporting is disabled.
    -  Record-type will be added by default as fourth field within the data record for all on-change templates. This enumeration value indicates the type of the record: full-sync (value 0), on-change (value 1), audit (value 3) or periodic (value 4).
    -  Delete-flag will be added by default as the fifth field within the data record for all on-change templates. This field will be set to true only when the instance of data no longer exists.
    -  Last-message will be added by default as last field within the data record for all on-change templates. This boolean value indicates if the data record is the last for the current ongoing export. True indicates that the ongoing data export is complete. This value will be true in the data record when a full-data-sync triggered for the on-change template completes or when the periodic data export for the configured heartbeat time interval completes.
 -  Up to 4 exportingProcesses may be configured in the system. The exportingProcess has to be configured in the cache in order to have the data exported out. Each cache can be configured with max 1 exportingProcess.
 -  Cache configuration rules remain the same independent of the number of IPFIX exporters.
 -  Note that a packet is exported and counted as template data-record (counter /ipfix:ipfix/ipfix:cache/ipfix:dataRecords) for on-change configured caches, when:
    - An audit message is sent (after successful connection to collector).
    - After completion of full-data-sync export.
    - After completion of periodic export.


Input parameters:

* cache-name: cache name
* critical-content: This field indicates that the cache contains critical data and ipfix-app should retain the data for this cache which could not be exported, when connection with collector is lost. This cache's data will be maintained in ipfix-app's memory and flushed upon connectivity restoration.
* exportingProcess: This field indicates the exportingProcess name whose destination(s) will be used for pushing the cache's data out. The exportingProcess has to be configured in the cache in order to have the data exported out. Each cache can be configured with max 1 exportingProcess.
* field1-ie-name: field ie name
* field1-name: field name
* field2-ie-name: field ie name
* field2-name: field name
* field3-ie-name: field ie name
* field3-name: field name
* heartbeat-interval: periodic heartbeat-interval for on-change templates
* reporting-enable: reporting enable flag

