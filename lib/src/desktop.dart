import 'package:basic_mixpanel/src/base.dart';
import 'package:basic_mixpanel/src/desktop_shared.dart';

class MixpanelDesktop extends MixpanelBase<MixpanelAnalytics> {
  MixpanelDesktop.init(super.token)
      : super.init(
          sdk: MixpanelAnalytics(
            token: token,
            verbose: true,
            useIp: true,
            baseApiUrl: 'https://api-eu.mixpanel.com',
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
  track(event, {properties = const {}}) => use((sdk) => sdk.track(event: event, properties: properties));
}
