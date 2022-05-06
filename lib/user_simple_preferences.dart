import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences {
  static final SharedPreferences _preferences =
      SharedPreferences.getInstance() as SharedPreferences;

  static const _keyTodo = 'tdod';

  static Future setTodo(String todo) async {
    await _preferences.setString(_keyTodo, todo);
  }

  static String? getTodo() => _preferences.getString(_keyTodo);
}
