This macro configures mib reset sync count for ONU template.

- Mib-reset-sync-count is an integer (range 1 .. 4294967295 or empty) that identifies the version of an onu template in the onu-emulated-mount.

  - Note: Empty value is supported for backward compatibility.

- The mib-reset-sync-count is used to instruct whether a new onu template version should force an omci mib reset of all attached ont instances using the onu template.

  - If a new onu template version is configured to the device with mib-reset-sync-count different from the previous version, an omci mib reset will be enforced to all onts using the template.
  - If a new onu template version is configured to the device with the same mib-reset-sync-count same as the previous version, the mib reset will be suppressed.
  - It is advised to initialize the mib-reset-sync-count of an onu template at 1 and to increment by 1 for every onu template version that requires a mib reset.

- By default, onu template modifications should always force a mib reset of attached ont instances for predictable omci behaviour. This will be service impacting to customers connected over impacted ont's.
- For known safe onu template modifications with predictable omci behaviour, the mib reset can be suppressed by keeping the mib-reset-sync-count at the same value.

Pre-condition:

 * onu template must be created

Input parameters:

 * mib-reset-sync-count: Value for mib-reset-sync-count range is 1 .. 4294967295

Input parameters:

* mib-reset-sync-count: mib reset sync count
* onu-template-name: ONU template name

