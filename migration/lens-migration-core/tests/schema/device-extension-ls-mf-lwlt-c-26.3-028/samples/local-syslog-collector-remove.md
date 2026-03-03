This macro removes the local syslog collector.

When removing the configuration for a local log file, the file itself and all rotated files that have been created are removed from the local filesystem. Please make sure to retrieve all the affected log files from the device before proceeding to such a configuration.

Pre-condition:

The following procedures must be fulfilled before deleting the local log file

* A local log file has been configured before.

Input parameters:

* log-file-name: name of the file

