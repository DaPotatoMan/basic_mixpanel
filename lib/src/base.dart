import 'dart:async';

import 'package:flutter/foundation.dart';

class MixpanelConfig {
  const MixpanelConfig({
    this.serverUrl = 'https://api-eu.mixpanel.com',
    this.logging = false,
  });

  final bool logging;
  final String serverUrl;
}

abstract class MixpanelBase<SDK> {
  const MixpanelBase.init(this.token, {required this.sdk});

  @protected
  final FutureOr<SDK> sdk;
  final String token;

  @protected
  @nonVirtual
  Future<T> use<T>(T Function(SDK sdk) fn) async => fn(await sdk);

  Future<void> identify(String id);

  Future<void> registerSuperProperties(Map<String, dynamic> props);
  Future<void> registerSuperPropertiesOnce(Map<String, dynamic> props);
  Future<void> clearSuperProperties();

  Future<void> setPeopleProp(String prop, dynamic to);

  Future<void> track(
    String event, {
    Map<String, dynamic> properties = const {},
  });
}
