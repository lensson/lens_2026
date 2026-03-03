This macro configures the allow-server-at-user-side flag to allow exchanging PPPoE messages with a PPPoE server located at the user side and to allow exchanging PPPoE messages with a PPPoE client located at the network side instead of discarding them. This flag does not impact the processing of PPPoE messages exchanged with a PPPoE client/server at the user/network side.

The default value of this parameter is false.

Prerequisite:

* Applicable only when PPPoE Intermediate Agent is enabled.

Input parameters:

* allow-server-at-user-side: Enable/Disable the option to forward server PPPoE messages from user interface and client PPPoE messages from network side
* cc-name: The name of CC sample
* ibridge-user-port-name: Ibridge user port name

