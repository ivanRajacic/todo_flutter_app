import 'package:flutter/cupertino.dart';

class Todo {
  final String title;
  final String date;
  final String priority;
  final Key key;

  bool isChecked;

  Todo(this.title, this.date, this.priority, this.isChecked, this.key);
}
