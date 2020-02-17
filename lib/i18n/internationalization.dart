import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class FastShoppingI18n {
  static final FastShoppingI18n _singleton = FastShoppingI18n._();
  static const String _fallbackLocale = 'en_US';

  Map<String, String> _preferredMessages;
  Map<String, String> _fallbackMessages;

  factory FastShoppingI18n() => _singleton;
  FastShoppingI18n._();

  Future<void> init([String preferredLocale = 'en_US']) async {
    if (preferredLocale != 'en_US') {
      try {
        final json = await rootBundle
            .loadString('lib/i18n/messages/$preferredLocale.json');
        _preferredMessages = Map<String, String>.from(jsonDecode(json));
      } catch (_) {
        try {
          final language = preferredLocale.split('_').first;

          final json =
              await rootBundle.loadString('lib/i18n/messages/$language.json');
          _preferredMessages = Map<String, String>.from(jsonDecode(json));
        } catch (_) {}
      }
    }

    final fallbackJson =
        await rootBundle.loadString('lib/i18n/messages/$_fallbackLocale.json');
    _fallbackMessages = Map<String, String>.from(jsonDecode(fallbackJson));
  }

  String message(String key) {
    if (_preferredMessages != null && _preferredMessages.containsKey(key)) {
      return _preferredMessages[key];
    } else if (_fallbackMessages.containsKey(key)) {
      return _fallbackMessages[key];
    }

    return '❗ $key';
  }
}