Description:
This macro configures TCA profiles for Ethernet frame performance monitoring counters on an ONT UNI interface (ENET)

Prerequisite:
* None

Input parameters:
* drop-events-threshold    :  Threhsold value for the total number of events in which inbound packets were dropped range is 1 .. 18446744073709551614
* eth-crc-err-threshold    :  Threhsold value for number of received packets dropped due to Ethernet CRC error range is 1 .. 18446744073709551614
* undersize-pkts-threshold :  Threshold value for the total number of undersized packets received range is 1 .. 18446744073709551614
* oversize-pkts-threshold  :  Threshold value for the total number of oversized packets received range is 1 .. 18446744073709551614


Input parameters:

* drop-events-threshold: Threhsold value for the total number of events in which inbound packets were dropped range is 0 .. 4294967294
* eth-crc-tca-threshold: Threhsold value for number of received packets dropped due to Ethernet CRC error range is 0 .. 4294967294
* ethernet-frame-error-profile: Ethernet frame performance monitoring counters threshold profile name
* onu-name: ONU name
* oversize-pkts-threshold: Threshold value for the total number of oversized packets received range is 0 .. 4294967294
* undersize-pkts-threshold: Threshold value for the total number of undersized packets received range is 0 .. 4294967294

