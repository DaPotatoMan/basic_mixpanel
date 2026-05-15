import 'dart:async';

import 'package:flutter/foundation.dart';

/// Configuration for [Mixpanel].
class MixpanelConfig {
  /// Creates a configuration for Mixpanel SDK initialization.
  const MixpanelConfig({
    this.serverUrl = 'https://api-eu.mixpanel.com',
    this.logging = false,
  });

  /// Enables SDK logging when `true`.
  final bool logging;

  /// Mixpanel ingest endpoint.
  final String serverUrl;
}

/// Base contract used by platform-specific Mixpanel implementations.
abstract class MixpanelBase<SDK> {
  const MixpanelBase.init(this.token, {required this.sdk});

  @protected
  final FutureOr<SDK> sdk;
  final String token;

  @protected
  @nonVirtual
  Future<T> use<T>(T Function(SDK sdk) fn) async => fn(await sdk);

  /// Associates future events with a known user id.
  Future<void> identify(String id);

  /// Maps an anonymous id to a known user id.
  Future<void> alias(String alias, String distinctId);

  /// Clears local identity and stored queue data.
  Future<void> reset();

  /// Sends queued events immediately.
  Future<void> flush();

  /// Registers super properties to attach to all future events.
  Future<void> registerSuperProperties(Map<String, dynamic> props);

  /// Registers super properties only if they do not already exist.
  Future<void> registerSuperPropertiesOnce(Map<String, dynamic> props);

  /// Removes a single super property.
  Future<void> unregisterSuperProperty(String prop);

  /// Removes all registered super properties.
  Future<void> clearSuperProperties();

  /// Sets a single people/profile property.
  Future<void> setPeopleProp(String prop, dynamic to);

  /// Sets multiple people/profile properties.
  Future<void> setPeopleProps(Map<String, dynamic> props);

  /// Tracks an event with optional properties.
  Future<void> track(
    String event, {
    Map<String, dynamic> properties = const {},
  });
}
