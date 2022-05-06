import 'package:flutter/material.dart';

import 'todo.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({Key? key}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  String? _selectedPriority;
  final _priorities = ['High', 'Medium', 'Low'];

  final _nameController = TextEditingController();
  final _dateController = TextEditingController();

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
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.red,
                        ),
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
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                _Title(nameController: _nameController),
                _DatePicker(dateController: _dateController),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _PriorityPicker(
                        selectedPriority: _selectedPriority,
                        priorities: _priorities,
                        updatePriority: updatePriority),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 60.0,
                        child: ElevatedButton(
                          onPressed: passCardData,
                          style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0))),
                          child: const Text(
                            'Add',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
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

  void updatePriority(String? newValue) {
    setState(() {
      _selectedPriority = newValue ?? '';
    });
  }

  void passCardData() {
    if (_selectedPriority != null) {
      Todo data = Todo(_nameController.text, _dateController.text,
          _selectedPriority!, false, UniqueKey());
      Navigator.pop(context, data);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    super.dispose();
  }
}

class _PriorityPicker extends StatefulWidget {
  const _PriorityPicker({
    Key? key,
    required String? selectedPriority,
    required List<String> priorities,
    required Function updatePriority,
  })  : _selectedPriority = selectedPriority,
        _priorities = priorities,
        _updatePriority = updatePriority,
        super(key: key);

  final String? _selectedPriority;
  final List<String> _priorities;
  final Function _updatePriority;

  @override
  State<_PriorityPicker> createState() => _PriorityPickerState();
}

class _PriorityPickerState extends State<_PriorityPicker> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InputDecorator(
        decoration: InputDecoration(
          hintText: 'Priority',
          labelText: 'Priority',
          labelStyle: const TextStyle(
            color: Colors.grey,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: widget._selectedPriority,
            icon: const Icon(
              Icons.arrow_drop_down_circle,
              color: Colors.red,
            ),
            elevation: 8,
            isDense: true,
            hint: const Text('Priority'),
            onChanged: (String? newValue) => widget._updatePriority(newValue),
            items: widget._priorities
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _DatePicker extends StatefulWidget {
  const _DatePicker({
    Key? key,
    required TextEditingController dateController,
  })  : _dateController = dateController,
        super(key: key);

  final TextEditingController _dateController;

  @override
  State<_DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<_DatePicker> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: widget._dateController,
        readOnly: true,
        onTap: () async => _datePicker(context),
        decoration: InputDecoration(
          hintText: 'Date',
          labelText: 'Date',
          labelStyle: const TextStyle(
            color: Colors.grey,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  Future<void> _datePicker(BuildContext context) async {
    {
      _selectedDate = await showDatePicker(
          context: context,
          initialDate: _selectedDate == null ? DateTime.now() : _selectedDate!,
          firstDate: DateTime(2000),
          lastDate: DateTime(2030));

      setState(() {
        widget._dateController.text = _selectedDate!.day.toString() +
            '.' +
            _selectedDate!.month.toString() +
            '.' +
            _selectedDate!.year.toString() +
            ' ' +
            _selectedDate!.hour.toString() +
            ':' +
            _selectedDate!.minute.toString();
      });
    }
  }
}

class _Title extends StatelessWidget {
  const _Title({
    Key? key,
    required TextEditingController nameController,
  })  : _nameController = nameController,
        super(key: key);

  final TextEditingController _nameController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: _nameController,
        decoration: InputDecoration(
          hintText: 'Enter the title of the todo task',
          labelText: 'Title',
          labelStyle: const TextStyle(
            color: Colors.grey,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}
