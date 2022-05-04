import 'dart:collection';

import 'package:flutter/material.dart';
import 'todo.dart';
import 'todo_card_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HashMap allTodo = HashMap<TodoCardWidget, bool>();
  List<TodoCardWidget> workingTodo = [];
  String filterStatus = 'All';

  int todoCounter = 0;
  int todoCompletedCounter = 0;

  bool getTodoStatus(Key key) {
    bool returnValue = false;
    allTodo.forEach((k, v) {
      if (k.key == key) {
        returnValue = v;
      }
    });

    return returnValue;
  }

  int todoCount() {
    return allTodo.length;
  }

  int todoCompletedCount() {
    int counter = 0;
    allTodo.forEach((k, v) {
      if (v == true) {
        counter++;
      }
    });
    return counter;
  }

  void updateTodoStatus(Key key, bool isChecked) {
    setState(() {
      if (isChecked) {
        allTodo.forEach((k, v) {
          if (k.key == key) {
            allTodo.update(k, (value) => true);
          }
        });
      } else {
        allTodo.forEach((k, v) {
          if (k.key == key) {
            allTodo.update(k, (value) => false);
          }
        });
      }
      if (filterStatus == 'All') {
        workingTodo = allTodo.keys.toList() as List<TodoCardWidget>;
      } else if (filterStatus == 'Active') {
        filterTodo(true, false);
      } else {
        filterTodo(true, true);
      }
      todoCompletedCounter = todoCompletedCount();
    });
  }

  void filterTodo(bool shouldfilterTodo, bool showCompleted) {
    workingTodo.clear();
    if (shouldfilterTodo == true) {
      if (showCompleted) {
        filterStatus = 'Completed';
      } else {
        filterStatus = 'Active';
      }
      setState(() {
        workingTodo = (Map.from(allTodo)
              ..removeWhere((k, v) => v != showCompleted))
            .keys
            .toList()
            .cast<TodoCardWidget>();
      });
    } else {
      setState(() {
        filterStatus = 'All';
        workingTodo = allTodo.keys.toList() as List<TodoCardWidget>;
      });
    }
  }

  void deleteTodo(Key key, bool isChecked) {
    List<TodoCardWidget> tempTodoCardList =
        allTodo.keys.toList() as List<TodoCardWidget>;
    for (var i = 0; i < tempTodoCardList.length; i++) {
      if (tempTodoCardList[i].key == key) {
        setState(() {
          allTodo.remove(tempTodoCardList[i]);
          todoCounter = todoCount();
          todoCompletedCounter = todoCompletedCount();
          workingTodo = allTodo.keys.toList() as List<TodoCardWidget>;
        });
      }
    }
  }

  void addTodo() async {
    final result = await Navigator.pushNamed(context, '/add');
    if (result != null) {
      final Todo data = result as Todo;
      setState(() {
        allTodo.putIfAbsent(
            TodoCardWidget(
              title: data.title,
              date: data.date,
              priority: data.priority,
              callback: updateTodoStatus,
              deleteCallback: deleteTodo,
              checkStatusCallback: getTodoStatus,
              key: UniqueKey(),
            ),
            () => false);
        todoCounter = todoCount();
        workingTodo = allTodo.keys.toList() as List<TodoCardWidget>;
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
                              onPressed: () => filterTodo(false, false),
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
                              onPressed: () => filterTodo(true, false),
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
                              onPressed: () => filterTodo(true, true),
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
                child: workingTodo.isNotEmpty
                    ? ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: workingTodo.length,
                        itemBuilder: (context, index) {
                          return workingTodo[index];
                        },
                      )
                    : const Text('No todo\'s')),
          ]),
        ),
      ),
    );
  }
}
