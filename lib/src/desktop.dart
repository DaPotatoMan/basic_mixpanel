import 'package:basic_mixpanel/src/base.dart';
import 'package:basic_mixpanel/src/desktop_shared.dart';

class MixpanelDesktop extends MixpanelBase<MixpanelAnalytics> {
  MixpanelDesktop.init(
    super.token, {
    required String serverUrl,
  }) : super.init(
          sdk: MixpanelAnalytics(
            token: token,
            verbose: true,
            useIp: true,
            baseApiUrl: serverUrl,
          ),
        );

  @override
  identify(id) => registerSuperProperties({'distinct_id': id});

  @override
  registerSuperProperties(props) => use((sdk) => sdk.engage(operation: MixpanelUpdateOperations.$set, value: props));

  @override
  registerSuperPropertiesOnce(props) => use((sdk) => sdk.engage(operation: MixpanelUpdateOperations.$setOnce, value: props));

  @override
  clearSuperProperties() => use((sdk) => sdk.engage(operation: MixpanelUpdateOperations.$unset, value: {}));

  @override
  setPeopleProp(prop, to) => use(
        (sdk) => sdk.engage(operation: MixpanelUpdateOperations.$set, value: {prop: to.toString()}),
      );

  @override
  track(event, {properties = const {}}) => use((sdk) => sdk.track(event: event, properties: properties));
}
