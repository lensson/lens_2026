This macro configures untag on the user interface.  It creates a user VLAN sub-interface which receives untagged or priority-tagged packets.

Input parameters:

* egress_marking_index: the value of egress pbit/dei marking index
* interface_name: the name of the user VLAN sub-interface
* n-vlan-id: the value of user-side vlan id to match
* priority_tagged_user_traffic: the user VSI can receive priority-tagged traffic or not
* untagged_user_traffic: the user VSI can receive untagged traffic or not

