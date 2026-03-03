Description:
This macro configures TCA profiles for Ethernet physical layer performance monitoring counters in an ONT UNI interface (ENET)

Prerequisite:

* None

Input parameters:

* excessive-collision-threshold    :  Threshold value for the total number of frames whose transmission failed due to excessive collisions range is 1 .. 4294967294
* late-collision-threshold     :  Threshold value for the number of late collisions detected range is 1 .. 4294967294
* rx-buffer-overflow-threshold :  Threshold value for receive buffer overflows  range is 1 .. 4294967294
* tx-buffer-overflow-threshold :  Threshold value for the transmit buffer overflows   range is 1 .. 4294967294
* single-collision-threshold   :  Threshold value for number of frames delayed by single collision  range is 1 .. 4294967294
* multiple-collision-threshold :  Threshold value for number of frames delayed by multiple collisions  range is 1 .. 4294967294
* sqe-counter-threshold        :  Threshold value for the number of times that the SQE test error message were generated  range is 1 .. 4294967294.
* deferred-tx-threshold        :  Threshold value for the number of frames whose first transmission attempt was delayed because the medium was busy  range is 1 .. 4294967294.
* internal-mac-tx-error-threshold : Threshold value for the number of frames whose transmission failed due to an internal MAC sublayer transmit error  range is 1 .. 4294967294.
* carrier-sense-error-threshold : Threshold value for the number of times that carrier sense was lost while transmitting a frame  range is 1 .. 4294967294.
* alignment-error-threshold     : Theshold value for the number of frames received with alignment error  range is 1 .. 4294967294
* internal-mac-rx-error-threshold : Threshold value for the number of frames whose reception failed due to an internal MAC sublayer  receive error  range is 1 .. 4294967294

* Refer G.988 OMCI specification for more details on the thresholds.
* The threshold values given in the parameters are only for example. The actual values should be configured based on operator needs.



Input parameters:

* alignment-error-threshold: Theshold value for the number of frames received with alignment error  range is 0 .. 4294967294
* carrier-sense-error-threshold: Threshold value for the number of times that carrier sense was lost while transmitting a frame  range is 0 .. 4294967294
* deferred-tx-threshold: Threshold value for the number of frames whose first transmission attempt was delayed because the medium was busy  range is 0 .. 4294967294
* ethernet-physical-layer-error-profile: Ethernet physical layer performance monitoring counters threshold profile name
* excessive-collision-threshold: Threshold value for the total number of frames whose transmission failed due to excessive collisions range is 0 .. 4294967294
* internal-mac-rx-error-threshold: Threshold value for the number of frames whose reception failed due to an internal MAC sublayer  receive error  range is 0 .. 4294967294
* internal-mac-tx-error-threshold: Threshold value for the number of frames whose transmission failed due to an internal MAC sublayer transmit error  range is 0 .. 4294967294
* late-collision-threshold: Threshold value for the number of late collisions detected range is 0 .. 4294967294
* multiple-collision-threshold: Threshold value for number of frames delayed by multiple collisions  range is 0 .. 4294967294
* onu-name: ONU name
* rx-buffer-overflow-threshold: Threshold value for receive buffer overflows  range is 0 .. 4294967294
* single-collision-threshold: Threshold value for number of frames delayed by single collision  range is 0 .. 4294967294
* sqe-counter-threshold: Threshold value for the number of times that the SQE test error message were generated  range is 0 .. 4294967294
* tx-buffer-overflow-threshold: Threshold value for the transmit buffer overflows   range is 0 .. 4294967294

