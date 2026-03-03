Description:
This macro configures TCA profiles for ANI XGPON TC layer performance monitoring counters in an ONT ANI interface

Prerequisite:

* None

Input parameters:

* psbd-hec-error-threshold    :  Threshold value for number of HEC errors in the downstream physical sync block range is 1 .. 4294967294
* xgtc-hec-error-threshold    :  Threshold value for number of HEC errors detected in the XGTC header  range is 1 .. 4294967294
* unknown-profile-threshold   :  Threshold value for number of grants received for unknown profiles  range is 1 .. 4294967294
* xgem-hec-loss-threshold     :  Threshold value for the number of 4 byte words lost because of an XGEM frame HEC error  range is 1 .. 18446744073709551615
* xgem-key-errors-threshold   :  Threshold value for the number of XGEM frames key errors  range is 1 .. 18446744073709551615
* xgem-hec-error-threshold    :  Threshold value for the number of instances of an XGEM frame HEC error  range is 1 .. 18446744073709551615

* Refer G.988 OMCI specification for more details on the thresholds.
* The threshold values given in the parameters are only for example. The actual values should be configured based on operator needs.
* The TCA profile value allowed range is  1 .. 4294967294 when pm-counter-size is configured as 32-bit-performance-monitoring. and allowed range is 1 .. 18446744073709551615 when pm-counter-size is configured as 64-bit-performance-monitoring.

Input parameters:

* onu-name: ONU name
* psbd-hec-error-threshold: Threshold value for number of HEC errors in the downstream physical sync block range is 0 .. 4294967294
* unknown-profile-threshold: Threshold value for number of grants received for unknown profiles  range is 0 .. 4294967294
* xgem-hec-error-threshold: Threshold value for the number of instances of an XGEM frame HEC error  range is 0 .. 18446744073709551615
* xgem-hec-loss-threshold: Threshold value for the number of 4 byte words lost because of an XGEM frame HEC error  range is 0 .. 18446744073709551615
* xgem-key-errors-threshold: Threshold value for the number of XGEM frames key errors  range is 0 .. 18446744073709551615
* xgpon-tc-layer-tca-profile: ANI XGPON TC layer PM counters threshold profile name
* xgtc-hec-error-threshold: Threshold value for number of HEC errors detected in the XGTC header  range is 0 .. 4294967294

