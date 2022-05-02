import 'package:flutter/material.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({Key? key}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class TodoCardData {
  final String title;
  final String date;
  final String priority;

  TodoCardData(this.title, this.date, this.priority);
}

class _AddTodoPageState extends State<AddTodoPage> {
  String? _selectedPriority;
  final List<String> _priorityList = ['High', 'Medium', 'Low'];

  final _nameController = TextEditingController();
  final _dateController = TextEditingController();

  void passCardData() {
    if (_selectedPriority != null) {
      TodoCardData data = TodoCardData(
          _nameController.text, _dateController.text, _selectedPriority!);
      Navigator.pop(context, data);
    }
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
          padding: const EdgeInsets.all(40.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon:
                            const Icon(Icons.arrow_back_ios, color: Colors.red),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Add Task',
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                        hintText: 'Title',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: _dateController,
                    decoration: InputDecoration(
                        hintText: 'Date',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: InputDecorator(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:
                                    const BorderSide(color: Colors.grey))),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedPriority,
                            icon: const Icon(
                              Icons.arrow_drop_down_circle,
                              color: Colors.red,
                            ),
                            elevation: 8,
                            isDense: true,
                            hint: const Text('Priority'),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedPriority = newValue ?? '';
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
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 60.0,
                        child: ElevatedButton(
                          onPressed: () {
                            passCardData();
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0))),
                          child: const Text(
                            'Add',
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
