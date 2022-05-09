// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Todo {
  final String title;
  final String date;
  final String priority;
  bool isChecked;

  Todo({
    required this.title,
    required this.date,
    required this.priority,
    required this.isChecked,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'date': date,
      'priority': priority,
      'isChecked': isChecked,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      title: map['title'] as String,
      date: map['date'] as String,
      priority: map['priority'] as String,
      isChecked: map['isChecked'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Todo.fromJson(String source) =>
      Todo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Todo &&
        other.title == title &&
        other.date == date &&
        other.priority == priority &&
        other.isChecked == isChecked;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        date.hashCode ^
        priority.hashCode ^
        isChecked.hashCode;
  }

  Todo copyWith({
    String? title,
    String? date,
    String? priority,
    bool? isChecked,
  }) {
    return Todo(
      title: title ?? this.title,
      date: date ?? this.date,
      priority: priority ?? this.priority,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}
