import 'package:flutter/material.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({Key? key}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class InfromationData {
  final String title;
  final String date;
  final String priority;

  InfromationData(this.title, this.date, this.priority);
}

class _AddTodoPageState extends State<AddTodoPage> {
  String _selectedPriority = 'High';
  final List<String> _priorityList = ['High', 'Medium', 'Low'];

  final _nameController = TextEditingController();
  final _dateController = TextEditingController();

  void popOut() {
    InfromationData data = InfromationData(
        _nameController.text, _dateController.text, _selectedPriority);

    Navigator.pop(context, data);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24.0),
          child: Column(children: [
            Column(
              children: [
                const BackButton(),
                const Text('Add Task'),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Title',
                  ),
                ),
                TextField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    hintText: 'Date',
                  ),
                ),
                DropdownButton<String>(
                  value: _selectedPriority,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPriority = newValue!;
                    });
                  },
                  items: _priorityList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                ElevatedButton(
                  onPressed: () {
                    popOut();
                  },
                  child: const Text('Add'),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
