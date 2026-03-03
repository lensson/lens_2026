This macros configure the software rollback behaviour in case of an OAM management connectivity loss detected after a software upgrade. If desired, Lightspan can perform an autonomous rollback to avoid node isolation due OAM changes as part of an upgrade or migration.
By default the SW rollback on OAM connectivity loss is enabled.

Input parameters:

* enable: enable or disable software rollback on connectivity loss, default should be enable.
* time: Indicates the delay between detection of connectivity loss and the actual triggering of the Lightspan application software rollback. The time can be configured from 5 minutes up to 120 minutes as allowed range, default should be 20.

