import 'package:flutter/material.dart';
import 'package:todo_flutter_app/user_simple_preferences.dart';
import 'todo.dart';
import 'todo_widget.dart';

enum Filter { all, active, completed }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Todo> todos = [];

  Filter filterStatus = Filter.all;
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
                  const _Title(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _Counter(
                          todoCompletedCount: todoCompletedCount,
                          todoCount: todoCount,
                        ),
                        Row(
                          children: [
                            _FilterAllButton(
                              filterStatus: filterStatus,
                              filterTodo: filterTodo,
                            ),
                            _FilterActiveButton(
                              filterStatus: filterStatus,
                              filterTodo: filterTodo,
                            ),
                            _FilterCompletedButton(
                              filterStatus: filterStatus,
                              filterTodo: filterTodo,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _TodoList(
              todos: todos,
              filterStatus: filterStatus,
              todoFilteredCount: todoFilteredCount,
              todoFilteredList: todoFilteredList,
              updateTodoStatus: updateTodoStatus,
              deleteTodo: deleteTodo,
            ),
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

  int get todoCount => todos.length;

  int get todoCompletedCount =>
      todos.where((todo) => todo.isChecked == true).length;

  List<Todo> get todoFilteredList =>
      todos.where((todo) => todo.isChecked == showCompleted).toList();

  int get todoFilteredCount => todoFilteredList.length;

  void updateTodoStatus(int hashCode) {
    setState(() {
      int index = todos.indexWhere((todo) => todo.hashCode == hashCode);
      todos[index] = todos[index].copyWith(
        isChecked: !todos[index].isChecked,
      );
    });
  }

  void deleteTodo(int hashCode) async {
    setState(() {
      int index = todos.indexWhere((todo) => todo.hashCode == hashCode);
      todos.removeAt(index);
    });

    await TodoPreferences().setTodos(todos);
  }

  void addTodo() async {
    final result = await Navigator.pushNamed(context, '/add');
    if (result == null) return;
    setState(() {
      todos.add(result as Todo);
    });

    await TodoPreferences().setTodos(todos);
  }

  Future<List<Todo>> loadTodo() async {
    return await TodoPreferences()
        .getTodos()
        .then((List<Todo> tempTodos) => todos = tempTodos);
  }

  void filterTodo(Filter filterStatus) {
    setState(() {
      this.filterStatus = filterStatus;
      if (filterStatus == Filter.active) {
        showCompleted = false;
      }
      if (filterStatus == Filter.completed) {
        showCompleted = true;
      }
    });
  }
}

class _TodoList extends StatelessWidget {
  const _TodoList({
    Key? key,
    required this.todos,
    required this.filterStatus,
    required this.todoFilteredCount,
    required this.todoFilteredList,
    required this.updateTodoStatus,
    required this.deleteTodo,
  }) : super(key: key);

  final List<Todo> todos;
  final Filter filterStatus;
  final int todoFilteredCount;
  final List<Todo> todoFilteredList;
  final Function updateTodoStatus;
  final Function deleteTodo;

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: todos.isNotEmpty
            ? ListView.builder(
                itemCount: filterStatus == Filter.all
                    ? todos.length
                    : todoFilteredCount,
                itemBuilder: (context, index) {
                  return TodoWidget(
                    todo: filterStatus == Filter.all
                        ? todos[index]
                        : todoFilteredList[index],
                    updateStatusCallback: updateTodoStatus,
                    deleteCallback: deleteTodo,
                  );
                },
              )
            : const Text('No todo\'s'));
  }
}

class _FilterCompletedButton extends StatelessWidget {
  const _FilterCompletedButton({
    Key? key,
    required this.filterStatus,
    required this.filterTodo,
  }) : super(key: key);

  final Filter filterStatus;
  final Function(Filter filterStatus) filterTodo;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => filterTodo(Filter.completed),
      child: Text(
        'Completed',
        style: TextStyle(
          color: filterStatus == Filter.completed ? Colors.red : Colors.black,
        ),
      ),
    );
  }
}

class _FilterActiveButton extends StatelessWidget {
  const _FilterActiveButton({
    Key? key,
    required this.filterStatus,
    required this.filterTodo,
  }) : super(key: key);

  final Filter filterStatus;
  final Function(Filter filterStatus) filterTodo;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => filterTodo(Filter.active),
      child: Text(
        'Active',
        style: TextStyle(
          color: filterStatus == Filter.active ? Colors.red : Colors.black,
        ),
      ),
    );
  }
}

class _FilterAllButton extends StatelessWidget {
  const _FilterAllButton({
    Key? key,
    required this.filterStatus,
    required this.filterTodo,
  }) : super(key: key);

  final Filter filterStatus;
  final Function(Filter filterStatus) filterTodo;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => filterTodo(Filter.all),
      child: Text(
        'All',
        style: TextStyle(
          color: filterStatus == Filter.all ? Colors.red : Colors.black,
        ),
      ),
    );
  }
}

class _Counter extends StatelessWidget {
  const _Counter({
    Key? key,
    required this.todoCompletedCount,
    required this.todoCount,
  }) : super(key: key);

  final int todoCompletedCount;
  final int todoCount;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$todoCompletedCount' ' of ' '$todoCount',
      style: const TextStyle(
        color: Colors.grey,
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        'My Tasks',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
      ),
    );
  }
}
