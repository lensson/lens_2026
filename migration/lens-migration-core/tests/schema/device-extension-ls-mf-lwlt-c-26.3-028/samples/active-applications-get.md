This macro is for retrieving the current log level of the available loggers per application.

Purpose:

* The purpose is to retrieve the list of loggers on the system with their logging level state
* The default severity of each module should be in the default level (WARNING), when no specific configuration has been given on the device.
* If a specific configuration has been given, then the logging level will change to this value

Procedure:

* The objective is to retrieve the list of common loggers per application, running on the device with their logging state.
* Only the applications/modules that are defined in that list are configurable

