Description:

This macro modifies the ONU metadata defined under the onu-management
node (e.g. mib-upload-behavior).

The update is applied to the ONU template or ONU instance depending on the
usage parameter value

Prerequisite:
*   The ONU has to be created

Input parameters:

* mib-upload-behavior-value: **mib-upload-per-onu-flavor** to only perform MIB upload when the first ONU of a flavor is discovered or **mib-upload-per-onu** to perform always MIB upload
* onu-name: ONU name, in case usage = template this identifies the template
* onu-template: a reference to the ONU template, needs to be specified when usage = template-overrule
* usage: **template** when this edit applies to an ONU template, **template-overrule** when this edit applies to a template overrule for this ONU, **parameter not used** when this edit applies to an ONU instance,

