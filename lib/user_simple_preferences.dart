import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'todo.dart';

class UserSimplePreferences {
  static const _keyTodo = 'todo';

  static Future setTodo(Todo todo) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    await _preferences.setString(_keyTodo, jsonEncode(todo.toJson()));
  }

  static Future getTodo() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();

    if (_preferences.getString(_keyTodo) != null) {
      return Todo.fromJson(jsonDecode(_preferences.getString(_keyTodo)!));
    } else {
      return null;
    }
  }
}
