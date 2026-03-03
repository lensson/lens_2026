This macro handles the ability of an administrator user, to configure a disconnection time for idle CLI or NETCONF session connections.

Pre-condition:

* It is possible to configure the maximum idle time , before terminating a session.
* /confdConfig/netconf/idleTmeout (xs:duration) [PT0S]. Maximum idle time before terminating a NETCONF session. If the session is waiting for notifications,or has a pending confirmed commit, the idle timeout is not used. The default value is 0, which means no timeout. Will be silently capped to 49 days 17 hours.
* /confdConfig/cli/idleTimeout (xs:duration) [PT30M]. Maximum idle time before terminating a CLI session. Default is PT30M, ie 30 minutes. PT0M means no timeout. Will be silently capped to 49 days 17 hours.
* The configuration of idle timeouts for CLI or NETCONF parameters takes effect only for new sessions.

Input parameters:

* cli-idletimeout-time: Maximum idle time before terminating a CLI session.
* netconf-idletimeout-time: Maximum idle time before terminating a NETCONF session.

