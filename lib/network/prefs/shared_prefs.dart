import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:survey/models/user.dart';

class SharedPrefs {
  SharedPreferences? _prefs;

  SharedPrefs._();

  Future<void> init() async {
    if (_prefs != null) return;
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<SharedPrefs> getInstance() async {
    final instance = SharedPrefs._();
    await instance.init();
    return instance;
  }

  User? getUser() {
    final loggerInUserJsonStr = _prefs!.getString("logged_in_user");
    if (loggerInUserJsonStr == null) return null;
    final loggedInUserJson = json.decode(loggerInUserJsonStr);
    print(loggedInUserJson);
    return User.fromJson(loggedInUserJson);
  }

  Future<void> putUser(User user) async {
    final loggedInUserJson = json.encode(user.toJson());
    await _prefs!.setString("logged_in_user", loggedInUserJson);
  }

  Future<void> removeUser() async {
    await _prefs!.remove("logged_in_user");
  }
}
