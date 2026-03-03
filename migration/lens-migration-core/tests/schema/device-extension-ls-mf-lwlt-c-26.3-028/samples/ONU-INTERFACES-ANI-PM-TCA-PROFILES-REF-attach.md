Description:
This macro attaches ANI PM TCA profiles to an ONT ANI interface

Prerequisite:

* ANI interface should be created and PM enabled.
* ANI XPON FEC PM TCA profile should be created to associate it with xgpon-fec-layer-tca-profile. FEC profile is valid for GPON and XGPON ONU types
* ANI XGPON TC layer PM TCA profile should be created to associate it with xgpon-tc-layer-tca-profile. TC layer profile valid only for XGPON ONU types.
* ANI XGPON Downstream PM TCA profile should be created to associate it with xgpon-ds-layer-tca-profile. Downstream TCA profile valid only for XGPON ONU types.
* ANI aggregate GEM frame PM TCA profile should be created to associate it with tca-gem-frame-err-profile.


Input parameters:

* xgpon-fec-layer-tca-profile   :  xgpon-fec-layer-tca-profile name
* xgpon-tc-layer-tca-profile    :  xgpon-tc-layer-tca-profile name
* xgpon-ds-layer-tca-profile    :  xgpon-ds-layer-tca-profile name
* gem-frame-error-profile    :  gem-frame-error-profile name
Input parameters:

* onu-name: ONU name
* onu-template-ani-intf: ANI interface name
* tca-gem-frame-err-profile: Aggregate GEM frame error TCA profile name
* tca-xgpon-xgs-ds-err-profile: ANI XGPON downstream PM counters TCA profile name
* tca-xgpon-xgs-tc-err-profile: ANI XGPON TC layer PM counters TCA profile name
* tca-xpon-fec-err-profile: ANI XGPON FEC error PM counters TCA profile name

