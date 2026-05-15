import 'package:basic_mixpanel/src/base.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class MixpanelNative extends MixpanelBase<Mixpanel> {
  MixpanelNative.init(super.token, MixpanelConfig config)
      : super.init(
          sdk: Mixpanel.init(token, trackAutomaticEvents: true, config: {'ignore_dnt': true}).then((sdk) {
            sdk
              ..setLoggingEnabled(config.logging)
              ..setServerURL(config.serverUrl)
              ..optInTracking();

            return sdk;
          }),
        );

  @override
  identify(id) => use((sdk) => sdk.identify(id));

  @override
  reset() => use((sdk) => sdk.reset());

  @override
  setPeopleProp(prop, to) => use((sdk) => sdk.getPeople().set(prop, to));

  @override
  registerSuperProperties(props) => use((sdk) => sdk.registerSuperProperties(props));

  @override
  registerSuperPropertiesOnce(props) => use((sdk) => sdk.registerSuperPropertiesOnce(props));

  @override
  clearSuperProperties() => use((sdk) => sdk.clearSuperProperties());

  @override
  track(
    event, {
    properties = const {},
  }) =>
      use((sdk) => sdk.track(event, properties: properties));
}
