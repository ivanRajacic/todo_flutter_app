import 'package:flutter/material.dart';
import 'package:todo_flutter_app/todo_preferences.dart';
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
  final ValueNotifier<bool> finishedLoading = ValueNotifier<bool>(false);

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
                          finishedLoading: finishedLoading,
                        ),
                        Row(
                          children: [
                            _FilterButton(
                              filterName: 'All',
                              filterNameStatus: Filter.all,
                              filterCurrentStatus: filterStatus,
                              filterTodo: filterTodo,
                            ),
                            _FilterButton(
                              filterName: 'Active',
                              filterNameStatus: Filter.active,
                              filterCurrentStatus: filterStatus,
                              filterTodo: filterTodo,
                            ),
                            _FilterButton(
                              filterName: 'Completed',
                              filterNameStatus: Filter.completed,
                              filterCurrentStatus: filterStatus,
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
              filterStatus: filterStatus,
              todoFilteredCount: todoFilteredCount,
              todoFilteredList: todoFilteredList,
              updateTodoStatus: updateTodoStatus,
              deleteTodo: deleteTodo,
              loadTodo: loadTodo,
              setTodo: setTodo,
              finishedLoading: finishedLoading,
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

  void updateTodoStatus(int hashCode) async {
    setState(() {
      int index = todos.indexWhere((todo) => todo.hashCode == hashCode);
      todos[index] = todos[index].copyWith(
        isChecked: !todos[index].isChecked,
      );
    });
    await TodoPreferences().setTodos(todos);
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
    return await TodoPreferences().getTodos();
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

  void setTodo(List<Todo> todos) {
    this.todos = todos;
  }
}

class _TodoList extends StatelessWidget {
  const _TodoList({
    Key? key,
    required this.filterStatus,
    required this.todoFilteredCount,
    required this.todoFilteredList,
    required this.updateTodoStatus,
    required this.deleteTodo,
    required this.loadTodo,
    required this.setTodo,
    required this.finishedLoading,
  }) : super(key: key);

  final Filter filterStatus;
  final int todoFilteredCount;
  final List<Todo> todoFilteredList;
  final Function updateTodoStatus;
  final Function deleteTodo;
  final Function loadTodo;
  final Function setTodo;
  final ValueNotifier<bool> finishedLoading;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadTodo(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Todo> todos = snapshot.data as List<Todo>;
          setTodo(todos);
          // finishedLoading.value = true;
          return (Flexible(
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
                  : const Text('No todo\'s')));
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    Key? key,
    required this.filterTodo,
    required this.filterName,
    required this.filterNameStatus,
    required this.filterCurrentStatus,
  }) : super(key: key);

  final Function(Filter filterStatus) filterTodo;
  final String filterName;
  final Filter filterNameStatus;
  final Filter filterCurrentStatus;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => filterTodo(filterNameStatus),
      child: Text(
        filterName,
        style: TextStyle(
          color: filterCurrentStatus == filterNameStatus
              ? Colors.red
              : Colors.black,
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
    required this.finishedLoading,
  }) : super(key: key);

  final int todoCompletedCount;
  final int todoCount;
  final ValueNotifier<bool> finishedLoading;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: finishedLoading,
        builder: (context, finishedLoading, child) {
          return Text(
            '$todoCompletedCount' ' of ' '$todoCount',
            style: const TextStyle(
              color: Colors.grey,
            ),
          );
        });
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
