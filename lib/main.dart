import 'package:flutter/material.dart';
import 'home_page.dart';
import 'add_todo_page.dart';
import 'todo.dart';
import 'todo_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  List<Todo> todos = await TodoPreferences().getTodos();
  runApp(MyApp(
    todos: todos,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.todos,
  }) : super(key: key);

  final List<Todo> todos;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(todos: todos),
      routes: {
        '/home': (context) => HomePage(todos: todos),
        '/add': (context) => const AddTodoPage(),
      },
    );
  }
}
