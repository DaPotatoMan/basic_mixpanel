import 'dart:convert';

import 'package:basic_mixpanel/basic_mixpanel.dart';
import 'package:basic_mixpanel/src/desktop_shared.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
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

    test('alias is exposed and completes', () async {
      final mixpanel = Mixpanel.init('token-123');

      await mixpanel.alias('user-456', 'anon-123');
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

    test('unregisterSuperProperties is exposed and completes', () async {
      final mixpanel = Mixpanel.init('token-123');

      await mixpanel.unregisterSuperProperties(['region', 'plan']);
    });
  });

  group('MixpanelAnalytics', () {
    test('persists an anonymous distinct id until reset', () async {
      SharedPreferences.setMockInitialValues({});
      final firstClient = _RecordingClient();
      final first = MixpanelAnalytics(token: 'token')..http = firstClient;

      await first.track(event: 'opened', properties: {});
      final firstId = firstClient.distinctId;

      final secondClient = _RecordingClient();
      final second = MixpanelAnalytics(token: 'token')..http = secondClient;
      await second.track(event: 'opened', properties: {});

      expect(firstId, matches(RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$')));
      expect(secondClient.distinctId, firstId);

      await second.reset();
      await second.track(event: 'opened', properties: {});

      expect(secondClient.distinctId, isNot(firstId));
    });

    test('identify merges the anonymous id before using the identified id', () async {
      SharedPreferences.setMockInitialValues({});
      final client = _RecordingClient();
      final analytics = MixpanelAnalytics(token: 'token')..http = client;

      await analytics.track(event: 'opened', properties: {});
      final anonymousId = (client.events.single['properties'] as Map<String, dynamic>)['distinct_id'];

      await analytics.identify('user-123');

      final merge = client.events.last;
      expect(merge['event'], r'$identify');
      expect(merge['properties'], {
        r'$identified_id': 'user-123',
        r'$anon_id': anonymousId,
        'token': 'token',
      });

      await analytics.track(event: 'opened', properties: {});
      expect((client.events.last['properties'] as Map<String, dynamic>)['distinct_id'], 'user-123');
    });
  });
}

class _RecordingClient extends BaseClient {
  final events = <Map<String, dynamic>>[];

  String? get distinctId => (events.last['properties'] as Map<String, dynamic>)['distinct_id'] as String?;

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    final data = request.url.queryParameters['data']!;
    final event = jsonDecode(utf8.decode(base64Decode(data))) as Map<String, dynamic>;
    events.add(event);
    return StreamedResponse(Stream<List<int>>.value(const []), 200);
  }
}
