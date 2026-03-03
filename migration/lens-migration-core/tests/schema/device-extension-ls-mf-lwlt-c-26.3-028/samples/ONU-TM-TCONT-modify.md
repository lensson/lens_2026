Description:
This sample modifies T-CONT parameters.

T-CONTs support three scheduling policies:

*   SP policy: Strict Priority, all queues have different priorities.
*   WRR policy: Weighted Round Robin, all queues have the same priority.
*   SP+WRR policy: Hybrid SP and WRR scheduler, some queues have different priorities, and some queues have the same priority. All WRR queues must have the same and lowest priority.

Prerequisite:
device has to be created.
ANI Interface has to be created

Input parameters:

* alloc-id: ONU Alloc ID
* ani-name: ANI name reference
* onu-name: ONU name
* queue0-priority: Queue0 Priority Value
* queue0-weight: Queue0 Weight Value
* queue1-priority: Queue1 Priority Value
* queue1-weight: Queue1 Weight Value
* queue2-priority: Queue2 Priority Value
* queue2-weight: Queue2 Weight Value
* queue3-priority: Queue3 Priority Value
* queue3-weight: Queue3 Weight Value
* queue4-priority: Queue4 Priority Value
* queue4-weight: Queue4 Weight Value
* queue5-priority: Queue5 Priority Value
* queue5-weight: Queue5 Weight Value
* queue6-priority: Queue6 Priority Value
* queue6-weight: Queue6 Weight Value
* queue7-priority: Queue7 Priority Value
* queue7-weight: Queue7 Weight Value
* tc-2-q-profile-name: TC Id 2 Queue Id Mapping Profile Name
* tcont-name: T-CONT Name

