import 'package:flutter/material.dart';

class TodoCardWidget extends StatefulWidget {
  final String title;
  final String date;
  final String priority;
  final Function? callback;
  final Function? deleteCallback;
  final Function? checkStatusCallback;
  const TodoCardWidget(
      {Key? key,
      this.title = 'title',
      this.date = 'date',
      this.priority = 'priority',
      this.callback,
      this.deleteCallback,
      this.checkStatusCallback})
      : super(key: key);

  @override
  State<TodoCardWidget> createState() => _TodoCardWidgetState();
}

class _TodoCardWidgetState extends State<TodoCardWidget> {
  _promptDeleteCardDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:
                const Text('Are you sure you want to delete this todo card?'),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    if (widget.deleteCallback != null) {
                      widget.deleteCallback!(
                          widget.key, widget.checkStatusCallback!(widget.key));
                    }
                  });
                  Navigator.pop(context);
                  const snackBar = SnackBar(
                    content: Text('Todo card deleted successfully!'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
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
              widget.title,
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
                  widget.date,
                  style: TextStyle(
                    decoration: widget.checkStatusCallback!(widget.key)
                        ? TextDecoration.lineThrough
                        : null,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  ' * ',
                  style: TextStyle(
                    decoration: widget.checkStatusCallback!(widget.key)
                        ? TextDecoration.lineThrough
                        : null,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  widget.priority,
                  style: TextStyle(
                    decoration: widget.checkStatusCallback!(widget.key)
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
        value: widget.checkStatusCallback!(widget.key),
        onChanged: (bool? value) {
          setState(() {
            if (widget.callback != null) {
              widget.callback!(widget.key, value);
            }
          });
        },
      ),
      IconButton(
        onPressed: () => _promptDeleteCardDialog(context),
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
      )
    ]);
  }
}
