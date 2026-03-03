This macro handles the ability of an administrator user, to forcibly disconnect an active session of another user including another administrator.

Pre-condition:

* All sessions of the device can be terminated using kill-session rpc, when “extendedSessions” parameter is enabled. With “extendedSessions” enabled, not only can other NETCONF session be terminated, but also CLI sessions. Sessions can be received with “netconf-state“ rpc.
* kill-session should be restricted only to admin users.

Input parameters:

* session-id: Particular session to kill.

