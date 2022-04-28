import 'package:flutter/material.dart';
import 'package:todo_flutter_app/homepage.dart';
import 'package:todo_flutter_app/information_entry.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Homepage(),
      routes: {
        '/add': (context) => information_entry(),
      },
    );
  }
}
