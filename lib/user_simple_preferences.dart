import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'todo.dart';

class TodoPreferences {
  static const _keyTodo = 'todo';
  final Future<SharedPreferences> _preferences =
      SharedPreferences.getInstance();

  Future setTodos(List<Todo> todos) async {
    final SharedPreferences preferences = await _preferences;

    List<String> stringTodos = [];
    for (var todo in todos) {
      stringTodos.add(jsonEncode(todo.toJson()));
    }
    await preferences.setStringList(_keyTodo, stringTodos);
  }

  Future<List<Todo>> getTodos() async {
    final SharedPreferences preferences = await _preferences;
    List<String> stringTodos = [];
    List<Todo> todos = [];

    if (preferences.getStringList(_keyTodo) == null) {
      return todos;
    }
    stringTodos = preferences.getStringList(_keyTodo)!;
    for (var strTodo in stringTodos) {
      todos.add(Todo.fromJson(jsonDecode(strTodo)));
    }
    return todos;
  }
}
