This configures an on-change-audit-interval that is applicable to all on-change templates in the system.

 -	The default value of this audit interval is 3600sec, and it can accept values in multiples of 1800sec.
 -	When the audit interval value is configured as non 0, a periodic audit message will be exported as an IPFIX data record for each on-change cache template. This happens if there has been no valid on-change data record exported in that audit interval. The export of the audit message will happen after a random offset after the audit interval expiry. This audit message will include the record-type as audit (value 2), and will include the last exported value of cache-sequence-number.
 -	When the value configured is 0, no periodic audit message will be exported for any on-change cache.

Input parameters:

* on-change-audit-interval: Value in seconds for a periodic audit of on-change templates.

