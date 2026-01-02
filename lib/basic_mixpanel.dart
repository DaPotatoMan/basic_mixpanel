import 'dart:io';

import 'package:basic_mixpanel/src/base.dart';
import 'package:basic_mixpanel/src/desktop.dart' deferred as desktop;
import 'package:basic_mixpanel/src/native.dart' deferred as native;
import 'package:flutter/foundation.dart';

export 'package:basic_mixpanel/src/base.dart' show MixpanelConfig;

class Mixpanel extends MixpanelBase<MixpanelBase<dynamic>> {
  Mixpanel.init(super.token, [MixpanelConfig config = const MixpanelConfig()]) : super.init(sdk: _loadLib(token, config));

  static Future<MixpanelBase<dynamic>> _loadLib(String token, MixpanelConfig config) async {
    if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      await native.loadLibrary();
      return native.MixpanelNative.init(token, config);
    } else {
      await desktop.loadLibrary();
      return desktop.MixpanelDesktop.init(token, config);
    }
  }

  @override
  identify(id) => use((sdk) => sdk.identify(id));

  @override
  registerSuperProperties(props) => use((sdk) => sdk.registerSuperProperties(props));

  @override
  registerSuperPropertiesOnce(props) => use((sdk) => sdk.registerSuperPropertiesOnce(props));

  @override
  clearSuperProperties() => use((sdk) => sdk.clearSuperProperties());

  @override
  track(event, {properties = const {}}) => use((sdk) => sdk.track(event, properties: properties));

  @override
  setPeopleProp(prop, to) => use((sdk) => sdk.setPeopleProp(prop, to));
}
