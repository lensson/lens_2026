This macro modifies the xpon alarm control at system level.

Input parameters:

* ct-data-path-integrity-alarm-control: Threshold value to evaluate the additional info of the data path integrity failure alarm. As well as the threshold to report the alarm, threshold is the percentage beyond which data path integrity alarm will be raised. The value ranges from 1 to 100 or disabled.
* min-dying-gasp-ratio-to-declare-ct-los-with-dying-gasp: Threshold value to evaluate the additional info of the new CT LOS alarm. The threshold expresses the percentage of ONUs active at the time the CT LOS occurred, that raised the dying gasp indication. If the number of ONUs raising dying gasp exceeds this threshold, the additional info of the CT LOS alarm will indicate that a dying gasp is the root cause of the PON failure.
* publish-onu-dying-gasp-on-ct-los: This leaf indicates whether publish the onu-dying-gasp alarm when there is a channel-termination-loss-of-signal (because of fiber-cut or dying gasp).
* report-mac-address: This leaf indicates whether onu-present-and-unexpected alarm is enable report mac address.
* report-onu-parameters: This leaf indicates whether onu-present-and-unexpected alarm is enable report onu parameters.
* suppress-ct-los-alarm-when-no-v-ani-configured: This leaf indicates whether channel-termination-loss-of-signal alarm is suppressed when no v-ani is configured.
* suppress-ct-los-alarm-when-only-one-onu-connected: This leaf indicates whether channel-termination-loss-of-signal alarm is suppressed when only one ONU is connected.
* suppress-mac-addr-separator: This leaf indicates whether onu-present-and-unexpected alarm is enable suppress mac address separator.

