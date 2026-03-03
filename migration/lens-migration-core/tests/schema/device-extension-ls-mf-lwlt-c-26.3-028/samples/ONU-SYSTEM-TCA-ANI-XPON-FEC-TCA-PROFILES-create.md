Description:
This macro configures TCA profiles for ANI XPON FEC performance monitoring counters in an ONT ANI interface

Prerequisite:

* None

Input parameters:

* corrected-bytes-threshold    :  Threshold value for the number of bytes that were corrected by the FEC function  range is 1 .. 18446744073709551615
* corrected-code-words-threshold    :  Threshold value for the number of the code words that were corrected by the FEC function  range is 1 .. 18446744073709551615
* uncorrectable-code-words-threshold   :  Threshold value for number of uncorrectable code words  range is 1 .. 18446744073709551615
* fec-seconds-threshold     :  Threshold value for the number of seconds during which there was a FEC anomaly  range is 1 .. 4294967294

* Refer G.988 OMCI specification for more details on the thresholds.
* The threshold values given in the parameters are only for example. The actual values should be configured based on operator needs.
* The TCA profile value allowed range is  1 .. 4294967294 when pm-counter-size is configured as 32-bit-performance-monitoring. and allowed range is 1 .. 18446744073709551615 when pm-counter-size is configured as 64-bit-performance-monitoring.

Input parameters:

* corrected-bytes-threshold: Threshold value for the number of bytes that were corrected by the FEC function  range is 0 .. 18446744073709551615
* corrected-code-words-threshold: Threshold value for the number of the code words that were corrected by the FEC function  range is 0 .. 18446744073709551615
* fec-seconds-threshold: Threshold value for the number of seconds during which there was a FEC anomaly  range is 0 .. 4294967294
* onu-name: ONU name
* uncorrectable-code-words-threshold: Threshold value for number of uncorrectable code words  range is 0 .. 18446744073709551615
* xpon-fec-error-profile: ANI XPON FEC PM counters threshold profile name

