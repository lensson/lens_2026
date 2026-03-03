Description:
This macro configures TCA profiles with threshold values for POTS RTP performance monitoring counters in an ONU .

Prerequisite:

* None

Input parameters:

* rtp-errors-threshold       :  Threshold value for RTP packet errors range is 1 .. 4294967294
* rtp-packet-loss-threshold  :  Threshold value for RTP packet loss range is 1 .. 4294967294
* max-jitter-threshold       :  Threshold value for the maximum jitter identified during the measured interval (RTP timestamp units)
* buffer-underflow-threshold : Threshold value for the number of times the RTP reassembly buffer underflows range is 1 .. 4294967294 
* buffer-overflow-threshold  : Threshold value for the number of times the RTP reassembly buffer overflows range is 1 .. 4294967294

* Refer G.988 OMCI specification for more details on the thresholds.
* The threshold values given in the parameters are only for example. The actual values should be configured based on operator needs.
Input parameters:

* buffer-overflow-threshold: Threshold value for the number of times the RTP reassembly buffer overflows range is 0 .. 4294967294
* buffer-underflow-threshold: Threshold value for the number of times the RTP reassembly buffer underflows range is 0 .. 4294967294
* max-jitter-threshold: Threshold value for the maximum jitter identified during the measured interval (RTP timestamp units)
* max-rtcp-inter-packet-time-threshold: Threshold value for the maximum time between RTCP packets during the measured interval (in milliseconds)
* onu-name: ONU name
* rtp-errors-threshold: Threshold value for RTP packet errors range is 0 .. 4294967294
* rtp-failure-tca-profile: POTS RTP performance monitoring TCA profile name
* rtp-packet-loss-threshold: Threshold value for RTP packet loss range is 0 .. 4294967294)

