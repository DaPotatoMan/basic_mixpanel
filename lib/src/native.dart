import 'package:basic_mixpanel/src/base.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class MixpanelNative extends MixpanelBase<Mixpanel> {
  MixpanelNative.init(super.token)
      : super.init(
          sdk: Mixpanel.init(token, trackAutomaticEvents: true).then((sdk) {
            sdk
              ..setServerURL('https://api-eu.mixpanel.com')
              ..optInTracking();

            return sdk;
          }),
        );

  @override
  identify(id) => use((sdk) => sdk.identify(id));

  @override
  setPeopleProp(prop, to) => use((sdk) => sdk.getPeople().set(prop, to));

  @override
  registerSuperProperties(Map<String, dynamic> properties) => use((sdk) => sdk.registerSuperProperties(properties));

  @override
  registerSuperPropertiesOnce(Map<String, dynamic> properties) => use((sdk) => sdk.registerSuperPropertiesOnce(properties));

  @override
  Future<void> clearSuperProperties() => use((sdk) => sdk.clearSuperProperties());

  @override
  track(
    event, {
    properties = const {},
  }) =>
      use((sdk) => sdk.track(event, properties: properties));
}
