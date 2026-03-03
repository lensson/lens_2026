
* Once a user is authenticated, group membership shall be established.
* Group membership is used by the authorization rules to decide which operations a certain user is allowed to perform.
* A single user can be a member of several groups. And a group can include more than one user.

* There are certain pre-provisioned groups and rule-lists in the device in order to provide Role based access control (RBAC) functionality.
  It is not possible to modify the pre-provisioned rules or the order or those, as pre-configured authorization rules are designed to serve certain functionality in specific order.
  The pre-defined groups will be related to separate domain/area and will permit the access in a set of yang modules that describe this particular area.

* For each domain/area, three different groups will exist based on the level of access:
    - read-only: permits only the read the data nodes of a domain
    - read-write: permits to read, create, update and delete the nodes of an area.
    - exec: permits to perform the actions which are defined for an area

* A user who does not belong to any of the groups, is matched automatically in “defaultGroup”.
  There is no reason for explicitly assignment in that group. In case the user is assigned to any of the pre-defined groups, the matching to “defaultGroup” is cancelled.

* It will be possible to assign any user to the pre-defined groups.
  So, by assigning a user in a group with read access, user will be able to retrieve the configuration of this profile, but not to configure.
  In order to take write permissions, operator should assign the user in the read-write group and remove from read group.  The same will be applicable for exec option.

* Any modification to pre-provisioned rules can happen by techsupport user, but it should be done with caution,
  as it can result in unspecified behavior and affect the behavior or all pre-configured users and groups.

* Role Based Access Control is applied for both CLI and Netconf connections.
    - When executing a command or rpc, the rules in the authorization database are searched.
    - When actual data access is attempted, the data rules are searched.
    - The rules are tried in order, when a rule matches the operation (command), the action of the matching rule is applied - whether permit or deny.


Pre-condition:

* Only users belong to admin group can add users in a pre-defined group.

Procedure:

* A user is added in a pre-defined group.


Input parameters:

* group-name: Group name associated with this entry.
* user-name: The name of users who belong to this group.

