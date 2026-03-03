This macro send HGU TR-069 parameters to HGU device without using TR-069 server.

Pre-condition:

 * onu has to be create

Input parameters:

* para-index: Index of pair, range is 1 .. 40, should be unique accrose sensitive and non-sensitive name-value pair.
* para-name: Name of pair, length 10 .. 255, should be unique accrose sensitive and non-sensitive name-value pair.
* para-value: Value of pair, length 1 .. 255.
Input parameters:

* onu-name: ONU name
* para-index: index of the HGU parameter non-sensitive name-value pairs
* para-name: name of the HGU parameter non-sensitive name-value pairs
* para-value: value of the HGU parameter non-sensitive name-value pairs
* sensitive-para-index: index of the HGU parameter sensitive name-value pairs
* sensitive-para-name: name of the HGU parameter sensitive name-value pairs
* sensitive-para-value: value of the HGU parameter sensitive name-value pairs

