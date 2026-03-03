This macro edits an xPON upstream traffic descriptor profile which can be used to characterize an individual TCONT in an ONU or a virtual ONU.

Input parameters:

* assured-bandwidth: Represents a portion of the link capacity that is allocated to the given traffic flow as long as the flow has unsatisfied traffic demand, regardless of the overall traffic conditions.
* fixed-bandwidth: Represents the reserved portion of the link capacity that is allocated to the given traffic flow, regardless of its traffic demand and the overall traffic load conditions.
* jitter-tolerance: Minimum time interval over which an active traffic flow shall receive an allocation of the size corresponding at least to the assigned bandwidth, expressed as multiple of 125us upstream physical frame.
* maximum-bandwidth: Represents the upper limit on the total bandwidth that can be allocated to the traffic flow under any traffic conditions.
* traffic-descriptor-profile-name: Traffic descriptor profile name.

