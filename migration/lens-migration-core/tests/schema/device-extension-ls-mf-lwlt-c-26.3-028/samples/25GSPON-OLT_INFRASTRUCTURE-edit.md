This macro edits an 25GSPON infrastructure in the OLT on which 25GSPON ONUs can be attached.

Input parameters:

* authentication-fail-control: Determines how the OLT must react when a discovered ONU fails all authentication possibilities after PLOAM messages exchange.
* authentication-method: ONU authentication mode.
* ber-tca-profile: Configuration of an xPON channel pair with ber-tca profile data applyed on all ONUs ranged on given channel-pair.
* closest-onu-distance: The distance of the closest ONU.
* ct-enabled: The configured, desired state of the interface.
* early-fetch-onu-loid-info: This indicates whether onu-present-and-unexpected alarm is enable report onu loid info.
* loid-alternate-fetch-fall-back: This indicates whether to fallback to proprietary LOID ME after failure to obtain LOID by ONU-G ME.
* maximum-differential-xpon-distance: The maximum differential logical reach for a channel partition.
* olt-infrastructure-name: OLT infrastructure name.
* olt-port-name: OLT infrastructure port name.
* pm-enable: If true, enables performance counters on this channel-termination interface.
* scg-index: This attribute identifies the partition inside the channel-group.
* specific-polling-period: Quiet window control specifically to this channel-pair. Value zero means the channel pair will never offer any quiet windows.
* twentyfivegs-pon-id: The PON identifier of this channel-termination.
* us-omci-granting: This attribute modifies the frequency at which the OLT channel-pair port will allocate grants to the ONUs for their OMCI communication.

