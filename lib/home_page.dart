import 'package:flutter/material.dart';
import 'todo.dart';
import 'todo_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Todo> todos = [];
  String filterStatus = 'All';
  bool showCompleted = false;

  int todoCounter = 0;
  int todoCompletedCounter = 0;

  int todoCount() {
    return todos.length;
  }

  int todoCompletedCount() {
    return todos.where((element) => element.isChecked == true).length;
  }

  void updateTodoStatus(Key key) {
    setState(() {
      int index = todos.indexWhere((element) => element.key == key);
      todos[index] = Todo(todos[index].title, todos[index].date,
          todos[index].priority, !todos[index].isChecked, todos[index].key);
      todoCompletedCounter = todoCompletedCount();
    });
  }

  void filterTodo(String filterStatus) {
    setState(() {
      if (filterStatus == 'All') {
        this.filterStatus = 'All';
      } else if (filterStatus == 'Active') {
        this.filterStatus = 'Active';
        showCompleted = false;
      } else if (filterStatus == 'Completed') {
        this.filterStatus = 'Completed';
        showCompleted = true;
      }
    });
  }

  void deleteTodo(Key key) {
    setState(() {
      int index = todos.indexWhere((element) => element.key == key);
      todos.removeAt(index);
      todoCounter = todoCount();
      todoCompletedCounter = todoCompletedCount();
    });
  }

  void addTodo() async {
    final result = await Navigator.pushNamed(context, '/add');
    if (result != null) {
      final Todo data = result as Todo;
      setState(() {
        todos.add(data);
        todoCounter = todoCount();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //glavni container
      floatingActionButton: FloatingActionButton(
        onPressed: addTodo,
        tooltip: 'Add Card',
        child: const Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
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
                          '$todoCompletedCounter' ' of ' '$todoCounter',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () => filterTodo('All'),
                              child: Text(
                                'All',
                                style: TextStyle(
                                  color: filterStatus == 'All'
                                      ? Colors.red
                                      : Colors.black,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => filterTodo('Active'),
                              child: Text(
                                'Active',
                                style: TextStyle(
                                  color: filterStatus == 'Active'
                                      ? Colors.red
                                      : Colors.black,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => filterTodo('Completed'),
                              child: Text(
                                'Completed',
                                style: TextStyle(
                                  color: filterStatus == 'Completed'
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
                        itemCount: filterStatus == 'All'
                            ? todos.length
                            : todos
                                .where((element) =>
                                    element.isChecked == showCompleted)
                                .length,
                        itemBuilder: (context, index) {
                          return (TodoWidget(
                            todo: filterStatus == 'All'
                                ? todos[index]
                                : todos
                                    .where((element) =>
                                        element.isChecked == showCompleted)
                                    .toList()[index],
                            updateStatusCallback: updateTodoStatus,
                            deleteCallback: deleteTodo,
                          ));
                        },
                      )
                    : const Text('No todo\'s')),
          ]),
        ),
      ),
    );
  }
}
