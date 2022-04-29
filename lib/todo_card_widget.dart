import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TodoCardWidget extends StatefulWidget {
  final String title;
  final String date;
  final String priority;
  const TodoCardWidget(
      {Key? key,
      this.title = 'title',
      this.date = 'date',
      this.priority = 'priority'})
      : super(key: key);

  @override
  State<TodoCardWidget> createState() => _TodoCardWidgetState();
}

class _TodoCardWidgetState extends State<TodoCardWidget> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Column(
        children: [
          Text(widget.title),
          Row(
            children: [Text(widget.date), Text(widget.priority)],
          )
        ],
      ),
      const Spacer(),
      Checkbox(
        value: isChecked,
        onChanged: (bool? value) {
          setState(() {
            isChecked = value!;
          });
        },
      ),
    ]);
  }
}
