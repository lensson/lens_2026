This macro creates or modifies a flooding profile.

Please note:
    If device can support subtended port, the parameter "SUBTENDED-PORT-SUPPORT" must be set as true.
    If device can't support subtended port, don't need to set parameter "SUBTENDED-PORT-SUPPORT".

Input parameters:

* ds-flood-ntp-multicast-address-frame: Enable or disable DS NTP flooding, it's optional
* ds-nni-flood-ipv4-multicast-behavior: The DS ipv4 multicast behavior for subtend node port, you can set as "flood_nni" and "flood_nni_limited". If igmp snooping function is enabled, recommend to set as "flood_nni_limited". When set as "flood_nni_limited", 224.0.0.x will be flooded in NNI port.
* ds-uni-flood-any-frame: Enable or disable DS any frame flooding, it's optional
* ds-uni-flood-any-multicast-mac-frame: Enable or disable DS any multicast flooding, it's optional
* ds-uni-flood-broadcast-address-frame: Enable or disable DS broadcast flooding, it's optional
* ds-uni-flood-ipv4-multicast-address-frame: Enable or disable DS unknown IPv4 multicast flooding, it's optional
* ds-uni-flood-ipv6-multicast-address-frame: Enable or disable DS unknown IPv6 multicast flooding, it's optional
* ds-uni-flood-rip-multicast-address-frame: Enable or disable DS RIP flooding, it's optional
* ds-uni-flood-unknown-unicast-frame: Enable or disable DLF flooding, it's optional
* selective-flooding-policy-name: the name of the SELECTIVE-FLOODING-POLICY-NAME
* subtended-port-support: If device can support subtended port, please set as true.
* us-flood-any-multicast-mac-frame: Enable or disable US any multicast flooding, it's optional
* us-flood-ipv4-multicast-address-frame: Enable or disable US unknown IPv4 multicast flooding, it's optional
* us-flood-ipv6-multicast-address-frame: Enable or disable US unknown IPv6 multicast flooding, it's optional
* us-flood-ntp-multicast-address-frame: Enable or disable US NTP flooding, it's optional
* us-flood-rip-multicast-address-frame: Use 'usRIP_flood' to control flood US RIP, it's optional

