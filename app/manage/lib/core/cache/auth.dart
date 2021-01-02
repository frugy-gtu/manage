import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:manage/core/model/general_user_model.dart';

class Auth {
  static Box _box;
  static GeneralUserModel _user;

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

  static GeneralUserModel get user {
    if(isLoggedIn()) {

      if(_user != null) return _user;

      _user = GeneralUserModel(
        email: _box.get('email'),
        username: _box.get('username'),
        createdAt: _box.get('createdAt'),
      );

      return _user;
    }

    return null;
  }

  static set user(GeneralUserModel user) {
    _box.put('email', user.email);
    _box.put('username', user.username);
    _box.put('createdAt', user.createdAt);
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
