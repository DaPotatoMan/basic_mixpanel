import 'package:basic_mixpanel/src/base.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class MixpanelNative extends MixpanelBase<Mixpanel> {
  MixpanelNative.init(super.token) : super.init(sdk: Mixpanel.init(token, trackAutomaticEvents: true));

  @override
  identify(id) => use((sdk) => sdk.identify(id));

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
