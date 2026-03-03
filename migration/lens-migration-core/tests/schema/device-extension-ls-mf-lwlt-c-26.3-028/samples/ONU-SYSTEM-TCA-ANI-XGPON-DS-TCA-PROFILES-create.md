Description:
This macro configures TCA profiles for ANI XGPON downstream performance monitoring counters in an ONT ANI interface

Prerequisite:

* None

Input parameters:

* ploam-mic-error-threshold    :  Threshold value for number of MIC errors detected in downstream PLOAM messages range is 1 .. 4294967294
* omci-mic-error-threshold    :  Threshold value for number of MIC errors detected in OMCI messages directed to the ONU  range is 1 .. 4294967294

* Refer G.988 OMCI specification for more details on the thresholds.
* The threshold values given in the parameters are only for example. The actual values should be configured based on operator needs.
Input parameters:

* omci-mic-error-threshold: Threshold value for number of MIC errors detected in OMCI messages directed to the ONU  range is 0 .. 4294967294
* onu-name: ONU name
* ploam-mic-error-threshold: Threshold value for number of MIC errors detected in downstream PLOAM messages range is 0 .. 4294967294
* xgponani-downstream-error-profile: ANI XGPON downstream PM counters threshold profile name

