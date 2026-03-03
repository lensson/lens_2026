This sample modifies the LLDP-MED port configurations in Ethernet UNI interface using template-parameters.

Prerequisite:

*   ENET UNI interface has to be created
*   LLDP-MED port configuration done using ONU template

Input parameters:

* admin-status: Administrative status of the LLDP port.
* dest-mac-address: Ethernet destination mac-address.
* message-fast-tx: Time interval between LLDP PDU transmissions during fast transmission periods.
* message-tx-hold-multiplier: Multiplier of message-tx-interval. This value is used to cache the learned LLDP cache before discard.
* message-tx-interval: Time interval between LLDP PDU transmissions during normal transmission periods.
* onu-name: ONU name
* onu-template-uni1: Ethernet UNI interface where LLDP-MED port is configured.
* reinit-delay: Amount of delay (in units of seconds) from when admin-status becomes 'disabled' until re-initialization is attempted.
* tx-credit-max: The maximum number of consecutive LLDP PDUs that can be transmitted at any time.
* tx-fast-init: The number of LLDP PDU transmissions that are made during the fast transimission period.

