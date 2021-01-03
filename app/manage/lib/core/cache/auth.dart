import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:manage/core/model/user_model.dart';

class Auth {
  static Box _box;
  static UserModel _user;

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

  static UserModel get user {
    if(isLoggedIn()) {

      if(_user != null) return _user;

      _user = UserModel(
        email: _box.get('email'),
        username: _box.get('username'),
      );

      return _user;
    }

    return null;
  }

  static set user(UserModel user) {
    _box.put('email', user.email);
    _box.put('username', user.username);
  }

  static set status(AuthStatus status) {
    switch (status) {
      case AuthStatus.logged_out:
        _box.put('status', 0);
        _user = null;
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
