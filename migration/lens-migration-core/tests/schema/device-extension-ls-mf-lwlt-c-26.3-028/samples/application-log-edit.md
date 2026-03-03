This macro configures logging at a chosen severity level for an application

* Set Logger Logging configuration.
* The equal-or-higher rule is applied, meaning that if info level is chosen then all levels of info and above will be generated from the specific submodule of application.

Pre-condition:

* To be able to configure logging level of a specific application you should explicit use the application and module name as returned by active-applications.

Log levels Description:

* critical: Immediate action must be taken on the system
* error: Error condition that must be handled
* warning: Potential problem that may need to be handled
* info: Informative messages regarding the action or the state of app
* debug: Information about internal state/flow of the application (verbose)

Input parameters:

* app-name: application name
* loglevel: severity level
* module-name: logger name

