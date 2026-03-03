Description:
This macro configures TCA profiles with threshold values for GEM port performance monitoring counters in an ONU .

Prerequisite:

* None

Input parameters:

* encryption-key-errors-threshold    :  Threshold value for the number of encryption key errors range is 1 .. 4294967294

* Refer G.988 OMCI specification for more details on the thresholds.
* The threshold values given in the parameters are only for example. The actual values should be configured based on operator needs.
Input parameters:

* enc-key-err-threshold: Threshold value for the number of encryption key errors range is 0 .. 4294967294
* gemport-tca-profile: GEM port performance monitoring TCA profile name
* onu-name: ONU name

