import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Secrets {
  static final Map<String, String> _keys = {};
  static bool _loaded = false;

  static Future<void> load() async {
    if (_loaded) return;
    _loaded = true;

    try {
      final data = await rootBundle.loadString('config/keys.json');
      final json = jsonDecode(data) as Map<String, dynamic>;
      json.forEach((k, v) => _keys[k] = v.toString());
    } catch (_) {}

    _keys.putIfAbsent('featherless', () => const String.fromEnvironment(
      'FEATHERLESS_KEY',
      defaultValue: '',
    ));
  }

  static String get featherlessKey => _keys['featherless'] ?? '';
  static bool get hasFeatherlessKey => featherlessKey.isNotEmpty;
}
