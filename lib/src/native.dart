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
  alias(alias, distinctId) => use((sdk) => sdk.alias(alias, distinctId));

  @override
  reset() => use((sdk) => sdk.reset());

  @override
  flush() => use((sdk) => sdk.flush());

  @override
  setPeopleProp(prop, to) => use((sdk) => sdk.getPeople().set(prop, to));

  @override
  setPeopleProps(props) => use((sdk) async {
    final people = sdk.getPeople();

    for (final entry in props.entries) {
      people.set(entry.key, entry.value);
    }
  });

  @override
  registerSuperProperties(props) => use((sdk) => sdk.registerSuperProperties(props));

  @override
  registerSuperPropertiesOnce(props) => use((sdk) => sdk.registerSuperPropertiesOnce(props));

  @override
  unregisterSuperProperty(prop) => use((sdk) => sdk.unregisterSuperProperty(prop));

  @override
  clearSuperProperties() => use((sdk) => sdk.clearSuperProperties());

  @override
  track(
    event, {
    properties = const {},
  }) => use((sdk) => sdk.track(event, properties: properties));
}
