Description:
This macro configures TCA profiles for aggregate GEM performance monitoring counters in an ONT ANI interface

Prerequisite:

* None

Input parameters:

* in-lost-gem-frames-threshold    :  Threshold value for the number of lost GEM frames count in downstream range is 1 .. 4294967294
* out-lost-gem-frames-threshold    :  Threshold value for the number of lost GEM frames count in upstream  range is 1 .. 4294967294
* bad-gem-header-error-threshold   :  Threshold value for the number of bad GEM header error count  range is 1 .. 4294967294

* The threshold values given in the parameters are only for example. The actual values should be configured based on operator needs.


Input parameters:

* bad-gem-header-error-threshold: Threshold value for number of grants received for unknown profiles  range is 0 .. 4294967294
* gem-frame-error-profile: ANI aggregate GEM performance monitoring threshold profile name
* in-lost-gem-frames-threshold: Threshold value for the number of lost GEM frames count in downstream range is 0 .. 4294967294
* onu-name: ONU name
* out-lost-gem-frames-threshold: Threshold value for the number of lost GEM frames count in upstream  range is 0 .. 4294967294

