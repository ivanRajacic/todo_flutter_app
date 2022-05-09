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
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      _CheckBox(
        widget: widget,
        updateIsChecked: updateIsChecked,
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Title(widget: widget),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  _Date(widget: widget),
                  _Separator(widget: widget),
                  _Priority(widget: widget),
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
      )
    ]);
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

class _CheckBox extends StatelessWidget {
  const _CheckBox({
    Key? key,
    required this.widget,
    required this.updateIsChecked,
  }) : super(key: key);

  final TodoWidget widget;
  final void Function(bool?) updateIsChecked;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: Checkbox(
        value: widget.todo.isChecked,
        onChanged: updateIsChecked,
      ),
    );
  }
}

class _Priority extends StatelessWidget {
  const _Priority({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final TodoWidget widget;

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.todo.priority,
      style: TextStyle(
        decoration: widget.todo.isChecked ? TextDecoration.lineThrough : null,
        color: Colors.grey,
      ),
    );
  }
}

class _Separator extends StatelessWidget {
  const _Separator({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final TodoWidget widget;

  @override
  Widget build(BuildContext context) {
    return Text(
      ' * ',
      style: TextStyle(
        decoration: widget.todo.isChecked ? TextDecoration.lineThrough : null,
        color: Colors.grey,
      ),
    );
  }
}

class _Date extends StatelessWidget {
  const _Date({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final TodoWidget widget;

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.todo.date,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        decoration: widget.todo.isChecked ? TextDecoration.lineThrough : null,
        color: Colors.grey,
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final TodoWidget widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        widget.todo.title,
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
