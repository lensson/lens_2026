This macro creates an Uplink interface with SFP being plugged in.

On the ethernet layer:

* If the interface is configured in autoneg mode:
    - When no speed is specified the interface will automatically negotiate at the maximum possible speed, when a speed is specified only the specified speed will be advertised to the peer side.
    - When speed is specified, only the configured speed will be advertised towards the peer.
* For optical interfaces, if the interface is configured in manual mode, and no specification of speed/duplex is provided, the device will automatically determine the nominal speed of the transceiver and try to establish the link.
* For electrical interfaces, the preferred mode is autoneg.
* Only full duplex is supported.

Queue profiles:

* 2 queues will be created within this ETHERNET interface for DFMB-A, 4 queues for DFMB-B and DFMB-D.

SP and WRR:

    - For DFMB-A: Default 2 SP queues per SFP+ uplink port
    - For DFMB-B/DFMB-D:
           - Default 2 SP queues per QSFP uplink port as DFMB-A (No QSFP for DFMB-D)
           - 4 SP+WRR queues per SFP+ uplink port
           - Default 4 SP queues of Aldrin driver are created with system initialization, queue priority and weight can be modified,  queues can not be deleted
           - Queue priority range is 0~3
           - For WRR, queue weight must NOT be 0, queue priority must be 0.
           - For SP,  queue priority must same with queueId, queue weight must be 0.
           - For 1 GigE uplink ports, with maximum 2 WRR queues per port
           - For 10 GigE uplink ports, with maximum 2 WRR queues per port, but no effect for queue weight configuration. (priority still OK)

Pre-condition:

* SFP should be plugged at the UPLINK cage
* Cage, SFP and Port configurations should be present. Refer GPON-OLT_PORT-edit.xml macro for configurations RPC

Input parameters:

* duplex: Nature of the port
* interface-type: Type of the interfaces
* network-port: Name of the transceiver-link
* network-port-name: Name of interface
* queue: Number of local queues
* queue-profile: Queue Profile name
* queue0-priority: Priority of queue0
* queue0-weight: Weight of queue0
* queue1-priority: Priority of queue1
* queue1-weight: Weight of queue1
* queue2-priority: Priority of queue2
* queue2-weight: Weight of queue2
* queue3-priority: Priority of queue3
* queue3-weight: Weight of queue3
* speed-in-gb: Supported speeds are given below

