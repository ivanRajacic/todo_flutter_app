import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'todo.dart';

class TodoPreferences {
  final _keyTodo = 'todo';
  final _preferences = SharedPreferences.getInstance();

  Future setTodos(List<Todo> todos) async {
    final preferences = await _preferences;

    final stringTodos = todos.map((e) => jsonEncode(e.toJson())).toList();
    await preferences.setStringList(_keyTodo, stringTodos);
  }

  Future<List<Todo>> getTodos() async {
    final SharedPreferences preferences = await _preferences;

    final stringTodos = preferences.getStringList(_keyTodo);
    if (stringTodos == null) return [];

    return stringTodos.map((e) => Todo.fromJson(jsonDecode(e))).toList();
  }
}
