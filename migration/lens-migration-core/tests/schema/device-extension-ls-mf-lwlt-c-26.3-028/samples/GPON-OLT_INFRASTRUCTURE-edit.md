This macro edits a GPON infrastructure in the OLT on which GPON ONUs can be attached.

In Type-B protection case:

- laser-on-by-default needs to be configured as false. 
- If the channel termination is the secondary channel termination in TypeB protection group, channel-termination-type-b-pon-location-data also needs to be configured with location data of the Primary channel termination to ensure service connectivity for DHCP relay
- If the channel termination is the secondary channel termination in TypeB protection group, and if system host-id is configured on primary pon, host-id-of-primary-side needs to be configured to update the host-id of primary LT to secondary LT channel termination.

Input parameters:

* access-node-id: This is typically the access-node-id of the node which hosts the primary channel termination. In that case the value is identified by the object.
* authentication-fail-control: Determines how the OLT must react when a discovered ONU fails all authentication possibilities after PLOAM messages exchange.
* authentication-method: ONU authentication mode.
* ber-tca-profile: Configuration of an xPON channel pair with ber-tca profile data applyed on all ONUs ranged on given channel-pair.
* closest-onu-distance: The distance of the closest ONU.
* ct-enabled: The configured, desired state of the interface.
* dba-congestion-monitoring-enable: If true, enables DBA congestion monitoring for the interface for the supported periods.
* dba-congestion-monitoring-threshold: Specifies the threshold value in percentage of the PON capacity beyond which the system declares the PON as congested.
* early-fetch-onu-loid-info: This indicates whether onu-present-and-unexpected alarm is enable report onu loid info.
* fec-downstream-enable: Enable/disable downstream Forward Error Correciton (FEC).
* gpon-pon-id: The PON identifier of this channel-termination. It is a string representing 7 hexadecimal octets expressed in ASCII.
* gpon-pon-id-interval: This indicates the frequency of transmission of the periodic downstream PON-ID PLOAM message of this G-PON. Value '0' allows not to generate this PLOAM message.
* host-id-of-primary-side: In case of secondary LT in typeb, configure system host-id of primary LT to host-id-of-primary-side on secondary CT.
* laser-on-by-default: Control laser-on, none type-b case need be configured true, type-b case need be configured false.
* loid-alternate-fetch-fall-back: This indicates whether to fallback to proprietary LOID ME after failure to obtain LOID by ONU-G ME.
* maximum-differential-xpon-distance: The maximum differential logical reach for a channel partition.
* meant-for-type-b-primary-role: It is for intralt type-b and both CTs which refer to the same CP. One CT is true, the other is false, the value of both CTs cannot be the same. the secondary CT don't allow to be created before the primary CT and only the secondary CT can be deleted when service is configured.
* olt-infrastructure-name: OLT infrastructure name.
* olt-port-name: OLT infrastructure port name.
* pm-enable: If true, enables performance counters on this channel-termination interface.
* port-id: This is typically the number of the port that terminates the primary channel termination.
* scg-index: This attribute identifies the partition inside the channel-group.
* slot-id: This is typically the slot-id of the board hosting the primary channel-termination.
* specific-polling-period: Quiet window control specifically to this channel-pair. Value zero means the channel pair will never offer any quiet windows.
* speed-monitoring-enable: If true, enables speed monitoring for the interface for the supported periods.
* us-omci-granting: This attribute modifies the frequency at which the OLT channel-pair port will allocate grants to the ONUs for their OMCI communication.

