Description:
This macro configures TCA profiles with threshold values for POTS call control performance monitoring counters in an ONU .

Prerequisite:

* None

Input parameters:

* call-setup-fail-threshold    :  Threshold value for number of call setup failures range is 1 .. 4294967294
* call-setup-timeout-threshold :  Threshold value for call setup timeout threshold (time in milliseconds)
* call-terminate-threshold     :  Threshold value for the number of calls terminated range is 1 .. 4294967294
* port-release-no-dialing-threshold : Threshold value for the number of analogue port releases without dialing detected range is 1 .. 4294967294 
* port-offhook-timeout-threshold    : Threshold value for the longest period of a single off-hook detected on the analogue port (time in milliseconds)

* Refer G.988 OMCI specification for more details on the thresholds.
* The threshold values given in the parameters are only for example. The actual values should be configured based on operator needs.
Input parameters:

* call-setup-fail-threshold: Threshold value for number of call setup failures range is 0 .. 4294967294
* call-setup-timeout-threshold: Threshold value for the number of calls terminated range is 0 .. 4294967294
* call-terminate-threshold: Threshold for number of calls that were terminated with cause range is 0 .. 4294967294
* ccpm-failure-tca-profile: POTS Call Control performance monitoring TCA profile name
* onu-name: ONU name
* port-offhook-timeout-threshold: Threshold value for the longest period of a single off-hook detected on the analogue port (time in milliseconds)
* port-release-no-dialing-threshold: Threshold value for the number of analogue port releases without dialing detected range is 0 .. 4294967294

