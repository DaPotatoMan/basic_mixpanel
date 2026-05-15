import 'dart:convert';

import 'package:basic_mixpanel/basic_mixpanel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MixpanelConfig', () {
    test('uses documented defaults', () {
      const config = MixpanelConfig();

      expect(config.logging, isFalse);
      expect(config.serverUrl, 'https://api-eu.mixpanel.com');
    });

    test('accepts overrides', () {
      const config = MixpanelConfig(
        logging: true,
        serverUrl: 'https://api.mixpanel.com',
      );

      expect(config.logging, isTrue);
      expect(config.serverUrl, 'https://api.mixpanel.com');
    });
  });

  group('Mixpanel', () {
    test('creates an instance with the provided token', () {
      final mixpanel = Mixpanel.init('token-123');

      expect(mixpanel.token, 'token-123');
      expect(mixpanel, isA<Mixpanel>());
    });

    test('reset clears persisted mixpanel cache key', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('mixpanel.analytics', jsonEncode({'track': [], 'engage': []}));

      final mixpanel = Mixpanel.init('token-123');
      await mixpanel.reset();

      expect(prefs.getString('mixpanel.analytics'), isNull);
    });

    test('flush is exposed and completes', () async {
      final mixpanel = Mixpanel.init('token-123');

      await mixpanel.flush();
    });

    test('unregisterSuperProperty is exposed and completes', () async {
      final mixpanel = Mixpanel.init('token-123');

      await mixpanel.unregisterSuperProperty('region');
    });
  });
}
