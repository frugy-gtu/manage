import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Auth {
  static Box _box;

  static Future<void> init() async {
    _box = await Hive.openBox('auth');
  }

  static bool isLoggedIn() {
    switch (_box.get('status', defaultValue: 0)) {
      case 0:
        return false;
      default:
        return true;
    }
  }

  static set status(AuthStatus status) {
    switch (status) {
      case AuthStatus.logged_out:
        _box.put('status', 0);
        break;
      default:
        _box.put('status', 1);
        break;
    }
  }

  static get accessToken => _box.get('accessToken', defaultValue: '');

  static set accessToken(String token) => _box.put('accessToken', token);

  static ValueListenable<Box> listenable(List<String> keys) {
    return _box.listenable(keys: keys);
  }
}

enum AuthStatus {
  logged_in,
  logged_out,
}
