import 'dart:io';

import 'package:basic_mixpanel/src/base.dart';
import 'package:basic_mixpanel/src/desktop.dart' deferred as desktop;
import 'package:basic_mixpanel/src/native.dart' deferred as native;
import 'package:flutter/foundation.dart';

class Mixpanel extends MixpanelBase<MixpanelBase<dynamic>> {
  Mixpanel.init(
    super.token, {
    String serverUrl = 'https://api-eu.mixpanel.com',
  }) : super.init(sdk: _loadLib(token, serverUrl));

  static Future<MixpanelBase<dynamic>> _loadLib(String token, String serverUrl) async {
    if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      await native.loadLibrary();
      return native.MixpanelNative.init(token, serverUrl: serverUrl);
    } else {
      await desktop.loadLibrary();
      return desktop.MixpanelDesktop.init(token, serverUrl: serverUrl);
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
