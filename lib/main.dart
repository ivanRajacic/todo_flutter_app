import 'package:flutter/material.dart';
import 'home_page.dart';
import 'add_todo_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
      routes: {
        '/home': (context) => const HomePage(),
        '/add': (context) => const AddTodoPage(),
      },
    );
  }
}
