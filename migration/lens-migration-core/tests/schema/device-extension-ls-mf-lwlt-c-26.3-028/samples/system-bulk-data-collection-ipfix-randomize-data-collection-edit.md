This option enables or disables the randomization of the exporting interval.
It applies only to non-PM configured caches.

The default value of this attribute is "false", in which case all subsequent exports are aligned to the wall-clock. 
When enabled (ie. the option value is set to "true"), then the export interval for each non-PM cache will be offset by a random value over the wall-clock expiry.

Input parameters:

* randomize-data-collection-enable: Either true or false in order to enable or disable the randomize-data-collection functionality

