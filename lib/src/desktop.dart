import 'package:basic_mixpanel/src/base.dart';
import 'package:basic_mixpanel/src/desktop_shared.dart';

class MixpanelDesktop extends MixpanelBase<MixpanelAnalytics> {
  MixpanelDesktop.init(super.token, MixpanelConfig config)
      : super.init(
          sdk: MixpanelAnalytics(
            token: token,
            verbose: true,
            useIp: true,
            baseApiUrl: config.serverUrl,
          ),
        );

  @override
  identify(id) => registerSuperProperties({'distinct_id': id});

  @override
  alias(alias, distinctId) => track(
        r'$create_alias',
        properties: {
          'alias': alias,
          'distinct_id': distinctId,
        },
      );

  @override
  reset() => use((sdk) => sdk.reset());

  @override
  flush() => use((sdk) => sdk.flush());

  @override
  registerSuperProperties(props) => use((sdk) => sdk.engage(operation: MixpanelUpdateOperations.$set, value: props));

  @override
  registerSuperPropertiesOnce(props) => use((sdk) => sdk.engage(operation: MixpanelUpdateOperations.$setOnce, value: props));

  @override
  unregisterSuperProperty(prop) => use((sdk) => sdk.engage(operation: MixpanelUpdateOperations.$unset, value: {prop: ''}));

  @override
  clearSuperProperties() => use((sdk) => sdk.engage(operation: MixpanelUpdateOperations.$unset, value: {}));

  @override
  setPeopleProp(prop, to) => use(
        (sdk) => sdk.engage(operation: MixpanelUpdateOperations.$set, value: {prop: to.toString()}),
      );

  @override
  track(event, {properties = const {}}) => use((sdk) => sdk.track(event: event, properties: properties));
}
