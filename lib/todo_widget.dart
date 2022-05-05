import 'package:flutter/material.dart';

import 'todo.dart';

class TodoWidget extends StatefulWidget {
  final Todo todo;
  final Function updateStatusCallback;
  final Function deleteCallback;
  const TodoWidget(
      {Key? key,
      required this.todo,
      required this.updateStatusCallback,
      required this.deleteCallback})
      : super(key: key);

  @override
  State<TodoWidget> createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              widget.todo.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Text(
                  widget.todo.date,
                  style: TextStyle(
                    decoration: widget.todo.isChecked
                        ? TextDecoration.lineThrough
                        : null,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  ' * ',
                  style: TextStyle(
                    decoration: widget.todo.isChecked
                        ? TextDecoration.lineThrough
                        : null,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  widget.todo.priority,
                  style: TextStyle(
                    decoration: widget.todo.isChecked
                        ? TextDecoration.lineThrough
                        : null,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          )
        ],
      ),
      const Spacer(),
      Checkbox(
        value: widget.todo.isChecked,
        onChanged: (bool? value) => updateIsChecked(),
      ),
      IconButton(
        onPressed: () => _promptDeleteTodoDialog(context),
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
      )
    ]);
  }

  void updateIsChecked() {
    setState(() {
      widget.updateStatusCallback(widget.todo.key);
    });
  }

  void deleteTodo(BuildContext context) {
    widget.deleteCallback(widget.todo.key);
    Navigator.pop(context);
    const snackBar = SnackBar(
      content: Text('Todo card deleted successfully!'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _promptDeleteTodoDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:
                const Text('Are you sure you want to delete this todo card?'),
            actions: [
              TextButton(
                onPressed: () => deleteTodo(context),
                child: const Text(
                  'Yes',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 17.0,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'No',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 17.0,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
