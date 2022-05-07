import 'package:flutter/material.dart';
import 'package:todo_flutter_app/user_simple_preferences.dart';
import 'todo.dart';
import 'todo_widget.dart';

enum Status { all, active, completed }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Todo> todos = [];
  var filterStatus = Status.all;
  bool showCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      'My Tasks',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$todoCompletedCount' ' of ' '$todoCount',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () => filterTodo(Status.all),
                              child: Text(
                                'All',
                                style: TextStyle(
                                  color: filterStatus == Status.all
                                      ? Colors.red
                                      : Colors.black,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => filterTodo(Status.active),
                              child: Text(
                                'Active',
                                style: TextStyle(
                                  color: filterStatus == Status.active
                                      ? Colors.red
                                      : Colors.black,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => filterTodo(Status.completed),
                              child: Text(
                                'Completed',
                                style: TextStyle(
                                  color: filterStatus == Status.completed
                                      ? Colors.red
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
                child: todos.isNotEmpty
                    ? ListView.builder(
                        itemCount: filterStatus == Status.all
                            ? todos.length
                            : todoFilteredCount,
                        itemBuilder: (context, index) {
                          return TodoWidget(
                            todo: filterStatus == Status.all
                                ? todos[index]
                                : todos
                                    .where((element) =>
                                        element.isChecked == showCompleted)
                                    .toList()[index],
                            updateStatusCallback: updateTodoStatus,
                            deleteCallback: deleteTodo,
                          );
                        },
                      )
                    : const Text('No todo\'s')),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTodo,
        tooltip: 'Add Card',
        child: const Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
    );
  }

  int get todoCount {
    return todos.length;
  }

  int get todoCompletedCount {
    return todos.where((element) => element.isChecked == true).length;
  }

  int get todoFilteredCount {
    return todos.where((element) => element.isChecked == showCompleted).length;
  }

  void updateTodoStatus(Key key) {
    setState(() {
      int index = todos.indexWhere((element) => element.key == key);
      todos[index] = Todo(todos[index].title, todos[index].date,
          todos[index].priority, !todos[index].isChecked, todos[index].key);
    });
  }

  void filterTodo(var filterStatus) {
    setState(() {
      switch (filterStatus) {
        case Status.all:
          this.filterStatus = Status.all;
          break;
        case Status.active:
          this.filterStatus = Status.active;
          showCompleted = false;
          break;
        case Status.completed:
          this.filterStatus = Status.completed;
          showCompleted = true;
      }
    });
  }

  void deleteTodo(Key key) {
    setState(() {
      int index = todos.indexWhere((element) => element.key == key);
      todos.removeAt(index);
    });
  }

  void addTodo() async {
    final result = await Navigator.pushNamed(context, '/add');
    if (result != null) {
      final data = result as Todo;
      setState(() {
        todos.add(data);
      });
    }
  }
}
