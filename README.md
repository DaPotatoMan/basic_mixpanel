# basic_mixpanel

Minimal cross-platform Mixpanel wrapper for Flutter.

## Install

Add to `pubspec.yaml`:

```yaml
dependencies:
  basic_mixpanel: ^0.0.1
```

## Usage

```dart
import 'package:basic_mixpanel/basic_mixpanel.dart';

final mixpanel = Mixpanel.init(
  'YOUR_MIXPANEL_TOKEN',
  const MixpanelConfig(
    logging: false,
    serverUrl: 'https://api-eu.mixpanel.com',
  ),
);

await mixpanel.identify('user_123');
await mixpanel.track('app_opened', properties: {'source': 'push'});
await mixpanel.setPeopleProp('plan', 'pro');
await mixpanel.flush();
```

## API

- `identify(String id)`
- `alias(String alias, String distinctId)`
- `track(String event, {Map<String, dynamic> properties})`
- `setPeopleProp(String prop, dynamic to)`
- `registerSuperProperties(Map<String, dynamic> props)`
- `registerSuperPropertiesOnce(Map<String, dynamic> props)`
- `unregisterSuperProperty(String prop)`
- `clearSuperProperties()`
- `flush()`
- `reset()`

## Notes

- Default `serverUrl` is `https://api-eu.mixpanel.com`.
- This package loads native or desktop implementation automatically.
