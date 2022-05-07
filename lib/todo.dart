import 'package:flutter/cupertino.dart';

class Todo {
  final String title;
  final String date;
  final String priority;
  final Key key;

  bool isChecked;

  Todo(this.title, this.date, this.priority, this.isChecked, this.key);

  Todo.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        date = json['date'],
        priority = json['priority'],
        key = json['key'] as Key,
        isChecked = json['isChecked'] as bool;

  Map<String, dynamic> toJson() => {
        'title': title,
        'date': date,
        'priority': priority,
        'key': key.toString(),
        'isChecked': isChecked.toString()
      };
}
