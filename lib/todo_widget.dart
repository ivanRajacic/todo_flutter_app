import 'package:flutter/material.dart';

import 'todo.dart';

class TodoWidget extends StatefulWidget {
  final Todo todo;
  final Function updateStatusCallback;
  final Function deleteCallback;
  const TodoWidget({
    Key? key,
    required this.todo,
    required this.updateStatusCallback,
    required this.deleteCallback,
  }) : super(key: key);

  @override
  State<TodoWidget> createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CheckBox(
          isChecked: widget.todo.isChecked,
          updateIsChecked: updateIsChecked,
        ),
        Expanded(
          flex: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Title(title: widget.todo.title),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    _Date(
                      date: widget.todo.date,
                      isChecked: widget.todo.isChecked,
                    ),
                    _Separator(
                      isChecked: widget.todo.isChecked,
                    ),
                    _Priority(
                      priority: widget.todo.priority,
                      isChecked: widget.todo.isChecked,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () => _promptDeleteTodoDialog(context),
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  void updateIsChecked(bool? b) {
    setState(() {
      widget.updateStatusCallback(widget.todo.hashCode);
    });
  }

  void deleteTodo(BuildContext context) {
    widget.deleteCallback(widget.todo.hashCode);
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
          title: const Text('Are you sure you want to delete this todo card?'),
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
      },
    );
  }
}

class _CheckBox extends StatelessWidget {
  const _CheckBox({
    Key? key,
    required this.isChecked,
    required this.updateIsChecked,
  }) : super(key: key);

  final bool isChecked;
  final void Function(bool?) updateIsChecked;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: Checkbox(
        value: isChecked,
        onChanged: updateIsChecked,
      ),
    );
  }
}

class _Priority extends StatelessWidget {
  const _Priority({
    Key? key,
    required this.priority,
    required this.isChecked,
  }) : super(key: key);

  final String priority;
  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    return Text(
      priority,
      style: TextStyle(
        decoration: isChecked ? TextDecoration.lineThrough : null,
        color: Colors.grey,
      ),
    );
  }
}

class _Separator extends StatelessWidget {
  const _Separator({
    Key? key,
    required this.isChecked,
  }) : super(key: key);

  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    return Text(
      ' * ',
      style: TextStyle(
        decoration: isChecked ? TextDecoration.lineThrough : null,
        color: Colors.grey,
      ),
    );
  }
}

class _Date extends StatelessWidget {
  const _Date({
    Key? key,
    required this.isChecked,
    required this.date,
  }) : super(key: key);

  final bool isChecked;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Text(
      date,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        decoration: isChecked ? TextDecoration.lineThrough : null,
        color: Colors.grey,
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        title,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}
