import 'package:flutter/material.dart';
import 'package:todo_flutter_app/todo_preferences.dart';
import 'todo.dart';
import 'todo_widget.dart';

enum Filter { all, active, completed }

class HomePage extends StatefulWidget {
  final List<Todo> todos;
  const HomePage({Key? key, required this.todos}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final preferences = TodoPreferences();

  List<Todo> todos = [];
  Filter selectedFilter = Filter.all;
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
                            _FilterButton(
                              text: 'All',
                              filterType: Filter.all,
                              selectedFilter: selectedFilter,
                              onPressed: filterTodo,
                            ),
                            _FilterButton(
                              text: 'Active',
                              filterType: Filter.active,
                              selectedFilter: selectedFilter,
                              onPressed: filterTodo,
                            ),
                            _FilterButton(
                              text: 'Completed',
                              filterType: Filter.completed,
                              selectedFilter: selectedFilter,
                              onPressed: filterTodo,
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
              filterStatus: selectedFilter,
              todoFilteredCount: todoFilteredCount,
              todoFilteredList: todoFilteredList,
              onUpdateTodo: updateTodo,
              onDeleteTodo: deleteTodo,
              todos: todos,
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

  void updateTodo(Todo todo) async {
    setState(() {
      int index = todos.indexOf(todo);
      todos[index] = todos[index].copyWith(
        isChecked: !todos[index].isChecked,
      );
    });
    preferences.setTodos(todos);
  }

  void deleteTodo(Todo todo) async {
    setState(() {
      todos.remove(todo);
    });

    preferences.setTodos(todos);
  }

  void addTodo() async {
    final result = await Navigator.pushNamed(context, '/add');
    if (result == null) return;
    setState(() {
      todos.add(result as Todo);
    });

    preferences.setTodos(todos);
  }

  void setTodo(List<Todo> todos) {
    this.todos = todos;
  }

  void filterTodo(Filter filter) {
    setState(() {
      selectedFilter = filter;
      if (filter == Filter.active) {
        showCompleted = false;
      }
      if (filter == Filter.completed) {
        showCompleted = true;
      }
    });
  }

  @override
  void initState() {
    setTodo(widget.todos);
    super.initState();
  }
}

class _TodoList extends StatelessWidget {
  const _TodoList({
    Key? key,
    required this.filterStatus,
    required this.todoFilteredCount,
    required this.todoFilteredList,
    required this.onUpdateTodo,
    required this.onDeleteTodo,
    required this.todos,
  }) : super(key: key);

  final Filter filterStatus;
  final int todoFilteredCount;
  final List<Todo> todoFilteredList;
  final Function onUpdateTodo;
  final Function onDeleteTodo;
  final List<Todo> todos;

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
                    updateTodoCallback: onUpdateTodo,
                    deleteCallback: onDeleteTodo,
                  );
                },
              )
            : const Text('No todo\'s'));
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.filterType,
    required this.selectedFilter,
  }) : super(key: key);

  final Function(Filter filterStatus) onPressed;
  final String text;
  final Filter filterType;
  final Filter selectedFilter;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onPressed(filterType),
      child: Text(
        text,
        style: TextStyle(
          color: selectedFilter == filterType ? Colors.red : Colors.black,
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
