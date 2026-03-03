Description:
This macro detaches ANI PM TCA profiles from an ONT ANI interface

Prerequisite:

* ANI XPON FEC PM TCA profile should be already associated with xgpon-fec-layer-tca-profile.
* ANI XGPON TC layer PM TCA profile should be already associated with xgpon-tc-layer-tca-profile.
* ANI XGPON Downstream PM TCA profile should be already associated with xgpon-ds-layer-tca-profile.
* ANI aggregate GEM frame PM TCA profile should be created to associate it with tca-gem-frame-err-profile.

Input parameters:

* xgpon-fec-layer-tca-profile    :  xgpon-fec-layer-tca-profile name
* xgpon-tc-layer-tca-profile    :  xgpon-tc-layer-tca-profile name
* xgpon-ds-layer-tca-profile    :  xgpon-ds-layer-tca-profile name
* gem-frame-error-profile    :  gem-frame-error-profile name


Input parameters:

* onu-ani-intf: ONT ANI interface name
* onu-name: ONU name
* tca-gem-frame-err-profile: Aggregate GEM frame error TCA profile name
* tca-xgpon-xgs-ds-err-profile: ANI XGPON downstream PM counters threshold profile name
* tca-xgpon-xgs-tc-err-profile: ANI XGPON TC layer PM counters threshold profile name
* tca-xpon-fec-err-profile: tca-xpon-fec-err-profile name

